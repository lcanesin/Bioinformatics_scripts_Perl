#!/usr/bin/perl

use strict;

my %list;
my $id;
my $total_count;

open (WMOUT, $ARGV[0]);
  while (<WMOUT>) {
    chomp();
    my $line = $_;
    
    if ($line =~ m/^\n/) { next; }
    if ($line =~ m/^>/) {
      $id = $line;
      next;
    } else {
      my @tmp = split (/ - /, $line);
      my $base_count = $tmp[1] - $tmp[0] + 1;
      $list{$id} += $base_count;
      $total_count += $base_count; 
    }
  }

foreach my $read (keys %list) {
 print "Contig=$read\tCount=$list{$read}\n";
}

print "\n\nTotal_count = $total_count\n";

close (WMOUT);

exit;
