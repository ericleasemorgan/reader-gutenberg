#!/usr/bin/env perl

# metadata2sql.pl - given a configured JSON file, output SQL 

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
	my $gid   = $_;
	my $title = $metadata->{ $gid }->{ 'title' }->[ 0 ];

	# normalize
	$title =~ s/\r//g;
	$title =~ s/\n/ /g;
	
	# check for title
	if ( $title ) {
	
		# parse some more
		my $author   = $metadata->{ $gid }->{ 'author' }->[ 0 ];
		my $language = $metadata->{ $gid }->{ 'language' }->[ 0 ];
		my $rights   = $metadata->{ $gid }->{ 'rights' }->[ 0 ];
		my $subjects = $metadata->{ $gid }->{ 'subject' };

		# debug
		warn "       gid: $gid\n";
		warn "     title: $title\n";
		warn "    author: $author\n";
		warn "  langauge: $language\n";
		warn "    rights: $rights\n";
		warn "  subjects: " . join( '; ', @$subjects ) . "\n";
		warn "\n";
	
		# escape
		$title  =~ s/'/''/g;
		$author =~ s/'/''/g;
		$rights =~ s/'/''/g;
		
		# output
		print "UPDATE titles SET title = '$title', author = '$author', language = '$language', rights = '$rights' WHERE gid = '$gid';\n";
		
		# check for subjects; output some more
		if ( $subjects ) {
		
			# loop through each subject
			for my $subject ( @$subjects ) {
			
				# normalize and output
				$subject =~ s/'/''/g;
				print "INSERT INTO subjects ( gid, subject ) VALUES ( '$gid', '$subject' );\n";
			
			}
			
		}
			
	}
	
}

# done
exit;
