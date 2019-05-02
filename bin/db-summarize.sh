#!/usr/bin/env bash

DB='./etc/gutenberg.db'

echo "Number of records"
echo "-----------------"
echo "SELECT COUNT( title ) FROM titles;" | sqlite3 $DB
echo
echo "Most frequent authors"
echo "---------------------"
echo "SELECT COUNT( author ) AS c, author FROM titles group by author order by c desc limit 50;" | sqlite3 $DB
echo
echo "Most frequent classifications"
echo "-----------------------------"
echo "SELECT COUNT( classification ) AS c, classification FROM classifications group by classification order by c desc limit 50;" | sqlite3 $DB
echo
echo "Most frequent subjects"
echo "----------------------"
echo "SELECT COUNT( subject ) AS c, subject FROM subjects group by subject order by c desc limit 50;" | sqlite3 $DB
echo
echo "Most frequent langauges"
echo "-----------------------"
echo "SELECT COUNT( language ) AS c, language FROM titles group by language order by c desc limit 50;" | sqlite3 $DB
