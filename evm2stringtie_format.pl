#!/usr/bin/perl

use strict;

my $gene_id;

open (EVM, $ARGV[0]);
  while (<EVM>) {
    chomp();
    my $line = $_;
    if ($line =~ m/^\n/) { next; }
    my @tmp = split (/\t/, $line);
    my @tmp_name = split (/[=;]/, $tmp[8]);
    if ($tmp[2] =~ m/mRNA/) {
      print "$tmp[0]\t$tmp[1]\ttranscript\t$tmp[3]\t$tmp[4]\t$tmp[5]\t$tmp[6]\t$tmp[7]\tgene_id \"$tmp_name[3]\"; transcript_id \"$tmp_name[1]\";\n";
      next;
    } elsif ($tmp[2] =~ m/exon/) { 
      my @exon_number = split (/\.exon/, $tmp_name[1]);
      ($gene_id =  $exon_number[0]) =~ s/model/TU/g;
      print "$tmp[0]\t$tmp[1]\t$tmp[2]\t$tmp[3]\t$tmp[4]\t$tmp[5]\t$tmp[6]\t$tmp[7]\tgene_id \"$gene_id\"; transcript_id \"$tmp_name[3]\"; exon_number \"$exon_number[1]\"\n";
      next;
    }
  }
close (GFF);

exit;
