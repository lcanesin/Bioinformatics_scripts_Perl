#!/usr/bin/perl


                                   ###########################
                                   ##     Preprocessing     ##
                                   ###########################
use strict;
use Switch;

                         ###############################################
                         ## Duplicates query and target file creation ##
                         ###############################################

open(RMOUT, $ARGV[0]);
  while (<RMOUT>) {
    chomp();
    if () { next; }
    my @tmp = split (/\t/, $_);
    $checklist{"$tmp_list[0]\t$tmp_list[2]"} = 1;
  }
close(RMOUT);

open (DUPLIC, $ARGV[1]);
  while (<DUPLIC>) {
    chomp();
    my $line = $_;
    if ($line =~ /^\n/) { next; }
    if ($line =~ /^#/) { next; }
    my @tmp = split (/\t/, $line);
    my $namecheck = "$tmp[0]\t$tmp[1]";
#print "$namecheck\n";
    if (!$checklist{$namecheck}) { next; }
    if ($list{$tmp[0]}{$tmp[1]}) {
#print "enter already created list entry\n"; 
      $count{$tmp[0]}{$tmp[1]}++;
      $perc_id{$tmp[0]}{$tmp[1]} += $tmp[2];
      $length{$tmp[0]}{$tmp[1]} += $tmp[3];
      next;
    } elsif (!$list{$tmp[0]}{$tmp[1]}) {
#print "enter list\n";
      $count{$tmp[0]}{$tmp[1]} = 1;
      $perc_id{$tmp[0]}{$tmp[1]} = $tmp[2];
      $length{$tmp[0]}{$tmp[1]} = $tmp[3];
      $list{$tmp[0]}{$tmp[1]} = 1;
      next;
    }
  }
close (DUPLIC);

my %duplicates;

foreach my $busco (sort keys %perc_id) {
  foreach my $contig (keys %{$perc_id{$busco}}) {
    my $mean_id = $perc_id{$busco}{$contig}/$count{$busco}{$contig};
#print "$mean_id\t$perc_id{$busco}{$contig}\t$count{$busco}{$contig}\n";
    $duplicates{$busco}{$contig} = "$mean_id\t$length{$busco}{$contig}";
  }
}

my $id_diff;
my $len_diff;
my $first_id;
my $first_length;

foreach my $busco2 (sort keys %duplicates) {
  foreach my $contig2 (keys %{$duplicates{$busco2}}) {
#print "running_inside_assemblies\n"; 
    my @tmp_out = split (/\t/, $duplicates{$busco2}{$contig2});
    if ($first_id) {
      $id_diff = $first_id - $tmp_out[0];
      $len_diff = $first_length - $tmp_out[1];

      if ($id_diff < 0) {
        $id_diff *= -1;
      }
      if ($len_diff < 0) {
        $len_diff *= -1;
      }
      my $pair_id = ($first_id + $tmp_out[0]) / 2;
      my $pair_len = ($first_length + $tmp_out[1]) / 2;      
      $first_id = 0;
      $first_length = 0;
      print "$busco2\t$pair_id\t$id_diff\t$pair_len\t$len_diff\n";
      next;
    } elsif (!$first_id) {
      $first_id = $tmp_out[0];
      $first_length = $tmp_out[1];
      next;
    }
  }
}

exit;
