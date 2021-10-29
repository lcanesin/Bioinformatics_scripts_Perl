#!/usr/bin/perl

use strict;

my %list;

open (LIST, $ARGV[0]);
  while (<LIST>) {
    chomp();
    $list{$_} = 1;
  }
close (LIST);

my %out;
my $header;
my $ok;

open (FASTA, $ARGV[1]);
  while (<FASTA>) {
    chomp();
    my $line = $_;
    if ($line =~ m/^\n/) { next; }
    if ($line =~ m/^>/) {
      my @name_tmp = split (/\./, $line);
#      ($header = $name_tmp[0]) =~ s/>//ei;
      ($header = $line) =~ s/>//ei;
      if ($list{$header}) {
        $ok = 1;
      } else {
        $ok = 0;
      }
      next;
    } else {
      if ($ok) {
        $out{$header} .= $line;
      }
      next;
    }
  }
close (FASTA);

foreach my $gene (keys %out) {
  print ">$gene\n$out{$gene}\n";
} 
