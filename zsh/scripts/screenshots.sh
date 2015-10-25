#!/bin/zsh

wait-cycle() {
	SECONDS_TO_WAIT=$1

	while [[ $SECONDS_TO_WAIT > 0 ]]; do
		echo "$SECONDS_TO_WAIT second(s) to screenshot..."
		sleep 1
		SECONDS_TO_WAIT=$((SECONDS_TO_WAIT - 1))
	done
}

take-screenshot() {
	FILE_ROOT_FOLDER=$HOME/Documents
	FILE_NAME="screen-$(date +"%Y-%m-%d-%T")"
	FILE_NAME_FULL="$FILE_ROOT_FOLDER/$FILE_NAME.png"

	wait-cycle 3

	import -window root $FILE_NAME_FULL
}