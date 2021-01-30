#!/usr/bin/perl-5.16.2
use strict;
use warnings;
use List::MoreUtils qw(uniq);

#my $infile = "/lustre/scratch119/casm/team176tv/sg18/Prostate/FilteredCaveman/Results_0001_0024/VAF_longlist_BranchingStructure.txt";
my $infile = $ARGV[0];
open(IN,$infile) or die "Cannot open $infile: $!\n";
my $header = <IN>;

my %muthash;
my @samples;
while(<IN>){
	chomp $_;
	my @tabs = split(/\t/,$_);
	$muthash{"$tabs[1]_$tabs[2]"}{$tabs[0]} = $tabs[3];
	push(@samples,$tabs[0]);
}
close(IN);
@samples = uniq @samples;

#my $outfile = "/lustre/scratch119/casm/team176tv/sg18/Prostate/FilteredCaveman/Results_0001_0024/SharingMatrix";
my $outfile = $ARGV[1];
open(OUT,">",$outfile) or die "Cannot open $outfile: $!\n";

my $printline = '';
foreach my $sample (@samples){
	$printline .= "$sample\t";
}
chop $printline;
#leave tab as mutation names will be row names
print OUT "\t$printline\n";

foreach my $key (keys %muthash){
	$printline = '';
	foreach my $sample (@samples){
		if($muthash{$key}{$sample}){
			$printline .= "$muthash{$key}{$sample}\t";
		}else{
			$printline .= "0\t";
		}
	}
	chop $printline;
	print OUT "$key\t$printline\n";
}
close(OUT);

exit;