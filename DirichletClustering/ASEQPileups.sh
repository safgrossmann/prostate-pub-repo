#####################################
# Create ASEQ pileups per structure #
#####################################
#create full path files , e.g.
perl -ne 'chomp $_; print "/nfs/cancer_ref01/nst_links/live/1959/$_/$_.sample.dupmarked.bam\n";' Structure4_AllNonContaminatedSamples > AllNonContaminatedSamples_FullBamPath #example line, change subdir
#
MEM=200
CORE=8
QUEUE='normal'
MINBQ=10
MINRQ=20
DIR=/lustre/scratch119/casm/team176tv/sg18/Prostate/ResultsSortedByMorphologicalStructure
cd $DIR
for STRUCTURE in Structure4 #SecondUrethralStructure ManuallyTracedTree_Right Structure3 Structure1 FirstUrethralStructure
do
VCF=$DIR/$STRUCTURE/UniqueVCFForPileup
while read bam
do
BASE=$(basename $bam .sample.dupmarked.bam)
bsub -J"ASEQPileup.$BASE" -M"$MEM" -R"select[mem>$MEM] rusage[mem=$MEM] span[hosts=1]" -n $CORE -q $QUEUE \
-o $DIR/LOGS/stdout_ASEQ.$BASE -e $DIR/LOGS/stderr_ASEQ.$BASE \
"/nfs/users/nfs_s/sg18/Tools/ASEQ vcf=$VCF threads=$CORE out=$DIR/$STRUCTURE/ASEQ/ mbq=$MINBQ mrq=$MINRQ bam=$bam"
done < $STRUCTURE/AllNonContaminatedSamples_FullBamPath
done
