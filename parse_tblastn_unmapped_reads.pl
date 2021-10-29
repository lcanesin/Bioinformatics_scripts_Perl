#!/usr/bin/perl


                                   ###########################
                                   ##     Preprocessing     ##
                                   ###########################
use strict;

                         ###############################################
                         ## Duplicates query and target file creation ##
                         ###############################################

open (REFSEQ, $ARGV[0]);
  while (<REFSEQ>) {
    chomp();
    my $line = $_;
    if ($line =~ /^#/) { next; } 
    my @tmp = split (/\t/, $line);
    if ($tmp[14] >= 80) {
      print "$line\n";
    }
  }
close (REFSEQ);

exit;
