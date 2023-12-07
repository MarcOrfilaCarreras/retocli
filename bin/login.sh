login_help() {
    echo ""
    echo "Usage: retocli login [arguments]"
    echo ""
    echo "Arguments:"
    echo "  -h, --help          Show this help message and exit."
    echo ""
    echo "  -u, --username      Specify the username for authentication."
    echo ""
    echo "  -p, --password      Specify the password for authentication."
    echo ""
    exit 1
}

get_cookies() {
    local username="$1"
    local password="$2"

    username=$(echo "$username" | sed 's/@/%40/')

    result=$(curl -s -c - 'https://aceptaelreto.com/bin/login.php' \
            -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8' \
            -H 'Accept-Language: es-ES,es;q=0.8' \
            -H 'Connection: keep-alive' \
            -H 'Content-Type: application/x-www-form-urlencoded' \
            -H 'Origin: https://aceptaelreto.com' \
            -H 'User-Agent: Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/119.0.0.0 Mobile Safari/537.36' \
            --data-raw "loginForm_username=$username&loginForm_password=$password&commit=Entrar")

    acrsession_cookie=$(echo "$result" | awk '/acrsession/{print $NF}')
    acr_session_cookie=$(echo "$result" | awk '/ACR_SessionCookie/{print $NF}')

    if ! [ -n "$acrsession_cookie" ] && ! [ -n "$acr_session_cookie" ]; then
        echo "Something was wrong during the login ..."
        exit 1
    fi

    echo "# This file is updated automatically" > ~/.acepta_el_reto
    echo "acrsession_cookie = $acrsession_cookie" >> ~/.acepta_el_reto
    echo "acr_session_cookie = $acr_session_cookie" >> ~/.acepta_el_reto

    result=$(curl -L -s 'https://aceptaelreto.com/bin/search.php?search_query=MarcOrfilaCarreras&commit=searchUser' \
            -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8' \
            -H 'Accept-Language: es-ES,es;q=0.6' \
            -H 'Connection: keep-alive' \
            -H 'User-Agent: Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/119.0.0.0 Mobile Safari/537.36' \
            --compressed)

    id=$(echo "$result" | grep -oP '<input type="hidden" value="\K[^"]+' | head -1)
    id=$(echo "$id" | grep -oP 'id=\K\d+')

    echo "id = $id" >> ~/.acepta_el_reto

    if ! [ -n "$id" ]; then
        echo "Something was wrong during the login ..."
        exit 1
    fi

    echo "You are now logged in !"
}

login() {
    local username
    local password

    while [[ $# -gt 0 ]]; do
        case "$1" in
            -u | --username)
                shift
                username="$1"
                ;;
            -p | --password)
                shift
                password="$1"
                ;;
            -h | --help)
                login_help
                exit 0
                ;;
            *)
                ;;
        esac
        shift
    done

    if ! [ -n "$username" ] && ! [ -n "$password" ]; then
        login_help
        exit 1
    fi

    get_cookies "$username" "$password"
}