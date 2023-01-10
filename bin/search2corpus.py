#!/usr/bin/env python

# search2corpus.py - given a query and a directory, create a corpus

# Eric Lease Morgan <emorgan@nd.edu>
# (c) University of Notre Dame; distributed under a GNU Public License

# October 13, 2022 - first cut


# configure
DATABASE  = './etc/gutenberg.db'
SQL       = "SELECT gid, author, title FROM indx WHERE indx MATCH '##QUERY##' ORDER BY RANK;"
TEXTS     = './texts'
EXTENSION = '.txt'
COLUMNS   = [ 'file', 'author', 'title' ]
METADATA  = 'metadata.csv'

# require
from pathlib import Path
import sqlite3
import sys
from shutil import copy
import pandas as pd

# get input
if len( sys.argv ) != 3 : sys.exit( 'Usage: ' + sys.argv[ 0 ] + " <query> <directory>" )
query     = sys.argv[ 1 ]
directory = sys.argv[ 2 ]

# initialize
connection             = sqlite3.connect( DATABASE )
connection.row_factory = sqlite3.Row
sql                    = SQL.replace( '##QUERY##', query )
texts                  = Path( TEXTS )
corpus                 = Path( directory )

# make sane
corpus.mkdir( exist_ok=True)

# find all items and process each one
rows    = connection.execute( sql )
records = []
for index, row in enumerate( rows ) :

	# parse
	gid    = str( row[ 'gid' ] )
	author = row[ 'author' ]
	title  = row[ 'title' ]
	
	# build file names
	source      = texts/( gid + EXTENSION )
	destination = corpus/( gid + EXTENSION )
	
	# debug
	sys.stderr.write( '         item: ' + str( index )       + '\n' )
	sys.stderr.write( '       author: ' + author             + '\n' )
	sys.stderr.write( '        title: ' + title              + '\n' )
	sys.stderr.write( '       source: ' + str( source )      + '\n' )
	sys.stderr.write( '  destination: ' + str( destination ) + '\n' )
	sys.stderr.write( '\n' )

	# try to do the work
	try                      : copy( source, destination )
	except FileNotFoundError : 
	
		sys.stderr.write( 'Error: File not found:' + str( source ) + '\n\n' )
		continue
	
	# update the list of (metadata) records
	file   = gid + EXTENSION
	record = [ file, author, title ]
	records.append( record )

metadata = pd.DataFrame( records, columns=COLUMNS )
metadata.to_csv( corpus/METADATA, index=False )


		