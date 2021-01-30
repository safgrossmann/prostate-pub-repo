#!/usr/bin/perl-5.16.2
use strict;
use warnings;
#check whcih structure and exclude unplaced clusters from vcf creation
my $structure = $ARGV[0];
my @exclude = ();
if($structure eq 'Structure3'){
	@exclude = (54,3,1,15,21,102,17,18,23);
}elsif($structure eq 'Structure4'){
	@exclude = (70,9,1,7,41);
}else{
	die "Currentyl expects 'Structure3' or 'Structure4' as first argument\n";
}
my %badparams = map { $_ => 1 } @exclude;
#open and check commanline arguments
my $mut_path = $ARGV[1];
open(MUT,$mut_path) or die "Cannot open $mut_path: $!\n"; #expects alt_depth.csv from NDP input
my $assign_path = $ARGV[2];
open(ASSIGN,$assign_path) or die "Cannot open $assign_path: $!\n"; #expects clust_assign_posthoc.csv from NDP output 
unless($ARGV[3]){
	die "Please supply directory for output files as fourth argument\n";
}
my $outpath = $ARGV[3];
#create hash linking mutations to clusters
my $header = <ASSIGN>;
my %assignhash;
while(<ASSIGN>){
	chomp $_;
	my @tabs = split(/,/,$_);
	$assignhash{$tabs[1]} = $tabs[0] #links between mutid (equivalent to line number of input file) and the assigned cluster
}
close(ASSIGN);
#print mutation information into vcf
$header=<MUT>;
my $lineindex = 1;
my $vcfheader = "##fileformat=VCFv4.1\n#CHROM\tPOS\tID\tREF\tALT\tQUAL\tFILTER\tINFO\n";
while(<MUT>){
	chomp $_;
	my @tabs = split(/,/,$_);
	@tabs = @tabs[0..3];
	#check if vcf should be printed for the cluster the current mutation is assigned to
	my $currcluster = $assignhash{$lineindex};
	if($tabs[0] eq 'X' || $tabs[0] eq 'Y' ){
		$lineindex += 1;
		next;
	}elsif(exists($badparams{$currcluster})){
		$lineindex += 1;
		next;
	}
	#check if corresponding vcf should be created or already exists
	my $filename = $outpath.'Cluster'.$currcluster.'.vcf';
	if (-e $filename){
		open(CURR,">>",$filename) or die "Cannot open $filename to append to: $!\n";
		print CURR "$tabs[0]\t$tabs[1]\t.\t$tabs[2]\t$tabs[3]\t.\tPASS\t.\n";
		close(CURR);
	}else{
		open(CURR,">",$filename) or die "Cannot open $filename to write to: $!\n";
		print CURR $vcfheader;
		print CURR "$tabs[0]\t$tabs[1]\t.\t$tabs[2]\t$tabs[3]\t.\tPASS\t.\n";
		close(CURR);
	}
	$lineindex += 1;
}
close(MUT);
exit;










