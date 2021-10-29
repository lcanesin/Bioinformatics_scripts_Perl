#!/usr/bin/perl


                                   ###########################
                                   ##     Preprocessing     ##
                                   ###########################
use strict;

                         ###############################################
                         ## Duplicates query and target file creation ##
                         ###############################################

my %list;

open (LIST, $ARGV[0]);
  while (<LIST>) {
    chomp();
    my @tmp_list = split (/\t/, $_);
    $list{$tmp_list[0]} .= "_$tmp_list[2]_";
  }
close (LIST);

my %busco;

open (BUSCOS, $ARGV[1]);
  while (<BUSCOS>) {
    chomp();
    my $line_buscos = $_;
    my @tmp_buscos = split (/\t/, $line_buscos);
    $busco{$tmp_buscos[0]} = $line_buscos;
  }
close (BUSCOS);


print "Contigs\talignment_blocks\tquery_size\tsubj_size\tsize_diff\tquery_align_size\tsubj_align_size\tmean_id\tmean_blastid\tcoverage\tmean_continuity\tdupl_busco\tbusco_mean_id\tbusco_id_diff\tbusco_align_len\tbusco_align_diff\n";

open (CONTIGS, $ARGV[2]);
  while (<CONTIGS>) {
    chomp();
    my $line_contigs = $_;
    my @tmp_contigs = split (/\t/, $line_contigs);
    my @tmp_name = split (/_/, $tmp_contigs[0]);
    foreach my $id (sort keys %list) {

#print "\t-$tmp_contigs[0]-\t-$tmp_name[0]-\t-$tmp_name[1]-\t-$list{$id}-\n";
      if ($list{$id} =~ /$tmp_name[0]/ && $list{$id} =~ /$tmp_name[1]/) {
        print "$line_contigs\t$busco{$id}\n";
      }
    }
  }
close (CONTIGS);

exit;
