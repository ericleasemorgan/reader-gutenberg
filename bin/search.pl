#!/usr/bin/env perl

# search.pl - command-line interface to search a solr instance

# Eric Lease Morgan <emorgan@nd.edu>
# April 30, 2019 - first cut; based on earlier work
# May    2, 2019 - added classification and files (urls)


# configure
use constant FACETFIELD => ( 'facet_subject', 'facet_author', 'facet_language', 'facet_classification' );
use constant SOLR       => 'http://10.0.1.11:8983/solr/reader-gutenberg';
use constant TEXTS      => './texts';

# require
use strict;
use WebService::Solr;
use Data::Dumper;

# get input; sanity check
my $query  = $ARGV[ 0 ];
my $rows   = $ARGV[ 1 ];
if ( ! $query or ! $rows ) { die "Usage: $0 <query> <integer>\n" }

# initialize
my $solr = WebService::Solr->new( SOLR );
my $texts = TEXTS;

# build the search options
my %search_options = ();
$search_options{ 'facet.field' } = [ FACETFIELD ];
$search_options{ 'facet' }       = 'true';
$search_options{ 'rows' }        = $rows;

# search
my $response = $solr->search( $query, \%search_options );

# build a list of subject facets
my @facet_subject = ();
my $subject_facets = &get_facets( $response->facet_counts->{ facet_fields }->{ facet_subject } );
foreach my $facet ( sort { $$subject_facets{ $b } <=> $$subject_facets{ $a } } keys %$subject_facets ) { push @facet_subject, $facet . ' (' . $$subject_facets{ $facet } . ')'; }

# build a list of subject facets
my @facet_classification = ();
my $classification_facets = &get_facets( $response->facet_counts->{ facet_fields }->{ facet_classification } );
foreach my $facet ( sort { $$classification_facets{ $b } <=> $$classification_facets{ $a } } keys %$classification_facets ) { push @facet_classification, $facet . ' (' . $$classification_facets{ $facet } . ')'; }

# build a list of subject facets
my @facet_author = ();
my $author_facets = &get_facets( $response->facet_counts->{ facet_fields }->{ facet_author } );
foreach my $facet ( sort { $$author_facets{ $b } <=> $$author_facets{ $a } } keys %$author_facets ) { push @facet_author, $facet . ' (' . $$author_facets{ $facet } . ')'; }

# build a list of subject facets
my @facet_language = ();
my $language_facets = &get_facets( $response->facet_counts->{ facet_fields }->{ facet_language } );
foreach my $facet ( sort { $$language_facets{ $b } <=> $$language_facets{ $a } } keys %$language_facets ) { push @facet_language, $facet . ' (' . $$language_facets{ $facet } . ')'; }

# get the total number of hits
my $total = $response->content->{ 'response' }->{ 'numFound' };

# get number of hits returned
my @hits = $response->docs;

# start the output
print "Your search found $total item(s) and " . scalar( @hits ) . " item(s) are displayed.\n\n";
print '         subject facets: ', join( '; ', @facet_subject ), "\n\n";
print '          author facets: ', join( '; ', @facet_author ), "\n\n";
print '        language facets: ', join( '; ', @facet_language ), "\n\n";
print '  classification facets: ', join( '; ', @facet_classification ), "\n\n";

# loop through each document
for my $doc ( $response->docs ) {

	# parse
	my $author          = $doc->value_for(  'author' );
	my $title           = $doc->value_for(  'title' );
	my $gid             = $doc->value_for(  'gid' );
	my $rights          = $doc->value_for(  'rights' );
	my $file            = $doc->value_for(  'file' );
	my $language        = $doc->value_for(  'language' );
	my @subjects        = $doc->values_for( 'subject' );
	my @classifications = $doc->values_for( 'classification' );
	
	# create file name
	my $filename = "$texts/$gid.txt";
	
	# output
	print "\n$title\n\n";
	print "              author: $author\n";
	print "          subject(s): " . join( '; ', @subjects ), "\n";
	print "  classifications(s): " . join( '; ', @classifications ), "\n";
	print "            language: $language\n";
	print "              rights: $rights\n";
	print "          remote URL: $file\n";
	print "          local file: $filename\n";
	print "                 gid: $gid\n";
	print "\n";

}

# done
exit;


# convert an array reference into a hash
sub get_facets {

	my $array_ref = shift;
	
	my %facets;
	my $i = 0;
	foreach ( @$array_ref ) {
	
		my $k = $array_ref->[ $i ]; $i++;
		my $v = $array_ref->[ $i ]; $i++;
		next if ( ! $v );
		$facets{ $k } = $v;
	 
	}
	
	return \%facets;
	
}


