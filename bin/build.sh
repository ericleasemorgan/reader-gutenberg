#!/usr/bin/env bash

find rdf -name "*.rdf" | parallel --gnu ./bin/rdf2sql.pl {} > ./sql/inserts.sql 
./bin/db-initialize.sh 
./bin/db-summarize.sh
./bin/index-bibliographics.pl
./bin/keys2cache.sh
