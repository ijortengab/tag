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

command="$1";
case $command in
    add|a) shift ;;
    set|s) shift ;;
    delete|d) shift ;;
    empty|e) shift ;;
    find|f) shift ;;
    export|x) shift ;;
    *) Die "Command '$1' unknown. Type --help for more info."
esac

# Jika bukan dari terminal, yakni dari standard input.
if [ ! -t 0 ]; then
    while read _each; do
        files_arguments+=("$_each")
    done </dev/stdin
fi

# Free style format of operands.
# Auto set as file or tag.
while [[ $# -gt 0 ]]; do
    PathModify clear
    PathModify full-path "$1"
    VarDump full_path dirname basename filename extension PWD
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
        Validate minimal-arguments 1 ${#tags_arguments[@]} "Tag(s) not defined."
    ;;
    empty|e|export|x)
        Validate minimal-arguments 1 ${#files_arguments[@]} "File not defined."
    ;;
    *)
        Validate minimal-arguments 1 ${#files_arguments[@]} "File not defined."
        Validate minimal-arguments 1 ${#tags_arguments[@]} "Tag(s) not defined."
esac

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
