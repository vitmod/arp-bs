#!/bin/bash
# GNU make wrapper
# Create log file and copy output both to stdout and log
# Check if we have -j parameter
# if yes tell make to synchronize output, and grep it to make less verbose
# NOTE: there is no way to show what task is being executed
#       unfortunately when output is synced only 
# on error show log with less command

mkdir -p log
f="log/`date +%s`"
if test -f "$f"; then
	mv $f $f.1
fi
rm -f make.log
ln -s "$f" make.log
date > $f
echo >> $f

if echo "$@" |grep -E '\-j[0-9]+' >/dev/null; then
	echo '==> Parallel build'
	depdir="`pwd`/build/.deps/"
	export LC_ALL=C
	exec make -Oline "$@" 2>&1 |tee -a "$f" \
	|grep --line-buffered -e '^==>' -e '^touch' -e '^Makefile:' -e '^make:' \
	|sed -e "s,${depdir},,g"
	
	if test "${PIPESTATUS[0]}" -eq 0; then
		exit 0
	fi
	
	read -p "error, show log (Y/n)? " choice
	case "$choice" in 
	n ) exit ;;
	# TODO: more
	* )	less -i "+?error|fail" $f
		echo "log saved to $f, make.log symlink updated"
	;;
	esac
else
	echo '==> Linear build'
	exec make "$@" 2>&1 |tee -a "$f"
fi
