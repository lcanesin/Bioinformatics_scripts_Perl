#!/usr/bin/perl


                                   ###########################
                                   ##     Preprocessing     ##
                                   ###########################
use strict;

                         ###############################################
                         ## Duplicates query and target file creation ##
                         ###############################################

my %list;
my $filename;

open (DUPLIC, $ARGV[0]);
  while (<DUPLIC>) {
    chomp();
    my $line = $_;
    if ($line =~ /^\n/) { next; }
    my @tmp = split (/\t/, $line);
    if ($list{$tmp[0]}) {
      $filename = $tmp[0]."_query.txt";
    } elsif (!$list{$tmp[0]}) {
      $filename = $tmp[0]."_target.txt";
      $list{$tmp[0]} = 1;
    }
    open(FH, '>>', $filename) or die $!;
      print FH "$tmp[2]\n";
    close (FH);
  }
close (DUPLIC);

exit;

                                   ###########################
                                   ##   Contig retrieval    ##
                                   ###########################

#my $flag;
#my $header;
#my %seq;
#                         
#open (FASTA, $ARGV[1]);
#  while (<FASTA>) {
#    chomp();
   # my $line = $_;
#print "$flag\n";
#    if ($line =~ /^\n/) { next; }
#    if ($line =~ /^>/) {
#      $flag = 0;
#      $line =~ tr/^>//d;
#print "$line\n";
#      foreach my $busco (keys %contigs) {
#        if ($contigs{$busco} =~ $line) {
#          $header = $line;
#          $flag = 1;
#print "found header $header\n"; 
#        }
#      }
#      next;
#    } elsif ($line !~ /^>/) {
#      if ($flag) {
#        $seq{$header} .= $line;
#      }
#      next;
#    }
#  }
#close (FASTA);
#
#foreach my $dup_seq (keys %seq) {
#  print ">$dup_seq\n$seq{$dup_seq}\n";
#}


exit;
