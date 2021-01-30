######################################################
# Create alt and depth file for dirichlet clustering #
######################################################
#Format as examples in Stan's email from 05-Apr-2019. Ordering of columns is different between depth and alt output file
library(stringr)
for(Structure in c( 'Structure3')){ #'ManuallyTracedTree_Right', 'Structure4', 'SecondUrethralStructure',, 'Structure1', 'FirstUrethralStructure'
  dirpath = paste0("/lustre/scratch119/casm/team176tv/sg18/Prostate/ResultsSortedByMorphologicalStructure/",Structure) #added the last bit to fix structure3
  allFiles <- list.files(path=paste0(dirpath,"/ASEQ/"), pattern='.PILEUP.ASEQ', all.files=T, full.names=T)
  #merge all corresponding files
  Depth <- data.frame(chrom = NA,pos = NA,ref = NA,alt = NA)
  Alt <- data.frame(chrom = NA,pos = NA,ref = NA,alt = NA)
  for(file in allFiles){
    curr <- read.table(file = file, header = T)
    curr$AltReads <- as.integer(curr$cov * curr$af + 0.5)
    smplname <- str_match(file,"PD40870b_lo[0-9]+")[1]
    newdepth <- curr[,c('chr','pos','ref','alt', 'cov')]
    colnames(newdepth) <- c('chrom','pos','ref','alt',smplname)
    newalt <- curr[,c('chr','pos','ref','alt', 'AltReads')]
    colnames(newalt) <- c('chrom','pos','ref','alt',smplname)
    Depth <- merge(x = Depth, y = newdepth,
                   all = T, by = c('chrom','pos','ref','alt')
    )
    Alt <- merge(x = Alt, y = newalt,
                 all = T, by = c('chrom','pos','ref','alt')
    )
  }
  #clean the initial NA line from both data.frames and all remaining NAs
  Depth <- Depth[rowSums(is.na(Depth)) != ncol(Depth), ]
  Alt <- Alt[rowSums(is.na(Alt)) != ncol(Alt), ]
  Depth[is.na(Depth)] <- 0
  Alt[is.na(Alt)] <- 0
  #create additional columns and order columns according to Stan's example - depth can stay as is, alt need to be reordered [not matching each other anymore but matching the example]
  Depth$coord_id <- paste0(Depth$chrom,"_",Depth$pos)
  Depth$mut_id <- paste0(Depth$coord_id,"_",Depth$ref,"_",Depth$alt)
  Alt$coord_id <- paste0(Alt$chrom,"_",Alt$pos)
  Alt$mut_id <- paste0(Alt$coord_id,"_",Alt$ref,"_",Alt$alt)
  Alt <- Alt[,c( 1,2,3,4,(ncol(Alt)-1),ncol(Alt),5:(ncol(Alt)-2) )]
  #write output
  write.table(x = Depth, file = paste0(dirpath,"/target_depth.csv"), quote = F,
              col.names = T, row.names = F, sep = ",")
  write.table(x = Alt, file = paste0(dirpath,"/alt_depth.csv"), quote = F,
              col.names = T, row.names = F, sep = ",")
}

###
#additional filtering for strucutre3 [excl high dbSNP] and structure 4 before very long clustering
#after the reading loop and   Depth <- Depth[rowSums(is.na(Depth)) != ncol(Depth), ]
#Alt <- Alt[rowSums(is.na(Alt)) != ncol(Alt), ]
#Depth[is.na(Depth)] <- 0
#Alt[is.na(Alt)] <- 0
cntNonZero<- apply(Alt[,c(5:92)], 1, function(x) sum(x > 0))
keep <- union(which(rowSums(Alt[,c(5:92)])>=5),which(cntNonZero>=2)) #at least one sample with 5 alt reads or alt reads detected in at least two samples
Depth <- Depth[keep,]
Alt <- Alt[keep,]
#then normal renaming and ordering of columns as well as saving as above
#quickly restricting the old mut contexts to the new positions #no of mut contexts line is never the same as full table
mutcon <- read.table(file = "mut_contexts.tsv", header = T)
colnames(mutcon)
keepme <- Alt[,c(1:4)]
mutcon <- merge(mutcon,keepme,by=c('chrom','pos','ref','alt'))
write.table(mutcon, file = paste0(dirpath,'/mut_contexts.tsv'),
            row.names = F, col.names = T, quote = F, sep = "\t")

#####################################
# Create shared VAF mutation matrix #
#####################################
library(stringr)
#Change paths in following line - can take a while for structures with a lot of cuts
dirpath = "/Users/sg18/volumes/sshfs_mnt/team176space/Prostate/ResultsSortedByMorphologicalStructure/Structure4/ASEQ/"
allFiles <- list.files(path=dirpath, pattern='.PILEUP.ASEQ', all.files=T, full.names=T)
Collect <- data.frame(chr = NA,pos = NA,ref = NA,alt = NA)
for(file in allFiles){
  curr <- read.table(file = file, header = T)
  curr <- curr[,c(1,2,5,6,16)]
  smplname <- str_match(file,"PD40870b_lo[0-9]+")[1]
  colnames(curr) <- c(colnames(curr)[1:4],smplname)
  Collect <- merge(x = Collect, y = curr,
                   all = T, by = c('chr','pos','ref','alt')
                   )
}
write.table(Collect, file = paste0(dirpath,"FullMutationMatrix.tsv"),
            sep = "\t", quote = F,
            col.names = T, row.names = F)
####################################################
# Read in shared matrices and build inital heatmap #
####################################################
library(pheatmap)
dirpath = "/lustre/scratch119/casm/team176tv/sg18/Prostate/ResultsSortedByMorphologicalStructure/"
args = commandArgs(trailingOnly = TRUE)
subdir=as.character(args[1])
CurrMatrix <- read.table(file = paste0(dirpath,subdir,"/ASEQ/FullMutationMatrix.tsv"),
                         header = T)
length(which(is.na(CurrMatrix)))
ind <- apply(CurrMatrix, 1, function(x) all(is.na(x)))
CurrMatrix <- CurrMatrix[ !ind, ] #removes the with all NAs
length(which(is.na(CurrMatrix)))
CurrMatrix <- na.omit(CurrMatrix) #removes all rows with NAs (usually a very low number)
# CurrMatrix[is.na(CurrMatrix)] <- 0 #sets the remaining NAs to 0
CurrMatrix_Numbers <- CurrMatrix[,c(5:ncol(CurrMatrix))]

pdf(file = paste0(dirpath,subdir,"/RHeatmaps.pdf"))
#FullHeatmap
pheatmap(CurrMatrix_Numbers)
#Sharedness of at least 0.1 between two cells
SharedMutsRowNo <- c()
for(row in c(1:dim(CurrMatrix_Numbers)[1])){
  if( length(which(CurrMatrix_Numbers[row,] >= 0.1)) > 1){
    SharedMutsRowNo <- append(SharedMutsRowNo, row)
  }
}
pheatmap(Shared_FirstUrethral[SharedMutsRowNo,])
#Sharedness of at least 0.25 of at least two cells
SharedMutsRowNo <- c()
for(row in c(1:dim(CurrMatrix)[1])){
  if( length(which(CurrMatrix[row,] >= 0.25)) > 1){
    SharedMutsRowNo <- append(SharedMutsRowNo, row)
  }
}
pheatmap(Shared_FirstUrethral[SharedMutsRowNo,])
dev.off()
