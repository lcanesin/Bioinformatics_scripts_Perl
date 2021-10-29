#!/usr/bin/perl

use strict;

open (CHG, $ARGV[0]);
  while (<CHG>) {
    chomp();
    my $line = $_;
    my @tmp = split (/ /, $line);
#    if (($tmp[2] > 3) || ($tmp[3] > 3)) {
      if ($tmp[2] eq ".") {
        my $insertion = length($tmp[3]);
	if ($insertion > 3) {
          $LRG_INS++;
        } else {
          $SML_INS++;
        }
        next;
      } elsif ($tmp[3] eq ".") {
        my $deletion = length($tmp[2]);
        if ($deletion > 3) {
          $LRG_DEL++;
        } else {
          $SML_DEL++;
        }
        next;
      }
#    } 
  }
close (CHG);

exit;
