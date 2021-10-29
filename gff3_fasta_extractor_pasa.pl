#!/usr/bin/perl

use strict;

my %out;
my $header;

open (FASTA, $ARGV[0]);
  while (<FASTA>) {
    chomp();
    my $line = $_;
    if ($line =~ m/^\n/) { next; }
    if ($line =~ m/^>/) {
      ($header = $line) =~ s/>//ei;
      next;
    } else {
      $out{$header} .= $line;
      next;
    }
  }
close (FASTA);

my %gene_f;
my %gene_r;

open (PASA, $ARGV[1]);
  while (<PASA>) {
    chomp();
    my $line = $_;
    if ($line =~ m/^\n/) { next; }
    my @tmp = split (/\t/, $line);
    if ($tmp[2] =~ m/exon/) { 
      my @tmp_name = split (/\"/, $tmp[8]);
      my $start = $tmp[3] - 1;
      my $steps = $tmp[4] - $tmp[3] + 1;   #ATGCCCGAGTGC         2 10       
      my $string = substr ($out{$tmp[0]}, $start, $steps);
      my $id = "$tmp_name[1].$tmp_name[3]";    
      if ($tmp[6] =~ m/\+/) {
        $gene_f{$id} .= $string;
      } elsif ($tmp[6] =~ m/-/) {
        $gene_r{$id} .= $string;
      }
    }
  }
close (PASA);

my %revcomp_gene;

foreach my $cds (keys %gene_r) {
  my $revcomp = reverse $gene_r{$cds};
  $revcomp =~ tr/ATGCatgc/TACGtacg/;
  $revcomp_gene{$cds} = $revcomp;
} 
my %all_genes = (%gene_f, %revcomp_gene);

my %primary;
my %primary_name;

foreach my $genes (sort keys %all_genes) {
  my @tmp_genes = split (/\./, $genes);
  if (length($primary{$tmp_genes[0]}) < length($all_genes{$genes})) {
    $primary{$tmp_genes[0]} = $all_genes{$genes};
    $primary_name{$tmp_genes[0]} = $tmp_genes[1];
  }
}


foreach my $gene_out (sort keys %primary) {
  print ">$gene_out.$primary_name{$gene_out}\n$primary{$gene_out}\n";
}
