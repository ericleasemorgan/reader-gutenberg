#!/usr/bin/env bash

# db-update.sh - given a set of pre-configurations, update a database

# Eric Lease Morgan <eric_morgan@infomotions.com>
# April 29, 2019 - first cut


# configure
DB='./etc/gutenberg.db'
SQL='./sql/update.sql'
METADATA='./sql/metadata.sql'

# build transaction
echo "BEGIN TRANSACTION;" >  $SQL
cat $METADATA             >> $SQL
echo "END TRANSACTION;"   >> $SQL

# do the work and done
cat $SQL | sqlite3 $DB
exit
