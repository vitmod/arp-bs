#!/bin/sh

DIR=`pwd`
GITBRANCH=`git branch | sed -n -e 's/^\* \(.*\)/\1/p'`
REPLIST="apps driver"

for f in  $REPLIST ; do
	if [ -d "$f" ]; then
		echo "$f already cloned"
	else
		if [ "$2" = "dev" ]; then
			# dev
			git clone git@github.com:OpenAR-P/$f $f; cd $f; git checkout $GITBRANCH; cd $DIR
		else
			# usr
			git clone git://github.com/OpenAR-P/$f $f; cd $f; git checkout $GITBRANCH; cd $DIR
		fi
		echo "git clone" $f
	fi
done
