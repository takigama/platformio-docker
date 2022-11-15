#!/bin/bash

# quick and dirty script for me to use to push/build

VERS=none
AVERS=none

if [ "x$1" == "x" ]
then
	VERS=latest
	echo "---- No Version Specified, using latest"
else
	VERS=$1
fi


if [ "x$VERS" == "xlatest" ]
then
	AVERS=`tail -1 allversions.txt`
else
	AVERS=$1
fi


docker build -f Dockerfile-python2 -t takigama/platformio:$VERS-python2 --build-arg version=$AVERS .
docker push takigama/platformio:$VERS-python2
