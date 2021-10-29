#!/usr/bin/perl

use strict;

my %families;

open (FAM, $ARGV[0]);
  while (<FAM>) {
    chomp();
    my @tmp = split (/\t/, $_);
    $families{$tmp[0]} = $tmp[1];
  }
close (FAM);

open (FASTA, $ARGV[1]);
  while (<FASTA>) {
    chomp();
    my $line = $_;
    if ($line =~ m/^>/) {
      $line =~ s/>//;
      print ">$line"."_".$families{$line}."\n";
      next;
    } else {
      print "$line\n";
      next;
    } 
  }
close (FASTA);

exit;
