#!/usr/bin/perl

use strict;

my %list;

open (LIST, $ARGV[0]);
  while (<LIST>) {
    chomp();
    my @tmp = split (/\t/, $_);
    $list{$tmp[0]} = $tmp[4];
  }
close (LIST);

open (GFF, $ARGV[1]);
  while (<GFF>) {
    chomp();
    my $line = $_;
    if ($line =~ m/^\n/) { next; }
    if ($line =~ m/\tCDS\t/) {
      my @gff_tmp = split (/\t/, $line);
      my @gff_name = split (/[;=]/, $gff_tmp[8]);
      print "$gff_tmp[0]\t$gff_tmp[1]\tnucleotide_to_protein_match\t$gff_tmp[3]\t$gff_tmp[4]\t$gff_tmp[5]\t$gff_tmp[6]\t$gff_tmp[7]\tID=$gff_name[3];Target=$list{$gff_name[3]}\n";
    }
  }
close (GFF);

exit;
