library(stringr)
#original genome-wide coverage files used for plotting:
Coverage <- read.table(file = "/Users/sg18/volumes/sshfs_mnt/team176space/Prostate/DepthSummaryFromCannaps.txt",
                       header = T)

#Load depth files
dir <- "/Users/sg18/volumes/sshfs_mnt/team176space/Prostate/DepthCounts/"
files <- list.files(path = dir, pattern = ".uniq")
Collect <- data.frame(Sample = rep(NA,415), Min10 = rep(NA,415), Min20 = rep(NA,415), Min30 = rep(NA,415))
helper = 1
for(file in files){
  tbl <- read.table(file = paste0(dir,file),
                    col.names = c("count","depth"), sep = " ")
  Collect[helper,"Sample"] <- str_match(file, "PD[0-9]+b_lo[0-9]+")[1]
  Collect[helper,"Min10"] <- sum(tbl$count[which(tbl$depth>=10)]) / 249250621
  Collect[helper,"Min20"] <- sum(tbl$count[which(tbl$depth>=20)]) / 249250621
  Collect[helper,"Min30"] <- sum(tbl$count[which(tbl$depth>=30)]) / 249250621
  helper = helper + 1
}

