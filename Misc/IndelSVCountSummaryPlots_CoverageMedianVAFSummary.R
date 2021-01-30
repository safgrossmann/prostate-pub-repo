library(ggplot2)
library(gridExtra)
library(stringr)
#Two boxplots - one for indels and one for CNVs & SVs

#load SV & CNV data
SV <- read.table(file = "/Users/sg18/volumes/sshfs_mnt/team176space/Prostate/SummaryLists/SVCounts_Combined",
                 col.names = c('Donor','Sample','SVCount'))
CNV <- read.table(file = "/Users/sg18/volumes/sshfs_mnt/team176space/Prostate/SummaryLists/CNVCounts_Combined",
                  header = T)
CNV$Donor <- str_match(CNV$Sample,"PD[0-9]+")[,1]
Comb_SV_CNV <- merge(SV, CNV, by = c('Donor','Sample'), all = T)
Comb_SV_CNV$SVCount[is.na(Comb_SV_CNV$SVCount)] <- 0
Comb_SV_CNV$Comb <- Comb_SV_CNV$SVCount + Comb_SV_CNV$CNVCount
#ggplot
ggplot(Comb_SV_CNV, aes(x = Donor, y = Comb, fill = Donor)) + geom_boxplot() + theme_bw() + ylab('CNV and SV Count') + xlab('')

#load indel data
indel <- read.table(file = "/Users/sg18/volumes/sshfs_mnt/team176space/Prostate/SummaryLists/IndelCount_Summary.tsv",
                    col.names = c('Donor','Sample','IndelCount'))

Comb_Total <- merge(Comb_SV_CNV,indel)
Comb_Total$Donor_Order <- factor(Comb_Total$Donor, levels = c("PD43390","PD43391","PD43392","PD37885","PD40870","PD42298","PD43393","PD28690"))



p1 <- ggplot(Comb_Total, aes(x = Donor_Order, y = IndelCount, fill = Donor_Order)) +
  geom_boxplot(outlier.shape = NA, alpha = 0.8) + geom_jitter(color = "black", shape = 1, size = 1.25, width = 0.25) +
  theme_bw() + ylab('Indel Count') + xlab('') + theme(legend.position = "none") +
  theme(axis.text.x = element_text(angle = 45, hjust = 0.9))
p2 <- ggplot(Comb_Total, aes(x = Donor_Order, y = Comb, fill = Donor_Order)) + 
  geom_boxplot(outlier.shape = NA, alpha = 0.8) + geom_jitter(color = "black", shape = 1, size = 1.25, width = 0.25) +
  theme_bw() + ylab('CNV and SV Count') + xlab('') +
  theme(axis.text.x = element_text(angle = 45, hjust = 0.9))
pdf(file= "/Users/sg18/Documents/PhD/Prostate_Documents/PaperFigures/ChangedAfterPetersFirstReview/IndelSVCount.pdf",
    width = 8.27, height = 11.69/2.5)
grid.arrange(p1,p2,nrow = 1, layout_matrix = rbind(c(1,1,1,1,2,2,2,2,2)))
dev.off()




#### Coverage and VAF Histogram Plots
Coverage <- read.table(file = "/Users/sg18/volumes/sshfs_mnt/team176space/Prostate/DepthSummaryFromCannaps.txt",
                       header = T)
#one sample with 0 coverage? remove 
Coverage <- Coverage[which(Coverage$Coverage>=1),]

Full <- read.table("/Users/sg18/Documents/PhD/PhdThesis/Figures_Data_Prostate/PD40870_AllSectionsMetadataForRegressions.tsv",
                   sep="\t",header = T)
p1 <- ggplot(Coverage, aes(x=Coverage)) + geom_histogram(fill = 'darkgray', color = 'black', binwidth = 2.5) +
  theme_bw() + ylab("Count") + xlab("Mean Genome Coverage")

p2 <- ggplot(Full, aes(x=vaf)) + geom_histogram(fill = 'darkgray', color = 'black', binwidth = 0.05) +
  theme_bw() + ylab("Count") + xlab('Median VAF') + xlim(c(0.1,0.5))
pdf(file = "/Users/sg18/Documents/PhD/Prostate_Documents/PaperFigures/CoverageAndMedianVafHistograms",
    width = 8.27/2, height = 11.69/4)
grid.arrange(p1,p2,ncol=2)
dev.off()

### Minimum fraction covered 10x/20x/30x
#Load depth files
dir <- "/Users/sg18/volumes/sshfs_mnt/team176space/Prostate/DepthCounts/"
#files <- list.files(path = dir, pattern = ".uniq")
#Collect <- data.frame(Sample = rep(NA,415), Min10 = rep(NA,415), Min20 = rep(NA,415), Min30 = rep(NA,415))
#helper = 1
#for(file in files){
#  tbl <- read.table(file = paste0(dir,file),
#                    col.names = c("count","depth"), sep = " ")
#  Collect[helper,"Sample"] <- str_match(file, "PD[0-9]+b_lo[0-9]+")[1]
#  Collect[helper,"Min10"] <- sum(tbl$count[which(tbl$depth>=10)]) / 249250621
#  Collect[helper,"Min20"] <- sum(tbl$count[which(tbl$depth>=20)]) / 249250621
#  Collect[helper,"Min30"] <- sum(tbl$count[which(tbl$depth>=30)]) / 249250621
#  helper = helper + 1
#}
#write.table(Collect, file = paste0(dir,"Fraction10x20x30x.tsv"),
#            col.names = T, row.names = F, sep = "\t", quote = F)
tbl <- read.table(file = paste0(dir,"Fraction10x20x30x.tsv"),
                  header = T)
tbl <- tbl[which(tbl$Min10 >0.0001),]
min10 <- ggplot(tbl, aes(x=Min10)) + geom_histogram(fill = 'darkgray', color = 'black', binwidth = 0.05) +
  theme_bw() + ylab("Count") + xlab("Genome Fraction Covered >= 10x") +
  xlim(c(0,1))+ ylim(c(0,350))
min20 <- ggplot(tbl, aes(x=Min20)) + geom_histogram(fill = 'darkgray', color = 'black', binwidth = 0.05) +
  theme_bw() + ylab("Count") + xlab("Genome Fraction Covered >= 20x") +
  xlim(c(0,1))+ ylim(c(0,350))
min30 <- ggplot(tbl, aes(x=Min30)) + geom_histogram(fill = 'darkgray', color = 'black', binwidth = 0.05) +
  theme_bw() + ylab("Count") + xlab("Genome Fraction Covered >= 30x") +
  xlim(c(0,1)) + ylim(c(0,350))

grid.arrange(min10,min20,min30,nrow = 1)

