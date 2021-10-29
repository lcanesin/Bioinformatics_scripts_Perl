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
        my @tmp = split ($name, /\./);
        if (length($seq) > length($longer_seq{$tmp[1]})) {
          $longer_seq{$tmp[1]} = $seq;
        }
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

foreach my $gene (sort keys %longer_seq) {
  if (length($longer_seq{$gene}) >= 200) {
	print ">STRG.$gene\n$longer_seq{$gene}\n";
  }
}

exit;
