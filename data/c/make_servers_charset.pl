#!/usr/bin/perl

use warnings;
use strict;

while (<>) {
	chomp;
	s/#.*$//;
	s/^\s+//; s/\s+$//;
	next if /^$/;

	die "format error: $_" unless
		(my ($a, $b, $c) = /^([a-z0-9.-]+)\s+([a-z0-9-]+)(?:\s+(.+))?$/);

	if ($c) {
		print qq(    { "$a",\t"$b",\t"$c" },\n);
	} else {
		print qq(    { "$a",\t"$b",\tNULL },\n);
	}
}

