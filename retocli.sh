source "$(dirname "$0")/bin/login.sh"
source "$(dirname "$0")/bin/profile.sh"
source "$(dirname "$0")/bin/results.sh"
source "$(dirname "$0")/bin/logout.sh"

entrypoint_help() {
    echo ""
    echo "Usage: retocli [command] [arguments]"
    echo ""
    echo "Commands:"
    echo "  login       Log in to the system by providing valid credentials."
    echo "              Usage: retocli login [arguments]"
    echo ""
    echo "  profile     View user profile information."
    echo "              Usage: retocli profile [arguments]"
    echo ""
    echo "  results     Retrieves and sends information of the submissions."
    echo "              Usage: retocli results [arguments]"
    echo ""
    echo "  logout      Log out and terminate the current authenticated session."
    echo "              Usage: retocli logout [arguments]"
    echo ""
    exit 1
}

case "$1" in
    "login")
        login "$@"
        ;;

    "profile")
        profile "$@"
        ;;
    
    "results")
        results "$@"
        ;;

    "logout")
        logout "$@"
        ;;
    *)
        entrypoint_help
        ;;
esac
