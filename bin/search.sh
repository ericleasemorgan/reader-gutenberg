#!/usr/bin/env bash

# search.sh - a rudimentary query interface

# Eric Lease Morgan <emorgan@nd.edu>
# (c) University of Notre Dame; distributed under a GNU Public License

# October 13, 2022 - first cut


# configure
DATABASE='./etc/gutenberg.db'
SQL=".mode lines\nSELECT gid, author, title, subject, classification FROM indx WHERE indx MATCH '##QUERY##' ORDER BY RANK;"

# sanity check
if [[ -z $1 ]]; then
	echo "Usage: $0 <query>" >&2
	exit
fi

# get input, build the query, search, and done
QUERY=$1
SQL=$( echo $SQL | sed "s/##QUERY##/$QUERY/" )
echo -e $SQL | sqlite3 $DATABASE
exit
