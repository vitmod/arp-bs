#!/bin/sh

prefix=/usr
exec_prefix=${prefix}
datarootdir=${prefix}/share


if [ -d /home/root ]; then
	export HOME=/home/root
	cd
fi
# neutrino exit codes:
#
# 1 - halt
# 2 - reboot
# 3 - restart neutrino
#
# >128 signal

	  echo "run" > /dev/vfd
	  echo "LOADING neutrino"
	  echo "starting neutrino ->"
		killall showiframe &
		/usr/bin/neutrino
	  rtv=$?
	  echo "neutrino ended <- RTV: " $rtv
	 case "$rtv" in
		0) echo "0"
		   echo "SHUTDOWN"
		   init 0;;
		1) echo "1"
		   echo "REBOOT"
		   init 6;;
		*) echo "*"
		   echo "ERROR"
		   init 6;;
	 esac
