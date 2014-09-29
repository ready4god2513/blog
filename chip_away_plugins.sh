#!/bin/bash

echo "stashing working directory changes..."
git stash >/dev/null
for plugin in plugins/*; do
    echo "=> Trying out removing plugin ${plugin}..."
    git rm ${plugin}
    ./build.sh 2&>1  >/dev/null
    echo "==> Done building, checking for differences."
    DIFF=$(git diff)
    if [[ "$DIFF" != "" ]]; then
        echo "==> There was a difference after removing the plugin ${plugin}!"
        git reset HEAD ${plugin}
        git checkout -- ${plugin} public/
    fi
done
echo "restoring working directory changes..."
git stash pop >/dev/null