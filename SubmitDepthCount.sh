#Create original depth counts
MEM=4000
CORE=1
QUEUE='normal'
Savedir=/nfs/users/nfs_s/sg18/team176space/Prostate/DepthCounts
cd /nfs/cancer_ref01/nst_links/live/1959/ 
for file in PD*/*sample.dupmarked.bam
do
base=$(basename $file .sample.dupmarked.bam)
bsub -J"Depth.$base" -M"$MEM" -R"select[mem>$MEM] rusage[mem=$MEM] span[hosts=1]" -n $CORE -q $QUEUE \
-o /nfs/users/nfs_s/sg18/team176space/Prostate/LOGS/stdout.depth.$base -e /nfs/users/nfs_s/sg18/team176space/Prostate/LOGS/stderr.depth.$base \
"samtools depth -r 1 -q 1 -Q 1 $file > $Savedir/$base.depth"
done
exit

#Summarise depth counts once finished
MEM=4000
CORE=1
QUEUE='normal'
cd /lustre/scratch119/casm/team176tv/sg18/Prostate/DepthCounts
for file in PD*.depth
do
base=$(basename $file .depth)
bsub -J"Depth.$base" -M"$MEM" -R"select[mem>$MEM] rusage[mem=$MEM] span[hosts=1]" -n $CORE -q $QUEUE \
-o /nfs/users/nfs_s/sg18/team176space/Prostate/LOGS/stdout.depth.uniq.$base -e /nfs/users/nfs_s/sg18/team176space/Prostate/LOGS/stderr.depth.uniq.$base \
"cut -f3 $file | sort -n | uniq -c | sed 's/^ *//g' > $file.uniq"
done
exit



