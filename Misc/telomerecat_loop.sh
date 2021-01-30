#!/bin/bash

callme=/nfs/users/nfs_s/sg18/Scripts/Prostate/TelomereLengthEstimation/bam2length.sh
MEM=8000
CORE=6
QUEUE=normal

cd /lustre/scratch119/casm/team176tv/sg18/Prostate/TelomereEstimation/1959
project=1959
outdir=/lustre/scratch119/casm/team176tv/sg18/Prostate/TelomereEstimation/1959
touch samples.txt
for bam in $(find /nfs/cancer_ref01/nst_links/live/$project -iname '*.sample.dupmarked.bam'); do
sample=$(basename $bam| sed 's/\..*$//')
echo $sample >> samples.txt
mkdir -p $outdir/$sample
bsub -o $PWD/log.%J -e $PWD/err.%J -q $QUEUE -R "select[mem>=$MEM] span[hosts=1] rusage[mem=$MEM]" -M$MEM -n$CORE -J $sample $callme $bam $sample $outdir
done

cd /lustre/scratch119/casm/team176tv/sg18/Prostate/TelomereEstimation/1589
project=1589
outdir=/lustre/scratch119/casm/team176tv/sg18/Prostate/TelomereEstimation/1589
for bam in $(find /nfs/cancer_ref01/nst_links/live/$project -iname '*.sample.dupmarked.bam'); do
sample=$(basename $bam| sed 's/\..*$//')
echo $sample >> samples.txt
mkdir -p $outdir/$sample
bsub -o $PWD/log.%J -e $PWD/err.%J -q $QUEUE -R "select[mem>=$MEM] span[hosts=1] rusage[mem=$MEM]" -M$MEM -n$CORE -J $sample $callme $bam $sample $outdir
done

exit
#Some Jobs failed with runtime limit exception
DIR=/lustre/scratch119/casm/team176tv/sg18/Prostate/TelomereEstimation/
cd $DIR
QUEUE='long'
MEM=4000
CORE=1
max=$(wc -l $DIR/RerunBoth | perl -ne '($d)=$_=~/(\d+)/; print "$d";')
bsub -J"TeloRPAry[1-$max]" -M"$MEM" -R"select[mem>$MEM && hname!='cgp-6-1-0'] rusage[mem=$MEM] span[hosts=1]" -n $CORE -q $QUEUE \
-o $DIR/stdout.Repeatarray -e $DIR/stderr.Repeatarray \
"awk -v jindex=\$LSB_JOBINDEX 'NR==jindex' RerunBoth | bash"

