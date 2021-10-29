#!/usr/bin/perl


                                   ###########################
                                   ##     Preprocessing     ##
                                   ###########################
use strict;

                         ###############################################
                         ## Duplicates query and target file creation ##
                         ###############################################

my $n;
my %count;
my %q_contig_size;
my %s_contig_size;
my %q_alignment_size;
my %s_alignment_size;
my %id;
my %blastid;
my %cov;
my %con;
my $key;
my %ctg1_align_pos;
my %ctg2_align_pos;
my %ctg1_align_pos;
my %ctg2_align_pos;

open (LASTZ, $ARGV[0]);
  while (<LASTZ>) {
    chomp();
    my $line = $_;
    $line =~ s/%//g;
    if ($line =~ /^#/) { next; }
    my @tmp = split (/\t/, $line);
    $key = "$tmp[0]_$tmp[7]";
    $count{$key}++;
    $q_contig_size{$key} = $tmp[3];
    $s_contig_size{$key} = $tmp[10]; 
    $q_alignment_size{$key} += $tmp[6];
    $s_alignment_size{$key} += $tmp[13];
    $ctg1_align_pos{$key} .= "$tmp[4]-$tmp[5],";
    $ctg2_align_pos{$key} .= "$tmp[11]-$tmp[12],";
    $id{$key} .= "$tmp[25],";
    $blastid{$key} .= "$tmp[26],";
    $cov{$key} += $tmp[30]; 
    $con{$key} .= "$tmp[34],";    
  }
close(LASTZ);

#open (BUSCO, $ARGV[2]);
#  while (<BUSCO>) {
#    chomp();
#    my $line_b = $_;
#    if ($line_b =~ /^#/) { next; }
#    my @tmp_b = split (/\t/, $line_b);
#    $busco_id = $tmp_b[0];
#    $busco_ctgs{$busco_id} .= "$tmp_b[1]_";
#    $ctg_pos1{$busco_id} .= "$tmp_b[6]-$tmp_b[7],";
#    $busco_pos1{$busco_id} .= "$tmp_b[8]-$tmp_b[9],"; 
#    $busco_blastid1{$busco_id} += $tmp_b[2];
#    $n_b++;
#    $busco 
#  }
#close (BUSCO);


my %mean_id;

foreach my $id_key (keys %id) {
  my @id_tmp = split (/,/, $id{$id_key});
  my $sum_id;
  map { $sum_id += $_ } @id_tmp;
  $mean_id{$id_key} = $sum_id/$count{$id_key};
}

my %mean_blastid;

foreach my $blastid_key (keys %blastid) {
  my @blastid_tmp = split (/,/, $blastid{$blastid_key});
  my $sum_blastid;
  map { $sum_blastid += $_ } @blastid_tmp;
  $mean_blastid{$blastid_key} = $sum_blastid/$count{$blastid_key};
}

my %mean_con;

foreach my $con_key (keys %con) {
  my @con_tmp = split (/,/, $con{$con_key});
  my $sum_con;
  map { $sum_con += $_ } @con_tmp;
  $mean_con{$con_key} = $sum_con/$count{$con_key};
}

my %diff_length;

foreach my $contig_key (keys %q_contig_size) {
  $diff_length{$contig_key} = $q_contig_size{$contig_key} - $s_contig_size{$contig_key};
}

print "Contigs\talignment_blocks\tquery_size\tsubj_size\tsize_diff\tquery_align_size\tsubj_align_size\tquery_align_position\tsubj_align_position\tmean_id\tmean_blastid\tmean_continuity\n";

foreach my $out_key (keys %count) {
  print "$out_key\t$count{$out_key}\t$q_contig_size{$out_key}\t$s_contig_size{$out_key}\t$q_alignment_size{$out_key}\t$s_alignment_size{$out_key}\t$ctg1_align_pos{$out_key}\t$ctg2_align_pos{$out_key}\t$mean_id{$out_key}\t$mean_blastid{$out_key}\t$mean_con{$out_key}\n";
}

exit;
