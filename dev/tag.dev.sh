#!/bin/bash

source $(dirname $0)/tag.parse_options.sh
source $(dirname $0)/bash/functions/var-dump/dev/var-dump.function.sh
source $(dirname $0)/tag.debug.sh

source $(dirname $0)/bash/functions/array-diff/dev/array-diff.function.sh

source $(dirname $0)/tag.functions.sh

# Variable.
command=
files_arguments=()
tags_arguments=()

if [[ $help == 1 ]];then
    Help
    exit 1
fi

if [[ $1 == '' ]];then
    Usage
    exit 1
fi

command="$1";
case $command in
    add|a) shift ;;
    delete|d) shift ;;
    clear|c) shift ;;
    find|f) shift ;;
    *) Die "Command unknown. Type --help for more info."
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
        clear|c)
            Validate minimal-arguments 1 $# "File not defined."
            while [[ $# -gt 0 ]]; do
                case "$1" in
                    *) files_arguments+=("$1")
                    shift
                esac
            done
        ;;
        *)
            Validate minimal-arguments 1 $# "Tag(s) not defined."
            Validate minimal-arguments 2 $# "File not defined."
            last_argument=${@:$#:1}
            files_arguments+=("$last_argument");
            while [[ $# -gt 1 ]]; do
                case "$1" in
                    *) tags_arguments+=("$1")
                    shift
                esac
            done
            # Delete the last argument.
            shift
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
        clear|c)
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
            # Delete the last argument.
            shift
    esac

fi
# VarDump files_arguments tags_arguments

case $command in
    find|f) FindManager ;;
    *) set -- "${files_arguments[@]}"
        while [[ $# -gt 0 ]]; do
            PathInfo "$1"
            if [ -d "$full_path" ];then
                # Todo.
                echo -n
            elif [ -f "$full_path" ];then
                TagManager
            else
                Error "File not found: ${basename}."
            fi
            shift
        done
esac

# VarDump --------
# VarDump full_path dirname basename filename extension PWD
# VarDump tags
