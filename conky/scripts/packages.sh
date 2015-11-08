#!/bin/bash
# Simle packages script.
# Written by MR.

# System constants.
EXIT_SUCCESS=0
EXIT_FAILURE=1

case $1 in
  # Get current AUR packages updates count.
  -aur-updates-count)
    sudo aura -Au --dryrun | grep -c ' => '
    ;;

  -abs-updates-count)
    checkupdates | wc -l
    ;;
esac

exit $EXIT_SUCCESS