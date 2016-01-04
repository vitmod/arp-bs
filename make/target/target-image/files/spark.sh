#!/bin/bash
# This script creates flashable images Spark
# Author: Schischu modified by schpuntik & technic"
# It's expected that image rootfs is already in $prefix/release"

set -e

# check that we are in correct dir
curdir=`pwd`
if [ "`cd $(dirname $0) && pwd`" != "$curdir" ]; then
	echo "run me from `dirname $0`"
	exit 1
fi
tmpdir=$curdir/tmp
tmprootdir=$tmpdir/ROOT
tmpkerneldir=$tmpdir/KERNEL
outdir=$curdir/out

prefix=$1
if [ -z "$prefix" ]; then
	echo "set prefix"
	exit 1
fi
VERSION=$2
if [ -z "$VERSION" ]; then
	echo "set VERSION"
	exit 1
fi

echo "curdir       = $curdir"
echo "prefix       = $prefix"
echo "outdir       = $outdir"
echo "tmpkerneldir = $tmpkerneldir"
echo "tmpdir       = $tmpdir"
echo "tmprootdir   = $tmprootdir"
echo "VERSION      = $VERSION"

if [ -e $tmpdir ]; then
  rm -rf $tmpdir/*
fi
mkdir -p $tmpdir
# root partion
mkdir $tmprootdir
cp -a $prefix/release/* $tmprootdir
# boot partion
mkdir $tmpkerneldir
mv $tmprootdir/boot/uImage $tmpkerneldir/uImage

MKFSJFFS2=$prefix/host/bin/mkfs.jffs2
SUMTOOL=$prefix/host/bin/sumtool

if [ ! -e $outdir ]; then
  mkdir $outdir
fi

# --- KERNEL ---
# Size 8MB !
cp -f $tmpkerneldir/uImage $outdir/uImage

# --- ROOT ---
# Size 96MB !
echo "MKFSJFFS2 --qUfv -e0x20000 -r $tmprootdir -o $curdir/mtd_root.bin"
$MKFSJFFS2 -qUfv -e0x20000 -r $tmprootdir -o $curdir/mtd_root.bin
echo "SUMTOOL -v -p -e 0x20000 -i $curdir/mtd_root.bin -o $curdir/mtd_root.sum.pad.bin"
$SUMTOOL -v -p -e 0x20000 -i $curdir/mtd_root.bin -o $curdir/mtd_root.sum.pad.bin

rm -f $curdir/mtd_root.bin
rm -f $curdir/mtd_root.sum.bin

# check sizes
SIZE=`stat $tmpkerneldir/uImage -t --format %s`
SIZE=`printf "0x%x" $SIZE`
if [[ $SIZE > "0x800000" ]]; then
	echo "KERNEL TO BIG. $SIZE instead of 0x800000" >&2
	exit 1
fi

SIZE=`stat mtd_root.sum.pad.bin -t --format %s`
SIZE=`printf "0x%x" $SIZE`
if [[ $SIZE > "0x6000000" ]]; then
	echo "ROOT TO BIG. $SIZE instead of 0x6000000"  >&2
	exit 1
fi

# copy to outdir
mv $curdir/mtd_root.sum.pad.bin $outdir/e2jffs2.img
cp -f $tmpkerneldir/uImage $outdir/uImage

# create zip
rm -f $outdir/*.zip
cd $outdir; zip $VERSION.zip e2jffs2.img uImage


echo ""
echo ""
echo ""
echo "-----------------------------------------------------------------------"
echo "Flashimage created:"
echo `ls $outdir`

echo "-----------------------------------------------------------------------"
echo "To flash the created image copy the e2jffs2.img and uImage files to"
echo "your usb drive in the subfolder /enigma2/"
echo ""
echo "Before flashing make sure that enigma2 is the default system on your box."
echo "To set enigma2 as your default system press OK for 5 sec on your box "
echo "while the box is starting. As soon as \"FoYc\" is being displayed press"
echo "DOWN (v) on your box to select \"ENIG\" and press OK to confirm"
echo "To start the flashing process press OK for 5 sec on your box "
echo "while the box is starting. As soon as \"Fact\" is being displayed press"
echo "RIGHT (->) on your box to start the update"
echo ""
