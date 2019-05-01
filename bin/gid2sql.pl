#!/usr/bin/env perl

# gid2sql.pl - given a configured JSON file, output SQL 

# Eric Lease Morgan <eric_morgan@infomotions.com>
# April 29, 2019 - first cut


# configure
use constant METADATA => './etc/metadata.json';

# require
use JSON;
use strict;

# initialize
binmode ( STDOUT, ':utf8' );
my $json = '';
{
	local $/; 
	open my $fh, "<", METADATA;
	$json = <$fh>;
	close $fh;
}
my $metadata = decode_json( $json );

# loop through each "record" in the metadata
foreach ( sort { $a <=> $b } keys $metadata ) {

	# parse
	my $gid      = $_;
	my $title    = $metadata->{ $gid }->{ 'title' }->[ 0 ];

	# normalize
	$title =~ s/\r//g;
	$title =~ s/\n/ /g;
	
	# check for title
	if ( $title ) {
	
		warn "$title ($gid)\n";
		print "INSERT INTO titles ( gid ) VALUES ( '$gid' );\n";
	
	}
	
}

# done
exit;
