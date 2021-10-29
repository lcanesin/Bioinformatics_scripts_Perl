#!/usr/bin/perl

use strict;

my %primaryT;
my $gene_id;

open (FASTA, $ARGV[0]);
  while (<FASTA>) {
    chomp();
    my $line = $_;
    if ($line =~ m/^\n/) { next; }
    if ($line =~ m/^>/) {
      my @name_tmp = split (/\s+/, $line);
      $transcript_id = $name_tmp[0];
      $gene_id = $name_tmp[1];    
    } else {
      $primaryT{$gene_id}{$transcript_id} = $line;
    }
  }
close (FASTA);

my %output

foreach my $gene (keys %primaryT) {
  foreach my $transcript (keys %{$primaryT{$gene}}) {
    
  }
}
