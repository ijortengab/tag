#!/bin/bash

source $(dirname $0)/tag.parse_options.sh
source $(dirname $0)/bash/functions/var-dump/dev/var-dump.function.sh
source $(dirname $0)/tag.debug.sh

source $(dirname $0)/bash/functions/array-diff/dev/array-diff.function.sh

source $(dirname $0)/bash/functions/array-unique/dev/array-unique.function.sh

source $(dirname $0)/tag.functions.sh

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
    replace|r) shift ;;
    delete|d) shift ;;
    empty|e) shift ;;
    find|f) shift ;;
    export|x) shift ;;
    *) Die "Command '$1' unknown. Type --help for more info."
esac

if [ -t 0 ]; then
    # Jika dari terminal.
    case $command in
        find|f)
            while [[ $# -gt 0 ]]; do
                case "$1" in
                    *) tags_arguments+=("$1")
                    shift
                esac
            done
        ;;
        empty|e|export|x)
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
        ;;
        empty|e|export|x)
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

VarDump files_arguments tags_arguments
ArrayUnique tags_arguments[@]
tags_arguments=("${_return[@]}")
VarDump files_arguments tags_arguments
VarDump filter

case $filter in
    f) process_file=1; process_dir=0 ;;
    d) process_file=0; process_dir=1 ;;
    *) process_file=1; process_dir=1 ;;
esac
VarDump process_file process_dir

case $command in
    find|f) FindGenerator ;;
    *)  set -- "${files_arguments[@]}"
        while [[ $# -gt 0 ]]; do
            VarDump full_path dirname basename filename extension PWD
            PathModify clear
            PathModify full-path "$1"
            if [ -f "$full_path" ];then
                PathModify regular-file
            fi
            VarDump full_path dirname basename filename extension PWD
            if [[ $extension == 'tag' ]];then
                PathModify dot-tag
            fi
            VarDump full_path dirname basename filename extension PWD
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

# VarDump --------
# VarDump full_path dirname basename filename extension PWD
# VarDump tags
