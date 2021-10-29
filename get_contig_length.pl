#!/usr/bin/perl

use strict;

my $name;
my $seq;
my %longer_seq;

open (FASTA, $ARGV[0]);
  while (<FASTA>) {
    chomp();
    my $line = $_;
    if ($line =~ m/^>/) {
      if ($seq) {
        print length($seq)."\n";
      }
      $name = $line;
      $seq = "";
      next;
    } else {
      $seq .= $line;
      next;
    }
  }
close(FASTA);

exit;
