# Platformio Docker Builder

## Why?

Wasn't overly happy with the platformio containers available on the hub and there were a couple of things I wanted to make work:

 * Globally installed platformio executable
 * Ability to run as any user
 * Automated build as much as humanly possible in many environments
 * Have assets generated during the build mappable to directories and maintain the user ID
 * Each platformio project ends up with its own .platformio and .pio directories (nice isolation)

None of the existing containers did all of the above so I built my own and pushed a tag for all versions of platofmio. There should
be a tag for all versions of platformio available and the "latest" tag will always be the latest version available the last time
the build was run

## How...

This is how I run it - 
```
docker run -e HOME=`pwd` -u $UID -w `pwd` -v `pwd`:`pwd` --rm -it takigama/platformio platformio run
```

What it does:

 * Sets the home directory inside the container to the current directory (usually the where platformio.ini is)
 * Maps pwd to pwd inside the container
 * Sets the working directory to `pwd` (the directory where the command is executed)
 * removes the container after the build.

Obviously you can change the command on the end "platformio run" to anything you like, but the end result is that
the .platformio directory (where it stores all the binaries and such for building the device) are inside your current
directory as well as the .pio directory (where it stores the compiled firmware). The point being that it keeps alot of
the downloaded components of the build context and makes re-usability quite decent for any given project while also 
maintaining complete isolation between projects. 


If you're feeling brave you can try and navigate the pain of pushing a firmware from docker direct to a device:

```
docker run --device=/dev/ttyACM0 -e HOME=`pwd` -u 1000 -w `pwd` -v `pwd`:`pwd` --rm -it takigama/platformio platformio run -t upload
```

But it can be a bit painful and there are many things that can get in the way (user inside docker not having permissions to the
device for eg, and dockers support for such devices can be a bit average)

## Building The Docker 

If you wish to build your own docker container, grab a clone of the github at the top of the page and just run (this defaults to latest
python:3 image

```
docker build -t myownlittleplatformio:6.1.5 --build-arg version=6.1.5 -f Dockerfile .
```

If you need a platformio that needs version 2 of python (from image is python:2):

```
docker build -t myownlittleplatformio:2.0.0 --build-arg version=2.0.0 -f Dockerfile-python2 .
```


Change the tag to whatever you want for a tag (the bit after -t) and change the version=xxxxx to the version of platformio you are after.
The file "allversions.txt" is all the available versions of platformio available according to pip (i.e. built from the output of
"pip install platformio==") as per the last push to github


## Combined .platformio Directory

In the use case where you just want to have one .platformio directory for all your projects you can change the command line to something like
this:

```
docker run -e HOME=DIRECTORY_WHERE_I_WANT_MY_PLATFORMIO_DIRECTORY -u $UID -w `pwd` -v DIRECTORY_WHERE_I_WANT_MY_PLATFORMIO_DIRECTORY:DIRECTORY_WHERE_I_WANT_MY_PLATFORMIO_DIRECTORY -v `pwd`:`pwd` --rm -it takigama/platformio platformio run
```

Change DIRECTORY_WHERE_I_WANT_MY_PLATFORMIO_DIRECTORY to where you want it to store the .platformio directory
