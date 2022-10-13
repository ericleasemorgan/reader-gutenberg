#!/usr/bin/env perl

# configure
use constant STARTERS => ( "*END*THE SMALL PRINT", "*** START OF THE PROJECT GUTENBERG", "*** START OF THIS PROJECT GUTENBERG", "This etext was prepared by", "E-text prepared by", "Produced by", "Distributed Proofreading Team", "Proofreading Team at http://www.pgdp.net", "http://gallica.bnf.fr)", "      http://archive.org/details/", "http://www.pgdp.net", "by The Internet Archive)", "by The Internet Archive/Canadian Libraries", "by The Internet Archive/American Libraries", "public domain material from the Internet Archive", "Internet Archive)", "Internet Archive/Canadian Libraries", "Internet Archive/American Libraries", "material from the Google Print project", "*END THE SMALL PRINT", "***START OF THE PROJECT GUTENBERG", "This etext was produced by", "*** START OF THE COPYRIGHTED", "The Project Gutenberg", "http://gutenberg.spiegel.de/ erreichbar.", "Project Runeberg publishes", "Beginning of this Project Gutenberg", "Project Gutenberg Online Distributed", "Gutenberg Online Distributed", "the Project Gutenberg Online Distributed", "Project Gutenberg TEI", "This eBook was prepared by", "http://gutenberg2000.de erreichbar.", "This Etext was prepared by", "This Project Gutenberg Etext was prepared by", "Gutenberg Distributed Proofreaders", "Project Gutenberg Distributed Proofreaders", "the Project Gutenberg Online Distributed Proofreading Team", "**The Project Gutenberg", "*SMALL PRINT!", "More information about this book is at the top of this file.", "tells you about restrictions in how the file may be used.", "l'authorization à les utilizer pour preparer ce texte.", "of the etext through OCR.", "*****These eBooks Were Prepared By Thousands of Volunteers!*****", "We need your donations more than ever!", " *** START OF THIS PROJECT GUTENBERG", "****     SMALL PRINT!", '["Small Print" V.', '      (http://www.ibiblio.org/gutenberg/', 'and the Project Gutenberg Online Distributed Proofreading Team', 'Mary Meehan, and the Project Gutenberg Online Distributed Proofreading', '                this Project Gutenberg edition.' );
use constant ENDERS => ("*** END OF THE PROJECT GUTENBERG", "*** END OF THIS PROJECT GUTENBERG", "***END OF THE PROJECT GUTENBERG", "End of the Project Gutenberg", "End of The Project Gutenberg", "Ende dieses Project Gutenberg", "by Project Gutenberg", "End of Project Gutenberg", "End of this Project Gutenberg", "Ende dieses Projekt Gutenberg", "        ***END OF THE PROJECT GUTENBERG", "*** END OF THE COPYRIGHTED", "End of this is COPYRIGHTED", "Ende dieses Etextes ", "Ende dieses Project Gutenber", "Ende diese Project Gutenberg", "**This is a COPYRIGHTED Project Gutenberg Etext, Details Above**", "Fin de Project Gutenberg", "The Project Gutenberg Etext of ", "Ce document fut presente en lecture", "Ce document fut présenté en lecture", "More information about this book is at the top of this file.", "We need your donations more than ever!", "END OF PROJECT GUTENBERG", " End of the Project Gutenberg", " *** END OF THIS PROJECT GUTENBERG" );

# require
use strict;

# get input
my $file = $ARGV[ 0 ];
if ( ! $file ) { die "Usage: $0 <file>\n" }

# initialize markers
my %starters = (); foreach ( STARTERS ) { $starters{ $_ }++ }
my %enders   = (); foreach ( ENDERS )   { $enders{ $_ }++ }

# initialize
my $text    =  &slurp( $file );
$text       =~ s/\r//g;
my @lines   =  split( "\n", $text );
my @cleaned =  ();
my $end     =  0;
binmode( STDOUT, ":utf8" );

# process each line
foreach my $line ( @lines ) {
		
	# look for starters
	my $start = 0;
	foreach my $starter ( keys %starters ) {
	
		if ( index( $line, $starter, 0 ) > -1 ) {
		
			$start   = 1;
			@cleaned = ();
			last;
		
		}
	
	}
	
	# look for enders
	foreach my $ender ( keys %enders ) {
	
		if ( index( $line, $ender, 0 ) > -1 ) {
		
			$end = 1;
			last;
		
		}
	
	}
	
	last if ( $end );
	next if ( $start );				
	push( @cleaned, $line );
		
}

# output and done
print join( "\n", @cleaned ), "\n";
exit;


sub slurp {

	my $f = shift;
	open ( F, $f ) or die "Can't open $f: $!\n";
	my $r = do { local $/; <F> };
	close F;
	return $r;

}