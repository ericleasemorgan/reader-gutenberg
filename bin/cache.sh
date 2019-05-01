#!/usr/bin/env bash

# cache.sh - a front-end to cache.py

# Eric Lease Morgan <eric_morgan@infomotions.com>
# April 29, 2019 - first cut


# configure, do the work, and done
export GUTENBERG_DATA='./etc'
./bin/cache.py
exit
