#!/usr/bin/perl

use strict;

open (READ, $ARGV[0]);
	while (<READ>) {
		chomp();
		my $line = $_;
		if ($line =~ /^\@SRR/) {
			my @tmp = split (/\s/, $line);
			print "\@$tmp[1]\/1\n";
			next;
		} elsif ($line =~ /^\+SRR/) {
                        print "+\n";
			next;
		} else {
			print "$line\n";
			next;
		}
	}
close (READ);

exit;
