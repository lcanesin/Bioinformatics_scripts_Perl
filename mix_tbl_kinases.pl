#!/usr/bin/perl 

use strict;

my %hits;
my %fam;
my %headers;

open (HITS, $ARGV[0]);
  while (<HITS>) {
    chomp();
    my $line = $_;
#print "-$line-\n";
    $hits{$line} = 1;
  }
close (HITS);

open (FAM, $ARGV[1]);
  while (<FAM>) {
    chomp();
    my $line = $_;
#print "\t\t--$line--\n";
    $fam{$line} = 1;
  }
close (FAM);

open (HEADER, $ARGV[2]);
  while (<HEADER>) {
    chomp();
    my $line = $_;
    $line =~ s/>//;
    $line =~ s/ category/;category/;
#print "\t\t\t\t---$line---\n";
    $headers{$line} = 1;
  }
close (HEADER);

foreach my $header_name (keys %headers) {
  my @tmp1 = split (/;/, $header_name);
  my @tmp2 = split (/:/, $tmp1[2]);
  if ($hits{$tmp1[0]}) {
    foreach my $fam_name (keys %fam) {
      my @tmp3 = split (/,/, $fam_name);
      if ($tmp2[1] eq $tmp3[0]) {
        print "$tmp1[0]\t$tmp3[0]\t$tmp3[1]\t$tmp3[2]\t$tmp3[3]\n";
      }
    }
  }
}

exit;
