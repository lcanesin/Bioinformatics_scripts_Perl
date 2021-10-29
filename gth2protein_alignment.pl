#!/usr/bin/perl

use strict;

my $file = "$ARGV[0]";
my @lines1;

open (FH, "< $file") or die "Can't open $file for read: $!";
  while (<FH>) {
    chomp;
    push @lines1, $_;
  }
close FH or die "Cannot close $file: $!";

my $file2 = "$ARGV[1]";
my @lines2;

open (FH2, "< $file2") or die "Can't open $file for read: $!";
  while (<FH2>) {
    chomp;
    push @lines2, $_;
  }
close FH2 or die "Cannot close $file2: $!";

my $index;

foreach (@lines1) {
  my @queries = split (/[;=]/, $lines1[$index]);
  my @targets = split (/[;=]/, $lines2[$index]);
  print "$queries[1]\t$queries[3]\t$targets[1]\t$targets[3]\t$targets[5]\n";
  $index++;
}

exit;

