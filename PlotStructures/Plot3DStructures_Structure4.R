library(plotly)
source("/Users/sg18/volumes/sshfs_mnt/Scripts/Prostate/Plot3DStructures_Utils.R")
#######################################################
# Merge manual annotation and Reconstruct coordinates #
#######################################################
dir = '/Users/sg18/volumes/sshfs_mnt/team176space/Prostate/ResultsSortedByMorphologicalStructure/Structure4/'
ManualAnnotation <- read.table(file = paste0(dir,'PdidToCutAllocation.tsv'),
                               header = T, sep = "\t", na.strings = '', stringsAsFactors = F)
ManualAnnotation <- ManualAnnotation[,c('PDID','Cut',"ClosestSequencedSectionDirectionOfRoot","DoubleCut","SerfileSlide")]

ReconstructCoordinates <- read.table(file = paste0(dir,'SerfileCoordinates.tsv'),
                                     header = F, sep = "\t", stringsAsFactors = F)
colnames(ReconstructCoordinates) <- c('Cut','X','Y')
PosTbl <- merge(ManualAnnotation, ReconstructCoordinates, by = 'Cut', all = T)
PosTbl$SerfileSlide <- as.numeric(PosTbl$SerfileSlide)
plot_ly(PosTbl, x = ~X, y = ~Y, z = ~SerfileSlide,
        type = 'scatter3d', name = 'MainCuts', text = ~PDID) %>%
  layout(title = 'Raw')
##################################################################
# Manual Alignment check and recalibration and centering to root #
##################################################################
#Several alignment problems
#a few slides misaligned but adjacent slides are well aligned to each other (misaligned examples  26,58,67 but e.g. 25 well aligned to 27 )
#slide 33 misaligned but 32 well to 34
#slide 54 misaligned but 53 well to 55
#took x-y coordinates for cuts on 26,33 and 54 from one of the well-aligned slides
#several jiggles from 71 upwards but not easy to correct since several slides have these jumps in adjacent fashion and fix points over more than 50 microns also won't be accurate
#recalibrate
PosTbl$X <- PosTbl$X / ReconToMicronRatio
PosTbl$Y <- PosTbl$Y / ReconToMicronRatio
PosTbl$Z = 10 * PosTbl$SerfileSlide
#set relative origin
PosTbl$X <- PosTbl$X  - PosTbl$X[which(PosTbl$ClosestSequencedSectionDirectionOfRoot=='root')]
PosTbl$Y <- PosTbl$Y  - PosTbl$Y[which(PosTbl$ClosestSequencedSectionDirectionOfRoot=='root')]
PosTbl$Z <- PosTbl$Z - PosTbl$Z[which(PosTbl$ClosestSequencedSectionDirectionOfRoot=='root')]
#########################################################
# Adding distances to root and basic connection network #
#########################################################
#adding distances
PosTbl$RootDistance = NA
for(row in c(1:nrow(PosTbl))){
  curr_cut <- as.character(PosTbl$Cut[row])
  dist <- comp_dist_root(df = PosTbl, curr = curr_cut)
  PosTbl$RootDistance[row] = dist
}
#adding traces
p_addedtraces <- plot_ly(PosTbl, x = ~X, y = ~Y, z = ~Z,
        type = 'scatter3d', name = 'MainCuts',
        mode = 'markers', text =~ Cut,
        marker = list(color = ~RootDistance, colorscale = 'Greens',
                      showscale = T, reversescale = T),
        showlegend = T)
global_added <- c('root')
for(row in c(1:nrow(PosTbl))){
  curr_cut <- as.character(PosTbl$Cut[row])
  if(curr_cut %in% global_added){
    next
  }else{
    newframe = data.frame(x = PosTbl$X[row], y = PosTbl$Y[row], z = PosTbl$Z[row], type ='colordummy')
    addcut(df = PosTbl, currcut = curr_cut, local_added = global_added)
    p_addedtraces <- p_addedtraces %>% add_trace(data = newframe, x=~x,  y=~y, z=~z, inherit = F, mode = 'lines',
                                                 type = 'scatter3d', showlegend = F,
                                                 line = list(color = 'rgb(0,0,0)', width = 2, showscale = F))
  }
}
#plot
p_addedtraces
###################################
# Overlay with clone contribution #
###################################
#read in clones table
Clones <- read.csv(paste0(dir,'DirichletClustering/75kIterations/cluster_and_samples.csv'),
                   header = T, stringsAsFactors = F)
Clones_names <- Clones$cluster_id
Clones <- Clones[,c(1:(ncol(Clones)-2))]
Clones <- as.data.frame(t(Clones))
colnames(Clones) = Clones_names
row.names(Clones)[2:nrow(Clones)] = paste0('PD40870b_',row.names(Clones)[2:nrow(Clones)] )
Clones$PDID <- row.names(Clones)
#merge
PosTbl_Clones <- merge(x = PosTbl, y = Clones, all = T, by = c('PDID'))
#set all NA to 0 as colouring is an issue with the structurally added ones otherwise
PosTbl_Clones[is.na(PosTbl_Clones)] <- 0

p_addedtraces <- plot_ly(PosTbl_Clones[which(PosTbl_Clones$PDID!=0),], x = ~X, y = ~Y, z = ~Z,
                         type = 'scatter3d', name = 'MainCuts',
                         mode = 'markers', text =~ Cut,
                         marker = list(color = ~Cl.77, colorscale = 'Greens',
                                       showscale = T, reversescale = T),
                         showlegend = T)
global_added <- c('root')
for(row in c(1:nrow(PosTbl))){
  curr_cut <- as.character(PosTbl$Cut[row])
  if(curr_cut %in% global_added){
    next
  }else{
    newframe = data.frame(x = PosTbl$X[row], y = PosTbl$Y[row], z = PosTbl$Z[row], type ='colordummy')
    addcut(df = PosTbl, currcut = curr_cut, local_added = global_added)
    p_addedtraces <- p_addedtraces %>% add_trace(data = newframe, x=~x,  y=~y, z=~z, inherit = F, mode = 'lines',
                                                 type = 'scatter3d', showlegend = F,
                                                 line = list(color = 'rgb(0,0,0)', width = 2, showscale = F))
  }
}
#plot
p_addedtraces
##############################################################
# Get additional metadata like clonality and telomere lenght #
##############################################################
metatbl <- read.table(file = "/Users/sg18/volumes/sshfs_mnt/team176space/Prostate/VAF_Telomere_MutCount_PerSample.tsv",
                      header = T)
metatbl <- metatbl[which(metatbl$Donor=='PD40870'),c('Sample',"MedianVAF","MutationCount","SeqX","TelomereLength")]
colnames(metatbl)[1] <- 'PDID'
PosTbl_Complete <- merge(PosTbl_Clones,metatbl,all.x = T, by = 'PDID') 
PosTbl_Complete <- PosTbl_Complete[-which(PosTbl_Complete$PDID=='PD40870b_lo0524' | PosTbl_Complete$PDID=='PD40870b_lo0525'),]
#write (hopefully) final table with all metadata
dir = '/Users/sg18/volumes/sshfs_mnt/team176space/Prostate/ResultsSortedByMorphologicalStructure/Structure4/'
write.table(PosTbl_Complete, file = paste0(dir,'PreprocessedCoordinatesFor3DPlot_InclCloneContributionAndMetadata.tsv'),
            col.names = T, row.names = F, quote = F, sep = "\t")

##################
# Final plotting #
##################
library(plotly)
source("/Users/sg18/volumes/sshfs_mnt/Scripts/Prostate/Plot3DStructures_Utils.R")
dir = '/Users/sg18/volumes/sshfs_mnt/team176space/Prostate/ResultsSortedByMorphologicalStructure/Structure4/'
PosTbl_Complete <- read.table(file = paste0(dir,'PreprocessedCoordinatesFor3DPlot_InclCloneContributionAndMetadata.tsv'),
                              header = T, stringsAsFactors = F)

p_addedtraces <- plot_ly(PosTbl_Complete[which(PosTbl_Complete$PDID!=0),], x = ~X, y = ~Y, z = ~Z,
                         type = 'scatter3d', name = 'GridModel',
                         mode = 'markers', text =~ PDID,
                         marker=list(color = 'lightgrey'),
                         showlegend = T)
global_added <- c('root')
for(row in c(1:nrow(PosTbl_Complete))){
  curr_cut <- as.character(PosTbl_Complete$Cut[row])
  if(curr_cut %in% global_added){
    next
  }else{
    newframe = data.frame(x = PosTbl_Complete$X[row], y = PosTbl_Complete$Y[row], z = PosTbl_Complete$Z[row], type ='colordummy')
    addcut(df = PosTbl_Complete, currcut = curr_cut, local_added = global_added)
    p_addedtraces <- p_addedtraces %>% add_trace(data = newframe, x=~x,  y=~y, z=~z, inherit = F, mode = 'lines',
                                                 type = 'scatter3d', showlegend = F,
                                                 line = list(color = 'rgb(0,0,0)', width = 2, showscale = F))
  }
}
for(annot in c('RootDistance','TelomereLength','MutationCount','MedianVAF')){
  p_addedtraces <<- p_addedtraces %>% add_trace(data = PosTbl_Complete[which(PosTbl_Complete$PDID!=0),], x = ~X, y = ~Y, z = ~Z,
                                                type = 'scatter3d', mode = 'markers' ,name = annot, inherit = F,
                                                text = as.formula(paste0('~',annot)),visible = 'legendonly',
                                                marker = list(color = as.formula(paste0('~',annot)),showscale = T,reversescale = F,
                                                              colorbar = list(x = -0.2))
  )
}
#plot
p_addedtraces



p_addedtraces <- plot_ly(PosTbl_Complete[which(PosTbl_Complete$PDID!=0),], x = ~X, y = ~Y, z = ~Z,
                         type = 'scatter3d', name = 'GridModel',
                         mode = 'markers', text =~ PDID,
                         #marker=list(color="lightgrey"),
                         marker=list(
                           color = 'lightgrey',
                           cauto = F, cmin = 0, cmax = 1,
                           colorbar=list(
                             title='ClusterContributionToSection',
                             x = 0
                           ),
                           #colorscale='Greens',
                           colorscale= list(0, rgb(0, 1, 0)),
                           reversescale =F
                         ),
                         showlegend = T)
global_added <- c('root')
for(row in c(1:nrow(PosTbl_Complete))){
  curr_cut <- as.character(PosTbl_Complete$Cut[row])
  if(curr_cut %in% global_added){
    next
  }else{
    newframe = data.frame(x = PosTbl_Complete$X[row], y = PosTbl_Complete$Y[row], z = PosTbl_Complete$Z[row], type ='colordummy')
    addcut(df = PosTbl_Complete, currcut = curr_cut, local_added = global_added)
    p_addedtraces <- p_addedtraces %>% add_trace(data = newframe, x=~x,  y=~y, z=~z, inherit = F, mode = 'lines',
                                                 type = 'scatter3d', showlegend = F,
                                                 line = list(color = 'rgb(0,0,0)', width = 2, showscale = F))
  }
}
for(cluster in c(str_match(colnames(PosTbl_Complete),"Cl.[0-9]+")[!is.na(str_match(colnames(PosTbl_Complete),"Cl.[0-9]+"))])){
  p_addedtraces <<- p_addedtraces %>% add_trace(data = PosTbl_Complete[which(PosTbl_Complete$PDID!=0),], x = ~X, y = ~Y, z = ~Z,
                                                type = 'scatter3d', mode = 'markers' ,name = cluster, inherit = F,
                                                text = as.formula(paste0('~',cluster)),visible = 'legendonly',
                                                marker = list(color = as.formula(paste0('~',cluster)),
                                                              colorscale= list(0, rgb(0, 1, 0)), showscale = F,reversescale = F,
                                                              cauto = F, cmin = 0, cmax = 1)
  )
}
p_addedtraces

######
# add acinus annotation
######
dir = '/Users/sg18/volumes/sshfs_mnt/team176space/Prostate/ResultsSortedByMorphologicalStructure/Structure4/'
PosTbl_Complete <- read.table(file = paste0(dir,'PreprocessedCoordinatesFor3DPlot_InclCloneContributionAndMetadata.tsv'),
                              header = T, stringsAsFactors = F)



#correlation of embryonic clones
Cl76_67 <- PosTbl_Complete[union(which(PosTbl_Complete[,'Cl.76'] > 0.05),which(PosTbl_Complete[,'Cl.67'] > 0.05)),c('Cl.76','Cl.67')]
Cl76_72 <- PosTbl_Complete[union(which(PosTbl_Complete[,'Cl.76'] > 0.05),which(PosTbl_Complete[,'Cl.72'] > 0.05)),c('Cl.76','Cl.72')]
Cl76_77 <- PosTbl_Complete[union(which(PosTbl_Complete[,'Cl.76'] > 0.05),which(PosTbl_Complete[,'Cl.77'] > 0.05)),c('Cl.76','Cl.77')]
Cl72_67 <- PosTbl_Complete[union(which(PosTbl_Complete[,'Cl.72'] > 0.05),which(PosTbl_Complete[,'Cl.67'] > 0.05)),c('Cl.72','Cl.67')]
Cl72_77 <- PosTbl_Complete[union(which(PosTbl_Complete[,'Cl.72'] > 0.05),which(PosTbl_Complete[,'Cl.77'] > 0.05)),c('Cl.72','Cl.77')]
Cl77_67 <- PosTbl_Complete[union(which(PosTbl_Complete[,'Cl.67'] > 0.05),which(PosTbl_Complete[,'Cl.77'] > 0.05)),c('Cl.67','Cl.77')]
spearmans <- data.frame(rho = c(as.numeric(cor.test(Cl76_67[,1],Cl76_67[,2],method = 'spearman')['estimate']),
                                as.numeric(cor.test(Cl76_72[,1],Cl76_72[,2],method = 'spearman')['estimate']),
                                as.numeric(cor.test(Cl76_77[,1],Cl76_77[,2],method = 'spearman')['estimate']),
                                as.numeric(cor.test(Cl72_67[,1],Cl72_67[,2],method = 'spearman')['estimate']),
                                as.numeric(cor.test(Cl72_77[,1],Cl72_77[,2],method = 'spearman')['estimate']),
                                as.numeric(cor.test(Cl77_67[,1],Cl77_67[,2],method = 'spearman')['estimate'])
                                ),
                        p = c(as.numeric(cor.test(Cl76_67[,1],Cl76_67[,2],method = 'spearman')['p.value']),
                              as.numeric(cor.test(Cl76_72[,1],Cl76_72[,2],method = 'spearman')['p.value']),
                              as.numeric(cor.test(Cl76_77[,1],Cl76_77[,2],method = 'spearman')['p.value']),
                              as.numeric(cor.test(Cl72_67[,1],Cl72_67[,2],method = 'spearman')['p.value']),
                              as.numeric(cor.test(Cl72_77[,1],Cl72_77[,2],method = 'spearman')['p.value']),
                              as.numeric(cor.test(Cl77_67[,1],Cl77_67[,2],method = 'spearman')['p.value'])
                        ),
                        cluster = c('Cl.76:Cl.67','Cl.76:Cl.72','Cl.76:Cl.77','Cl.72:Cl.67','Cl.72:Cl.77','Cl.77:Cl.67')
                        )
spearmans$p[which(spearmans$p==0)] <- 2.2e-16
write.table(spearmans, file = "/Users/sg18/volumes/sshfs_mnt/team176space/Prostate/ResultsSortedByMorphologicalStructure/Structure4/SpearmanCorrelations_EmbryonicClones.tsv",
            col.names = T, row.names = F, quote = F, sep = "\t")





##### Getting 2D structures using MDS ########
dir = '/Users/sg18/volumes/sshfs_mnt/team176space/Prostate/ResultsSortedByMorphologicalStructure/Structure4/'
PosTbl_Complete <- read.table(file = paste0(dir,'PreprocessedCoordinatesFor3DPlot_InclCloneContributionAndMetadata.tsv'),
                              header = T, stringsAsFactors = F)
ori_matrix <- PosTbl_Complete[,c('X','Y','Z')]
ori_matrix_dist <- dist(ori_matrix)
ori_matrix_mds <- cmdscale(ori_matrix_dist, k = 2)
PosTbl_Complete$MSD_x <- ori_matrix_mds[,1]
PosTbl_Complete$MSD_y <- ori_matrix_mds[,2]
PosTbl_Complete$MSD_x <- PosTbl_Complete$MSD_x - PosTbl_Complete$MSD_x[which(PosTbl_Complete$ClosestSequencedSectionDirectionOfRoot=='root')]
PosTbl_Complete$MSD_y <- PosTbl_Complete$MSD_y - PosTbl_Complete$MSD_y[which(PosTbl_Complete$ClosestSequencedSectionDirectionOfRoot=='root')]


addcut_2d <- function(df,currcut,local_added, findme ='root'){
  if(currcut %in% local_added){
    return(1)
  }else{
    #position table as df, the current trace and cut to consider
    closest_cut <- df$ClosestSequencedSectionDirectionOfRoot[which(df$Cut == currcut)]
    if(closest_cut == findme){
      return(1)
    }
    newframe <<- rbind(newframe,
                       data.frame(x = df$MSD_x[which(df$Cut == closest_cut)],
                                  y = df$MSD_y[which(df$Cut == closest_cut)],
                                  type = 'colordummy')
    )
    global_added <<- append(global_added,currcut)
    local_added <- append(local_added,currcut)
    addcut_2d(df = df, currcut = closest_cut, local_added = local_added)
  }
}

p_addedtraces <- plot_ly(PosTbl_Complete[which(PosTbl_Complete$PDID!=0),], x = ~MSD_x, y = ~MSD_y,
                         type = 'scatter', name = 'GridModel',
                         mode = 'markers', text =~ PDID,
                         #marker=list(color="lightgrey"),
                         marker=list(
                           color = 'lightgrey', size = 9,
                           cauto = F, cmin = 0, cmax = 1, opacity = 0.75,
                           colorbar=list(
                             title='ClusterContributionToSection',
                             x = 0
                           ),
                           #colorscale='Greens',
                           colorscale= list(0, rgb(0, 1, 0)),
                           reversescale =F
                         ),
                         showlegend = T) %>%
  layout(xaxis = list(title = 'MSD Coordinate 1',zeroline = F),
         yaxis = list(title = 'MSD Coordinate 2', zeroline = F))
global_added <- c('root')
for(row in c(1:nrow(PosTbl_Complete))){
  curr_cut <- as.character(PosTbl_Complete$Cut[row])
  if(curr_cut %in% global_added){
    next
  }else{
    newframe = data.frame(x = PosTbl_Complete$MSD_x[row], y = PosTbl_Complete$MSD_y[row], type ='colordummy')
    addcut_2d(df = PosTbl_Complete, currcut = curr_cut, local_added = global_added)
    p_addedtraces <- p_addedtraces %>% add_trace(data = newframe, x=~x,  y=~y, inherit = F, mode = 'lines',
                                                 type = 'scatter', showlegend = F, opacity = 0.75,
                                                 line = list(color = 'lightgray', width = 1.5, showscale = F)) #rgb(0,0,0)
  }
}
for(cluster in c(str_match(colnames(PosTbl_Complete),"Cl.[0-9]+")[!is.na(str_match(colnames(PosTbl_Complete),"Cl.[0-9]+"))])){
  p_addedtraces <<- p_addedtraces %>% add_trace(data = PosTbl_Complete[which(PosTbl_Complete$PDID!=0),], x = ~MSD_x, y = ~MSD_y,
                                                type = 'scatter', mode = 'markers' ,name = cluster, inherit = F,
                                                text = as.formula(paste0('~',cluster)),visible = 'legendonly',
                                                marker = list(color = as.formula(paste0('~',cluster)), size = 9, opacity = 0.75,
                                                              colorscale= list(0, rgb(0, 1, 0)), showscale = F,reversescale = F,
                                                              cauto = F, cmin = 0, cmax = 1)
  )
}
p_addedtraces



########plot the four ancestral clones with four different colors















