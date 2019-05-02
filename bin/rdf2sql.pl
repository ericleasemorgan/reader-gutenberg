#!/usr/bin/env perl

# rdf2sql.pl - given a (Project Gutenberg) RDF file, output SQL statements
# usage: find cache -name "*.rdf" | parallel --gnu /rdf2sql.pl {} > ./inserts.sql 

# Eric Lease Morgan <eric_morgan@infomotions.com>
# May 1, 2019 - first cut


# require
use XML::XPath;
use strict;

# sanity check
my $rdf = $ARGV[ 0 ];
if ( ! $rdf ) { die "Usage: $0 <rdf>\n" }

# initialize
my $parser = XML::XPath->new( filename => $rdf );
binmode( STDOUT, ':utf8' );

# author/creator
my @authors = ();
my $authors = $parser->find( '//dcterms:creator' );
foreach my $author ( $authors->get_nodelist ) {

	my $item = $author->find( './pgterms:agent/pgterms:name' );
	push( @authors, $item );
	
}

# title
my @titles = ();
my $titles = $parser->find( '//dcterms:title' );
foreach my $title ( $titles->get_nodelist ) {

	my $item = $title->find( '.' );
	$item =~ s/\r//g;
	$item =~ s/\n/ /g;
	$item =~ s/ +/ /g;
	push( @titles, $item );
	
}

# rights
my @rights = ();
my $rights = $parser->find( '//dcterms:rights' );
foreach my $right ( $rights->get_nodelist ) {

	my $item = $right->find( '.' );
	push( @rights, $item );
	
}

# files
my %files = ();
my $files = $parser->find( '//pgterms:file' );
foreach my $file ( $files->get_nodelist ) {

	my $url  = $file->find( './@rdf:about' );
	my $mime = $file->find( './dcterms:format/rdf:Description/rdf:value' );	
	$files{ $url } = $mime;
	
}

my @urls = ();
foreach ( sort keys %files ) {

	my $file = $_;
	my $mime = $files{ $file };
	my $item = "$file ($mime)";
	push( @urls, $item );

}

# languages
my @languages = ();
my $languages = $parser->find( '//dcterms:language' );
foreach my $language ( $languages->get_nodelist ) {

	my $item = $language->find( './rdf:Description/rdf:value' );
	push( @languages, $item );
	
}

# identifier
my @identifiers = ();
my $identifiers = $parser->find( '//pgterms:ebook' );
foreach my $identifier ( $identifiers->get_nodelist ) {

	my $item = $identifier->find( './@rdf:about' );
	$item =~ s/ebooks\///g;
	push( @identifiers, $item );
	
}

# subjects
my @subjects        = ();
my @classifications = ();
my $subjects = $parser->find( '//dcterms:subject' ); 
foreach my $subject ( $subjects->get_nodelist ) {

	my $item = $subject->find( './rdf:Description/rdf:value' );
	
	# check for call number-esque value
	if ( length( $item ) == 2 ) { push(  @classifications, $item ) }
	else { push( @subjects, $item ) }
	
}

# debug
warn "      identifiers(s): " . join( '; ', @identifiers ) . "\n";
warn "           titles(s): " . join( '; ', @titles ) . "\n";
warn "           author(s): " . join( '; ', @authors ) . "\n";
warn "          subject(s): " . join( '; ', @subjects ) . "\n";
warn "  classifications(s): " . join( '; ', @classifications ) . "\n";
warn "           rights(s): " . join( '; ', @rights ) . "\n";
warn "        languages(s): " . join( '; ', @languages ) . "\n";
warn "            files(s): " . join( '; ', @urls ) . "\n";
warn "\n\n";

# select
my $gid      = $identifiers[ 0 ];
my $title    = $titles[ 0 ];
my $author   = $authors[ 0 ];
my $language = $languages[ 0 ];
my $rights   = $rights[ 0 ];

# escape
$title  =~ s/'/''/g;
$author =~ s/'/''/g;

# begin output
print "INSERT INTO titles ( gid, title, author, language, rights ) VALUES ( '$gid', '$title', '$author', '$language', '$rights' );\n";

# loop through each classification
for my $classification ( @classifications ) {

	# normalize and output
	$classification =~ s/'/''/g;
	print "INSERT INTO classifications ( gid, classification ) VALUES ( '$gid', '$classification' );\n";

}

# loop through each subject
for my $subject ( @subjects ) {

	# normalize and output
	$subject =~ s/'/''/g;
	print "INSERT INTO subjects ( gid, subject ) VALUES ( '$gid', '$subject' );\n";

}

# loop through each file (url)
for ( sort keys %files ) {

	# normalize and output
	my $file = $_;
	my $mime = $files{ $file };
	print "INSERT INTO files ( gid, file, mime ) VALUES ( '$gid', '$file', '$mime' );\n";

}

# done
exit;