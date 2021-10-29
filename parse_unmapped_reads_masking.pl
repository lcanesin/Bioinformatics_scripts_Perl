#!/usr/bin/perl

use strict;

my %seq;
my $header;

open (MASKED, $ARGV[0]);
  while (<MASKED>) {
    chomp();
    my $line = $_;
    if ($line =~ /^\n/) { next; }
    if ($line =~ /^>/) {
      $header = $line;
      next;
    } elsif ($line !~ /^>/) {
      $seq{$header} .= $line;
      next;
    }
  }
close (MASKED);

foreach my $read (keys %seq) {
  my $lc_count = $seq{$read} =~ tr/a-z//;
  my $read_len = length ($seq{$read});
  my $read_prop = ($lc_count / $read_len) * 100;
  print "$read\t$lc_count\t$read_len\t$read_prop\n";
}
exit;
