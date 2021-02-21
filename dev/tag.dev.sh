#!/bin/bash

source $(dirname $0)/tag.parse_options.sh
source $(dirname $0)/bash/functions/var-dump/dev/var-dump.function.sh
source $(dirname $0)/tag.debug.sh

source $(dirname $0)/bash/functions/array-diff/dev/array-diff.function.sh

source $(dirname $0)/bash/functions/array-unique/dev/array-unique.function.sh

source $(dirname $0)/tag.functions.sh

# Variable.
command=

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

# Standard Input kita anggap sebagai files.
if [ ! -t 0 ]; then
    while read _each; do
        files_arguments+=("$_each")
    done </dev/stdin
fi

command="$1";
case $command in
    add|a) shift; CommandAddSetDelete "$@"; exit;;
    set|s) shift; CommandAddSetDelete "$@"; exit;;
    delete|d) shift; CommandAddSetDelete "$@"; exit;;
    empty|e) shift; CommandEmpty "$@"; exit;;
    find|f) shift; CommandFind "$@"; exit;;
    export|x) shift; CommandExport "$@"; exit;;
    *) Die "Command '$1' unknown. Type --help for more info."
esac

# Free style format of operands.
# Auto set as file or tag.
while [[ $# -gt 0 ]]; do
    PathModify clear
    PathModify full-path "$1"
    if [ -f "$full_path" ];then
        files_arguments+=("$1")
    elif [ -d "$full_path" ];then
        files_arguments+=("$1")
    else
        tags_arguments+=("$1")
    fi
    shift
done

# Validate.
case $command in
    find|f)
        Validate minimal-arguments 0 0
    ;;
    empty|e)
        Validate minimal-arguments 1 ${#files_arguments[@]} "File not defined."
    ;;
    *)
        Validate minimal-arguments 1 ${#files_arguments[@]} "File not defined."
        Validate minimal-arguments 1 ${#tags_arguments[@]} "Tag(s) not defined."
esac

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
