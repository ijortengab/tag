#!/bin/bash
FLAG=(
    # Global Options:
        '--help|-h'
        '--version|-v'
    # Find Options:
        '--preview|-p'
        '--all|-a'
        '--word|-w'
        '--ignore-case|-i'
        '--recursive|-r'
    # Add/Delete/Clear Options:
        '--dry-run|-n'
)
MULTIVALUE=(
    # Find Options
        '--exclude-dir|-x'
)
VALUE=(
    # Global Options:
        '--tag-file|-T'
    # Add/Delete/Clear Options:
        '--directory|-d'
)
CSV=(
    # Global Options:
    'short:-F,parameter:filter,flag_option:true=f'
    'short:-D,parameter:filter,flag_option:true=d'
    'long:--type,parameter:filter,type:value'
    'long:--file,short:-f,parameter:files_arguments,type:multivalue'
    'long:--tag,short:-t,parameter:tags_arguments,type:multivalue'
)
source $(dirname $0)/bash/functions/code-generator-parse-options/dev/code-generator-parse-options.function.sh

CodeGeneratorParseOptions \
    --compact \
    --no-error-invalid-options \
    --no-error-require-arguments \
    --no-hash-bang \
    --no-original-arguments \
    --without-end-options-double-dash \
    --clean \
    --output-file tag.parse_options.sh \
    --debug-file tag.debug.sh \
    $@
