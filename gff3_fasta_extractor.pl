#!/usr/bin/perl

use strict;

#my %list;

#open (LIST, $ARGV[0]);
#  while (<LIST>) {
#    chomp();
#    $list{$_} = 1;
#  }
#close (LIST);

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

open (GFF, $ARGV[1]);
my $which = $ARGV[2];
  while (<GFF>) {
    chomp();
    my $line = $_;
    if ($line =~ m/^\n/) { next; }
    unless ($which eq "all") {
      if ($line !~ m/^$which/) { next; }
    }
    my @tmp = split (/\t/, $line);
    if ($tmp[2] =~ m/CDS/) { 
      my @tmp_name = split (/=/, $tmp[8]);
      my $start = $tmp[3] - 1;
      my $steps = $tmp[4] - $tmp[3] + 1;   #ATGCCCGAGTGC         2 10           
      if ($tmp[6] =~ m/\+/) {
        $gene_f{$tmp_name[2]} .= substr ($out{$tmp[0]}, $start, $steps);
      } elsif ($tmp[6] =~ m/-/) {
        my $string = substr ($out{$tmp[0]}, $start, $steps);
        $gene_r{$tmp_name[2]} = $string.$gene_r{$tmp_name[2]};
      }
    }
  }
close (GFF);

my %revcomp_gene;

foreach my $cds (keys %gene_r) {
  my $revcomp = reverse $gene_r{$cds};
  $revcomp =~ tr/ATGCatgc/TACGtacg/;
  $revcomp_gene{$cds} = $revcomp;
} 
my %all_genes = (%gene_f, %revcomp_gene);

foreach my $genes (sort keys %all_genes) {
  print ">$genes\n$all_genes{$genes}\n";
}

