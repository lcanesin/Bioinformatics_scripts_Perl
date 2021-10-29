#!/usr/bin/perl

use strict;

open (DMND, $ARGV[0]);
  while (<DMND>) {
    chomp();
    my $line = $_;
    my @tmp = split (/\t/, $line);
    my $aligned_proportion = (($tmp[2] / 100) * $tmp[3]) / $tmp[4];
    if ($aligned_proportion >= 0.7) {
      print "$line\n";
    }
  }
exit;
