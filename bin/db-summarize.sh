#!/usr/bin/env bash

DB='./etc/gutenberg.db'

echo "Number of records"
echo "-----------------"
echo "SELECT COUNT( t.gid ) FROM titles AS t, files AS f WHERE f.gid = t.gid AND f.file like '%.txt.utf-8' AND t.language IS 'en';" | sqlite3 $DB
echo
echo "Most frequent authors"
echo "---------------------"
echo "SELECT COUNT( t.author ) AS c, t.author FROM titles AS t, files AS f WHERE f.gid = t.gid AND f.file like '%.txt.utf-8' AND t.language IS 'en' group by t.author ORDER BY c desc limit 50;" | sqlite3 $DB
echo
echo "Most frequent classifications"
echo "-----------------------------"
echo "SELECT COUNT( c.classification ) AS c, c.classification FROM titles AS t, classifications AS c, files AS f WHERE f.gid = t.gid AND t.gid = c.gid AND f.file like '%.txt.utf-8' AND t.language IS 'en' group by c.classification ORDER BY c desc limit 50;" | sqlite3 $DB
echo
echo "Most frequent subjects"
echo "----------------------"
echo "SELECT COUNT( s.subject ) AS c, s.subject FROM subjects AS s, files AS f, titles AS t WHERE f.gid = t.gid AND t.gid = s.gid AND f.file like '%.txt.utf-8' AND t.language IS 'en' group by subject ORDER BY c desc limit 50;" | sqlite3 $DB

