#!/bin/bash

normal="$(tput sgr0)"
red="$(tput setaf 1)"
yellow="$(tput setaf 3)"
cyan="$(tput setaf 6)"
magenta="$(tput setaf 5)"

echo
echo ${yellow}'# Options'${normal}
echo
echo    ${red}-h, --help${normal}" ....... "${cyan}\$help${normal}" ....... = "${magenta}$help${normal}
echo    ${red}-v, --version${normal}" .... "${cyan}\$version${normal}" .... = "${magenta}$version${normal}
echo    ${red}-D${normal}" ............... "${cyan}\$filter${normal}" ..... = "${magenta}$filter${normal}
echo    ${red}-F${normal}" ............... "${cyan}\$filter${normal}" ..... = "${magenta}$filter${normal}
echo    ${red}-a, --all${normal}" ........ "${cyan}\$all${normal}" ........ = "${magenta}$all${normal}
echo    ${red}-d, --directory${normal}"    "${cyan}\$directory${normal}"    = "${magenta}$directory${normal}
echo    ${red}-n, --dry-run${normal}" .... "${cyan}\$dry_run${normal}" .... = "${magenta}$dry_run${normal}
echo -n ${red}-x, --exclude-dir${normal}"  "${cyan}\$exclude_dir${normal}"  = ""( "
for _e_ in "${exclude_dir[@]}"; do if [[ $_e_ =~ " " ]];then echo -n \"${magenta}"$_e_"${normal}\"" ";else echo -n ${magenta}"$_e_"${normal}" ";fi;done
echo ")"
echo -n ${red}-f, --file${normal}" ....... "${cyan}\$files_arguments${normal}"  = ""( "
for _e_ in "${files_arguments[@]}"; do if [[ $_e_ =~ " " ]];then echo -n \"${magenta}"$_e_"${normal}\"" ";else echo -n ${magenta}"$_e_"${normal}" ";fi;done
echo ")"
echo    ${red}-i, --ignore-case${normal}"  "${cyan}\$ignore_case${normal}"  = "${magenta}$ignore_case${normal}
echo    ${red}-p, --preview${normal}" .... "${cyan}\$preview${normal}" .... = "${magenta}$preview${normal}
echo    ${red}-r, --recursive${normal}"    "${cyan}\$recursive${normal}"    = "${magenta}$recursive${normal}
echo    ${red}--type${normal}" ........... "${cyan}\$filter${normal}" ..... = "${magenta}$filter${normal}
echo    ${red}-T, --tag-file${normal}" ... "${cyan}\$tag_file${normal}" ... = "${magenta}$tag_file${normal}
echo -n ${red}-t, --tag${normal}" ........ "${cyan}\$tags_arguments${normal}"  = ""( "
for _e_ in "${tags_arguments[@]}"; do if [[ $_e_ =~ " " ]];then echo -n \"${magenta}"$_e_"${normal}\"" ";else echo -n ${magenta}"$_e_"${normal}" ";fi;done
echo ")"
echo    ${red}-w, --word${normal}" ....... "${cyan}\$word${normal}" ....... = "${magenta}$word${normal}

echo
echo ${yellow}'# New Arguments (Operand)'${normal}
echo
echo ${cyan}\$1${normal} = ${magenta}$1${normal}
echo ${cyan}\$2${normal} = ${magenta}$2${normal}
echo ${cyan}\$3${normal} = ${magenta}$3${normal}
echo ${cyan}\$4${normal} = ${magenta}$4${normal}
echo ${cyan}\$5${normal} = ${magenta}$5${normal}
echo ${cyan}\$6${normal} = ${magenta}$6${normal}
echo ${cyan}\$7${normal} = ${magenta}$7${normal}
echo ${cyan}\$8${normal} = ${magenta}$8${normal}
echo ${cyan}\$9${normal} = ${magenta}$9${normal}
