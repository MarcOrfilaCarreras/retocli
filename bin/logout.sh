logout_help() {
    echo ""
    echo "Usage: retocli logout [arguments]"
    echo ""
    echo "Arguments:"
    echo "  -h, --help          Show this help message and exit."
    echo ""
    exit 1
}

logout() {

    while [[ $# -gt 0 ]]; do
        case "$1" in
            -h | --help)
                logout_help
                ;;
            *)
                ;;
        esac
        shift
    done

    echo "# This file is updated automatically" > ~/.acepta_el_reto

    echo -e "\nYou are now logged out !"
    exit 0
}