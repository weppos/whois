#!/usr/bin/perl -w

use strict;

while (<>) {
	chomp;
	s/^\s*(.*)\s*$/$1/;
	s/\s*#.*$//;
	next if /^$/;

	die "format error: $_" if not /^([\d\.]+)\/(\d+)\s+([\w\.]+)$/;
	my $m = $2; my $s = $3;
	my ($i1, $i2, $i3, $i4) = split(/\./, $1);
	print '{ ' . (($i1 << 24) + ($i2 << 16) + ($i3 << 8) + $i4) . 'UL, '.
		((~(0xffffffff >> $m)) & 0xffffffff) . 'UL, "';
	if ($s =~ /\./) {
		print $s;
	} elsif ($s eq 'UNALLOCATED') {
		print "\\006";
	} else {
		print "whois.$s.net";
	}
	print '" },' . "\n";
}

