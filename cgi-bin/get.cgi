#!/usr/bin/perl

# get.cgi - given a Project Gutenberg identifier, return the associated full text

# Eric Lease Morgan <emorgan@nd.edu>
# April 30, 2019 - first cut


# configure
use constant HOME => '/var/www/html/sandbox/gutenberg';
use constant GET  => './bin/get.sh';

# require
use CGI;
use CGI::Carp qw(fatalsToBrowser);
use strict;

# initialize
my $cgi = CGI->new;
my $gid = $cgi->param( 'gid' );
my $get = GET;

# done
chdir HOME;
print $cgi->header( -type => 'text/plain' );
print `$get $gid`;
exit;

