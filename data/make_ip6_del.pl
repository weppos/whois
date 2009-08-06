#!/usr/bin/perl -w

use strict;

while (<>) {
	chomp;
	s/^\s*(.*)\s*$/$1/;
	s/\s*#.*$//;
	next if /^$/;

	die "invalid line:\n$_\n"
		if not m#^([\da-fA-F]{4}):([\da-fA-F]{1,4})::/(\d+)\s+([\w\.]+)$#;
	my $len = $3; my $s = $4;
	my $i1 = $1; my $i2 = $2;
	my $net = (hex($i1) << 16) + hex $i2;

	if (0) { # just some code to help me visually aggregate networks
		my $bs = unpack('B32', pack('N', $net));
		$bs =~ s/(.{8})/$1 /g;
		print "${i1}:${i2}::/$len\t$bs $s\n";
		next;
	}

	print qq|{ ${net}UL, $len, "|;
	if ($s =~ /\./) {
		print $s;
	} elsif ($s eq '6to4') {
		print "\\x0A";
	} elsif ($s eq 'teredo') {
		print "\\x0B";
	} elsif ($s eq 'UNALLOCATED') {
		print "\\006";
	} else {
		print $s =~ /\./ ? $s : "whois.$s.net";
	}
	print qq|" },\n|;
}

