bam=$1
sample=$2
outdir=$3
unset PYTHONPATH

#work within virtual_env
source /lustre/scratch117/casm/team268/tc16/TelomereCat/test_env/bin/activate

telomerecat bam2length -N100 -p 6 -x --output $outdir/$sample/${sample}_telomerecat.csv $bam




