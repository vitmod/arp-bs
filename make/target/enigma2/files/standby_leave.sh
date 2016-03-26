#!/bin/sh 
echo "end standby..."
#enable hdmi
stfbcontrol he
fp_control -l 0 0
echo off > /proc/stb/avs/0/standby
echo "done"
