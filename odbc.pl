#!/usr/bin/perl
#===============================================================================
#
# FILE: odbc.pl
#
# USAGE: ./mitegroodbc.pl file wherefield wherevalue
#
# PARAMETERS: wherefield   - field for where statement
# wherevalue	 - value of where statement
# file	 - filename with path for results
#
# DESCRIPTION: performs a database query and returns the result to a file.
# BUGS: ---
# NOTES: ---
# AUTHOR: Sascha Tetzel (STE), sascha.tetzel@pdv.de
# COMPANY: PDV-Systeme GmbH 
# VERSION: 0.7
# CREATED: 08.02.2013 
# COPYRIGHT: Copyright (c) 2013, PDV-Systeme GmbH
# (c) Ausschliessliche Urheber- und Eigentumsrechte
# bei PDV-Systeme GmbH, Erfurt, Deutschland,
# deren Allgemeinen Geschaeftsbedingungen diese Datei unterliegt.
#
#===============================================================================
#use strict;
#use warnings;
use utf8;
use DBI;
my $data_source = q/dbi:ODBC:MITEGRO/;
my $user = q/sa/;
my $password = q/mitegro/;
my $clausel = "";
my $where = $ARGV[1];
my $value = $ARGV[2];
my $file = $ARGV[0];
if ( @ARGV > 0 ) {
    if ( @ARGV > 1 ) {
        $clausel = " where $where = '$value'";
    } else {
        print "fehlerhafter Aufruf";
        exit;
    }
}
my $dbh = DBI->connect( $data_source, $user, $password )
or die "Can't connect to $data_source: $DBI::errstr";
my $sql ="select Art_Nummer, Art_Bezeichnung1, Art_Bezeichnung2, Art_BildNummer, ART_Gewicht_Kg, ART_Produktgruppe, ART_EAN, ART_LangtextNummer from ELART"
. $clausel;
# Prepare the statement.
my $sth = $dbh->prepare($sql)
or die "Can't prepare statement: $DBI::errstr";
# Execute the statement.
$sth->execute();
# Print the column name. 
# :TODO:08.03.2011 22:40:10:ste: column names not hardcoded 
open FILE, ">$file" or die $!;
print FILE join( ";", @{$sth->{NAME}}), "\n";
# Fetch and display the result set value.
while ( my @row = $sth->fetchrow_array ) {
print FILE join( ";", @row ), "\n";
}
close FILE;
# Disconnect the database from the database handle.
$sth->finish();
$dbh->disconnect();
