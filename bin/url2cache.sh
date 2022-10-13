#!/usr/bin/env bash

# url2cache.sh - given a key and a URL, cache a file 

# Eric Lease Morgan <eric_morgan@infomotions.com>
# May 4, 2019 - first cut


# configure
DIRECTORY='./texts'
STRIP='./bin/strip.pl'
TMP='./tmp'

# get input
KEY=$1
URL=$2

# initialize
OUTPUTFILE="$DIRECTORY/$KEY.txt"

# conditionally configure, harvest, strip, save, and clean up
if [[ ! -f $OUTPUTFILE ]]; then

	TEMPORARYFILE="$TMP/$KEY.txt"
	wget --no-check-certificate -nv -O $TEMPORARYFILE $URL
	if [[ -f $TEMPORARYFILE ]]; then
	
		$STRIP $TEMPORARYFILE > $OUTPUTFILE
		#rm $TEMPORARYFILE
	fi

fi

# done
exit

