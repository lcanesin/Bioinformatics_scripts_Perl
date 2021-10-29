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

my $gene;
my $n;

open (GFF, $ARGV[1]);
  while (<GFF>) {
    $n++;
    chomp();
    my $line = $_;
    if ($line =~ m/^\n/) { next; }
    my @tmp = split (/\t/, $line);
    my @tmp_name = split (/\"/, $tmp[8]);
    my $start = $tmp[3] - 1;
    my $steps = $tmp[4] - $tmp[3] + 1;   #ATGCCCGAGTGC         2 10  
    $gene = substr ($out{$tmp[0]}, $start, $steps);         
    if ($tmp[6] =~ m/\+/) {
      print ">$tmp_name[1]_$n\n$gene\n";
      next;
    } elsif ($tmp[6] =~ m/-/) {
      my $revcomp = reverse $gene;
      $revcomp =~ tr/ATGCatgc/TACGtacg/;
      print ">$tmp_name[1]_$n\n$revcomp\n";
      next;
    }
  }
close (GFF);

exit;
