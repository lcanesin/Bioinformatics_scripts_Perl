#!/usr/bin/perl

use strict;

open (GFF, $ARGV[0]);
my $count;
  while (<GFF>) {
    chomp();
    $count++;
    my $line = $_;
    if ($line =~ m/^\n/) { next; }
    if ($line =~ m/^#/) { next; }
    $line =~ s/\tsimilarity\t/\texon\t/;
    $line =~ s/Target /gene_id \"repeat_$count\"; transcript_id \"repeat_$count.1\"; exon_number \"1\"; Target=/;
    print "$line\n";
  }
close (GFF);

