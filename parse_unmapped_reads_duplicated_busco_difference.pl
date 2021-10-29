#!/usr/bin/perl


                                   ###########################
                                   ##     Preprocessing     ##
                                   ###########################
use strict;

                         ###############################################
                         ## Duplicates query and target file creation ##
                         ###############################################





my %list;
my $prev_score;
my $prev_length;

open (DUPLIC, $ARGV[0]);
  while (<DUPLIC>) {
    chomp();
    my $line = $_;
    if ($line =~ /^\n/) { next; }
    my @tmp = split (/\t/, $line);
    if ($list{$tmp[0]}) {
#print "item found\n";
       my $length_diff = $prev_length - $tmp[6];
       my $score_diff = $prev_score - $tmp[5];
       if ($length_diff < 0) {
         $length_diff *= -1;
       }
       if ($score_diff < 0) {
         $score_diff *= -1;
       }
       print "$tmp[0]\t$length_diff\t$score_diff\n";
    } elsif (!$list{$tmp[0]}) {
      $prev_length = $tmp[6];
      $prev_score = $tmp[5];
      $list{$tmp[0]} = 1;
    }
  }
close (DUPLIC);

exit;
