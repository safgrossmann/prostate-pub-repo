####################
# Filter 0001-0024 #
####################
screen
DIR=/lustre/scratch119/casm/team176tv/sg18/Prostate
cd $DIR
Project=$(printf '1959,%.0s' {1..22} | perl -ne 'chop $_;print"$_";')
Samples='PD40870b_lo0001,PD40870b_lo0002,PD40870b_lo0003,PD40870b_lo0004,PD40870b_lo0005,PD40870b_lo0006,PD40870b_lo0007,PD40870b_lo0009,PD40870b_lo0010,PD40870b_lo0011,PD40870b_lo0012,PD40870b_lo0013,PD40870b_lo0014,PD40870b_lo0015,PD40870b_lo0016,PD40870b_lo0017,PD40870b_lo0018,PD40870b_lo0019,PD40870b_lo0020,PD40870b_lo0022,PD40870b_lo0023,PD40870b_lo0024'
ControlProject=$(printf '1959,%.0s' {1..22} | perl -ne 'chop $_;print"$_";')
ControlSample=$(printf 'PD40870b_lo0021,%.0s' {1..22} | perl -ne 'chop $_;print"$_";')
FILTER=/lustre/scratch119/casm/team176tv/sg18/INSTALZ/WGS/FilteredCaveman/runLCMFiltering_by_sample_project_speedup.sh
$FILTER -pt $Project -st $Samples -pn $ControlProject -sn $ControlSample -o $DIR/FilteredCaveman
#0025-112
screen
DIR=/lustre/scratch119/casm/team176tv/sg18/Prostate
cd $DIR
Project=$(printf '1959,%.0s' {1..61} | perl -ne 'chop $_;print"$_";')
Samples='PD40870b_lo0025,PD40870b_lo0026,PD40870b_lo0027,PD40870b_lo0029,PD40870b_lo0030,PD40870b_lo0031,PD40870b_lo0033,PD40870b_lo0034,PD40870b_lo0035,PD40870b_lo0036,PD40870b_lo0037,PD40870b_lo0038,PD40870b_lo0039,PD40870b_lo0040,PD40870b_lo0041,PD40870b_lo0042,PD40870b_lo0043,PD40870b_lo0045,PD40870b_lo0047,PD40870b_lo0048,PD40870b_lo0050,PD40870b_lo0051,PD40870b_lo0052,PD40870b_lo0054,PD40870b_lo0055,PD40870b_lo0056,PD40870b_lo0057,PD40870b_lo0058,PD40870b_lo0059,PD40870b_lo0060,PD40870b_lo0061,PD40870b_lo0065,PD40870b_lo0067,PD40870b_lo0068,PD40870b_lo0069,PD40870b_lo0070,PD40870b_lo0071,PD40870b_lo0073,PD40870b_lo0075,PD40870b_lo0076,PD40870b_lo0077,PD40870b_lo0078,PD40870b_lo0079,PD40870b_lo0080,PD40870b_lo0083,PD40870b_lo0084,PD40870b_lo0090,PD40870b_lo0091,PD40870b_lo0093,PD40870b_lo0094,PD40870b_lo0095,PD40870b_lo0098,PD40870b_lo0099,PD40870b_lo0102,PD40870b_lo0103,PD40870b_lo0106,PD40870b_lo0108,PD40870b_lo0109,PD40870b_lo0110,PD40870b_lo0111,PD40870b_lo0112'
ControlProject=$(printf '1959,%.0s' {1..61} | perl -ne 'chop $_;print"$_";')
ControlSample=$(printf 'PD40870b_lo0021,%.0s' {1..61} | perl -ne 'chop $_;print"$_";')
FILTER=/lustre/scratch119/casm/team176tv/sg18/INSTALZ/WGS/FilteredCaveman/runLCMFiltering_by_sample_project_speedup.sh
$FILTER -pt $Project -st $Samples -pn $ControlProject -sn $ControlSample -o $DIR/FilteredCaveman


############################################
# First round of filtering in 2019 - Feb19 #
############################################
DIR=/lustre/scratch119/casm/team176tv/sg18/Prostate
cd $DIR
Project=$(printf '1959,%.0s' {1..40} | perl -ne 'chop $_;print"$_";')
ControlProject=$(printf '1959,%.0s' {1..40} | perl -ne 'chop $_;print"$_";')
ControlSample=$(printf 'PD40870b_lo0021,%.0s' {1..40} | perl -ne 'chop $_;print"$_";')
FILTER=/lustre/scratch119/casm/team176tv/sg18/INSTALZ/WGS/FilteredCaveman/runLCMFiltering_by_sample_project_speedup.sh
#a
Samples='PD40870b_lo0113,PD40870b_lo0114,PD40870b_lo0115,PD40870b_lo0117,PD40870b_lo0119,PD40870b_lo0120,PD40870b_lo0121,PD40870b_lo0122,PD40870b_lo0123,PD40870b_lo0125,PD40870b_lo0126,PD40870b_lo0127,PD40870b_lo0128,PD40870b_lo0149,PD40870b_lo0151,PD40870b_lo0152,PD40870b_lo0153,PD40870b_lo0154,PD40870b_lo0155,PD40870b_lo0157,PD40870b_lo0161,PD40870b_lo0162,PD40870b_lo0164,PD40870b_lo0165,PD40870b_lo0166,PD40870b_lo0170,PD40870b_lo0173,PD40870b_lo0174,PD40870b_lo0175,PD40870b_lo0177,PD40870b_lo0179,PD40870b_lo0181,PD40870b_lo0184,PD40870b_lo0185,PD40870b_lo0186,PD40870b_lo0188,PD40870b_lo0189,PD40870b_lo0190,PD40870b_lo0191,PD40870b_lo0192'
$FILTER -pt $Project -st $Samples -pn $ControlProject -sn $ControlSample -o $DIR/FilteredCaveman/Filter_2019Feb19_a
#b
Samples='PD40870b_lo0193,PD40870b_lo0194,PD40870b_lo0195,PD40870b_lo0200,PD40870b_lo0202,PD40870b_lo0203,PD40870b_lo0204,PD40870b_lo0206,PD40870b_lo0222,PD40870b_lo0223,PD40870b_lo0224,PD40870b_lo0225,PD40870b_lo0226,PD40870b_lo0229,PD40870b_lo0230,PD40870b_lo0231,PD40870b_lo0232,PD40870b_lo0233,PD40870b_lo0234,PD40870b_lo0236,PD40870b_lo0237,PD40870b_lo0239,PD40870b_lo0240,PD40870b_lo0241,PD40870b_lo0242,PD40870b_lo0243,PD40870b_lo0244,PD40870b_lo0245,PD40870b_lo0246,PD40870b_lo0247,PD40870b_lo0248,PD40870b_lo0249,PD40870b_lo0250,PD40870b_lo0251,PD40870b_lo0253,PD40870b_lo0254,PD40870b_lo0255,PD40870b_lo0256,PD40870b_lo0257,PD40870b_lo0258'
$FILTER -pt $Project -st $Samples -pn $ControlProject -sn $ControlSample -o $DIR/FilteredCaveman/Filter_2019Feb19_b
#c
Samples='PD40870b_lo0259,PD40870b_lo0260,PD40870b_lo0261,PD40870b_lo0262,PD40870b_lo0263,PD40870b_lo0264,PD40870b_lo0265,PD40870b_lo0266,PD40870b_lo0267,PD40870b_lo0268,PD40870b_lo0269,PD40870b_lo0271,PD40870b_lo0272,PD40870b_lo0273,PD40870b_lo0274,PD40870b_lo0275,PD40870b_lo0276,PD40870b_lo0277,PD40870b_lo0278,PD40870b_lo0281,PD40870b_lo0283,PD40870b_lo0285,PD40870b_lo0286,PD40870b_lo0287,PD40870b_lo0288,PD40870b_lo0289,PD40870b_lo0290,PD40870b_lo0293,PD40870b_lo0294,PD40870b_lo0296,PD40870b_lo0298,PD40870b_lo0299,PD40870b_lo0300,PD40870b_lo0301,PD40870b_lo0305,PD40870b_lo0306,PD40870b_lo0307,PD40870b_lo0308,PD40870b_lo0309,PD40870b_lo0310'
$FILTER -pt $Project -st $Samples -pn $ControlProject -sn $ControlSample -o $DIR/FilteredCaveman/Filter_2019Feb19_c
#d
Samples='PD40870b_lo0311,PD40870b_lo0312,PD40870b_lo0313,PD40870b_lo0315,PD40870b_lo0316,PD40870b_lo0317,PD40870b_lo0318,PD40870b_lo0319,PD40870b_lo0320,PD40870b_lo0321,PD40870b_lo0322,PD40870b_lo0323,PD40870b_lo0324,PD40870b_lo0325,PD40870b_lo0327,PD40870b_lo0329,PD40870b_lo0330,PD40870b_lo0331,PD40870b_lo0332,PD40870b_lo0333,PD40870b_lo0334,PD40870b_lo0335,PD40870b_lo0336,PD40870b_lo0337,PD40870b_lo0338,PD40870b_lo0339,PD40870b_lo0340,PD40870b_lo0342,PD40870b_lo0343,PD40870b_lo0344,PD40870b_lo0345,PD40870b_lo0346,PD40870b_lo0348,PD40870b_lo0349,PD40870b_lo0350,PD40870b_lo0351,PD40870b_lo0352,PD40870b_lo0353,PD40870b_lo0354,PD40870b_lo0355'
$FILTER -pt $Project -st $Samples -pn $ControlProject -sn $ControlSample -o $DIR/FilteredCaveman/Filter_2019Feb19_d
#e
Project=$(printf '1959,%.0s' {1..26} | perl -ne 'chop $_;print"$_";')
ControlProject=$(printf '1959,%.0s' {1..26} | perl -ne 'chop $_;print"$_";')
ControlSample=$(printf 'PD40870b_lo0021,%.0s' {1..26} | perl -ne 'chop $_;print"$_";')
Samples='PD40870b_lo0356,PD40870b_lo0357,PD40870b_lo0358,PD40870b_lo0359,PD40870b_lo0360,PD40870b_lo0361,PD40870b_lo0362,PD40870b_lo0379,PD40870b_lo0380,PD40870b_lo0381,PD40870b_lo0382,PD40870b_lo0383,PD40870b_lo0384,PD40870b_lo0385,PD40870b_lo0386,PD40870b_lo0387,PD40870b_lo0388,PD40870b_lo0389,PD40870b_lo0391,PD40870b_lo0392,PD40870b_lo0393,PD40870b_lo0394,PD40870b_lo0397,PD40870b_lo0398,PD40870b_lo0400,PD40870b_lo0401'
$FILTER -pt $Project -st $Samples -pn $ControlProject -sn $ControlSample -o $DIR/FilteredCaveman/Filter_2019Feb19_e

############################
# Filtering on 04-Mar-2019 #
############################
grep -Fvf FilteredVcfPresent_4Mar2019 PD40870b_CavemanFinished_4Mar2019 | perl -ne 'chomp $_;print"$_,";'
#126 total - split into three batches of 42 each
DIR=/lustre/scratch119/casm/team176tv/sg18/Prostate
cd $DIR
Project=$(printf '1959,%.0s' {1..42} | perl -ne 'chop $_;print"$_";')
ControlProject=$(printf '1959,%.0s' {1..42} | perl -ne 'chop $_;print"$_";')
ControlSample=$(printf 'PD40870b_lo0021,%.0s' {1..42} | perl -ne 'chop $_;print"$_";')
FILTER=/lustre/scratch119/casm/team176tv/sg18/INSTALZ/WGS/FilteredCaveman/runLCMFiltering_by_sample_project_speedup.sh
#a
Samples='PD40870b_lo0129,PD40870b_lo0130,PD40870b_lo0133,PD40870b_lo0134,PD40870b_lo0135,PD40870b_lo0138,PD40870b_lo0139,PD40870b_lo0140,PD40870b_lo0144,PD40870b_lo0145,PD40870b_lo0160,PD40870b_lo0172,PD40870b_lo0198,PD40870b_lo0227,PD40870b_lo0228,PD40870b_lo0235,PD40870b_lo0302,PD40870b_lo0303,PD40870b_lo0304,PD40870b_lo0314,PD40870b_lo0328,PD40870b_lo0347,PD40870b_lo0395,PD40870b_lo0399,PD40870b_lo0402,PD40870b_lo0403,PD40870b_lo0405,PD40870b_lo0406,PD40870b_lo0407,PD40870b_lo0408,PD40870b_lo0409,PD40870b_lo0410,PD40870b_lo0411,PD40870b_lo0412,PD40870b_lo0413,PD40870b_lo0414,PD40870b_lo0415,PD40870b_lo0416,PD40870b_lo0417,PD40870b_lo0418,PD40870b_lo0419,PD40870b_lo0420'
$FILTER -pt $Project -st $Samples -pn $ControlProject -sn $ControlSample -o $DIR/FilteredCaveman/Filter_2019Mar04_a
#b
Samples='PD40870b_lo0421,PD40870b_lo0423,PD40870b_lo0424,PD40870b_lo0425,PD40870b_lo0426,PD40870b_lo0429,PD40870b_lo0430,PD40870b_lo0431,PD40870b_lo0432,PD40870b_lo0434,PD40870b_lo0435,PD40870b_lo0436,PD40870b_lo0437,PD40870b_lo0438,PD40870b_lo0439,PD40870b_lo0440,PD40870b_lo0441,PD40870b_lo0442,PD40870b_lo0443,PD40870b_lo0444,PD40870b_lo0445,PD40870b_lo0446,PD40870b_lo0447,PD40870b_lo0448,PD40870b_lo0449,PD40870b_lo0451,PD40870b_lo0457,PD40870b_lo0458,PD40870b_lo0459,PD40870b_lo0461,PD40870b_lo0462,PD40870b_lo0463,PD40870b_lo0464,PD40870b_lo0465,PD40870b_lo0466,PD40870b_lo0467,PD40870b_lo0468,PD40870b_lo0469,PD40870b_lo0470,PD40870b_lo0472,PD40870b_lo0473,PD40870b_lo0474'
$FILTER -pt $Project -st $Samples -pn $ControlProject -sn $ControlSample -o $DIR/FilteredCaveman/Filter_2019Mar04_b
#c
Samples='PD40870b_lo0475,PD40870b_lo0476,PD40870b_lo0477,PD40870b_lo0478,PD40870b_lo0479,PD40870b_lo0480,PD40870b_lo0482,PD40870b_lo0483,PD40870b_lo0484,PD40870b_lo0485,PD40870b_lo0487,PD40870b_lo0488,PD40870b_lo0489,PD40870b_lo0490,PD40870b_lo0491,PD40870b_lo0495,PD40870b_lo0496,PD40870b_lo0497,PD40870b_lo0498,PD40870b_lo0499,PD40870b_lo0500,PD40870b_lo0501,PD40870b_lo0502,PD40870b_lo0503,PD40870b_lo0504,PD40870b_lo0505,PD40870b_lo0507,PD40870b_lo0508,PD40870b_lo0509,PD40870b_lo0510,PD40870b_lo0511,PD40870b_lo0512,PD40870b_lo0513,PD40870b_lo0514,PD40870b_lo0515,PD40870b_lo0516,PD40870b_lo0517,PD40870b_lo0518,PD40870b_lo0519,PD40870b_lo0520,PD40870b_lo0521,PD40870b_lo0522'
$FILTER -pt $Project -st $Samples -pn $ControlProject -sn $ControlSample -o $DIR/FilteredCaveman/Filter_2019Mar04_c

##############################
# Filtering on 18 March 2019 #
##############################
#All samples from the main prostate now have a finished bam file.
#All samples (except the normal file) have a Caveman file marked as finished but due to the need for a rerun due to the sample management mistake, three samples cannot be filtered at the moment (404,418,428)
DIR=/lustre/scratch119/casm/team176tv/sg18/Prostate
cd $DIR
Project=$(printf '1959,%.0s' {1..20} | perl -ne 'chop $_;print"$_";')
ControlProject=$(printf '1959,%.0s' {1..20} | perl -ne 'chop $_;print"$_";')
ControlSample=$(printf 'PD40870b_lo0021,%.0s' {1..20} | perl -ne 'chop $_;print"$_";')
Samples='PD40870b_lo0380,PD40870b_lo0397,PD40870b_lo0398,PD40870b_lo0400,PD40870b_lo0401,PD40870b_lo0405,PD40870b_lo0419,PD40870b_lo0424,PD40870b_lo0426,PD40870b_lo0439,PD40870b_lo0450,PD40870b_lo0452,PD40870b_lo0453,PD40870b_lo0454,PD40870b_lo0455,PD40870b_lo0456,PD40870b_lo0460,PD40870b_lo0471,PD40870b_lo0481,PD40870b_lo0506'
FILTER=/lustre/scratch119/casm/team176tv/sg18/INSTALZ/WGS/FilteredCaveman/runLCMFiltering_by_sample_project_speedup.sh
$FILTER -pt $Project -st $Samples -pn $ControlProject -sn $ControlSample -o $DIR/FilteredCaveman/Filter_2019Mar18


########################################
# Filtering additional prostate donors #
########################################
DIR=/lustre/scratch119/casm/team176tv/sg18/Prostate
cd $DIR
Project=$(printf '1959,%.0s' {1..22} | perl -ne 'chop $_;print"$_";')
ControlProject=$(printf '1959,%.0s' {1..22} | perl -ne 'chop $_;print"$_";')
ControlSample=$(printf 'PD42298b_lo0031,%.0s' {1..22} | perl -ne 'chop $_;print"$_";')
Samples='PD42298b_lo0001,PD42298b_lo0002,PD42298b_lo0003,PD42298b_lo0004,PD42298b_lo0006,PD42298b_lo0007,PD42298b_lo0008,PD42298b_lo0015,PD42298b_lo0016,PD42298b_lo0018,PD42298b_lo0019,PD42298b_lo0020,PD42298b_lo0021,PD42298b_lo0022,PD42298b_lo0023,PD42298b_lo0024,PD42298b_lo0025,PD42298b_lo0026,PD42298b_lo0027,PD42298b_lo0028,PD42298b_lo0029,PD42298b_lo0030'
FILTER=/lustre/scratch119/casm/team176tv/sg18/INSTALZ/WGS/FilteredCaveman/runLCMFiltering_by_sample_project_speedup.sh
$FILTER -pt $Project -st $Samples -pn $ControlProject -sn $ControlSample -o $DIR/FilteredCaveman/Filter_PD42298_37Rakesh 
#22yr - 90
DIR=/lustre/scratch119/casm/team176tv/sg18/Prostate
cd $DIR
Project=$(printf '1959,%.0s' {1..32} | perl -ne 'chop $_;print"$_";')
ControlProject=$(printf '1959,%.0s' {1..32} | perl -ne 'chop $_;print"$_";')
ControlSample=$(printf 'PD43390b_lo0047,%.0s' {1..32} | perl -ne 'chop $_;print"$_";')
Samples='PD43390b_lo0003,PD43390b_lo0004,PD43390b_lo0006,PD43390b_lo0007,PD43390b_lo0008,PD43390b_lo0009,PD43390b_lo0010,PD43390b_lo0011,PD43390b_lo0013,PD43390b_lo0014,PD43390b_lo0016,PD43390b_lo0018,PD43390b_lo0019,PD43390b_lo0020,PD43390b_lo0021,PD43390b_lo0022,PD43390b_lo0023,PD43390b_lo0028,PD43390b_lo0029,PD43390b_lo0030,PD43390b_lo0032,PD43390b_lo0034,PD43390b_lo0035,PD43390b_lo0036,PD43390b_lo0037,PD43390b_lo0038,PD43390b_lo0039,PD43390b_lo0041,PD43390b_lo0042,PD43390b_lo0043,PD43390b_lo0044,PD43390b_lo0046'
FILTER=/lustre/scratch119/casm/team176tv/sg18/INSTALZ/WGS/FilteredCaveman/runLCMFiltering_by_sample_project_speedup.sh
$FILTER -pt $Project -st $Samples -pn $ControlProject -sn $ControlSample -o $DIR/FilteredCaveman/PD43390b_22Amsbio
#31yr - 91
DIR=/lustre/scratch119/casm/team176tv/sg18/Prostate
cd $DIR
Project=$(printf '1959,%.0s' {1..9} | perl -ne 'chop $_;print"$_";')
ControlProject=$(printf '1959,%.0s' {1..9} | perl -ne 'chop $_;print"$_";')
ControlSample=$(printf 'PD43391b_lo0002,%.0s' {1..9} | perl -ne 'chop $_;print"$_";')
Samples='PD43391b_lo0003,PD43391b_lo0005,PD43391b_lo0006,PD43391b_lo0009,PD43391b_lo0010,PD43391b_lo0011,PD43391b_lo0012,PD43391b_lo0013,PD43391b_lo0014'
FILTER=/lustre/scratch119/casm/team176tv/sg18/INSTALZ/WGS/FilteredCaveman/runLCMFiltering_by_sample_project_speedup.sh
$FILTER -pt $Project -st $Samples -pn $ControlProject -sn $ControlSample -o $DIR/FilteredCaveman/PD43391b_31Amsbio
#47 - 92
DIR=/lustre/scratch119/casm/team176tv/sg18/Prostate
cd $DIR
Project=$(printf '1959,%.0s' {1..2} | perl -ne 'chop $_;print"$_";')
ControlProject=$(printf '1959,%.0s' {1..2} | perl -ne 'chop $_;print"$_";')
ControlSample=$(printf 'PD43392b_lo0011,%.0s' {1..2} | perl -ne 'chop $_;print"$_";')
Samples='PD43392b_lo0005,PD43392b_lo0008' #sample PD43392b_lo0007 constantly re-enters Caveman and never gets finished
FILTER=/lustre/scratch119/casm/team176tv/sg18/INSTALZ/WGS/FilteredCaveman/runLCMFiltering_by_sample_project_speedup.sh
$FILTER -pt $Project -st $Samples -pn $ControlProject -sn $ControlSample -o $DIR/FilteredCaveman/PD43392b_47Amsbio
#71 - 93
DIR=/lustre/scratch119/casm/team176tv/sg18/Prostate
cd $DIR
Project=$(printf '1959,%.0s' {1..9} | perl -ne 'chop $_;print"$_";')
ControlProject=$(printf '1959,%.0s' {1..9} | perl -ne 'chop $_;print"$_";')
ControlSample=$(printf 'PD43393b_lo0001,%.0s' {1..9} | perl -ne 'chop $_;print"$_";')
Samples='PD43393b_lo0002,PD43393b_lo0003,PD43393b_lo0004,PD43393b_lo0005,PD43393b_lo0006,PD43393b_lo0007,PD43393b_lo0008,PD43393b_lo0009,PD43393b_lo0010'
FILTER=/lustre/scratch119/casm/team176tv/sg18/INSTALZ/WGS/FilteredCaveman/runLCMFiltering_by_sample_project_speedup.sh
$FILTER -pt $Project -st $Samples -pn $ControlProject -sn $ControlSample -o $DIR/FilteredCaveman/PD43393b_71Amsbio
#warm autopsy
DIR=/lustre/scratch119/casm/team176tv/sg18/Prostate
cd $DIR
Project=$(printf '1589,%.0s' {1..17} | perl -ne 'chop $_;print"$_";')
ControlProject=$(printf '1349,%.0s' {1..17} | perl -ne 'chop $_;print"$_";')
ControlSample=$(printf 'PD28690g,%.0s' {1..17} | perl -ne 'chop $_;print"$_";')
Samples='PD28690fd_PA_1_A10,PD28690fd_PA_1_A11,PD28690fd_PA_1_A1,PD28690fd_PA_1_A2,PD28690fd_PA_1_A3,PD28690fd_PA_1_A6,PD28690fd_PA_1_A8,PD28690fd_PA_1_C11,PD28690fd_PA_1_C2,PD28690fd_PA_1_C3,PD28690fd_PA_1_C5,PD28690fd_PA_1_C6,PD28690fd_PA_1_C9,PD28690fd_PA_1_E10,PD28690fd_PA_1_E12,PD28690fd_PA_1_G10,PD28690fd_PA_1_G11'
FILTER=/lustre/scratch119/casm/team176tv/sg18/INSTALZ/WGS/FilteredCaveman/runLCMFiltering_by_sample_project_speedup.sh
$FILTER -pt $Project -st $Samples -pn $ControlProject -sn $ControlSample -o $DIR/FilteredCaveman/PD28690_WarmAutopsy
#additional 59yr
DIR=/lustre/scratch119/casm/team176tv/sg18/Prostate
cd $DIR
Project=$(printf '1828,%.0s' {1..5} | perl -ne 'chop $_;print"$_";')
ControlProject=$(printf '1828,%.0s' {1..5} | perl -ne 'chop $_;print"$_";')
ControlSample=$(printf 'PD37885b_PROSTATE_3_A5,%.0s' {1..5} | perl -ne 'chop $_;print"$_";')
Samples='PD37885b_PROSTATE_3_A4,PD37885b_PROSTATE_3_C4,PD37885b_PROSTATE_3_D2,PD37885b_PROSTATE_3_E4,PD37885b_PROSTATE_3_G4'
FILTER=/lustre/scratch119/casm/team176tv/sg18/INSTALZ/WGS/FilteredCaveman/runLCMFiltering_by_sample_project_speedup.sh
$FILTER -pt $Project -st $Samples -pn $ControlProject -sn $ControlSample -o $DIR/FilteredCaveman/PD37885_Luiza59



#################################
# Filtering Structural Variants #
#################################
#Rakesh 42298
cd /nfs/cancer_ref01/nst_links/live/1959
DIR=/lustre/scratch119/casm/team176tv/sg18/Prostate/SVFilter
out=$DIR/PD42298
tpon=$out/pon.txt
Project=$(printf '1959,%.0s' {1..22} | perl -ne 'chop $_;print"$_";')
ControlProject=$(printf '1959,%.0s' {1..22} | perl -ne 'chop $_;print"$_";')
ControlSample=$(printf 'PD42298b_lo0031,%.0s' {1..22} | perl -ne 'chop $_;print"$_";')
Samples='PD42298b_lo0001,PD42298b_lo0002,PD42298b_lo0003,PD42298b_lo0004,PD42298b_lo0006,PD42298b_lo0007,PD42298b_lo0008,PD42298b_lo0015,PD42298b_lo0016,PD42298b_lo0018,PD42298b_lo0019,PD42298b_lo0020,PD42298b_lo0021,PD42298b_lo0022,PD42298b_lo0023,PD42298b_lo0024,PD42298b_lo0025,PD42298b_lo0026,PD42298b_lo0027,PD42298b_lo0028,PD42298b_lo0029,PD42298b_lo0030'
FILTER=/lustre/scratch116/casm/cgp/users/ms44/scripts/runAnnotateBRASS_v3.sh
$FILTER -pt $Project -st $Samples -pn $ControlProject -sn $ControlSample -o $out -t 10 -tpon $tpon
#22yr - 90
cd /nfs/cancer_ref01/nst_links/live/1959
DIR=/lustre/scratch119/casm/team176tv/sg18/Prostate/SVFilter
out=$DIR/PD43390
tpon=$out/pon.txt
Project=$(printf '1959,%.0s' {1..32} | perl -ne 'chop $_;print"$_";')
ControlProject=$(printf '1959,%.0s' {1..32} | perl -ne 'chop $_;print"$_";')
ControlSample=$(printf 'PD43390b_lo0047,%.0s' {1..32} | perl -ne 'chop $_;print"$_";')
Samples='PD43390b_lo0003,PD43390b_lo0004,PD43390b_lo0006,PD43390b_lo0007,PD43390b_lo0008,PD43390b_lo0009,PD43390b_lo0010,PD43390b_lo0011,PD43390b_lo0013,PD43390b_lo0014,PD43390b_lo0016,PD43390b_lo0018,PD43390b_lo0019,PD43390b_lo0020,PD43390b_lo0021,PD43390b_lo0022,PD43390b_lo0023,PD43390b_lo0028,PD43390b_lo0029,PD43390b_lo0030,PD43390b_lo0032,PD43390b_lo0034,PD43390b_lo0035,PD43390b_lo0036,PD43390b_lo0037,PD43390b_lo0038,PD43390b_lo0039,PD43390b_lo0041,PD43390b_lo0042,PD43390b_lo0043,PD43390b_lo0044,PD43390b_lo0046'
FILTER=$DIR/runAnnotateBRASS_v3.sh #contains adjustment for more polyclonal sample
$FILTER -pt $Project -st $Samples -pn $ControlProject -sn $ControlSample -o $out -t 10 -tpon $tpon
#31yr - 91
cd /nfs/cancer_ref01/nst_links/live/1959
DIR=/lustre/scratch119/casm/team176tv/sg18/Prostate/SVFilter
out=$DIR/PD43391
tpon=$out/pon.txt
Project=$(printf '1959,%.0s' {1..9} | perl -ne 'chop $_;print"$_";')
ControlProject=$(printf '1959,%.0s' {1..9} | perl -ne 'chop $_;print"$_";')
ControlSample=$(printf 'PD43391b_lo0002,%.0s' {1..9} | perl -ne 'chop $_;print"$_";')
Samples='PD43391b_lo0003,PD43391b_lo0005,PD43391b_lo0006,PD43391b_lo0009,PD43391b_lo0010,PD43391b_lo0011,PD43391b_lo0012,PD43391b_lo0013,PD43391b_lo0014'
FILTER=$DIR/runAnnotateBRASS_v3.sh #contains adjustment for more polyclonal sample
$FILTER -pt $Project -st $Samples -pn $ControlProject -sn $ControlSample -o $out -t 10 -tpon $tpon
#47 - 92
cd /nfs/cancer_ref01/nst_links/live/1959
DIR=/lustre/scratch119/casm/team176tv/sg18/Prostate/SVFilter
out=$DIR/PD43392
tpon=$out/pon.txt
Project=$(printf '1959,%.0s' {1..2} | perl -ne 'chop $_;print"$_";')
ControlProject=$(printf '1959,%.0s' {1..2} | perl -ne 'chop $_;print"$_";')
ControlSample=$(printf 'PD43392b_lo0011,%.0s' {1..2} | perl -ne 'chop $_;print"$_";')
Samples='PD43392b_lo0005,PD43392b_lo0008' #sample PD43392b_lo0007 constantly re-enters Caveman and never gets finished
FILTER=$DIR/runAnnotateBRASS_v3.sh #contains adjustment for more polyclonal sample
$FILTER -pt $Project -st $Samples -pn $ControlProject -sn $ControlSample -o $out -t 10 -tpon $tpon
#71 - 93
cd /nfs/cancer_ref01/nst_links/live/1959
DIR=/lustre/scratch119/casm/team176tv/sg18/Prostate/SVFilter
out=$DIR/PD43393
tpon=$out/pon.txt
Project=$(printf '1959,%.0s' {1..9} | perl -ne 'chop $_;print"$_";')
ControlProject=$(printf '1959,%.0s' {1..9} | perl -ne 'chop $_;print"$_";')
ControlSample=$(printf 'PD43393b_lo0001,%.0s' {1..9} | perl -ne 'chop $_;print"$_";')
Samples='PD43393b_lo0002,PD43393b_lo0003,PD43393b_lo0004,PD43393b_lo0005,PD43393b_lo0006,PD43393b_lo0007,PD43393b_lo0008,PD43393b_lo0009,PD43393b_lo0010'
FILTER=$DIR/runAnnotateBRASS_v3.sh #contains adjustment for more polyclonal sample
$FILTER -pt $Project -st $Samples -pn $ControlProject -sn $ControlSample -o $out -t 10 -tpon $tpon
#Main Donor - Remaining Samples
cd /nfs/cancer_ref01/nst_links/live/1959
DIR=/lustre/scratch119/casm/team176tv/sg18/Prostate/SVFilter
out=$DIR/Structure1
tpon=$out/pon.txt
Project=$(printf '1959,%.0s' {1..264} | perl -ne 'chop $_;print"$_";')
ControlProject=$(printf '1959,%.0s' {1..264} | perl -ne 'chop $_;print"$_";')
ControlSample=$(printf 'PD40870b_lo0021,%.0s' {1..264} | perl -ne 'chop $_;print"$_";')
Samples=PD40870b_lo0001,PD40870b_lo0002,PD40870b_lo0003,PD40870b_lo0004,PD40870b_lo0005,PD40870b_lo0006,PD40870b_lo0007,PD40870b_lo0025,PD40870b_lo0026,PD40870b_lo0027,PD40870b_lo0029,PD40870b_lo0030,PD40870b_lo0031,PD40870b_lo0033,PD40870b_lo0034,PD40870b_lo0035,PD40870b_lo0036,PD40870b_lo0037,PD40870b_lo0038,PD40870b_lo0039,PD40870b_lo0040,PD40870b_lo0041,PD40870b_lo0042,,PD40870b_lo0043,PD40870b_lo0045,PD40870b_lo0047,PD40870b_lo0048,PD40870b_lo0050,PD40870b_lo0051,PD40870b_lo0052,PD40870b_lo0054,PD40870b_lo0055,PD40870b_lo0056,PD40870b_lo0057,PD40870b_lo0058,PD40870b_lo0059,PD40870b_lo0060,PD40870b_lo0061,PD40870b_lo0063,PD40870b_lo0065,PD40870b_lo0066,PD40870b_lo0067,PD40870b_lo0068,PD40870b_lo0069,PD40870b_lo0070,PD40870b_lo0071,PD40870b_lo0073,PD40870b_lo0075,PD40870b_lo0076,PD40870b_lo0077,PD40870b_lo0078,PD40870b_lo0079,PD40870b_lo0080,PD40870b_lo0082,PD40870b_lo0083,PD40870b_lo0084,PD40870b_lo0089,PD40870b_lo0090,PD40870b_lo0091,PD40870b_lo0092,PD40870b_lo0093,PD40870b_lo0094,PD40870b_lo0095,PD40870b_lo0098,PD40870b_lo0099,PD40870b_lo0102,PD40870b_lo0103,PD40870b_lo0104,PD40870b_lo0106,PD40870b_lo0108,PD40870b_lo0109,PD40870b_lo0110,PD40870b_lo0111,PD40870b_lo0112,PD40870b_lo0113,PD40870b_lo0114,PD40870b_lo0115,PD40870b_lo0117,PD40870b_lo0119,PD40870b_lo0120,PD40870b_lo0121,PD40870b_lo0122,PD40870b_lo0123,PD40870b_lo0125,PD40870b_lo0126,PD40870b_lo0127,PD40870b_lo0128,PD40870b_lo0129,PD40870b_lo0130,PD40870b_lo0133,PD40870b_lo0134,PD40870b_lo0135,PD40870b_lo0138,PD40870b_lo0139,PD40870b_lo0140,PD40870b_lo0144,PD40870b_lo0145,PD40870b_lo0149,PD40870b_lo0151,PD40870b_lo0152,PD40870b_lo0153,PD40870b_lo0154,PD40870b_lo0155,PD40870b_lo0157,PD40870b_lo0160,PD40870b_lo0161,PD40870b_lo0162,PD40870b_lo0164,PD40870b_lo0165,PD40870b_lo0166,PD40870b_lo0170,PD40870b_lo0172,PD40870b_lo0173,PD40870b_lo0174,PD40870b_lo0175,PD40870b_lo0177,PD40870b_lo0179,PD40870b_lo0181,PD40870b_lo0184,PD40870b_lo0185,PD40870b_lo0186,PD40870b_lo0188,PD40870b_lo0189,PD40870b_lo0190,PD40870b_lo0191,PD40870b_lo0192,PD40870b_lo0193,PD40870b_lo0194,PD40870b_lo0195,PD40870b_lo0198,PD40870b_lo0200,PD40870b_lo0202,PD40870b_lo0203,PD40870b_lo0204,PD40870b_lo0206,PD40870b_lo0222,PD40870b_lo0223,PD40870b_lo0224,PD40870b_lo0225,PD40870b_lo0226,PD40870b_lo0227,PD40870b_lo0228,PD40870b_lo0229,PD40870b_lo0230,PD40870b_lo0231,PD40870b_lo0232,PD40870b_lo0233,PD40870b_lo0234,PD40870b_lo0235,PD40870b_lo0236,PD40870b_lo0237,PD40870b_lo0239,PD40870b_lo0240,PD40870b_lo0241,PD40870b_lo0242,PD40870b_lo0243,PD40870b_lo0244,PD40870b_lo0245,PD40870b_lo0246,PD40870b_lo0247,PD40870b_lo0248,PD40870b_lo0249,PD40870b_lo0250,PD40870b_lo0251,PD40870b_lo0253,PD40870b_lo0254,PD40870b_lo0255,PD40870b_lo0256,PD40870b_lo0257,PD40870b_lo0258,PD40870b_lo0259,PD40870b_lo0260,PD40870b_lo0261,PD40870b_lo0262,PD40870b_lo0263,PD40870b_lo0264,PD40870b_lo0265,PD40870b_lo0266,PD40870b_lo0267,PD40870b_lo0268,PD40870b_lo0269,PD40870b_lo0271,PD40870b_lo0272,PD40870b_lo0273,PD40870b_lo0274,PD40870b_lo0275,PD40870b_lo0276,PD40870b_lo0277,PD40870b_lo0278,PD40870b_lo0285,PD40870b_lo0289,PD40870b_lo0296,PD40870b_lo0298,PD40870b_lo0299,PD40870b_lo0300,PD40870b_lo0307,PD40870b_lo0314,PD40870b_lo0315,PD40870b_lo0316,PD40870b_lo0317,PD40870b_lo0318,PD40870b_lo0319,PD40870b_lo0320,PD40870b_lo0321,PD40870b_lo0322,PD40870b_lo0323,PD40870b_lo0324,PD40870b_lo0325,PD40870b_lo0327,PD40870b_lo0328,PD40870b_lo0329,PD40870b_lo0330,PD40870b_lo0331,PD40870b_lo0332,PD40870b_lo0333,PD40870b_lo0334,PD40870b_lo0335,PD40870b_lo0336,PD40870b_lo0357,PD40870b_lo0358,PD40870b_lo0359,PD40870b_lo0360,PD40870b_lo0361,PD40870b_lo0362,PD40870b_lo0383,PD40870b_lo0400,PD40870b_lo0407,PD40870b_lo0409,PD40870b_lo0410,PD40870b_lo0412,PD40870b_lo0413,PD40870b_lo0414,PD40870b_lo0418,PD40870b_lo0419,PD40870b_lo0420,PD40870b_lo0423,PD40870b_lo0425,PD40870b_lo0442,PD40870b_lo0446,PD40870b_lo0447,PD40870b_lo0466,PD40870b_lo0467,PD40870b_lo0468,PD40870b_lo0471,PD40870b_lo0476,PD40870b_lo0477,PD40870b_lo0478,PD40870b_lo0479,PD40870b_lo0480,PD40870b_lo0481,PD40870b_lo0482,PD40870b_lo0483,PD40870b_lo0484,PD40870b_lo0485,PD40870b_lo0499,PD40870b_lo0501,PD40870b_lo0503,PD40870b_lo0506,PD40870b_lo0509,PD40870b_lo0516,PD40870b_lo0518,PD40870b_lo0519,PD40870b_lo0521
FILTER=$DIR/runAnnotateBRASS_v3.sh #contains adjustment for more polyclonal sample
$FILTER -pt $Project -st $Samples -pn $ControlProject -sn $ControlSample -o $out -t 10 -tpon $tpon
#Structure3
cd /nfs/cancer_ref01/nst_links/live/1959
DIR=/lustre/scratch119/casm/team176tv/sg18/Prostate/SVFilter
out=$DIR/Structure3
tpon=$out/pon.txt
Project=$(printf '1959,%.0s' {1..80} | perl -ne 'chop $_;print"$_";')
ControlProject=$(printf '1959,%.0s' {1..80} | perl -ne 'chop $_;print"$_";')
ControlSample=$(printf 'PD40870b_lo0021,%.0s' {1..80} | perl -ne 'chop $_;print"$_";')
Samples='PD40870b_lo0009,PD40870b_lo0010,PD40870b_lo0011,PD40870b_lo0012,PD40870b_lo0013,PD40870b_lo0014,PD40870b_lo0015,PD40870b_lo0016,PD40870b_lo0017,PD40870b_lo0018,PD40870b_lo0019,PD40870b_lo0020,PD40870b_lo0022,PD40870b_lo0023,PD40870b_lo0024,PD40870b_lo0281,PD40870b_lo0283,PD40870b_lo0286,PD40870b_lo0287,PD40870b_lo0288,PD40870b_lo0290,PD40870b_lo0293,PD40870b_lo0294,PD40870b_lo0301,PD40870b_lo0302,PD40870b_lo0303,PD40870b_lo0304,PD40870b_lo0305,PD40870b_lo0306,PD40870b_lo0308,PD40870b_lo0309,PD40870b_lo0310,PD40870b_lo0311,PD40870b_lo0312,PD40870b_lo0313,PD40870b_lo0339,PD40870b_lo0340,PD40870b_lo0342,PD40870b_lo0343,PD40870b_lo0344,PD40870b_lo0345,PD40870b_lo0346,PD40870b_lo0347,PD40870b_lo0348,PD40870b_lo0349,PD40870b_lo0350,PD40870b_lo0351,PD40870b_lo0352,PD40870b_lo0353,PD40870b_lo0354,PD40870b_lo0355,PD40870b_lo0356,PD40870b_lo0441,PD40870b_lo0443,PD40870b_lo0444,PD40870b_lo0445,PD40870b_lo0448,PD40870b_lo0449,PD40870b_lo0450,PD40870b_lo0451,PD40870b_lo0452,PD40870b_lo0453,PD40870b_lo0454,PD40870b_lo0455,PD40870b_lo0456,PD40870b_lo0457,PD40870b_lo0458,PD40870b_lo0459,PD40870b_lo0460,PD40870b_lo0461,PD40870b_lo0462,PD40870b_lo0463,PD40870b_lo0464,PD40870b_lo0465,PD40870b_lo0469,PD40870b_lo0470,PD40870b_lo0472,PD40870b_lo0473,PD40870b_lo0474,PD40870b_lo0475'
FILTER=$DIR/runAnnotateBRASS_v3.sh #contains adjustment for more polyclonal sample
$FILTER -pt $Project -st $Samples -pn $ControlProject -sn $ControlSample -o $out -t 10 -tpon $tpon

#Structure4
cd /nfs/cancer_ref01/nst_links/live/1959
DIR=/lustre/scratch119/casm/team176tv/sg18/Prostate/SVFilter
out=$DIR/Structure4
tpon=$out/pon.txt
Project=$(printf '1959,%.0s' {1..70} | perl -ne 'chop $_;print"$_";')
ControlProject=$(printf '1959,%.0s' {1..70} | perl -ne 'chop $_;print"$_";')
ControlSample=$(printf 'PD40870b_lo0021,%.0s' {1..70} | perl -ne 'chop $_;print"$_";')
Samples=PD40870b_lo0337,PD40870b_lo0338,PD40870b_lo0379,PD40870b_lo0380,PD40870b_lo0381,PD40870b_lo0382,PD40870b_lo0384,PD40870b_lo0385,PD40870b_lo0386,PD40870b_lo0387,PD40870b_lo0388,PD40870b_lo0389,PD40870b_lo0391,PD40870b_lo0392,PD40870b_lo0393,PD40870b_lo0394,PD40870b_lo0395,PD40870b_lo0397,PD40870b_lo0398,PD40870b_lo0399,PD40870b_lo0401,PD40870b_lo0402,PD40870b_lo0403,PD40870b_lo0404,PD40870b_lo0405,PD40870b_lo0406,PD40870b_lo0408,PD40870b_lo0411,PD40870b_lo0415,PD40870b_lo0416,PD40870b_lo0417,PD40870b_lo0421,PD40870b_lo0424,PD40870b_lo0426,PD40870b_lo0428,PD40870b_lo0429,PD40870b_lo0430,PD40870b_lo0431,PD40870b_lo0432,PD40870b_lo0434,PD40870b_lo0435,PD40870b_lo0436,PD40870b_lo0437,PD40870b_lo0438,PD40870b_lo0439,PD40870b_lo0440,PD40870b_lo0487,PD40870b_lo0488,PD40870b_lo0489,PD40870b_lo0490,PD40870b_lo0491,PD40870b_lo0495,PD40870b_lo0496,PD40870b_lo0497,PD40870b_lo0498,PD40870b_lo0500,PD40870b_lo0502,PD40870b_lo0504,PD40870b_lo0505,PD40870b_lo0507,PD40870b_lo0508,PD40870b_lo0510,PD40870b_lo0511,PD40870b_lo0512,PD40870b_lo0513,PD40870b_lo0514,PD40870b_lo0515,PD40870b_lo0517,PD40870b_lo0520,PD40870b_lo0522
FILTER=$DIR/runAnnotateBRASS_v3.sh #contains adjustment for more polyclonal sample
$FILTER -pt $Project -st $Samples -pn $ControlProject -sn $ControlSample -o $out -t 10 -tpon $tpon

