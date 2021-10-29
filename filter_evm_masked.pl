#!/usr/bin/perl

      ###################################################################
      #          This script was developed by Lucas Canesin             #
      #                    lucascanesin@gmail.com                       #
      #                                                                 #
      ###################################################################

use strict;

my %genome;
my $transcript_name;

open (FASTA, $ARGV[1]);
  while (<FASTA>) {
    chomp();
    my $line = $_;
    if ($line =~ m/^\n/) { next; }
    if ($line =~ m/^>/) {
      $transcript_name = $line;
      next;
    } else {
      $genome{$transcript_name} .= $line;
      next;
    }
  }
close (FASTA);

my $length;
my $count;
my $proportion;

foreach my $transcript (keys %genome) {
  $length = length($genome{$transcript});
#  $count = () = $genome{$transcript} =~ m/\p{Lowercase}/g;
  $count = $genome{$transcript} =~ tr/[atcg]//;
  $proportion = $count/$length;
  if ($proportion > "$ARGV[0]") { 
    next; 
  } else {
    print "$transcript\n$genome{$transcript}\n";
  }
}

exit;
