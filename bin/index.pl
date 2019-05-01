#!/usr/bin/perl

# index.pl - make the content searchable

# Eric Lease Morgan <emorgan@nd.edu>
# April 30, 2019 - first investigations; based on other work


# configure
use constant DATABASE => './etc/gutenberg.db';
use constant DRIVER   => 'SQLite';
use constant QUERY    => qq(SELECT * FROM titles WHERE ( language IS 'en' AND rights IS 'Public domain in the USA.' AND author LIKE 'Longfellow%' ) ORDER BY gid;);
use constant SOLR     => 'http://localhost:8983/solr/gutenberg';
use constant GET      => './bin/get.sh';
use constant START    => 1000;
use constant MAX      => 10000000000;

# require
use DBI;
use strict;
use WebService::Solr;

# initialize
my $solr   = WebService::Solr->new( SOLR );
binmode( STDOUT, ':utf8' );
my $driver    = DRIVER; 
my $database  = DATABASE;
my $dbh       = DBI->connect( "DBI:$driver:dbname=$database", '', '', { RaiseError => 1 } ) or die $DBI::errstr;
my $get       = GET;

# find titles
my $handle = $dbh->prepare( QUERY );
$handle->execute() or die $DBI::errstr;

# process each title
my $i = 0;
while( my $titles = $handle->fetchrow_hashref ) {
	
	my $author   = '';
	my $language = '';
	my $rights   = '';

	# parse the title data
	my $gid      = $$titles{ 'gid' };
	my $title    = $$titles{ 'title' };
	my $author   = $$titles{ 'author' };
	my $rights   = $$titles{ 'rights' };
	my $language = $$titles{ 'language' };
	
	# limit indexing, so I don't have to start from the begining
	next if ( $gid < START );
	
	# get subjects
	my @subjects       = ();
	my @facet_subjects = ();
	my $subhandle = $dbh->prepare( qq(SELECT subject FROM subjects WHERE gid='$gid';) );
	$subhandle->execute() or die $DBI::errstr;
	while( my @subject = $subhandle->fetchrow_array ) {
	
		# update list of fully fleshed out subjects
		push @subjects, $subject[ 0 ];
		
		# build list of subject facets
		foreach my $facet ( split( ' -- ', $subject[ 0 ] ) ) { push @facet_subjects, $facet }
		
	}
	
	# get the full text and normalize it
	my $fulltext = `$get $gid`;
	$fulltext    =~ s/\r//g;
	$fulltext    =~ s/\n/ /g;
	$fulltext    =~ s/ +/ /g;
	$fulltext    =~ s/[^\x09\x0A\x0D\x20-\x{D7FF}\x{E000}-\x{FFFD}\x{10000}-\x{10FFFF}]//go;
	
	# debug; dump
	warn "         gid: $gid\n";
	warn "       title: $title\n";
	warn "      author: $author\n";
	warn "    language: $language\n";
	warn "      rights: $rights\n";
	warn "  subject(s): ", join( '; ', @subjects ), "\n";
	warn "   facets(s): ", join( '; ', @facet_subjects ), "\n";
	#warn "   full text: $fulltext\n";
	warn "\n";
	
	# create data
	my $solr_author         = WebService::Solr::Field->new( 'author'         => $author );
	my $solr_facet_author   = WebService::Solr::Field->new( 'facet_author'   => $author );
	my $solr_facet_language = WebService::Solr::Field->new( 'facet_language' => $language );
	my $solr_gid            = WebService::Solr::Field->new( 'gid'            => $gid );
	my $solr_langauge       = WebService::Solr::Field->new( 'language'       => $language );
	my $solr_rights         = WebService::Solr::Field->new( 'rights'         => $rights );
	my $solr_title          = WebService::Solr::Field->new( 'title'          => $title );
	my $solr_fulltext       = WebService::Solr::Field->new( 'fulltext'       => $fulltext );

	# fill a solr document with simple fields
	my $doc = WebService::Solr::Document->new;
	$doc->add_fields( $solr_facet_language, $solr_author, $solr_facet_author, $solr_gid, $solr_langauge, $solr_rights, $solr_title, $solr_fulltext );

	# add complex fields
	foreach ( @subjects )       { $doc->add_fields(( WebService::Solr::Field->new( 'subject'       => $_ ))) }
	foreach ( @facet_subjects ) { $doc->add_fields(( WebService::Solr::Field->new( 'facet_subject' => $_ ))) }

	# save/index
	$solr->add( $doc );

	# increment and check
	$i++;
	last if ( $i == MAX );
	
}

# done
exit;

