#!/usr/bin/perl-5.16.2
use strict;
use warnings;
use IO::Uncompress::Gunzip qw($GunzipError);

my $sample = $ARGV[0];
my $Cavemanfile = "/nfs/cancer_ref01/nst_links/live/1959/".$sample."/".$sample.".caveman_c.vcf.gz";
my $Caveman = IO::Uncompress::Gunzip->new( $Cavemanfile, MultiStream => 1 ) or die "Could not read from $Cavemanfile: $GunzipError";
my $outfile = "/lustre/scratch119/casm/team176tv/sg18/Prostate/$sample.CavmanVAFs.txt";
open(OUT,">",$outfile) or die "Cannot open $outfile for writing: $!\n";
print OUT "$sample\n";
while(<$Caveman>){
	if($_=~/^#/){
		next;
	}else{
		chomp $_;
		my @tabs = split(/\t/,$_);
		my @colons = split(/:/,$tabs[-1]);
		print OUT "$colons[-1]\n";
	}
}

close($Caveman);