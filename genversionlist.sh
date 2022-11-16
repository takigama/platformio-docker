#!/bin/bash


# quick and nasty script to get versions (on my laptop)

pip3 install platformio== 2>&1 > /dev/null | grep -i "(from versions" | cut -f 3 -d : | sed 's/[,)]//g' | tr ' ' '\n'  | sed '/^$/d'  > allversions.txt 
