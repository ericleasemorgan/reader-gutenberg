#!/usr/local/anaconda/bin/python

# get.cgi - given a Project Gutenberg identifier, return the associated full text

# Eric Lease Morgan <emorgan@nd.edu>
# May 1, 2019 - first cut


# configure
HOME ='/var/www/html/sandbox/gutenberg'
GET  ='./bin/get.sh'

# require
import cgi
import os
import subprocess
import cgitb

# initialize
form = cgi.FieldStorage()
gid  = form.getvalue( 'gid' )

# make sane
os.chdir( HOME )
print ( "Content-Type: text/plain" )
print ()

# do the work and done
print( subprocess.check_output( [ GET, gid ] ) )
exit()
