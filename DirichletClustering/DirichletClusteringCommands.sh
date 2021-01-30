#######################
# Prepare input files #
#######################

#The second and third argument are total depth and variant-allele counts. Done from the ASEQ pileups with some R code saved in Scripts/Prostate/CreateAndBuildSharingMatrices.R

#The fourth argument is the output of Context_pull_build37.pl. Create the corresponding input of this script:
cd /lustre/scratch119/casm/team176tv/sg18/Prostate/ResultsSortedByMorphologicalStructure
for i in */UniqueVCF*; do DIR=$(echo $i | perl -ne '($dir)=$_=~/(.+)\/Unique/;print "$dir";'); echo -e "chrom\tpos\tref\talt" > $DIR/ChromPosRefAlt_ForContextBuild; tail -n+3 $i | cut -f1,2,4,5 >> $DIR/ChromPosRefAlt_ForContextBuild; done
#run the context building
DIR=/lustre/scratch119/casm/team176tv/sg18/Prostate/
cd $DIR
MEM=400
CORE=2
QUEUE='normal'
SCRIPT=/nfs/users/nfs_s/sg18/Scripts/Prostate/DirichletClustering/Context_pull_build37.pl
BASES=10
for STRUCTURE in Structure3 # Structure4  Structure1 SecondUrethralStructure ManuallyTracedTree_Right FirstUrethralStructure
do
IN=$DIR/ResultsSortedByMorphologicalStructure/$STRUCTURE/OnlyIncludeCorrectResultsFrom01Jun18/ChromPosRefAlt_ForContextBuild #$DIR/ResultsSortedByMorphologicalStructure/$STRUCTURE/ChromPosRefAlt_ForContextBuild
OUT=$DIR/ResultsSortedByMorphologicalStructure/$STRUCTURE/OnlyIncludeCorrectResultsFrom01Jun18/mut_contexts.tsv #$DIR/ResultsSortedByMorphologicalStructure/$STRUCTURE/mut_contexts.tsv
bsub -J"PullContext.$STRUCTURE" -M"$MEM" -R"select[mem>$MEM] rusage[mem=$MEM] span[hosts=1]" -n $CORE -q $QUEUE \
-o $DIR/LOGS/stdout_PullContext.$STRUCTURE -e $DIR/LOGS/stderr_PullContext.$STRUCTURE \
"perl $SCRIPT $BASES $IN $OUT"
done

##############################
# Run main clustering script #
##############################
DIR=/lustre/scratch119/casm/team176tv/sg18/Prostate
cd $DIR
MEM=1000000
CORE=2
QUEUE='teramem'
JOB='Cluster'
SCRIPTPATH="/nfs/users/nfs_s/sg18/Scripts/Prostate/DirichletClustering"
RSCRIPT=$SCRIPTPATH/Run_Dirichlet_clustering_posthoc.R
for STRUCTURE in  Structure3 # Structure4 SecondUrethralStructure FirstUrethralStructure ... all other examples
do
DEPTH=$DIR/ResultsSortedByMorphologicalStructure/$STRUCTURE/DirichletClustering/target_depth.csv
ALT=$DIR/ResultsSortedByMorphologicalStructure/$STRUCTURE/DirichletClustering/alt_depth.csv
MUT=$DIR/ResultsSortedByMorphologicalStructure/$STRUCTURE/DirichletClustering/mut_contexts.tsv
OUT=$DIR/ResultsSortedByMorphologicalStructure/$STRUCTURE/DirichletClustering/
BURNIN=11000
bsub -J"$JOB.$STRUCTURE" -M"$MEM" -R"select[mem>$MEM] rusage[mem=$MEM] span[hosts=1]" -n $CORE -q $QUEUE \
-o $DIR/LOGS/stdout_$JOB.$STRUCTURE -e $DIR/LOGS/stderr_$JOB.$STRUCTURE \
"R-3.3.0 < $RSCRIPT --no-save --no-restore --args $SCRIPTPATH $ALT $DEPTH  $MUT $OUT $BURNIN"
done


#########################
# Run longer clustering #
#########################
DIR=/lustre/scratch119/casm/team176tv/sg18/Prostate
cd $DIR
MEM=36000 #only the sampling is not very resource hungry
CORE=1
QUEUE='basement' 
JOB='Cluster250k'
SCRIPTPATH="/nfs/users/nfs_s/sg18/Scripts/Prostate/DirichletClustering"
RSCRIPT=$SCRIPTPATH/Run_Dirichlet_clustering_LongAndOnlyClustering.R
for STRUCTURE in Structure3 #Structure4 24GB mem sufficient for struc 4
do
DEPTH=$DIR/ResultsSortedByMorphologicalStructure/$STRUCTURE/DirichletClustering_250k/target_depth.csv
ALT=$DIR/ResultsSortedByMorphologicalStructure/$STRUCTURE/DirichletClustering_250k/alt_depth.csv
MUT=$DIR/ResultsSortedByMorphologicalStructure/$STRUCTURE/DirichletClustering_250k/mut_contexts.tsv
OUT=$DIR/ResultsSortedByMorphologicalStructure/$STRUCTURE/DirichletClustering_250k/
BURNIN=200000 # burnin is not needed in this script but given for as default for later steps 
bsub -J"$JOB.$STRUCTURE" -M"$MEM" -R"select[mem>$MEM] rusage[mem=$MEM] span[hosts=1]" -n $CORE -q $QUEUE \
-o $DIR/LOGS/stdout_$JOB.$STRUCTURE -e $DIR/LOGS/stderr_$JOB.$STRUCTURE \
"R-3.3.0 < $RSCRIPT --no-save --no-restore --args $SCRIPTPATH $ALT $DEPTH  $MUT $OUT $BURNIN"
done


################################################
# Label switching and finalise long clustering #
################################################
DIR=/lustre/scratch119/casm/team176tv/sg18/Prostate
cd $DIR
MEM=1000000 
QUEUE='teramem' #hugemem
JOB='LabelSwitchFinalise'
SCRIPTPATH="/nfs/users/nfs_s/sg18/Scripts/Prostate/DirichletClustering"
RSCRIPT=$SCRIPTPATH/LabelSwitchingAndFinalPlots_PickUpAfterClustering.R 
CORE=1
Structure4_Session='/lustre/scratch119/casm/team176tv/sg18/Prostate/ResultsSortedByMorphologicalStructure/Structure4/DirichletClustering/ndp_2019_06_01_nuknt/Rsession.dat'
bsub -J"$JOB.Struc4" -M"$MEM" -R"select[mem>$MEM] rusage[mem=$MEM]  span[hosts=1]" -n $CORE -q $QUEUE \
-o $DIR/LOGS/stdout.$QUEUE.$JOB.Structure4 -e $DIR/LOGS/stderr.$QUEUE.$JOB.Structure4 \
"R-3.3.0 < $RSCRIPT --no-save --no-restore --args $Structure4_Session"
#REMEMBER TO CHECK CORES SET AND NUMBER OF BURN IN IN RSCRIPT
CORE=4
Session='/lustre/scratch119/casm/team176tv/sg18/Prostate/ResultsSortedByMorphologicalStructure/Structure1/DirichletClustering/ndp_2019_06_01_draci/Rsession.dat'
bsub -J"$JOB.Struc4" -M"$MEM" -R"select[mem>$MEM] rusage[mem=$MEM] span[hosts=1]" -n $CORE -q $QUEUE -G team78-grp \
-o $DIR/LOGS/stdout.$QUEUE.$JOB.Structure1 -e $DIR/LOGS/stderr.$QUEUE.$JOB.Structure1 \
"R-3.3.0 < $RSCRIPT --no-save --no-restore --args $Session" 
