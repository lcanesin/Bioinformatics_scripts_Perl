#!/usr/bin/perl

use strict;

my %out_bases;
my %out_reads;

open (PARSED, $ARGV[0]);
  while (<PARSED>) {
    chomp();
    my $line = $_;
    if ($line =~ /^\n/) { next; }
    my @tmp = split (/\t/, $line);
    if ($tmp[3] == 0)  {
      $out_bases{"unmasked"} += $tmp[2];
      $out_reads{"unmasked"}++;
      next;
    } elsif ($tmp[3] > 0 && $tmp[3] <= 10)  { 
      $out_bases{"bin1"} += $tmp[2];
      $out_reads{"bin1"}++; 
      next;
    } elsif ($tmp[3] > 10 && $tmp[3] <= 20) {
      $out_bases{"bin2"} += $tmp[2];
      $out_reads{"bin2"}++;
      next;
    } elsif ($tmp[3] > 20 && $tmp[3] <= 30) {
      $out_bases{"bin3"} += $tmp[2];
      $out_reads{"bin3"}++;
      next;
    } elsif ($tmp[3] > 30 && $tmp[3] <= 40) {
      $out_bases{"bin4"} += $tmp[2];
      $out_reads{"bin4"}++;
      next;
    } elsif ($tmp[3] > 40 && $tmp[3] <= 50) {
      $out_bases{"bin5"} += $tmp[2];
      $out_reads{"bin5"}++;
      next;
    } elsif ($tmp[3] > 50 && $tmp[3] <= 60) {
      $out_bases{"bin6"} += $tmp[2];
      $out_reads{"bin6"}++;
      next;
    } elsif ($tmp[3] > 60 && $tmp[3] <= 70) {
      $out_bases{"bin7"} += $tmp[2];
      $out_reads{"bin7"}++;
      next;
    } elsif ($tmp[3] > 70 && $tmp[3] <= 80) {
      $out_bases{"bin8"} += $tmp[2];
      $out_reads{"bin8"}++;
      next;
    } elsif ($tmp[3] > 80 && $tmp[3] <= 90) {
      $out_bases{"bin9"} += $tmp[2];
      $out_reads{"bin9"}++;
      next;
    } elsif ($tmp[3] > 90 && $tmp[3] <= 100) {
      $out_bases{"bin10"} += $tmp[2];
      $out_reads{"bin10"}++;
      next;
    } 
  }
close (PARSED);

print "Bin\tReads\tBases\n";

foreach my $bins (sort keys %out_bases) {
  print "$bins\t$out_reads{$bins}\t$out_bases{$bins}\n";
}

exit;
