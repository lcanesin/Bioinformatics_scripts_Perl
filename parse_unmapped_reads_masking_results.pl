#!/usr/bin/perl

use strict;

my $total_reads;
my $total_bases;
my $count_unmasked_reads;
my $count_unmasked_bases;
my $count_fullymasked_reads;
my $count_fullymasked_bases;

open (PARSED, $ARGV[0]);
  while (<PARSED>) {
    chomp();
    my $line = $_;
    if ($line =~ /^\n/) { next; }
    my @tmp = split (/\t/, $line);
    $total_reads++;
    $total_bases += $tmp[2]; 
    if ($tmp[3] == 0) { 
      $count_unmasked_reads++;
      $count_unmasked_bases += $tmp[2];
    } elsif ($tmp[3] == 100) {
      $count_fullymasked_reads++;
      $count_fullymasked_bases += $tmp[2];
    }
  }
close (PARSED);

my $perc_unmasked_reads = ($count_unmasked_reads/$total_reads)*100;
my $perc_fullymasked_reads = ($count_fullymasked_reads/$total_reads)*100;
my $perc_unmasked_bases = ($count_unmasked_bases/$total_bases)*100;
my $perc_fullymasked_bases = ($count_fullymasked_bases/$total_bases)*100;

print "Total reads:  $total_reads\nTotal bases:  $total_bases\nUnsmasked reads:  $perc_unmasked_reads\nUnmasked bases:  $perc_unmasked_bases\nFully masked reads:  $perc_fullymasked_reads\nFully masked bases:  $perc_fullymasked_bases\n";

exit;
