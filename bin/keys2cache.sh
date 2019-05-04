#!/usr/bin/env bash

# keys2cache.sh - query a database for keys and URL, and pipe the result to a cacheing application

# Eric Lease Morgan <eric_morgan@infomotions.com>
# May 4, 2019 - first cut; cool!


# configure
DB='./etc/gutenberg.db'
SQL="select t.gid, f.file from titles as t, files as f where t.gid = f.gid and file like '%.txt.utf-8' AND t.language IS 'en' order by t.gid;"
URL2CACHE='./bin/url2cache.sh'

# execute the SQL, parse, do the work, and done
echo $SQL | sqlite3 $DB | tr "|" " " | parallel --colsep ' ' $URL2CACHE {1} {2}  
exit
