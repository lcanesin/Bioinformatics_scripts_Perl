#!/usr/bin/perl

use strict;

my %align;
my $align_header;

open (DELTA, $ARGV[0]);
  while (<DELTA>) {
    chomp();
    my $line = $_;
    if ($line =~ m/^\n/) { next; }
    if ($line =~ m/^>/) {
      $align_header = $line;
      next;
    } else {
#print "-$align_header-\t-$line-\n";
      $align{$align_header} .= "$line\n";
    }
  }
close (DELTA);

#foreach my $testing (keys %align) {
#  print "$testing\n$align{$testing}"
#}
#exit;



my $count_keys = scalar (keys %align);
my $size_bin = int($count_keys/$ARGV[1]) + 1;

#print "$count_keys\t$size_bin\n";
#exit;

for (my $cores = 20; $cores > 0; $cores--) {
#print "$cores\n";
  my $filename = "nucmer_out.$cores.delta";
  open(FH, '>', $filename) or die $!;
    my $i = 0;
    foreach my $align_key (keys %align) {
      if ($i <= $size_bin) {
        $i++;
        print FH "$align_key\n$align{$align_key}";
        delete $align{$align_key};
      }
    }
  close(FH);
}

exit;
