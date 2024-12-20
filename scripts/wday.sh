#!/bin/bash -l
#
# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title workday journal
# @raycast.mode compact

# Optional parameters:
# @raycast.icon 📝

# Documentation:
# @raycast.description template for daily work journal & notes
# @raycast.author aaron g

today=$(date +"%Y-%m-%d")
tomorrow=$(gdate -d "tomorrow" '+%Y-%m-%d')
yesterday=$(gdate -d "yesterday" '+%Y-%m-%d')
file="$HOME/dev/notes_vault/work/daily-notes/"$(date +"%Y-%m-%d").md

cd $HOME/dev/notes_vault || exit

new_note() {
	touch "$file"

	# Format the file with the daily template
	cat <<EOF >"$file"
# $today

[[$yesterday]] - [[$tomorrow]]

## Intention

What do I want to achieve today and tomorrow?

## Tracking

- [ ] Run
- [ ] Strength training

## TODO

- [ ]

## Unplanned TODO

- [ ]

## Notes
EOF

}

# If the daily note does not exist, create a new one.
# this uses the test command with the -f flag.
if [ ! -f "$file" ]; then
	echo "File does not exist, creating new daily note."
	new_note
fi

# Open the daily note at the bottom of the file in insert mode
# nvim '+ normal Gzzo' "$file"
