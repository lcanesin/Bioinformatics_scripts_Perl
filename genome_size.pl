#!/usr/bin/perl

      ###################################################################
      #          This script was developed by Lucas Canesin             #
      #                    lucascanesin@gmail.com                       #
      #                                                                 #
      #  06/02/19 -> First version calculates overall genome size and   #
      #              total N proportion                                 #
      #                                                                 #
      #  07/02/19 -> Second version includes length of N patches        #
      ###################################################################

use strict;

my $Ncount;
my $genome_length;
my %genome;
my $contig_name;

open (FASTA, $ARGV[0]);
  while (<FASTA>) {
    chomp();
    my $line = $_;
    if ($line =~ m/^\n/) { next; }
    if ($line =~ m/^>/) {
      $contig_name = $line;
      next;
    } else {
      $genome{$contig_name} .= $line;
      $genome_length += length($line);
      my $count = $line =~ tr/N//;
      $Ncount += $count;
      next;
    }
  }
close (FASTA);

my $Nprop = ($Ncount * 100) / $genome_length;

print "Genome size = $genome_length bp\nTotal N count = $Ncount\nN's/100 bp = $Nprop";

foreach my $contig (keys %genome) {
  $genome{$contig} =~ s/[ATCGatcg]+/\n/g;
  $genome{$contig} =~ s/((.)\2+)/$2 . length($1)/ge;
  print "$genome{$contig}\n";
}

exit;
