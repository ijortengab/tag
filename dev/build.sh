#!/bin/bash

# Include.
source $(dirname $0)/tag.functions.sh

# Generate code.
chmod +x tag.options.sh
. tag.options.sh
# Create File.
touch ../tag.sh
chmod +x ../tag.sh
SOURCE=$(<tag.dev.sh)
# Replace line.
FILE_PARSE_OPTIONS=$(<tag.parse_options.sh)
FILE_FUNCTIONS=$(<tag.functions.sh)
FILE_ARRAY_DIFF=$(<bash/functions/array-diff/dev/array-diff.function.sh)
FILE_ARRAY_UNIQUE=$(<bash/functions/array-unique/dev/array-unique.function.sh)
SOURCE="${SOURCE//source \$(dirname \$0)\/tag.parse_options.sh/$FILE_PARSE_OPTIONS}"
SOURCE="${SOURCE//source \$(dirname \$0)\/tag.functions.sh/$FILE_FUNCTIONS}"
SOURCE="${SOURCE//source \$(dirname \$0)\/bash\/functions\/array-diff\/dev\/array-diff.function.sh/$FILE_ARRAY_DIFF}"
SOURCE="${SOURCE//source \$(dirname \$0)\/bash\/functions\/array-unique\/dev\/array-unique.function.sh/$FILE_ARRAY_UNIQUE}"
# Dump.
echo "${SOURCE}" > ../tag.sh
# Delete line.
sed -i '/var-dump\.function\.sh/d' ../tag.sh
sed -i '/tag\.debug\.sh/d' ../tag.sh
sed -i '/VarDump/d' ../tag.sh

# Create File.
touch ../README.md
SOURCE=$(<README.dev.md)
# Replace line.
HELP=`Help`
SOURCE="${SOURCE//\{\{HELP\}\}/$HELP}"
# Dump.
echo "${SOURCE}" > ../README.md
