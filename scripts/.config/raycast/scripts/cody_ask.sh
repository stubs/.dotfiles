#!/bin/bash -l

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title cody ask
# @raycast.mode fullOutput

# Optional parameters:
# @raycast.icon 🤖
# @raycast.argument1 { "type": "text", "placeholder": "Que onda?", "percentEncoded": false }
# @raycast.argument2 { "type": "text", "placeholder": "path/to/context-file", "optional": true, "percentEncoded": false }

# Documentation:
# @raycast.description Ask Cody AI a general question.
# @raycast.author aaron g


if [ -z "$2" ]; then
    cody chat --silent -m "$1" 2> /dev/null
else
    cody chat --silent -m "$1" --context-file "$2" 2> /dev/null
fi
