library(shiny)
library(ggplot2)
library(ggthemes)
library(plotly)
library(RColorBrewer)

####### PREP FOR TWO WEBSITES ########
#BUILD AND SAVE GRIDLINES AND TREE OBJECT FIRST
library(plotly)
source("/Users/sg18/volumes/sshfs_mnt/Scripts/Prostate/Plot3DStructures_Utils.R")
#STRUCTURE3
#dir = '/Users/sg18/volumes/sshfs_mnt/team176space/Prostate/ResultsSortedByMorphologicalStructure/Structure3/'
#PosTbl_Complete <- read.table(file = paste0(dir,'PreprocessedCoordinatesFor3DPlot_InclCloneContributionAndMetadata_corrected_again.tsv'),
#                              header = T, stringsAsFactors = F)
#STRUCTURE4
dir = '/Users/sg18/volumes/sshfs_mnt/team176space/Prostate/ResultsSortedByMorphologicalStructure/Structure4/'
PosTbl_Complete <- read.table(file = paste0(dir,'PreprocessedCoordinatesFor3DPlot_InclCloneContributionAndMetadata_Corrected.tsv'),
                                                            header = T, stringsAsFactors = F)
p_addedtraces <- plot_ly(PosTbl_Complete[which(PosTbl_Complete$PDID!=0),], x = ~X, y = ~Y, z=~Z,
                         type = 'scatter3d', name = 'Overview',
                         mode = 'markers', text =~PDID,
                         #marker=list(color="darkgrey"),
                         marker=list(
                           color = 'darkgray', size = 8,
                           cauto = F, cmin = 0, cmax = 1, opacity = 0.75,
                           colorbar=list(
                             title='Cluster Contribution 
                             To Microdissection',
                             x = 0.933, y = 1, thickness = 20, len = 0.3
                           ),
                           #colorscale='Greens',
                           colorscale= list(c(0, rgb(0.95, 0.95, 0.95)),
                                            c(1,rgb(0.12,0.12,0.12))
                           ),
                           reversescale =F, showscale = T
                         ),
                         showlegend = T, visible = 'legendonly')
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
#save(p_addedtraces,file="/Users/sg18/Desktop/Structure4_Gridlines")


####### STRUCTURE3 ######
ui_structure3 <- fluidPage(
  fluidRow(column(width = 5,plotlyOutput('dummyplot')
                  ),
           column(width = 7,
                  fluidPage(selectInput(inputId = 'cluster', label = 'Select a Cluster to Display Cellular Contribution in Microdissections',
                                        choices = c('Cl.2','Cl.4','Cl.5','Cl.6','Cl.7','Cl.8','Cl.9','Cl.10',
                                                    'Cl.11','Cl.12','Cl.13','Cl.14','Cl.16',
                                                    'Cl.20','Cl.22','Cl.24','Cl.25','Cl.26','Cl.27','Cl.28','Cl.29',
                                                    'Cl.31','Cl.33','Cl.36','Cl.37','Cl.38','Cl.39',
                                                    'Cl.41','Cl.43','Cl.45',
                                                    'Cl.61','Cl.65',
                                                    'Cl.71','Cl.73','Cl.74',
                                                    'Cl.85','Cl.98',
                                                    'Cl.101','Cl.103','Cl.114','Cl.118','Cl.119','Cl.124'),
                                        selected = 'Cl.2'),
                            hr(),
                            plotlyOutput('plot'),
                            div(style = "height:95%")
                            )
                  ),
           div(style = "height:50%")
           )
  )

server_structure3 <- function(input, output) {
  ##### Code to create and plot reactive 3D model #####

  dir = '/Users/sg18/volumes/sshfs_mnt/team176space/Prostate/ResultsSortedByMorphologicalStructure/Structure3/'
  PosTbl_Complete <- read.table(file = paste0(dir,'PreprocessedCoordinatesFor3DPlot_InclCloneContributionAndMetadata_corrected_again.tsv'),
                                header = T, stringsAsFactors = F)
  load(file = "/Users/sg18/Desktop/Structure3_Gridlines_Corrected")
  ClToCol <- read.table(file = "/Users/sg18/Desktop/Structure3_ClusterToColorTable.tsv",
                        col.names = c('Cluster','Color'))
  output$plot <- renderPlotly(
    p_addedtraces %>% add_trace(data = PosTbl_Complete,
                                x = ~X, y = ~Y, z = ~Z,
                                name = input$cluster,
                                type = 'scatter3d', mode = 'markers',
                                visible = TRUE, inherit = F,
                                text = as.formula(paste0('~',input$cluster)),
                                marker = list(color = as.formula(paste0('~',input$cluster)), size = 10.5, #
                                              colorscale= list(c(0, rgb(0.95,0.95, 0.95)),
                                                               c(1,as.character(ClToCol$Color[which(ClToCol$Cluster==input$cluster)]))
                                              ),
                                              showscale = F,reversescale = F,
                                              cauto = F, cmin = 0, cmax = 1
                                )
    )
    )
  
  ####### Code and plot for tree ######
  load(file = "/Users/sg18/Desktop/Structure3_Tree")
    output$dummyplot<- renderPlotly(
      plotly::ggplotly(ggtree_object, tooltip = c('MutationalBurden_Total','MutationalBurden_Cluster','AreaOccupied'), dynamicTicks = T, height = 650)
  )
}
shinyApp(ui_structure3,server_structure3)

######### STRUCTURE4 ##########
ui_structure4 <- fluidPage(
  fluidRow(column(width = 5,plotlyOutput('dummyplot')
  ),
  column(width = 7,
         fluidPage(selectInput(inputId = 'cluster', label = 'Select a Cluster to Display Cellular Contribution in Microdissections',
                               choices = c('Cl.2','Cl.3','Cl.4','Cl.5','Cl.6','Cl.8','Cl.10',
                                           'Cl.11','Cl.12','Cl.13','Cl.15','Cl.17','Cl.18','Cl.19',
                                           'Cl.20','Cl.21','Cl.22','Cl.23','Cl.24','Cl.25','Cl.26','Cl.28','Cl.29',
                                           'Cl.30','Cl.31','Cl.32','Cl.33','Cl.34','Cl.35','Cl.36','Cl.38','Cl.39',
                                           'Cl.67','Cl.72','Cl.76','Cl.77',
                                           'Cl.85'),
                               selected = 'Cl.2'),
                   hr(),
                   plotlyOutput('plot'),
                   div(style = "height:95%")
         )
  ),
  div(style = "height:50%")
  )
)
server_structure4 <- function(input, output) {
  ##### Code to create and plot reactive 3D model #####
  
  dir = '/Users/sg18/volumes/sshfs_mnt/team176space/Prostate/ResultsSortedByMorphologicalStructure/Structure4/'
  PosTbl_Complete <- read.table(file = paste0(dir,'PreprocessedCoordinatesFor3DPlot_InclCloneContributionAndMetadata_Corrected.tsv'),
                                header = T, stringsAsFactors = F)
  load(file = "/Users/sg18/Desktop/Structure4_Gridlines")
  ClToCol <- read.table(file = "/Users/sg18/Desktop/Structure4_ClusterToColorTable.tsv",
                        col.names = c('Cluster','Color'))
  output$plot <- renderPlotly(
    p_addedtraces %>% add_trace(data = PosTbl_Complete,
                                x = ~X, y = ~Y, z = ~Z,
                                name = input$cluster,
                                type = 'scatter3d', mode = 'markers',
                                visible = TRUE, inherit = F,
                                text = as.formula(paste0('~',input$cluster)),
                                marker = list(color = as.formula(paste0('~',input$cluster)), size = 10.5, #
                                              colorscale= list(c(0, rgb(0.95,0.95, 0.95)),
                                                               c(1,as.character(ClToCol$Color[which(ClToCol$Cluster==input$cluster)]))
                                              ),
                                              showscale = F,reversescale = F,
                                              cauto = F, cmin = 0, cmax = 1
                                )
    )
  )
  
  ####### Code and plot for tree ######
  load(file = "/Users/sg18/Desktop/Structure4_Tree")
  output$dummyplot<- renderPlotly(
    plotly::ggplotly(ggtree_object, tooltip = c('MutationalBurden_Total','MutationalBurden_Cluster','AreaOccupied'), dynamicTicks = T, height = 650)
  )
}
shinyApp(ui_structure4,server_structure4)
