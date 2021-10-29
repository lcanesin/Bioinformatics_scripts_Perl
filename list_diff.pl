#!/usr/bin/perl

use strict;

my %list;

open (LIST, $ARGV[0]);
  while (<LIST>) {
    chomp();
    my @tmp = split (/\t/, $_);
    $list{$tmp[0]} .= "$tmp[1]\n";
  }
close (LIST);

open (FASTA, $ARGV[1]);
  while (<FASTA>) {
    chomp();
    my $line = $_;
    if ($line =~ m/^\n/) { next; }
    if ($list{$line}) {
      print "$list{$line}";
    }
  }
close (FASTA);

exit;
