#!/bin/sh
echo "enter standby..."
stfbcontrol hd
fp_control -l 0 1
echo on > /proc/stb/avs/0/standby
echo off > /dev/vfd 
fp_control -s `date +"%H:%M:%S %d-%m-%Y"`
echo "done"
