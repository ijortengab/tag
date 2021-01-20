_new_arguments=()

while [[ $# -gt 0 ]]; do
    case "$1" in
        --help|-h) help=1; shift ;;
        --version|-v) version=1; shift ;;
        -D) filter=d; shift ;;
        -F) filter=f; shift ;;
        --all|-a) all=1; shift ;;
        --directory=*|-d=*) directory="${1#*=}"; shift ;;
        --directory|-d) if [[ ! $2 == "" && ! $2 =~ ^-[^-] ]]; then directory="$2"; shift; fi; shift ;;
        --dry-run|-n) dry_run=1; shift ;;
        --exclude-dir=*|-x=*) exclude_dir+=("${1#*=}"); shift ;;
        --exclude-dir|-x) if [[ ! $2 == "" && ! $2 =~ ^-[^-] ]]; then exclude_dir+=("$2"); shift; fi; shift ;;
        --ignore-case|-i) ignore_case=1; shift ;;
        --preview|-p) preview=1; shift ;;
        --recursive|-r) recursive=1; shift ;;
        --type=*) filter="${1#*=}"; shift ;;
        --type) if [[ ! $2 == "" && ! $2 =~ ^-[^-] ]]; then filter="$2"; shift; fi; shift ;;
        --tag-file=*|-t=*) tag_file="${1#*=}"; shift ;;
        --tag-file|-t) if [[ ! $2 == "" && ! $2 =~ ^-[^-] ]]; then tag_file="$2"; shift; fi; shift ;;
        --word|-w) word=1; shift ;;
        *) _new_arguments+=("$1"); shift ;;
    esac
done

set -- "${_new_arguments[@]}"

_new_arguments=()

while [[ $# -gt 0 ]]; do
    case "$1" in
        -[^-]*) OPTIND=1
            while getopts ":hvDFad:nx:iprt:w" opt; do
                case $opt in
                    h) help=1 ;;
                    v) version=1 ;;
                    D) filter=d ;;
                    F) filter=f ;;
                    a) all=1 ;;
                    d) directory="$OPTARG" ;;
                    n) dry_run=1 ;;
                    x) exclude_dir+=("$OPTARG") ;;
                    i) ignore_case=1 ;;
                    p) preview=1 ;;
                    r) recursive=1 ;;
                    t) tag_file="$OPTARG" ;;
                    w) word=1 ;;
                esac
            done
            shift "$((OPTIND-1))"
            ;;
        *) _new_arguments+=("$1"); shift ;;
    esac
done

set -- "${_new_arguments[@]}"

unset _new_arguments
