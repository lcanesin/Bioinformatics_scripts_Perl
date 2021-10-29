#!/usr/bin/perl

      ###################################################################
      #          This script was developed by Lucas Canesin             #
      #                    lucascanesin@gmail.com                       #
      #                                                                 #
      #  10/02/19 -> First version takes pasa output gtf annotations    #
      #              and transcripts crossmapped to filter poor blat    #
      #              alignments (default = 80% identity) and merge      #
      #              both annotations                                   #
      #                                                                 #
      ###################################################################

use strict;

my %query_loci;
my %subj_loci;
my $param = "$ARGV[0]";
my $query;
my $subj;

if ($param =~ /ref/) {
  $query = "ref";
  $subj = "alt";
} elsif ($param =~ /alt/) {
  $query = "alt";
  $subj = "ref";
}

my %list;

open (LIST, $ARGV[1]);
  while (<LIST>) {
    chomp();
    my $list_line = $_;
    my @list_tmp = split (/\./, $list_line);
    $list{$list_tmp[0]} = $list_tmp[1]; 

#print "-$list_tmp[0]-\t-$list_tmp[1]-\n";
  }
close (LIST);

open (GFF, $ARGV[2]);
  while (<GFF>) {
    chomp();
    my $gff_line = $_;
    if ($gff_line =~ /^\n/) { next; }
    my @gff_tmp = split (/\t/, $gff_line);
    my @gff_name_tmp = split (/\"/, $gff_tmp[8]);
    if ($gff_name_tmp[3] ne $list{$gff_name_tmp[1]}) { next; }
    if ($gff_tmp[0] =~ /^$query/) {
      $query_loci{$gff_name_tmp[1]} = $gff_line;
    } elsif ($gff_tmp[0] =~ /^$subj/) {
      $subj_loci{$gff_name_tmp[1]} = $gff_line;
    }
print "-$gff_line-\n";
  } 
close (GFF);

my %subj_hit_count;
my $strand;

open (SUBJ_HIT, $ARGV[3]); #opens blat psl file with hits to the query haplotype
  while (<SUBJ_HIT>) {
    chomp();
    my $subj_line = $_;
    if ($subj_line !~ m/PASA_cluster_/) { next; }
    my @subj_hit_tmp = split (/\t/, $subj_line);
    my $subj_hit_id = $subj_hit_tmp[0]/$subj_hit_tmp[10];
    if ($subj_hit_id < 0.8) { next; }
    $subj_hit_count{$subj_hit_tmp[9]}++;
    foreach my $query_transcript (keys %query_loci) {
      my @query_transcript_tmp = split (/\t/, $query_loci{$query_transcript});
      my @query_transcript_name_tmp = split (/\"/, $query_transcript_tmp[8]);
      if ($query_transcript_tmp[0] ne $subj_hit_tmp[0]) { next; } 
      if ($query_transcript_tmp[6] eq $subj_hit_tmp[8]) { 
        $strand = "same strand";
      } elsif ($query_transcript_tmp[6] ne $subj_hit_tmp[8]) {
        $strand = "opposite strand";
      }
      if (($query_transcript_tmp[3] <= $subj_hit_tmp[15])&&($query_transcript_tmp[4] >= $subj_hit_tmp[16])) {
        print "$subj_hit_tmp[9] is contained in $query_transcript_name_tmp[1] on $strand\n";
        next;
      } elsif (($query_transcript_tmp[3] <= $subj_hit_tmp[15])&&($query_transcript_tmp[4] < $subj_hit_tmp[16])) {
        if ($query_transcript_tmp[4] >= $subj_hit_tmp[15]) {
          print "$subj_hit_tmp[9] overlaps upstream $query_transcript_name_tmp[1] on $strand\n";
          next;
        }
      } elsif (($query_transcript_tmp[3] > $subj_hit_tmp[15])&&($query_transcript_tmp[4] >= $subj_hit_tmp[16])) {
        if ($query_transcript_tmp[3] <= $subj_hit_tmp[16]) {
          print "$subj_hit_tmp[9] overlaps downstream $query_transcript_name_tmp[1] on $strand\n";
          next;
        }
      } elsif (($query_transcript_tmp[3] > $subj_hit_tmp[15])&&($query_transcript_tmp[4] < $subj_hit_tmp[16])) {
        print "$subj_hit_tmp[9] contains $query_transcript_name_tmp[1] on $strand\n";
        next;
      }
    }        #fim foreach
  }        #fim while
close (SUBJ_HIT);



   #### to do ####
   
# Implement query and subject %id report (when appliable) into the overlap output 
# For those without overlap to any query gene, 
# transpose subject gene structure using blat hit as seed
   
exit;
