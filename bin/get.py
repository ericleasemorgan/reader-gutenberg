#!/usr/local/anaconda/bin/python

# get.py - given an identifier, return a Gutenberg text file

# Eric Lease Morgan <eric_morgan@infomotions.com>
# April 29, 2019 - first cut


# require
from gutenberg.acquire import load_etext
from gutenberg.cleanup import strip_headers
import sys

# sanity check
if len( sys.argv ) != 2 :
	sys.stderr.write( 'Usage: ' + sys.argv[ 0 ] + " <id>\n" )
	quit()

# get input
gid = int( sys.argv[ 1 ] )

# do the work and done
print( strip_headers( load_etext( gid ) ).strip() )
exit()
