#!/bin/sh

prefix=/usr
exec_prefix=${prefix}
datarootdir=${prefix}/share


if [ -d /root ]; then
	export HOME=/root
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
	  if [ -f /etc/init.d/cam ]; then
	    /etc/init.d/cam restart > /dev/null
	  fi
		killall showiframe &
		/usr/bin/neutrino
	  rtv=$?
	  echo "neutrino ended <- RTV: " $rtv
	 case "$rtv" in
		0) echo "0"
		   echo "SHUTDOWN"
		   if [ -f /etc/init.d/cam ]; then
		      /etc/init.d/cam stop > /dev/null
		   fi
		   init 0;;
		1) echo "1"
		   echo "REBOOT"
		   if [ -f /etc/init.d/cam ]; then
		      /etc/init.d/cam stop > /dev/null
		   fi
		   init 6;;
		*) echo "*"
		   echo "ERROR"
		   if [ -f /etc/init.d/cam ]; then
		      /etc/init.d/cam stop > /dev/null
		   fi
		   init 6;;
	 esac
