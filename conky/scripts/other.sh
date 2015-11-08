#!/bin/bash
# Simle misc script.
# Written by MR.

case $1 in
	-log-size)
		du -sh /var/log 2> /dev/null | grep /var/log | awk '{print $1}'
		;;
esac