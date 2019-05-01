#!/usr/bin/env bash

# db-initialize.sh - given a set of pre-configurations, create a database

# Eric Lease Morgan <eric_morgan@infomotions.com>
# April 29, 2019 - first cut


# configure
DB='./etc/gutenberg.db'
SQL='./sql/initialize.sql'
SCHEMA='./etc/schema.sql'
GID='./sql/gid.sql'

# initialize
rm -rf $DB
cat $SCHEMA | sqlite3 $DB

# update
echo "BEGIN TRANSACTION;" >  $SQL
cat $GID                  >> $SQL
echo "END TRANSACTION;"   >> $SQL

# do the work and done
cat $SQL | sqlite3 $DB
exit
