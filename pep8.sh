#!/usr/bin/env bash

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

function prompt_user () {
    # This will only return if 'y' entered.
    MSG=$1

    while true; do
        read -p "$MSG [y/n] " -n 1 yn
        case $yn in
            [Yy]* ) echo; break;;
            [Nn]* ) echo; exit;;
            * ) echo "Please answer yes or no.";;
        esac
    done
}

RESULTS=$( pep8 $DIR/oft $DIR/tests* $DIR/src/python/oftest )

if [ -n "$RESULTS" ]; then
    echo "Found some issues..."
    echo "---"
    echo "$RESULTS"
    echo "---"

    prompt_user "Do you wish to auto-resolve these issues?"

    autopep8 $DIR/oft $DIR/tests* $DIR/src/python/oftest -r -i
    RESULTS=$( pep8 $DIR/oft $DIR/tests* $DIR/src/python/oftest )
    if [ -n "$RESULTS" ]; then
        echo "There are some remaining issues..."
        echo "---"
        echo "$RESULTS"
        echo "---"
        echo "These will need to be resolved manually."
    else
        echo "All issues resolved."
    fi
fi
