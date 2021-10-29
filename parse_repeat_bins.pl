#!/usr/bin/perl

use strict;

my %read_size;

open (SIZE, $ARGV[0]);
  while (<SIZE>) {
    chomp();
    my @tmp_size = split (/\t/, $_);
    $read_size{$tmp_size[0]} = $tmp_size[1];
  }
close(SIZE);


my %bins;
my $read;
my $n;

my $border_out = $ARGV[2];
my $middle_out = $ARGV[3];
my $full_out = $ARGV[4];

open(BORDER, '>', $border_out);
open(MIDDLE, '>', $middle_out);
open(FULL, '>', $full_out);

open(BINS, $ARGV[1]);
  while (<BINS>) {
    chomp();
    my $line = $_;
    if ($line =~ /^\n/) { next; }
    my @tmp = split (/\t/, $line);
    if ($read eq $tmp[0]) { 
      $n++;
    } elsif ($read ne $tmp[0]) {
      if ($bins{"bin_1"} < 1 && $bins{"bin_10"} < 1) { 
print "entra middle\n";
        foreach my $number1 (sort keys %bins) {
          my $bin_number1 = $number1;
          $bin_number1 =~ s/bin_//;
          print MIDDLE "$read\t$read_size{$read}\t$bin_number1\t$bins{$number1}\n";
        }
      }
      if ($bins{"bin_1"} > 0 || $bins{"bin_10"} > 0) {
        foreach my $number2 (sort keys %bins) {
          my $bin_number2 = $number2;
          $bin_number2 =~ s/bin_//;
          print BORDER "$read\t$read_size{$read}\t$bin_number2\t$bins{$number2}\n";
        }
      }
      $n = 1;
      %bins = (); 
    }
    $read = $tmp[0];
    $bins{"bin_$n"} = $tmp[3];
    print FULL "$tmp[0]\t$read_size{$tmp[0]}\t$n\t$tmp[3]\n";
  }
close(BINS);

close(MIDDLE);
close(BORDER);
close(FULL);

exit;


