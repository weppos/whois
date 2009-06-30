#!/usr/bin/perl -w

use strict;

while (<>) {
	chomp;
	s/^\s*(.*)\s*$/$1/;
	s/\s*#.*$//;
	next if /^$/;
	die "format error: $_" unless
		(my ($a, $b) = /^([\w\d\.-]+)\s+([\w\d\.:-]+|[A-Z]+\s+.*)$/);
	$b =~ s/^W(?:EB)?\s+/\\x01/;
	$b =~ s/^M(?:SG)?\s+/\\x02/;
	$b = "\\x03" if $b eq 'NONE';
	$b = "\\x04" if $b eq 'CRSNIC';
	$b = "\\x07" if $b eq 'PIR';
	$b = "\\x08" if $b eq 'AFILIAS';
	$b = "\\x09" if $b eq 'NICCC';
	$b = "\\x0C" if $b eq 'ARPA';
	print "    \"$a\",\t\"$b\",\n";
}

