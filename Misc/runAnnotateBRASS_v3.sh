#!/bin/bash

#--------------------------------------------------------------------------------------------------------------------------
# Name		: runAnnotateBRASS_v3.sh
# Author	: Mathijs A. Sanders
# Version	: 3.00
# Copyright	: None
# Description	: runAnnotateBRASS_v3.sh -pt project_IDs -st samples_tumour_csv -pn project_IDs -sn samples_normal_csv -tpon text_file_PON -o output_directory [-ppon project_IDs] [-spon samples_PON] [-t 10] [-s snp_database] [-g reference_genome] [-h]
#--------------------------------------------------------------------------------------------------------------------------

#--------------------------------------------------------------------------------------------------------------------------
# Annotate variants
#--------------------------------------------------------------------------------------------------------------------------

annotateBRASS() {
	
	local PT_DIR=$1
	local ST_ID=$2
	local PN_DIR=$3
	local SN_ID=$4
	local REFERENCE=$5
	local SNP_DB=$6
	local OUTPUT_DIR=$7	
	local THREADS=$8
	local PON=$9

	
	BED=$(find /nfs/cancer_ref01/nst_links/live/${PT_DIR}/${ST_ID}/ -mindepth 1 -maxdepth 1 -type l -name "*.brass.annot.bedpe.gz")

	if [[ -z $BED ]]
	then
		echo "Error: Could not find the BRASS BED file belonging to sample $ST_ID in project directory $PT_DIR. Skipping this sample."
		return 0
	fi
		
	OUTPUT_NM=$(basename $BED | sed "s:\.brass\.annot\.bedpe\.gz:_original_annotated.bed:")

	MASTER_BAM=$(find /nfs/cancer_ref01/nst_links/live/${PT_DIR}/${ST_ID}/ -mindepth 1 -maxdepth 1 -type l -name "*.sample.dupmarked.bam")
	
	if [[ -z $MASTER_BAM ]]
	then
		echo "Error: Could not find the BAM file belonging to sample $ST_ID in project directory $PT_DIR. Skipping this sample."
		return 0
	fi

	MASTER_BRASS_BAM=$(find /nfs/cancer_ref01/nst_links/live/${PT_DIR}/${ST_ID}/ -mindepth 1 -maxdepth 1 -type l -name "*.mt.brass.brm.bam")
	
	if [[ -z $MASTER_BRASS_BAM ]]
	then
		echo "Error: Could not find the BRASS BAM file belonging to sample $ST_ID in project directory $PT_DIR. Skipping this sample."
		return 0
	fi

	MASTER_CONTROL_BAM=$(find /nfs/cancer_ref01/nst_links/live/${PN_DIR}/${SN_ID}/ -mindepth 1 -maxdepth 1 -type l -name "*.sample.dupmarked.bam")

	if [[ -z $MASTER_CONTROL_BAM ]]
	then
		echo "Error: Could not fint the control BAM file belonging to sample $SN_ID in project directory $PN_DIR. Skipping this sample."
		return 0
	fi

	TNM=$(echo $OUTPUT_NM | sed "s:_original_annotated\.bed::")

	bsub -K -q normal -J "${TNM}" -o ${OUTPUT_DIR}/log/log.%J -e ${OUTPUT_DIR}/err/err.%J -n${THREADS} -R"select[mem>10000] span[hosts=1] order[-slots] rusage[mem=10000]" -M10000 bash -e /lustre/scratch116/casm/cgp/users/ms44/scripts/annotateBRASS_v3.sh $MASTER_BAM $MASTER_BRASS_BAM $BED ${OUTPUT_DIR}/${OUTPUT_NM} $MASTER_CONTROL_BAM $PON $THREADS $REFERENCE $SNP_DB
	
	wait

	return 0
}
export -f annotateBRASS

display_usage() {
cat << HEREDOC
Usage: runAnnotateBRASS_v3.sh -pt project_tumour_IDS_csv -st sample_tumour_ids_csv -pn project_normal_ids -sn sample_normal_ids -tpon PON_text_file -o output_directory [-s SNP_database] [-g reference_genome] [-t threads] [-ppon project_PON_ids] [-spon sample_PON_ids]

Required arguments:

	-pt/--projects_tumour <comma_separated_project_IDs>			Comma-separated project IDs for each individual sample (as used in CanApps).
	-st/--samples_tumour <comma_separated_sample_IDs>			Comma-separated sample IDs (required to be present in the matched project directory).
	-pn/--projects_normal <comma_separated_project_IDs>			Comma-separated project IDs for each individual matched control sample (as used in CanApps).
	-sn/--samples_normal <comma_separated_sample_IDs>			Comma-separated sample IDs (required to be present in the matched project directory).
	-tpon/--text_file_PON <input_file>					Text file containing the full paths to panel of normal (PON) BAM files. Each line is a separate sample. 
	-o/--output <output_directory>						Output directory for storing all intermediate and final results.
	
Optional arguments:

	-t/--threads <threads>			Number of threads. Default:10
	-ppon/--projects_PON			Comma-separated project IDs for the individual PON samples.
	-spon/--samples_PON			Comma-separated sample ID (required to be present in the matched project directories).
	-s/--snp <snp_database>			dbSNP database containing common SNPs. Default: dbSNP147
	-g/--genome <reference_genome>		Reference genome used for aligning and variant calling. Default: hg19
	-h/--help				Get help information.

HEREDOC
}

#------------------------------------------------------------------------------------
# Get input parameters
#------------------------------------------------------------------------------------

THREADS=5
REFERENCE='/lustre/scratch119/casm/team78pipelines/canpipe/live/ref/human/GRCh37d5/genome.fa'
SNP_DB='/lustre/scratch116/casm/cgp/users/ms44/src/dbsnp/common_all_20180423.vcf.gz'

POSITIONAL=()
while [[ $# -gt 0 ]]
do
	key="$1"

	case $key in
		-pt|--projects_tumour)
		PROJECT_TUMOUR_IDS="$2"
    		shift
    		shift
    		;;
		-st|--samples_tumour)
		SAMPLE_TUMOUR_IDS="$2"
		shift
		shift
		;;
		-pn|--projects_normal)
		PROJECT_NORMAL_IDS=$2
		shift
		shift
		;;
		-sn|--samples_normal)
		SAMPLE_NORMAL_IDS=$2
		shift
		shift
		;;
		-tpon|--text_file_PON)
		PON_LOCATION="$2"
		shift
		shift
		;;
    		-o|--output)
    		OUTPUT_DIR="$2"
    		shift
    		shift
    		;;
		-t|--threads)
		THREADS="$2"
		shift
		shift
		;;
		-ppon|--projects_PON)
		PROJECT_PON_IDS="$2"
		shift
		shift
		;;
    		-spon|--samples_PON)
    		SAMPLE_PON_IDS="$2"
    		shift
    		;;
		-s|--snp)
		SNP_DB="$2"
		shift
		shift
		;;
		-g|--genome)
		GENOME="$2"
		shift
		shift
		;;
		-h|--help)
		display_usage
		exit 0
		shift
		;;
    		*)
    		display_usage
		exit -1
    		shift
    		;;
	esac
done
set -- "${POSITIONAL[@]}"

if [[ -z $PROJECT_TUMOUR_IDS ]]
then
	echo "Error: Please provide project directories for the samples of interest"
	exit -1
fi

if [[ -z $SAMPLE_TUMOUR_IDS ]]
then
        echo "Error: Please provide sample ids for the samples of interest matching the project ids listed under -pt"
        exit -1
fi

if [[ -z $PROJECT_NORMAL_IDS ]]
then
        echo "Error: Please provide project directories for the controls"
        exit -1
fi

if [[ -z $SAMPLE_NORMAL_IDS ]]
then
        echo "Error: Please provide sample ids for the controls matching the projects id listed under -pn"
        exit -1
fi

if [[ -z $PON_LOCATION ]]
then
	if [ -z $PROJECT_PON_IDS ] || [ -z $SAMPLE_PON_IDS ]
	then
		echo "Error: Please provide the location to the PON description text file or provide PON details via -ppon and -spon"
		exit -1
	fi
elif [ ! -z $PROJECT_PON_IDS] || [ ! -z $SAMPLE_PON_IDS ]
then
	echo "Error: The PON is defined by the PON text file and by PON identifiers (-ppon or -spon). Please only provide a single source of PON samples"
	exit -1
fi


PON_PROJECT_ARRAY=""
PON_SAMPLE_ARRAY=""

OLD=$IFS
IFS=','
PT_ARRAY=(${PROJECT_TUMOUR_IDS})
ST_ARRAY=(${SAMPLE_TUMOUR_IDS})
PN_ARRAY=(${PROJECT_NORMAL_IDS})
SN_ARRAY=(${SAMPLE_NORMAL_IDS})
if [ -z $PON_LOCATION ]
then
	PON_PROJECT_ARRAY=(${PROJECT_PON_IDS})
	PON_SAMPLE_ARRAY=(${SAMPLE_PON_IDS})
fi
IFS=$OLD
for t in "${PT_ARRAY[@]}"
do
	IDIR=/nfs/cancer_ref01/nst_links/live/${t}/
	if [[ ! -d $IDIR ]]
	then
		echo "Error: The provided project - $IDIR - does not exist on the iRods system"
		exit -1
	fi
done

if [[ ${#PT_ARRAY[@]} -ne ${#ST_ARRAY[@]} ]]
then
	echo "Error: The number of project directories (${#PT_ARRAY[@]}) and samples of interest (${#ST_ARRAY[@]}) are not equal. Please review provided project IDs and samples IDs for cases for which variant filtering is wished"
	exit -1
fi

for ((i=0; i<${#PT_ARRAY[@]}; i++));
do
	IDIR=/nfs/cancer_ref01/nst_links/live/${PT_ARRAY[$i]}/${ST_ARRAY[$i]}
	if [[ ! -d $IDIR ]]
	then
		echo "Error: The provided sample - ${ST_ARRAY[$i]} - does not exist in ${PT_ARRAY[$i]}"
		exit -1
	fi
done

for t in "${PN_ARRAY[@]}"
do
	IDIR=/nfs/cancer_ref01/nst_links/live/${t}/
	if [[ ! -d $IDIR ]]
	then
		echo "Error: The provided directory - $IDIR - does not exist on the iRods system"
		exit -1
	fi
done

if [[ ${#PN_ARRAY[@]} -ne ${#SN_ARRAY[@]} ]]
then
	echo "Error: The number of project directories and control samples are not equal. Please review the provided project IDs and samples IDs for use as controls"
	exit -1
fi

for ((i=0; i<${#PN_ARRAY[@]}; i++));
do
	IDIR=/nfs/cancer_ref01/nst_links/live/${PN_ARRAY[$i]}/${SN_ARRAY[$i]}
	if [[ ! -d $IDIR ]]
	then
		echo "Error: The control sample - ${SN_ARRAY[$i]} - does not exist in the project directory ${PN_ARRAY[$i]}"
		ecit -1
	fi
done

if [[ ${#PT_ARRAY[@]} -ne ${#PN_ARRAY[@]} ]]
then
	echo "Error: The number of samples of interest does not match the number of control samples. Please review these variables"
	exit -1
fi

if [[ -z $PON_LOCATION ]]
then
	for ((i=0; i<${#PON_PROJECT_ARRAY[@]}; i++));
	do
		IDIR=/nfs/cancer_ref01/nst_links/live/${PON_PROJECT_ARRAY[$i]}/${PON_SAMPLE_ARRAY[$i]}
		if [[ ! -d $IDIR ]]
		then
			echo "Error: The control sample - ${PON_SAMPLE_ARRAY[$i]} - does not exist in the project directory ${PON_PROJECT_ARRAY[$i]}"
			exit -1
		fi
	done
	
	if [[ ${#PON_PROJECT_ARRAY[@]} -ne ${#PON_SAMPLE_ARRAY[@]} ]]
	then
		echo "Error: The number of PON samples and provided PON directories is a mismatch. Please review the provided project and sample IDS for the PON panel."
		exit -1
	fi
else
	PON_SAMPLES=$(cat $PON_LOCATION | tr '\n' ',' | sed "s:,$::")
fi

if [[ -z $OUTPUT_DIR ]]
then
	echo "Error: Please provide a output directory (-h for help)"
	exit -1
fi

OUTPUT_DIR="${OUTPUT_DIR/#\~/$HOME}"

regex='^[0-9]+$'

if ! [[ $THREADS =~ $regex ]]
then
	echo "Error: Please provide an integer value for the number of threads"
	exit -1
fi

if [[ ! -f $SNP_DB ]]
then
	echo "Error: The provided dbSNP database file does not exist. Please provide the correct path to the dbSNP database."
	exit -1
fi
if [[ ! -f $REFERENCE ]]
then
	echo "Error: The provided reference sequence file does not exist. Please provde the correct path to the reference FASTA file."
	exit -1
fi

mkdir -p ${OUTPUT_DIR}
mkdir -p ${OUTPUT_DIR}/log
mkdir -p ${OUTPUT_DIR}/err

if [[ ! -d $OUTPUT_DIR ]]
then
       	echo "Error: Unable to make the directory. Please check permissions."
       	exit -1
fi

PON=""
k=0
if [[ ! -z $PON_LOCATION ]]
then
	readarray -t PON < $PON_LOCATION
	for f in "${PON[@]}"
	do
		BAM=$(readlink -f $f)
		if [[ -z $BAM ]]
		then
			echo "Error: the following PON BAM location does not exist - $f"
			exit -1
		fi
	done
else 
	for (( i = 0; i < ${#PON_PROJECT_ARRAY[@]}; i++ ));
	do
		BAM=$(find /nfs/cancer_ref01/nst_links/live/${PON_PROJECT_ARRAY[$i]}/${PON_SAMPLE_ARRAY[$i]}/ -mindepth 1 -maxdepth 1 -type l -name "*.sample.dupmarked.bam")
		if [[ -z $BAM ]]
		then
			echo "Error: the BAM for the following PON sample could not be found: ${PON_PROJECT_ARRAY[$i]} - ${PON_SAMPLE_ARRAY[$i]}"
			exit -1
		else
			PON[$k]=$BAM
			k=$(($k+1))
		fi
	done
fi

FINAL_PON=$(echo "${PON[@]}" | sed "s: :,:g")

awk -v STR_PT=$PROJECT_TUMOUR_IDS -v STR_ST=$SAMPLE_TUMOUR_IDS -v STR_PN=$PROJECT_NORMAL_IDS -v STR_SN=$SAMPLE_NORMAL_IDS -v OUTPUT_DIR=$OUTPUT_DIR -v REF=$REFERENCE -v SNP=$SNP_DB -v THR=$THREADS -v PON=$FINAL_PON 'BEGIN{n=split(STR_PT,apt,","); split(STR_ST,ast,","); split(STR_PN, apn, ","); split(STR_SN,asn, ","); for(i=1; i<=n ; i++){print apt[i] " " ast[i] " " apn[i] " " asn[i] " " REF " " SNP " " OUTPUT_DIR " " THR " " PON}}' | xargs -n1 -P0 -I {} bash -c 'annotateBRASS {}'

for f in $(ls ${OUTPUT_DIR}/*_original_annotated.bed); do NM=$(echo $f | sed "s:_original_annotated:_retained:"); grep "^#" $f > ${NM}; grep -v "^#" $f | awk -F$'\t' '{if(($49 >=3 && $50 >= 3) && ($51!~/NaN/ && $51 > 0 && $52!~/NaN/ && $52 > 0) && ($53 < 25 && $54 < 25 && ($53 + $54) <= 40) && ((($55/$47) <= 0.5 && ($57/$47) <= 0.5) || (($56/$48) <= 0.5 && ($58/$48) <= 0.5)) && ($59 < 0.05 && $60 < 0.05) && (($61 == 0 || (($67/$61) < 0.25 && ($69/$61) < 0.25 && $63 > 1)) || ($62 == 0 || (($68/$62) < 0.25 && ($70/$62) < 0.25 && $64 > 1))) && ($71~/false/) && ($73~/false/ || (($75/$74) < (1/3)) && $75 < 1) && (($80 < (0.15) || $80~NaN) && ($81 < (0.15) || $81~NaN)) && ($61 > 0 && ($82/$61) < 0.5) && ($62 > 0 && ($83/$62) < 0.5) && ($63 >= 4 && $64 >= 4)){print $0}else{}}' >> ${NM}; done

for f in $(ls ${OUTPUT_DIR}/*_original_annotated.bed); do NM=$(echo $f | sed "s:_original_annotated:_rejected:"); grep "^#" $f > ${NM}; grep -v "^#" $f | awk -F$'\t' '{if(($49 >=3 && $50 >= 3) && ($51!~/NaN/ && $51 > 0 && $52!~/NaN/ && $52 > 0) && ($53 < 25 && $54 < 25 && ($53 + $54) <= 40) && ((($55/$47) <= 0.5 && ($57/$47) <= 0.5) || (($56/$48) <= 0.5 && ($58/$48) <= 0.5)) && ($59 < 0.05 && $60 < 0.05) && (($61 == 0 || (($67/$61) < 0.25 && ($69/$61) < 0.25 && $63 > 1)) || ($62 == 0 || (($68/$62) < 0.25 && ($70/$62) < 0.25 && $64 > 1))) && ($71~/false/) && ($73~/false/ || (($75/$74) < (1/3)) && $75 < 1) && (($80 < (0.15) || $80~NaN) && ($81 < (0.15) || $81~NaN)) && ($61 > 0 && ($82/$61) < 0.5) && ($62 > 0 && ($83/$62) < 0.5) && ($63 >= 4 && $64 >= 4)){}else{print $0}}' >> ${NM}; done

exit 0
