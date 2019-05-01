#!/usr/bin/env bash

# get.sh - a front-end to get.py

# Eric Lease Morgan <eric_morgan@infomotions.com>
# April 29, 2019 - first cut


# configure, do the work, and done
export GUTENBERG_DATA='./etc'
./bin/get.py $1
exit
