profile_help() {
    echo ""
    echo "Usage: retocli profile [arguments]"
    echo ""
    echo "Arguments:"
    echo "  -h, --help          Show this help message and exit."
    echo ""
    echo "  -i, --id            Specify the ID of the user."
    echo ""
    echo "  -u, --username      Specify the username."
    echo ""
    exit 1
}

get_profile() {
    local id="$1"

    result=$(curl -s -w "%{http_code}" "https://aceptaelreto.com/ws/user/$id" \
            -H 'Accept: application/json' \
            -H 'Accept-Language: es-ES,es;q=0.6' \
            -H 'Connection: keep-alive' \
            -H 'User-Agent: Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/119.0.0.0 Mobile Safari/537.36' \
            --compressed)

    status_code=$(echo "$result" | tail -c 4)
    result=$(echo "$result" | head -c -4)

    if [ "$status_code" = "404" ]; then
        echo -e "\nThe user does not seem to exist ..."

        exit 1
    fi
    
    nick=$(echo "$result" | jq -r '.nick')
    country=$(echo "$result" | jq -r '.country.name')
    institution=$(echo "$result" | jq -r '.institution.name')
    institution_url=$(echo "$result" | jq -r '.institution.url')
    avatar=$(echo "$result" | jq -r '.avatar')

    column_width=20

    echo ""
    printf "%-${column_width}s %-${column_width}s %-${column_width}s\n" "User Information" "" ""
    echo "--------------------------------------"
    printf "%-${column_width}s %-${column_width}s %-${column_width}s\n" "ID:" "$id" ""
    printf "%-${column_width}s %-${column_width}s %-${column_width}s\n" "Nickname:" "$nick" ""
    printf "%-${column_width}s %-${column_width}s %-${column_width}s\n" "Country:" "$country" ""
    printf "%-${column_width}s %-${column_width}s %-${column_width}s\n" "Avatar:" "$avatar" ""
    echo ""

    printf "%-${column_width}s %-${column_width}s %-${column_width}s\n" "Institution Information" "" ""
    echo "--------------------------------------"
    printf "%-${column_width}s %-${column_width}s %-${column_width}s\n" "Institution:" "$institution" ""
    printf "%-${column_width}s %-${column_width}s %-${column_width}s\n" "Institution URL:" "$institution_url" ""
    echo ""
}

get_profile_id_by_username() {
    local username="$1"

    result=$(curl -s -w "%{redirect_url} %{http_code}" "https://aceptaelreto.com/bin/search.php?search_query=$username&commit=searchUser" \
            -H 'Accept: application/json' \
            -H 'Accept-Language: es-ES,es;q=0.6' \
            -H 'Connection: keep-alive' \
            -H 'User-Agent: Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/119.0.0.0 Mobile Safari/537.36' \
            --compressed)

    read redirect_url status_code <<<"$result"

    if [ "$status_code" -ne "302" ]; then
        echo -e "\nIt seems that the redirection didn't work ..."
        exit 1
    fi

    id=$(echo "$redirect_url" | grep -oP 'id=\K[^&]+')

    if [ -n "$id" ]; then
        echo "$id"
    fi
}

profile() {
    local id
    local username
    local operation="id"

    while [[ $# -gt 0 ]]; do
        case "$1" in
            -i | --id)
                    shift
                    id="$1"
                    ;;
            -u | --username)
                    shift
                    username="$1"
                    operation="username"
                    ;;
            -h | --help)
                profile_help
                exit 0
                ;;
            *)
                ;;
        esac
        shift
    done

    if [ "$operation" = "id" ]; then
        if ! [ -n "$id" ]; then
            config=$(cat ~/.acepta_el_reto)
            id=$(echo "$config" | grep -w "^id" | cut -d' ' -f3)
        fi

        get_profile "$id"
        exit 0
    fi

    if [ "$operation" = "username" ]; then
        id=$(get_profile_id_by_username "$username")

        if [[ "$id" -eq " " ]]; then
            echo -e "\nThe user does not seem to exist ..."
            exit 1
        fi

        get_profile "$id"
        exit 0
    fi
}