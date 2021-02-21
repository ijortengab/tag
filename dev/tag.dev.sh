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

command="$1"
shift
case $command in
    add|a) CommandAddSetDelete "$@";;
    set|s) CommandAddSetDelete "$@";;
    delete|d) CommandAddSetDelete "$@";;
    empty|e) CommandEmptyExport "$@";;
    find|f) CommandFind "$@";;
    export|x) CommandEmptyExport "$@";;
    copy|c) CommandCopy "$@";;
    *) Die "Command '$1' unknown. Type --help for more info."
esac
