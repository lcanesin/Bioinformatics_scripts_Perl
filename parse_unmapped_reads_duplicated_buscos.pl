#!/usr/bin/perl


                         ###########################
                         ##     Preprocessing     ##
                         ###########################
use strict;

                         ###########################
                         ## Duplicates retrieval  ##
                         ###########################

my %contigs;

open (DUPLIC, $ARGV[0]);
  while (<DUPLIC>) {
    chomp();
    my $line = $_;
    if ($line =~ /^\n/) { next; }
    my @tmp = split (/\t/, $line);
    $contigs{$tmp[0]} .= "$tmp[2],";
    print "-$tmp[2]-\n";
#print "$tmp[0]\t$tmp[2],\n";
  }
close (DUPLIC);

exit;

                         ###########################
                         ##   Contig retrieval    ##
                         ###########################

my $flag;
my $header;
my %seq;
                         
open (FASTA, $ARGV[1]);
  while (<FASTA>) {
    chomp();
    my $line = $_;
#print "$flag\n";
    if ($line =~ /^\n/) { next; }
    if ($line =~ /^>/) {
      $flag = 0;
      $line =~ tr/^>//d;
#print "$line\n";
      foreach my $busco (keys %contigs) {
        if ($contigs{$busco} =~ $line) {
          $header = $line;
          $flag = 1;
#print "found header $header\n"; 
        }
      }
      next;
    } elsif ($line !~ /^>/) {
      if ($flag) {
        $seq{$header} .= $line;
      }
      next;
    }
  }
close (FASTA);

foreach my $dup_seq (keys %seq) {
  print ">$dup_seq\n$seq{$dup_seq}\n";
}


exit;
