#!/usr/bin/env python

# index.py - given a few configurations, make a database easier to search

# Eric Lease Morgan <emorgan@nd.edu>
# (c) University of Notre Dame; distributed under a GNU Public License

# October 13, 2022 - first cut; based on previous work ("I've only written a dozen programs.")


# configure
DATABASE   = './etc/gutenberg.db'
DROPINDX   = 'DROP TABLE IF EXISTS indx;'
CREATEINDX = 'CREATE VIRTUAL TABLE indx USING FTS5( gid, author, title, subject, classification );'
INDEX      = 'INSERT INTO indx SELECT t.gid, t.author, t.title, group_concat( s.subject, "; " ), c.classification FROM titles AS t, subjects AS s, classifications AS c WHERE t.gid IS s.gid AND t.gid IS c.gid AND t.language IS "en" GROUP BY s.gid;';

# require
import sqlite3

# connect to database
connection                 = sqlite3.connect( DATABASE )
connection.isolation_level = None

# index; do the work and done
connection.execute( DROPINDX )
connection.execute( CREATEINDX )
connection.execute( INDEX )
exit()