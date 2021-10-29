#!/usr/bin/perl

use strict;

my %out;
my $exon_count;
my $exon_length;
my $exon_len_gene;
my $premRNA_len;
my $cds_count;
my $cds_length;
my $cds_len_gene;
my $mRNA_len;
my $gene_name;
my $gene_len;

open (GFF, $ARGV[0]);
  while (<GFF>) {
    chomp();
    my $line = $_;
    if ($line =~ m/^\n/) { next; }
    my @tmp = split (/\t/, $line);
    if ($line =~ m/\tmRNA\t/) {
      my @name_tmp = split (/[=;]/, $tmp[8]);
      if ($gene_name) {
        $out{$gene_name} = "$gene_len\t$exon_count\t$exon_len_gene\t$premRNA_len\t$cds_count\t$cds_len_gene\t$mRNA_len";
      }
      $gene_name = $name_tmp[1];
      $gene_len = $tmp[4] - $tmp[3] + 1;
      $exon_count = 0;
      $exon_len_gene = 0;
      $premRNA_len = 0;
      $cds_count = 0;
      $cds_len_gene = 0;
      $mRNA_len = 0;
      next;
    } elsif ($line =~ m/\texon\t/) {
      $exon_count++;
      $exon_length = $tmp[4] - $tmp[3] + 1;
      if ($exon_len_gene) {
        $exon_len_gene .= ",$exon_length";
      } elsif (!$exon_len_gene) {
        $exon_len_gene = "$exon_length";
      }    
      $premRNA_len += $exon_length;
      next;
    } elsif ($line =~ m/\tCDS\t/) {
      $cds_count++;
      $cds_length = $tmp[4] - $tmp[3] + 1;
      if ($cds_len_gene) {
        $cds_len_gene .= ", $cds_length";
      } elsif (!$cds_len_gene) {
        $cds_len_gene = "$cds_length";
      }
      $mRNA_len += $cds_length;
      next;
    }
  }
if ($gene_name) {
  $out{$gene_name} = "$gene_len\t$exon_count\t$exon_len_gene\t$premRNA_len\t$cds_count\t$cds_len_gene\t$mRNA_len";
}

close (GFF);

foreach my $gene (keys %out) {
  print "$gene\t$out{$gene}\n";
} 
