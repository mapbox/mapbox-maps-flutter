#!/bin/bash -eo pipefail
set -euo pipefail
make generate-android-style-code 2>&1 |tee >(grep -i -q 'Error:' && { echo 'Style extension code generation failed, please sync the style code and their templates.'; exit 1; }) >(grep -i -q '* Updating outdated file' && { echo 'Style extension validation failed, please sync the style code and their templates.'; exit 1; })
make generate-android-config-code 2>&1 |tee >(grep -i -q 'Error:' && { echo 'Serialisation configurations code generation failed, please sync the configuration code and their templates.'; exit 1; }) >(grep -i -q '* Updating outdated file' && { echo 'Serialisation configurations validation failed, please sync the configuration code and their templates.'; exit 1; })
make generate-android-annotation-code 2>&1 |tee >(grep -i -q 'Error:' && { echo 'Annotation plugin code generation failed, please sync the annotation plugin code and their templates.'; exit 1; }) >(grep -i -q '* Updating outdated file' && { echo 'Annotation plugin validation failed, please sync the annotation plugin code and their templates.'; exit 1; })
exit 0
