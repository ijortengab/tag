#!/bin/bash
# Create minified version.
chmod +x tag.options.sh
. tag.options.sh
# Replace line.
touch ../tag.sh
chmod +x ../tag.sh
SOURCE=$(<tag.dev.sh)
FILE_PARSE_OPTIONS=$(<tag.parse_options.sh)
FILE_FUNCTIONS=$(<tag.functions.sh)
FILE_ARRAY_DIFF=$(<bash/functions/array-diff/dev/array-diff.function.sh)
FILE_ARRAY_UNIQUE=$(<bash/functions/array-unique/dev/array-unique.function.sh)
SOURCE="${SOURCE//source \$(dirname \$0)\/tag.parse_options.sh/$FILE_PARSE_OPTIONS}"
SOURCE="${SOURCE//source \$(dirname \$0)\/tag.functions.sh/$FILE_FUNCTIONS}"
SOURCE="${SOURCE//source \$(dirname \$0)\/bash\/functions\/array-diff\/dev\/array-diff.function.sh/$FILE_ARRAY_DIFF}"
SOURCE="${SOURCE//source \$(dirname \$0)\/bash\/functions\/array-unique\/dev\/array-unique.function.sh/$FILE_ARRAY_UNIQUE}"
echo "${SOURCE}" > ../tag.sh
# Delete line.
sed -i '/var-dump\.function\.sh/d' ../tag.sh
sed -i '/tag\.debug\.sh/d' ../tag.sh
sed -i '/VarDump/d' ../tag.sh
# Readme
source $(dirname $0)/tag.functions.sh
SOURCE=$(<README.dev.md)
HELP=`Help`
SOURCE="${SOURCE//\{\{HELP\}\}/$HELP}"
echo "${SOURCE}" > ../README.md
# Add to $PATH
[ -d ~/bin ] && cp -r ../tag.sh ~/bin/tag
