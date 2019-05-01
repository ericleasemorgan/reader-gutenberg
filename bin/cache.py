#!/usr/bin/env python

# cache.sh - store Project Gutenberg metadata to a triple store
# see --> https://github.com/c-w/Gutenberg

# Eric Lease Morgan <eric_morgan@infomotions.com>
# April 29, 2019 - first cut


# require
from gutenberg.acquire import get_metadata_cache

# initialize
cache = get_metadata_cache()

# do the work, wait a while, and done
cache.populate()
exit()
