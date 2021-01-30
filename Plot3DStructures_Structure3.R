library(plotly)
source("/Users/sg18/volumes/sshfs_mnt/Scripts/Prostate/Plot3DStructures_Utils.R")
#######################################################
# Merge manual annotation and Reconstruct coordinates #
#######################################################
dir = '/Users/sg18/volumes/sshfs_mnt/team176space/Prostate/ResultsSortedByMorphologicalStructure/Structure3/'
ManualAnnotation <- read.table(file = paste0(dir,'StrctureToSampleAllocation_Structure3Sheet.tsv'),
                               header = T, sep = "\t", na.strings = '', stringsAsFactors = F)
ManualAnnotation <- ManualAnnotation[which(is.na(ManualAnnotation$Comment)),
                                     c('PDID','Cut',"ClosestSequencedSectionDirectionOfRoot","DoubleCut","SerfileSlide")]

ReconstructCoordinates <- read.table(file = paste0(dir,'ReconstructCoordinates_Structure3'),
                                     header = F, sep = "\t", stringsAsFactors = F)
colnames(ReconstructCoordinates) <- c('Cut','X','Y')
PosTbl <- merge(ManualAnnotation, ReconstructCoordinates, by = 'Cut', all = T)
PosTbl$SerfileSlide <- as.numeric(PosTbl$SerfileSlide)
plot_ly(PosTbl, x = ~X, y = ~Y, z = ~SerfileSlide,
        type = 'scatter3d', name = 'MainCuts', text = ~PDID) %>%
  layout(title = 'Raw')
###########################################
# Correct for alignment error in slide 80 #
###########################################
#Slide80 is wrinkled, which misaligns the sections before and after. Slide 80+ is different from 79-
#This is basically a translational alignment error. Picking three points that should be identical on 79 and 81
correctionpoints = data.frame(x = c(1.5628175,1.814635,1.206455,1.3819075,1.696455,1.0519075),
                              y= c(3.945665,3.1247575,3.6893025,3.6302125,2.8402125,3.348395),
                              Slide = c(rep('79',3),rep('81',3)),Number = c(rep(c(1,2,3),2)))
#plot(correctionpoints$x,correctionpoints$y, col = 'purple', pch = 18,xlim = c(0.8,2.2),ylim = c(2,4))
diff_x = mean(correctionpoints$x[which(correctionpoints$Slide=='81')] - correctionpoints$x[which(correctionpoints$Slide=='79')])
diff_y = mean(correctionpoints$y[which(correctionpoints$Slide=='81')] - correctionpoints$y[which(correctionpoints$Slide=='79')])
correctionpoints$x[which(correctionpoints$Slide=='81')] <- correctionpoints$x[which(correctionpoints$Slide=='81')] - diff_x
correctionpoints$y[which(correctionpoints$Slide=='81')] <- correctionpoints$y[which(correctionpoints$Slide=='81')] - diff_y
#points(correctionpoints$x,correctionpoints$y, col ='red')
#correct all values for x and y in PosTbl for slide 81 and above
PosTbl$X[which(PosTbl$SerfileSlide>=81)] <- PosTbl$X[which(PosTbl$SerfileSlide>=81)] - diff_x
PosTbl$Y[which(PosTbl$SerfileSlide>=81)] <- PosTbl$Y[which(PosTbl$SerfileSlide>=81)] - diff_y
#plot_ly(PosTbl, x = ~X, y = ~Y, z = ~SerfileSlide,
#        type = 'scatter3d', name = 'MainCuts', text = ~PDID)
rm(diff_x, diff_y, correctionpoints)
############################################
# Reclibrate Reconstruct values to microns #
############################################
#recalibrate
PosTbl$X <- PosTbl$X / ReconToMicronRatio
PosTbl$Y <- PosTbl$Y / ReconToMicronRatio
PosTbl$Z = 10 * PosTbl$SerfileSlide
################################################
# Set origin relative to root-proximate sample #
################################################
PosTbl$X <- PosTbl$X  - PosTbl$X[which(PosTbl$ClosestSequencedSectionDirectionOfRoot=='root')]
PosTbl$Y <- PosTbl$Y  - PosTbl$Y[which(PosTbl$ClosestSequencedSectionDirectionOfRoot=='root')]
PosTbl$Z <- PosTbl$Z - PosTbl$Z[which(PosTbl$ClosestSequencedSectionDirectionOfRoot=='root')]
#plot_ly(PosTbl, x = ~X, y = ~Y, z = ~Z,
#        type = 'scatter3d', name = 'RelativeToRoot',
#        text = ~PDID)
#######################################################
# Adding distances to root (save fully modified data) #
#######################################################
PosTbl$RootDistance = NA
for(row in c(1:nrow(PosTbl))){
  curr_cut <- as.character(PosTbl$Cut[row])
  dist <- comp_dist_root(df = PosTbl, curr = curr_cut)
  PosTbl$RootDistance[row] = dist
}
#plot_ly(PosTbl, x = ~X, y = ~Y, z = ~Z,
#        type = 'scatter3d', name = 'RootDistance',
#        text = ~Cut,
#        marker = list(color = ~RootDistance, colorscale = c('#FFE1A1', '#683531'), showscale = TRUE)
#)

write.table(PosTbl, file = paste0(dir,'PreprocessedCoordinatesFor3DPlot.tsv'),
            col.names = T, row.names = F, quote = F, sep = "\t")
dir = '/Users/sg18/volumes/sshfs_mnt/team176space/Prostate/ResultsSortedByMorphologicalStructure/Structure3/'
PosTbl <- read.table(file = paste0(dir,'PreprocessedCoordinatesFor3DPlot.tsv'),
                    header = T, sep = "\t", stringsAsFactors = F)
#######################################
# Adding connections between sections #
#######################################
#basic plot #with distances
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
p_addedtraces
#######################################
# Check on small peripheral structure #
#######################################

# Finally looks as expected #

peri_cutnames <- c('Lower_1','Lower_2','Lower_3','Lower_4','Lower_5','Lower_6','Lower_7',
                   'Top_1','Top_2','Top_3','Top_4','Top_5','Top_6',
                   'Trans_4','Trans_5')
PeripheralStructure <- PosTbl[which(PosTbl$Cut %in% peri_cutnames),]
PeripheralStructure$Type <- c(rep('Lower',7),
                              rep('Top',6),
                              rep('Trans',2))


p_addedtraces <- plot_ly(PeripheralStructure, x = ~X, y = ~Y, z = ~Z,
                     type = 'scatter3d', name = 'MainCuts',
                     text = ~Cut,
                     marker = list(color = ~RootDistance, colorscale = c('#FFE1A1', '#683531'), showscale = TRUE)
                     )
global_added = c('Cut59','Top_6')

addcut <- function(df,currcut,local_added, findme ='root'){
  if(currcut %in% local_added){
    return(1)
  }else{
    #position table as df, the current trace and cut to consider
    closest_cut <- df$ClosestSequencedSectionDirectionOfRoot[which(df$Cut == currcut)]
    if(closest_cut == findme){
      return(1)
    }
    newframe <<- rbind(newframe,
                       data.frame(x = df$X[which(df$Cut == closest_cut)],
                                  y = df$Y[which(df$Cut == closest_cut)],
                                  z = df$Z[which(df$Cut == closest_cut)],
                                  type = 'colordummy')
    )
    global_added <<- append(global_added,currcut)
    local_added <- append(local_added,currcut)
    addcut(df = df, currcut = closest_cut, local_added = local_added)
  }
}


for(row in c(1:nrow(PeripheralStructure))){
  curr_cut <- as.character(PeripheralStructure$Cut[row])
  if(curr_cut %in% global_added){
    next
  }else{
    newframe = data.frame(x = PeripheralStructure$X[row], y = PeripheralStructure$Y[row], z = PeripheralStructure$Z[row], type ='colordummy')
    addcut(df = PeripheralStructure, currcut = curr_cut, local_added = global_added, findme = 'Cut59')
    p_addedtraces <- p_addedtraces %>% add_trace(data = newframe, x=~x,  y=~y, z=~z,
                                                 type = 'scatter3d', mode = 'lines', inherit = F,
                                                 showlegend=FALSE
    )
  }
}
p_addedtraces
###################################
# Overlay with clone contribution #
###################################
#read in clones table
dir = '/Users/sg18/volumes/sshfs_mnt/team176space/Prostate/ResultsSortedByMorphologicalStructure/Structure3/'
Clones <- read.csv(paste0(dir,'DirichletClustering/LongClustering_52kBurnin/cluster_and_samples.csv'),
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
##############################################################
# Get additional metadata like clonality and telomere lenght #
##############################################################
metatbl <- read.table(file = "/Users/sg18/volumes/sshfs_mnt/team176space/Prostate/VAF_Telomere_MutCount_PerSample.tsv",
                      header = T)
metatbl <- metatbl[which(metatbl$Donor=='PD40870'),c('Sample',"MedianVAF","MutationCount","SeqX","TelomereLength")]
colnames(metatbl)[1] <- 'PDID'
PosTbl_Complete <- merge(PosTbl_Clones,metatbl,all.x = T, by = 'PDID') 
PosTbl_Complete <- PosTbl_Complete[-which(PosTbl_Complete$PDID=='PD40870b_lo0307' | PosTbl_Complete$PDID=='PD40870b_lo0299'),]
#write (hopefully) final table with all metadata
dir = '/Users/sg18/volumes/sshfs_mnt/team176space/Prostate/ResultsSortedByMorphologicalStructure/Structure3/'
write.table(PosTbl_Complete, file = paste0(dir,'PreprocessedCoordinatesFor3DPlot_InclCloneContributionAndMetadata.tsv'),
            col.names = T, row.names = F, quote = F, sep = "\t")



#########################
# Start plotting blocks #
#########################
library(plotly)
source("/Users/sg18/volumes/sshfs_mnt/Scripts/Prostate/Plot3DStructures_Utils.R")
dir = '/Users/sg18/volumes/sshfs_mnt/team176space/Prostate/ResultsSortedByMorphologicalStructure/Structure3/'
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

#Now plotting all the clusters
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
