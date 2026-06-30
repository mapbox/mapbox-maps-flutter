#!/usr/bin/env bash

echo "-> Running 'dart format' to check project dart style."

RESULT=$(dart format --language-version=3.6 -n lib example/lib example/integration_test)

if [[ $? != 0 ]]; then
    echo "----> Command failed."
elif [[ $RESULT == *"0 changed"* ]]; then
    echo "----> All format is good ✅"
else
    echo "----> Some files are not well formated:"
    echo "$RESULT"
    exit 1
fi
