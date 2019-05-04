#!/usr/bin/env bash

# configure
STRIP='./strip.pl'

# get input
INPUTFILE=$1
DIRECTORY=$2

# configure
OUTPUTFILE=$( basename $INPUTFILE '.txt' )

# do the work and done
$STRIP $INPUTFILE > "$DIRECTORY/$OUTPUTFILE.txt"
exit
