results_help() {
    echo ""
    echo "Usage: retocli results [arguments]"
    echo ""
    echo "Arguments:"
    echo "  -h, --help          Show this help message and exit."
    echo ""
    echo "  -i, --id            Specify the ID of the challenge to retrieve results."
    echo ""
    echo "  -l, --language      Specify the programming language."
    echo "                      Accepted values: JAVA, C, C++"
    echo ""
    echo "  -f, --file          Specify the file to be sent for the challenge."
    echo ""
    echo "  -o, --operation     Specify a specific action to perform on the challenge."
    echo "                      Accepted values: push, results"
    echo ""
    exit 1
}

get_results() {
    config=$(cat ~/.acepta_el_reto)

    acrsession_cookie=$(echo "$config" | grep -w "^acrsession_cookie" | cut -d' ' -f3)
    acr_session_cookie=$(echo "$config" | grep -w "^acr_session_cookie" | cut -d' ' -f3)
    id=$(echo "$config" | grep -w "^id" | cut -d' ' -f3)

    result=$(curl -s "https://aceptaelreto.com/ws/user/$id/submissions" \
            -H 'Accept: application/json, */*; q=0.01' \
            -H 'Accept-Language: es-ES,es;q=0.8' \
            -H 'Connection: keep-alive' \
            -H "Cookie: ACR_SessionCookie=$acr_session_cookie; acrsession=$acrsession_cookie" \
            -H 'User-Agent: Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/119.0.0.0 Mobile Safari/537.36' \
            --compressed)

    table=$(echo -e "Num\tTitle\tLanguage\tComment\tResult\tTimestamp\n$(echo "$result" | jq -r '.submission[] | [.problem.num, .problem.title, .language, .comment, .result, .submissionDate] | @tsv' | awk '{print $1"\t"$2"\t"$3"\t"$4"\t"$5"\t"strftime("%Y-%m-%d %H:%M:%S", $6 / 1000)}')" | column -ts $'\t')

    echo "$table"
    exit 0
}

send_result() {
    local question="$1"
    local language="$2"
    local file="$3"

    config=$(cat ~/.acepta_el_reto)

    acrsession_cookie=$(echo "$config" | grep -w "^acrsession_cookie" | cut -d' ' -f3)
    acr_session_cookie=$(echo "$config" | grep -w "^acr_session_cookie" | cut -d' ' -f3)
    id=$(echo "$config" | grep -w "^id" | cut -d' ' -f3)

    text=$(cat "$file")
    code=$(echo -e "$text" | tr '\n' '\r\n')
    language=$(echo "${language^^}")
    currentPage="/problem/send.php?id=$question"
    cat="-1"
    comment=""
    inputFile=""
    sentCode="inlineSentCode"

    result=$(curl -i -s 'https://aceptaelreto.com/bin/submitproblem.php' \
        -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8' \
        -H 'Accept-Language: es-ES,es;q=0.8' \
        -H 'Content-Type: multipart/form-data; boundary=----WebKitFormBoundary5cEXz01Kmg69ZBPF' \
        -H "Cookie: ACR_SessionCookie=$acr_session_cookie; acrsession=$acrsession_cookie" \
        -H 'Origin: https://aceptaelreto.com' \
        -H 'User-Agent: Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/119.0.0.0 Mobile Safari/537.36' \
        --data-raw $'------WebKitFormBoundary5cEXz01Kmg69ZBPF\r\nContent-Disposition: form-data; name="currentPage"\r\n\r\n'"$currentPage"$'\r\n------WebKitFormBoundary5cEXz01Kmg69ZBPF\r\nContent-Disposition: form-data; name="cat"\r\n\r\n'"$cat"$'\r\n------WebKitFormBoundary5cEXz01Kmg69ZBPF\r\nContent-Disposition: form-data; name="id"\r\n\r\n'"$question"$'\r\n------WebKitFormBoundary5cEXz01Kmg69ZBPF\r\nContent-Disposition: form-data; name="language"\r\n\r\n'"$language"$'\r\n------WebKitFormBoundary5cEXz01Kmg69ZBPF\r\nContent-Disposition: form-data; name="comment"\r\n\r\n'"$comment"$'\r\n------WebKitFormBoundary5cEXz01Kmg69ZBPF\r\nContent-Disposition: form-data; name="inputFile"; filename=""\r\nContent-Type: application/octet-stream\r\n\r\n'"$inputFile"$'\r\n------WebKitFormBoundary5cEXz01Kmg69ZBPF\r\nContent-Disposition: form-data; name="sentCode"\r\n\r\n'"$sentCode"$'\r\n------WebKitFormBoundary5cEXz01Kmg69ZBPF\r\nContent-Disposition: form-data; name="immediateCode"  \r\n\r\n'"$code"$'\r\n------WebKitFormBoundary5cEXz01Kmg69ZBPF--\r\n' \
        --compressed)

    idSend=$(echo "$result" | grep -oP 'Location: /problem/submission.php\?id=\K\d+')

    if [ -n "$idSend" ]; then
        echo "The question has been submitted !"
        exit 0
    fi

    echo "Something was wrong during the push ..."
    exit 1
    
}

get_last_results_by_id() {
    local question="$1"

    config=$(cat ~/.acepta_el_reto)

    acrsession_cookie=$(echo "$config" | grep -w "^acrsession_cookie" | cut -d' ' -f3)
    acr_session_cookie=$(echo "$config" | grep -w "^acr_session_cookie" | cut -d' ' -f3)
    id=$(echo "$config" | grep -w "^id" | cut -d' ' -f3)

    result=$(curl -s "https://aceptaelreto.com/ws/user/$id/submissions/problem/$question" \
            -H 'Accept: application/json, */*; q=0.01' \
            -H 'Accept-Language: es-ES,es;q=0.8' \
            -H "Cookie: ACR_SessionCookie=$acr_session_cookie; acrsession=$acrsession_cookie" \
            -H 'User-Agent: Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/119.0.0.0 Mobile Safari/537.36' \
            --compressed)

    table=$(echo -e "Num\tLanguage\tResult\tTimestamp\n$(echo "$result" | jq -r '.submission[] | [.num, .language, .result, .submissionDate] | @tsv' | awk '{print $1"\t"$2"\t"$3"\t"strftime("%Y-%m-%d %H:%M:%S", $4 / 1000)}')" | column -ts $'\t')

    echo "$table"
    exit 0
}

results() {
    local question=""
    local language=""
    local file=""
    local operation=""

    if [ "$#" -eq 0 ] || [ "$#" -eq 1 ]; then
        get_results
        exit 0
    fi

    while [[ $# -gt 0 ]]; do
        case "$1" in
            -i | --id)
                shift
                question="$1"
                ;;
            -l | --language)
                shift
                language="$1"
                ;;
            -f | --file)
                shift
                file="$1"
                ;;
            -o | --operation)
                shift
                operation="$1"
                ;;
            -h | --help)
                results_help
                exit 0
                ;;
            *)
                ;;
        esac
        shift
    done

    if [ "$operation" = "push" ]; then
        send_result "$question" "$language" "$file"
        exit 0
    fi

    if [ "$operation" = "results" ]; then
        get_last_results_by_id "$question"
        exit 0
    fi

    echo "You didn't select any operation ..."
    exit 1
}
