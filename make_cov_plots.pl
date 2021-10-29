#!/usr/bin/perl

use strict;

my @contigs;

open (LIST, $ARGV[0]);
  while (<LIST>) {
    chomp();
    push @contigs, $_;
  }
close (LIST);

my $input = "$ARGV[1]";
print "fullData <- read.table(\"$input\", h=F)\ncolnames=c(\"CTG\",\"POS\",\"COV\")\n";

foreach my $contig (@contigs) {
  print "vint_v18e_$contig <- fullData[ which (fullData[,1] == \"$contig\"),]\npng(\"vint_v18e_$contig.hist.png\")\nplot(vint_v18e_$contig\[,3\], type='l', col=\"darkgreen\", xlab=\"Contig length (bp)\", ylab = \"Read coverage/bp\")\ndev.off()\n";
}

exit;
