#!/usr/bin/env perl

# rdf2sql.pl - given a (Project Gutenberg) RDF file, output SQL statements
# usage: find cache -name "*.rdf" | parallel ./rdf2sql.pl {} > ./gutenberg.sql 

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

# subjects
my @subjects = ();
my $subjects = $parser->find( '//dcterms:subject' ); 
foreach my $subject ( $subjects->get_nodelist ) {

	my $item = $subject->find( './rdf:Description/rdf:value' );
	push( @subjects, $item );
	
}

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

# debug
print "  identifiers(s): " . join( '; ', @identifiers ) . "\n";
print "       titles(s): " . join( '; ', @titles ) . "\n";
print "       author(s): " . join( '; ', @authors ) . "\n";
print "      subject(s): " . join( '; ', @subjects ) . "\n";
print "       rights(s): " . join( '; ', @rights ) . "\n";
print "    languages(s): " . join( '; ', @languages ) . "\n";
print "        files(s): " . join( '; ', @urls ) . "\n";
print "\n\n";

# done
exit;