#!/bin/bash

_new_arguments=()

while [[ $# -gt 0 ]]; do
    case "$1" in
        --help|-h) help=1; shift ;;
        --version) version=1; shift ;;
        -1) _1=1; shift ;;
        -d) filter=d; shift ;;
        -f) filter=f; shift ;;
        --all|-a) all=1; shift ;;
        --directory=*|-D=*) directory="${1#*=}"; shift ;;
        --directory|-D) if [[ ! $2 == "" && ! $2 =~ ^-[^-] ]]; then directory="$2"; shift; fi; shift ;;
        --dry-run|-n) dry_run=1; shift ;;
        --exclude-dir=*|-x=*) exclude_dir+=("${1#*=}"); shift ;;
        --exclude-dir|-x) if [[ ! $2 == "" && ! $2 =~ ^-[^-] ]]; then exclude_dir+=("$2"); shift; fi; shift ;;
        --ignore-case|-i) ignore_case=1; shift ;;
        --preview|-p) preview=1; shift ;;
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
            while getopts ":h1dfaD:nx:ipt:w" opt; do
                case $opt in
                    h) help=1 ;;
                    1) _1=1 ;;
                    d) filter=d ;;
                    f) filter=f ;;
                    a) all=1 ;;
                    D) directory="$OPTARG" ;;
                    n) dry_run=1 ;;
                    x) exclude_dir+=("$OPTARG") ;;
                    i) ignore_case=1 ;;
                    p) preview=1 ;;
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

# Computes the difference of arrays.
#
# Globals:
#   Modified: _return
#
# Arguments:
#   1 = Parameter of the array to compare from.
#   2 = Parameter of the array to compare against.
#
# Returns:
#   None
#
# Example:
#   ```
#   my=("cherry" "manggo" "blackberry" "manggo" "blackberry")
#   yours=("cherry" "blackberry")
#   ArrayDiff my[@] yours[@]
#   # Get result in variable `$_return`.
#   # _return=("manggo" "manggo")
#   ```
ArrayDiff() {
    local e
    local source=("${!1}")
    local reference=("${!2}")
    _return=()
    # inArray is alternative of ArraySearch.
    inArray () {
        local e match="$1"
        shift
        for e; do [[ "$e" == "$match" ]] && return 0; done
        return 1
    }
    if [[ "${#reference[@]}" -gt 0 ]];then
        for e in "${source[@]}";do
            if ! inArray "$e" "${reference[@]}";then
                _return+=("$e")
            fi
        done
    else
        _return=("${source[@]}")
    fi
}

# Removes duplicate values from an array.
#
# Globals:
#   Modified: _return
#
# Arguments:
#   1 = Parameter of the input array.
#
# Returns:
#   None
#
# Example:
#   ```
#   my=("cherry" "manggo" "blackberry" "manggo" "blackberry")
#   ArrayUnique my[@]
#   # Get result in variable `$_return`.
#   # _return=("cherry" "manggo" "blackberry")
#   ```
ArrayUnique() {
    local e source=("${!1}")
    # inArray is alternative of ArraySearch.
    inArray () {
        local e match="$1"
        shift
        for e; do [[ "$e" == "$match" ]] && return 0; done
        return 1
    }
    _return=()
    for e in "${source[@]}";do
        if ! inArray "$e" "${_return[@]}";then
            _return+=("$e")
        fi
    done
}

# Print Version.
#
# Globals:
#   None
#
# Arguments:
#   None
#
# Returns:
#   None
Version() {
    echo '0.4.0'
}

# Print Short Usage of Command.
#
# Globals:
#   None
#
# Arguments:
#   None
#
# Returns:
#   None
Usage() {
    version=`Version`
    cat <<- EOF
Usage: tag <command> [arguments|STDIN]

Tag version $version, type --help for more info.

EOF
}

# Print Help.
#
# Globals:
#   None
#
# Arguments:
#   None
#
# Returns:
#   None
Help() {
    cat <<- 'EOF'
Usage: tag <command> [arguments|STDIN]

Available Commands
   add        Add tag(s) to the file (Alias: a)
   delete     Delete tag(s) from the file (Alias: d)
   empty      Empty all tag(s) from the file (Alias: e)
   find       Find tag by text or word (Alias: f)
   list       List all tag from the file (Alias: f)

Format Command
   tag add|a    [-nfd]   [-D <n>] [-t <n>] <file|STDIN> <tag> [<tag>]...
   tag delete|d [-nfd]   [-D <n>] [-t <n>] <file|STDIN> <tag> [<tag>]...
   tag empty|e  [-nfd]   [-D <n>] [-t <n>] <file|STDIN> [<file>]...
   tag find|f   [-1aiwp] [-x <n>]... <tag> [<tag>]...
   tag list|l   [-fd]    [-D <n>] <file|STDIN> [<file>]...

Global options
   -h, --help
        Print this help
   --version
        Print current version
   -f, --type f
        Only processes regular files, even though there is directory in
        arguments
   -d, --type d
        Only processes directories, even though there is regular file in
        arguments

Options per Command.
   -n, --dry-run
        Perform a trial run with no changes made
        Available for `add`, `delete`, and `empty` command.
   -D, --directory
        Set the directory if file argument is not relative to $PWD.
        Available for `add`, `delete`, `empty`, and `list` command.
   -t, --tag-file=<n>
        Set filename for Tagging Directory only. The extension `.tag` must not
        contains in argument, because it always added.
        Available for `add`, `delete`, and `empty` command.

Options for Find command
   -1   Find in starting point directory level depth only and no recursive.
        This is equals to `maxdepth 1` in find command.
   -a, --all
        Do not exclude directory starting with .
   -i, --ignore-case
        Ignore case distinctions.
   -w, --word
        Find tag by word. Default is find tag by containing text
        Attention. For example: `-w fair`, then:
         - match for `fair` tag
         - match for `fair-play` tag
         - not match for `fairness` tag
   -p, --preview
        Preview find command without execute it
   -x, --exclude-dir=<dir>
        Skip directory and all files inside them. Repeat option to skip other
        directory

Example
   tag add "November Rain.mp3" love rock
   ls ~/Photos/*.jpg | tag add trip-Bali-2021
   ls ~/Photos/event/ | tag add hiking -D ~/Photos/event/
   ls IMG-20201201-171501* | tag add hiking
   ls IMG-20201201-171501* | tag add hiking gede-mountain
   ls IMG-20201201-171501* | tag add hiking gede-mountain trip-2015
   tag find hiking -w -f | tag delete hiking | tag add adventure

Tagging directory
   - Tag the directory doesn't rename the directory name.
   - Tag the directory will create a `.tag` file inside the directory and put
     the tags inside that file.
   - Extension `.tag` cannot be changed but you can add filename with
    `--tag-file` option or include that file in path.

Example
   tag add . work todo
   tag add ~/Photos --tag-file=.metadata   event trip
   tag add ~/Photos/.metadata.tag          event trip

EOF
}

# Mencetak error ke STDERR kemudian exit.
#
# Globals:
#   None
#
# Arguments:
#   $1: String yang akan dicetak
#
# Returns:
#   None
Die() {
    Error "$1"
    exit 1
}

# Mencetak error ke STDERR.
#
# Globals:
#   None
#
# Arguments:
#   $1: String yang akan dicetak
#
# Returns:
#   None
Error() {
    echo -e "\e[91m""$1""\e[39m" >&2
}

# Function yang terdiri dari berbagai validasi.
#
# Globals:
#   None
#
# Arguments:
#   $1: Command
#   $*: Argument untuk command.
#
# Returns:
#   None
Validate() {
    case $1 in
        minimal-arguments)
            if [[ $3 -lt $2 ]];then
                Die "$4"
            fi
            ;;
    esac
}

# Populate variable tentang path.
#
# Globals:
#   Used: directory
#   Modified: full_path, dirname, basename, extension, filename
#
# Arguments:
#   $1: Path Relative
#
# Returns:
#   None
PathModify () {
    case $1 in
        clear) full_path=; dirname=; basename=; filename=; extension= ;;
        full-path)
            if [[ ! $directory == '' ]];then
                if [[ $directory =~ \/$ ]];then
                    full_path="$directory$2"
                else
                    full_path="${directory}/$2"
                fi
            else
                full_path=$(realpath "$2")
            fi
        ;;
        dot-tag)
            full_path="${dirname}"
            tag_file="${filename}"
            dirname=$(dirname "$full_path")
            basename=
            filename=
            extension=
        ;;
        regular-file)
            dirname=$(dirname "$full_path")
            basename=$(basename -- "$full_path")
            extension="${basename##*.}"
            filename="${basename%.*}"
        ;;
        tag-directory)
            dirname="$full_path"
            full_path="${dirname}/${tag_file}.tag"
            basename="${tag_file}.tag"
            filename="${tag_file}"
            extension="tag"
    esac
}

# Modifikasi tags terhadap file.
#
# Globals:
#   Used: full_path, dirname, basename, extension, filename
#         dry_run, tags_arguments
#
# Arguments:
#   None
#
# Returns:
#   None
#
# Output:
#   Mencetak output jika eksekusi move berhasil.
TagFile() {
    local tags tags_new tags_new_filtered
    local tags_new_filtered_stringify tags_new_stringify
    local basename_new full_path_new output

    # Mencari informasi tag dari filename.
    #
    # Globals:
    #   Used: filename
    #   Modified: tags, filename
    #
    # Arguments:
    #   1: filename (basename tanpa extension)
    #
    # Returns:
    #   None
    tagInfo() {
        local _tags
        # Contoh:
        # grep -o -E '\[\]$' <<< "filename[]"
        # []
        _tags=$(echo "$1" | grep -o -E '\[\]$')
        if [[ ! $_tags == "" ]];then
            filename=$(echo "$1" | sed 's/\[\]$//g')
        fi
        # Contoh:
        # grep -o -E '\[[^\[]+\]$' <<< "trans[por[ta]si]"
        # [ta]si]
        _tags=$(echo "$1" | grep -o -E '\[[^\[]+\]$')
        if [[ ! $_tags == "" ]];then
            # anu=(echo "$1" | sed -i "s/\]$/g")
            filename=$(echo "$1" | sed -E 's/\[[^\[]+\]$//g')
            _tags=${_tags##\[}
            _tags=${_tags%%\]}
            tags=($_tags)
        fi
    }

    tagInfo "$filename"

    case $command in
        add|a)
            tags_new=("${tags[@]}" "${tags_arguments[@]}")
            # Alternative ArrayUnique.
            tags_new_filtered=($(echo "${tags_new[@]}" | tr ' ' '\n' | sort -u | tr '\n' ' '))
            tags_new_filtered_stringify=$(printf %s "$f" "${tags_new_filtered[@]/#/ }" | cut -c2-)
            basename_new="${filename}[${tags_new_filtered_stringify}].$extension"
        ;;
        replace|r)
            tags_new=("${tags_arguments[@]}")
            # Alternative ArrayUnique.
            tags_new_filtered=($(echo "${tags_new[@]}" | tr ' ' '\n' | sort -u | tr '\n' ' '))
            tags_new_filtered_stringify=$(printf %s "$f" "${tags_new_filtered[@]/#/ }" | cut -c2-)
            basename_new="${filename}[${tags_new_filtered_stringify}].$extension"
        ;;
        delete|d)
            ArrayDiff tags[@] tags_arguments[@]
            tags_new=("${_return[@]}")
            tags_new_stringify=$(printf %s "$f" "${tags_new[@]/#/ }" | cut -c2-)
            if [[ ! "$tags_new_stringify" == "" ]];then
                basename_new="${filename}[${tags_new_stringify}].$extension"
            else
                basename_new="${filename}.$extension"
            fi
        ;;
        empty|e)
            basename_new="${filename}.$extension"
        ;;
        list|l)
            for e in "${tags[@]}"; do
                echo "$e"
            done
    esac
    if [[ ! "$basename_new" == "" && ! "$basename" == "$basename_new" ]];then
        full_path_new="${dirname}/${basename_new}"
        if [[ "$dirname" == "$PWD" ]];then
            output="$basename_new"
        else
            output="$full_path_new"
        fi
        if [[ ! $dry_run == 1 ]];then
            mv "$full_path" "$full_path_new"
        fi
    else
        if [[ "$dirname" == "$PWD" ]];then
            output="$basename"
        else
            output="$full_path"
        fi
    fi
    echo "$output"
}

# Modifikasi tags terhadap directory.
#
# Globals:
#   Used: full_path, tag_file, dry_run, tags_arguments
#   Modified: full_path, dirname, basename, extension, filename
#
#
# Arguments:
#   None
#
# Returns:
#   None
#
# Output:
#   Mencetak output jika eksekusi move berhasil.
TagDirectory() {
    local e option string line
    local tags tags_new
    # Baris yang diawali dengan ` - ` (spasi strip spasi) adalah baris tag.
    isLineTag() {
        [[ $(echo "$1" | grep '^ - \w') ]] && return 0
        return 1
    }
    # Populate variable global tags.
    tagInfo() {
        if [ -f "$1" ];then
            while IFS="" read -r p || [ -n "$p" ]
            do
                line="$(printf '%s\n' "$p")"
                if isLineTag "$line";then
                    # Menggunakan double quote, maka trailing space ikut serta.
                    tags+=("$(echo "$line" | sed 's|^ - ||')")
                fi
            done < "$1"
        fi
    }

    tagInfo "$full_path"
    case $command in
        add|a)
            ArrayDiff tags_arguments[@] tags[@]
            tags_new=("${_return[@]}")
            if [[ ${#tags_new[@]} -gt 0 ]];then
                if [[ ! $dry_run == 1 ]];then
                    # Add EOL in end of file.
                    # https://unix.stackexchange.com/a/161853
                    if [ -f "$full_path" ];then
                        tail -c1 < "$full_path"  | read -r _ || echo >> "$full_path"
                    else
                        echo "# This file generated by tag commmand." >> "$full_path"
                    fi
                    for e in "${tags_new[@]}"; do
                        if grep -q '^ - $' "$full_path";then
                            # First match entire file.
                            # https://stackoverflow.com/a/148473
                            sed -i '0,/^ - $/s// - '"$e"'/' "$full_path"
                        elif grep -q '^ -$' "$full_path";then
                            # First match entire file.
                            # https://stackoverflow.com/a/148473
                            sed -i '0,/^ - $/s// - '"$e"'/' "$full_path"
                        else
                            echo " - $e" >> "$full_path"
                        fi
                    done
                fi
            fi
            echo "$full_path"
        ;;
        replace|r)
            if [ -f "$full_path" ];then
                if [[ ! $dry_run == 1 ]];then
                    for e in "${tags[@]}"; do
                        sed -i '/^ - '"$e"'$/d' "$full_path"
                    done
                    for e in "${tags_arguments[@]}"; do
                        echo " - $e" >> "$full_path"
                    done
                fi
            fi
            echo "$full_path"
        ;;
        delete|d)
            if [ -f "$full_path" ];then
                ArrayDiff tags[@] tags_arguments[@]
                if [[ ! ${#tags[@]} == ${#_return[@]} ]];then
                    if [[ ! $dry_run == 1 ]];then
                        for e in "${tags_arguments[@]}"; do
                            sed -i '/^ - '"$e"'$/d' "$full_path"
                        done
                    fi
                fi
            fi
            echo "$full_path"
        ;;
        empty|e)
            if [ -f "$full_path" ];then
                if [[ ! $dry_run == 1 ]];then
                    for e in "${tags[@]}"; do
                        sed -i '/^ - '"$e"'$/d' "$full_path"
                    done
                fi
                string=$(<"$full_path")
                if [[ "$string" == "# This file generated by tag commmand." ]];then
                    rm "$full_path" && echo Deleted. >&2
                fi
            fi
            echo "$full_path"
        ;;
        list|l)
            for e in "${tags[@]}"; do
                echo "$e"
            done
    esac
}

# Generator find command dan mengekseskusinya (optional).
#
# Globals:
#   Used: tags_arguments, process_file, process_dir
#         _1, all, ignore_case, preview, word, exclude_dir
#
# Arguments:
#   None
#
# Returns:
#   None
#
# Output:
#   Mencetak output jika eksekusi move berhasil.
FindGenerator() {
    local command
    local find_command
    local directory_exclude directory_exclude_default=() _directory_exclude
    local find_directory='.'
    local find_arg
    local find_arg_maxdepth
    local find_arg_directory_exclude
    local find_arg_filename
    local find_parameter_name='-name'
    local is_recursive=1
    local find_arg_name
    local while_lopping_command
    local grep_command grep_arg_E grep_arg_i grep_arg_w grep_arg
    if [[ $_1 == 1 ]];then
        is_recursive=0
        find_directory='.'
        find_arg_maxdepth=' -maxdepth 1'
    fi
    if [[ $ignore_case == 1 ]];then
        find_parameter_name='-iname'
    fi
    if [[ $is_recursive == 1 ]];then
        if [[ ! $all == 1 ]];then
            directory_exclude_default=(".*")
            find_directory='"$PWD"'
        fi
        directory_exclude=("${directory_exclude_default[@]}" "${exclude_dir[@]}")
        _directory_exclude=()
        for e in "${directory_exclude[@]}"; do
            _directory_exclude+=("-name \"${e}\"")
        done
        find_arg_directory_exclude=$(printf "%s" "${_directory_exclude[@]/#/ -o }" | cut -c5-)
        if [[ ${#directory_exclude[@]} -gt 1 ]];then
            find_arg_directory_exclude="\( $find_arg_directory_exclude \)"
        fi
        if [[ ${#directory_exclude[@]} -gt 0 ]];then
            find_arg_directory_exclude=" -type d ${find_arg_directory_exclude} -prune -false -o"
        fi
    fi
    find_arg=" ${find_directory}"
    find_arg_name=()
    if [[ $process_file == 1 ]];then
        for e in "${tags_arguments[@]}"; do
            e='*\[*'"$e"'*\]*'
            find_arg_name+=("${find_parameter_name} \"${e}\"")
        done
    fi
    if [[ $process_dir == 1 ]];then
        if [[ $tag_file == '' ]];then
            find_arg_name+=("-name \"*.tag\"")
        else
            find_arg_name+=("-name \"${tag_file}.tag\"")
        fi
    fi
    find_arg_filename=$(printf "%s" "${find_arg_name[@]/#/ -o }" | cut -c5-)
    if [[ ${#find_arg_name[@]} -gt 1 ]];then
        find_arg_filename="\( $find_arg_filename \)"
    fi
    find_arg_filename=" -type f ${find_arg_filename}"
    find_command="find${find_arg}${find_arg_maxdepth}${find_arg_directory_exclude}${find_arg_filename}"
    if [[ $find_directory == '"$PWD"' ]];then
        find_command+=" -exec sh -c 'echo \$0 | sed \"s|^\$PWD|.|\"' {} \;"
    fi
    grep_arg_E=
    grep_arg_i=
    grep_arg_w=
    grep_arg_q=
    grep_arg=$(printf "%s" "${tags_arguments[@]/#/\|}"  | cut -c2-)
    if [[ ${#tags_arguments[@]} -gt 1 ]];then
        grep_arg=" \"($grep_arg)\""
        grep_arg_E=' -E'
    else
        grep_arg=" $grep_arg"
    fi
    if [[ $ignore_case == 1 ]];then
        grep_arg_i=' -i'
    fi
    if [[ $word == 1 ]];then
        grep_arg_w=' -w'
    fi
    while_lopping_command=
    filter_filename_command=
    filter_directory_command=
    if [[ $process_file == 1 ]];then
        grep_command="grep${grep_arg_q}${grep_arg_E}${grep_arg_i}${grep_arg_w}${grep_arg}"
        # Grep dulu, agar kasus {tag}.tag tereliminir.
        # contoh todo.tag, sementara todo adalah tag dan command sbb:
        # `tag find todo`, ternyata malah memunculkan `todo.tag`.
        filter_filename_command+='echo "$path" | grep -Eo "\[(.*)\].[^.]+$" | sed -E "s|\[(.*)\].[^.]+$|\1|"'
        filter_filename_command+=" | $grep_command"
        filter_filename_command='[[ $('"$filter_filename_command"') ]] && echo "$path";'
    fi
    if [[ $process_dir == 1 ]];then
        grep_arg_q=' -q'
        grep_command="grep${grep_arg_q}${grep_arg_E}${grep_arg_i}${grep_arg_w}${grep_arg}"
        extract_extension='echo "$path" | sed -E "s|.*(\.[^.]+)$|\1|"'
        filter_directory_command='[[ $('"$extract_extension"') == ".tag" ]]'
        filter_directory_command+=' && grep "^ - \w" "$path" | sed -E "s|^ - (.*)|\1|" | '
        filter_directory_command+=" $grep_command"
        filter_directory_command+=' && echo "$path";'
    fi

    while_lopping_command='while IFS= read -r path; do'
    if [[ ! "$filter_filename_command" == '' ]];then
        while_lopping_command+=" $filter_filename_command"
    fi
    if [[ ! "$filter_directory_command" == '' ]];then
        while_lopping_command+=" $filter_directory_command"
    fi
    while_lopping_command+="done"
    command="${find_command} | ${while_lopping_command}"
    if [[ $preview == 1 ]];then
        echo "$command"
    else
        # syntax [[ ]] hanya ada pada bash dan tidak dikenal oleh sh, sehingga
        # execute command ini menggunakan bash
        echo "$command" | bash
    fi
    return 0
}

# Variable.
command=
files_arguments=()
tags_arguments=()

if [[ $help == 1 ]];then
    Help
    exit
fi

if [[ $version == 1 ]];then
    Version
    exit
fi

if [[ $1 == '' ]];then
    Usage
    exit 1
fi

command="$1";
case $command in
    add|a) shift ;;
    delete|d) shift ;;
    empty|e) shift ;;
    find|f) shift ;;
    list|l) shift ;;
    replace|r) shift ;;
    *) Die "Command '$1' unknown. Type --help for more info."
esac

if [ -t 0 ]; then
    # Jika dari terminal.
    case $command in
        find|f)
            Validate minimal-arguments 1 $# "Tag(s) not defined."
            while [[ $# -gt 0 ]]; do
                case "$1" in
                    *) tags_arguments+=("$1")
                    shift
                esac
            done
        ;;
        empty|e|list|l)
            Validate minimal-arguments 1 $# "File not defined."
            while [[ $# -gt 0 ]]; do
                case "$1" in
                    *) files_arguments+=("$1")
                    shift
                esac
            done
        ;;
        *)
            Validate minimal-arguments 1 $# "File not defined."
            Validate minimal-arguments 2 $# "Tag(s) not defined."
            files_arguments+=("$1");
            shift
            while [[ $# -gt 0 ]]; do
                case "$1" in
                    *) tags_arguments+=("$1")
                    shift
                esac
            done
    esac
else
    # Jika dari standard input.
    while read _each; do
        files_arguments+=("$_each")
    done </dev/stdin
    case $command in
        find|f)
            while [[ $# -gt 0 ]]; do
                case "$1" in
                    *) tags_arguments+=("$1")
                    shift
                esac
            done
            Validate minimal-arguments 1 ${#tags_arguments[@]} "Tag(s) not defined."
        ;;
        empty|e|list|l)
            while [[ $# -gt 0 ]]; do
                case "$1" in
                    *) files_arguments+=("$1")
                    shift
                esac
            done
            Validate minimal-arguments 1 ${#files_arguments[@]} "File not defined."
        ;;
        *)
            Validate minimal-arguments 1 $# "Tag(s) not defined."
            while [[ $# -gt 0 ]]; do
                case "$1" in
                    *) tags_arguments+=("$1")
                    shift
                esac
            done
            Validate minimal-arguments 1 ${#files_arguments[@]} "File not defined."
    esac
fi

ArrayUnique tags_arguments[@]
tags_arguments=("${_return[@]}")

case $filter in
    f) process_file=1; process_dir=0 ;;
    d) process_file=0; process_dir=1 ;;
    *) process_file=1; process_dir=1 ;;
esac

case $command in
    find|f) FindGenerator ;;
    *)  set -- "${files_arguments[@]}"
        while [[ $# -gt 0 ]]; do
            PathModify clear
            PathModify full-path "$1"
            if [ -f "$full_path" ];then
                PathModify regular-file
            fi
            if [[ $extension == 'tag' ]];then
                PathModify dot-tag
            fi
            if [[ -f "$full_path" && $process_file == 1 ]];then
                TagFile
            elif [[ -d "$full_path" && $process_dir == 1 ]];then
                PathModify tag-directory
                TagDirectory
            else
                Error "File not found: ${full_path}"
            fi
            shift
        done
esac

