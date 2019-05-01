#!/usr/bin/env bash

# get.sh - a front-end to get.py

# Eric Lease Morgan <eric_morgan@infomotions.com>
# April 29, 2019 - first cut
# May    1, 2019 - added bits of abstraction


# configure
export GUTENBERG_DATA='./etc'
GET='./bin/get.py'

# do the work and done; needs sanity checking
$GET $1
exit
