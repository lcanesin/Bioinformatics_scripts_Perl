#!/usr/bin/perl

use strict;

my $name;
my $seq;
my %longer_seq;

open (HMM, $ARGV[0]);
  while (<HMM>) {
    chomp();
    if ($count) { $count++; } 
    my $line = $_;
    if ($line =~ m/Query:/) {
#      $check1 = 1;
      my @qname_tmp = split (/\s+/, $line);
      my $qname = $qname_tmp[1];
      next;
    } elsif ($line =~ m/^>>/) {
#      $check2 = 1;
      my @sname_tmp = split (/\s+/, $line);
      my $sname = $sname_tmp[1];
      my $count = 1;
      next;
    } 
    if ($count == 8) {
      
    }
  }
close (HMM);

exit;
