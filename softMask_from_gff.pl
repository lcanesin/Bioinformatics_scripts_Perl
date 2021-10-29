#!/usr/bin/perl

use strict;

my %gff;
my $n;

open (GFF, $ARGV[0]);
  while (<GFF>) {
    chomp();
    my @gff_tmp = split (/\t/, $_);
    $n++;
    $gff{$n} = "$gff_tmp[0]\t$gff_tmp[3]\t$gff_tmp[4]";
  }
close (GFF);

my %out;
my $header;
my $ok;

open (FASTA, $ARGV[1]);
  while (<FASTA>) {
    chomp();
    my $line = $_;
    if ($line =~ m/^\n/) { next; }
    if ($line =~ m/^>/) {
      my @name_tmp = split (/\s+/, $line);
      ($header = $name_tmp[0]) =~ s/>//ei;
      next;
    } else {
      $out{$header} .= $line;
      next;
    }
  }
close (FASTA);

foreach my $seq (keys %out) {
  foreach my $repeat (keys %gff) {
    my @out_tmp = split (/\t/, $gff{$repeat});
    if ($seq ne $out_tmp[0]) { next; }
    my $length = $out_tmp[2] - $out_tmp[1] + 1;
    my $start = $out_tmp[1] - 1;
    substr($out{$out_tmp[0]},$start,$length) = lc(substr($out{$out_tmp[0]},$start,$length));
  }
  print ">$seq\n$out{$seq}\n";
} 
