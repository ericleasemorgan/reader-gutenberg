#!/usr/bin/env bash

# build.sh - a brain-dead script to create a local SQL database from a Gutenberg triple-store

# Eric Lease Morgan <eric_morgan@infomotions.com>
# April 29, 2019 - first cut


echo "listing gutenberg identifiers" >&2
./bin/gid2sql.pl > ./sql/gid.sql

echo "initializing database" >&2
./bin/db-initialize.sh

echo "extracting metadata" >&2
./bin/metadata2sql.pl > ./sql/metadata.sql

echo "updating database" >&2
./bin/db-update.sh

echo "done" >&2
exit
