#########################################################
# Deriving Ratio between Reconstruct values and microns #
#########################################################
# #frames to recalibrate reconstruct values
# MicronCalibrate <- data.frame(name = c('top','bottom','left','right','far',
#                                        '101_1','101_2','101_3'),
#                               x = c(4.5434,	4.54629,	4.49726,	4.58025,3.47025,
#                                     3.18205,	3.31995,	3.49034),
#                               y = c(2.92182,	2.83787,	2.86959,	2.89138,3.514455,
#                                     2.83445,	2.94981,	2.9252775))
# Distances <- data.frame(name = c('LeftToRight','TopToLeft','BottomToLeft','TopToRight','BottomToRight',
#                                  'FarToLeft','FarToTop',
#                                  'A_12','A_13','A_23'),
#                         microns = c(413,320,279,239,289,
#                                     5610,5640,
#                                     848,1510,806),
#                         recon = c(rep(NA,5,10)))
# trigon_dist <- function(frame){
#   a = frame$x[1] - frame$x[2]
#   b = frame$y[1] - frame$y[2]
#   return( sqrt(a**2+b**2) )
# }
# Distances$recon[which(Distances$name=='LeftToRight')] <- trigon_dist( MicronCalibrate[which(MicronCalibrate$name=='left' | MicronCalibrate$name=='right'),] )
# Distances$recon[which(Distances$name=='TopToLeft')] <-trigon_dist( MicronCalibrate[which(MicronCalibrate$name=='top' | MicronCalibrate$name=='left'),] )
# Distances$recon[which(Distances$name=='BottomToLeft')] <-trigon_dist( MicronCalibrate[which(MicronCalibrate$name=='left' | MicronCalibrate$name=='bottom'),] )
# Distances$recon[which(Distances$name=='TopToRight')] <-trigon_dist( MicronCalibrate[which(MicronCalibrate$name=='top' | MicronCalibrate$name=='right'),] )
# Distances$recon[which(Distances$name=='BottomToRight')] <-trigon_dist( MicronCalibrate[which(MicronCalibrate$name=='right' | MicronCalibrate$name=='bottom'),] )
# Distances$recon[which(Distances$name=='FarToLeft')] <-trigon_dist( MicronCalibrate[which(MicronCalibrate$name=='far' | MicronCalibrate$name=='left'),] )
# Distances$recon[which(Distances$name=='FarToTop')] <-trigon_dist( MicronCalibrate[which(MicronCalibrate$name=='far' | MicronCalibrate$name=='top'),] )
# Distances$recon[which(Distances$name=='A_12')] <-trigon_dist( MicronCalibrate[which(MicronCalibrate$name=='101_1' | MicronCalibrate$name=='101_2'),] )
# Distances$recon[which(Distances$name=='A_13')] <-trigon_dist( MicronCalibrate[which(MicronCalibrate$name=='101_1' | MicronCalibrate$name=='101_3'),] )
# Distances$recon[which(Distances$name=='A_23')] <-trigon_dist( MicronCalibrate[which(MicronCalibrate$name=='101_3' | MicronCalibrate$name=='101_2'),] )
# Distances$ratio <- Distances$recon / Distances$microns
# ReconToMicronRatio = mean(Distances$ratio)
ReconToMicronRatio = 0.000212609292900364
#########################################
# Function to compute distances to root #
#########################################
comp_dist_root <- function(df,curr,totaldist = 0){
  curr_pos <- c(df$X[which(df$Cut == curr)],
                df$Y[which(df$Cut == curr)],
                df$Z[which(df$Cut == curr)])
  closest_cut <- df$ClosestSequencedSectionDirectionOfRoot[which(df$Cut == curr)]
  #exception for root sample
  if(closest_cut == 'root'){
    return(totaldist)
  }
  closest_pos <- c(df$X[which(df$Cut == closest_cut)],
                   df$Y[which(df$Cut == closest_cut)],
                   df$Z[which(df$Cut == closest_cut)])
  curr_dist <- sqrt( (curr_pos[1]-closest_pos[1])**2 + (curr_pos[2]-closest_pos[2])**2 + (curr_pos[3]-closest_pos[3])**2 )
  totaldist = totaldist + curr_dist
  #break if root found
  if( df$ClosestSequencedSectionDirectionOfRoot[which(df$Cut == closest_cut)] == 'root'){
    return(totaldist)
  }else{
    #recursive call otherwise
    comp_dist_root(df = df, curr = closest_cut, totaldist = totaldist)
  }
}
########################################################################################
# Function to create data.table that can be added as line trace to existing potly plot #
########################################################################################
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
# same for 2D
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

