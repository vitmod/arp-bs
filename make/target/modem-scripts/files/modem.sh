#!/bin/sh

. /etc/modem.conf

start(){
if [ ! -d /etc/ppp/peers ]; then
    mkdir -p /etc/ppp/peers
fi
echo "ABORT '~'
ABORT 'BUSY'
ABORT 'NO CARRIER'
ABORT 'ERROR'
REPORT 'CONNECT'
'' 'ATZ'
SAY 'Calling WCDMA/UMTS/GPRS'
'' 'AT+CGDCONT=1,\"IP\",\"$APN\"'
'OK' 'ATD$DIALNUMBER'
'CONNECT' ''" > /etc/ppp/peers/0.chat

echo "ABORT '~'
ABORT 'BUSY'
ABORT 'NO CARRIER'
ABORT 'ERROR'
ABORT 'NO DIAL TONE'
ABORT 'NO ANSWER'
ABORT 'DELAYED'
REPORT 'CONNECT'
'' 'ATZ'
SAY 'Calling CDMA/EVDO'
'OK' 'ATDT#777'
'CONNECT' 'ATO'
'' ''" > /etc/ppp/peers/1.chat

echo "debug
/dev/$MODEMPORT
$MODEMSPEED
crtscts
noipdefault
lock
ipcp-accept-local
lcp-echo-interval 60
lcp-echo-failure 6
mtu $MODEMMTU
mru $MODEMMRU
usepeerdns
defaultroute
noauth
maxfail 0
holdoff 5
$MODEMPPPDOPTS
nodetach
persist
user $MODEMUSERNAME
password $MODEMPASSWORD
connect \"/usr/sbin/chat -s -S -V -t 60 -f /etc/ppp/peers/$MODEMTYPE.chat 2>/tmp/chat.log\"" > /etc/ppp/peers/dialup

if [ ! -c /dev/ppp ]; then
    mknod /dev/ppp c 108 0
fi
pppd call dialup & >> /tmp/chat.log
}

stop(){
killall pppd
rm -rf /etc/ppp/peers/0.chat
rm -rf /etc/ppp/peers/1.chat
rm -rf /etc/ppp/peers/dialup
rm -rf /etc/ppp/resolv.conf
}



if [ -z "$MODEMMTU" ] || [ "$MODEMMTU" = "auto" ]; then
    MODEMMTU=1492
fi
if [ -z "$MODEMMRU" ] || [ "$MODEMMRU" = "auto" ]; then
    MODEMMRU=1492
fi
if [ -z "$DIALNUMBER" ] || [ "$DIALNUMBER" = "auto" ]; then
    if [ "$MODEMTYPE" = "0" ]; then
	DIALNUMBER="*99#"
    else
	DIALNUMBER="#777"
    fi
fi

if [ "$DEBUG" = "1" ]; then
    echo -e "==================================================\nACTION $1 MODEMPORT $2" >> /tmp/modem.log
else
    rm -rf /tmp/modem.log
fi
if [ "$MODEMPORT" = "auto" ]; then
    LIST=`lsusb | awk '{print $6}'`
    for vidpid in $LIST; do
	PORT=`cat /etc/modem.list | grep "$vidpid"|cut -f 3 -d : -s`
	if [ ! -z $PORT ]; then
	    break
	fi
    done
    MODEMPORT="tty$PORT"
    if [ "$DEBUG" = "1" ]; then
	echo "Detected modem port is $MODEMPORT"  >> /tmp/modem.log
    fi
fi

case $1 in

    start)
	start
    ;;

    stop)
	stop
    ;;

    add)
	if [ "$MODEMAUTOSTART" = "1" ] && [ "$MODEMPORT" = "$2" ]; then
	    stop
	    sleep 2
	    start
	fi
    ;;

    remove)
    if [ "$MODEMPORT" = "$2" ]; then
	stop
    fi
    ;;

    *)
    ;;

esac

exit 0
