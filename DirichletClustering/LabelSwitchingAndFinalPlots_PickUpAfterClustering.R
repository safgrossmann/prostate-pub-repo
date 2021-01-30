# Run Dirichlet clustering
# --
# Runs Dirichlet clustering and label switching on low input mutation data
#
# Args (command line):
#   1: Path to git repository (ie. parent directory where repository was cloned into)
#   2: Path to CSV containing counts of alt base (rows are variants, any columns starting with 'PD' are samples)
#   3: Path to CSV containing depth (rows are variants, any columns starting with 'PD' are samples)
#   4: Path to table with mutation contexts (generated with Peter Campbell's "Context_pull_build37.pl" script)
#   5: Directory to output results
#   6: Number of burnin cycles, eg 10000
# 
# If command line args are not provided, default file locations are used.
# 
# --
# /// Author --- PETER CAMPBELL
# /// Edits --- Simon Brunner
# /// Edit date --- 11-MAY-2018
# /// Edits --- Sebastian Grossmann
# /// Edit date - 09-APR-2019

# Further edits include change of default files, comment out debugging part, changing file path creation for sourcing local scripts, sourcing speed-optimised label.switching code
#~line 109 lymph.N <- as.matrix(lymph.depth[,which(grepl('PD', names(lymph.depth)))]) from names(lymph.var) as the non-matching order from input files from Stan's example is a problem now

#############################################
## -- Library loading and sourcing --

library(RColorBrewer)
library(label.switching)
library(philentropy)
library(ggplot2)
library(GGally)
library(dplyr)
library(data.table)
library(here)

library(foreach)
library(doMC)
registerDoMC(cores=4) #Stan set 10
library(lpSolve)

repo_location = '/nfs/users/nfs_s/sg18/Scripts/Prostate/DirichletClustering'
source(file.path(repo_location, 'Mutation_Cluster_Dirichlet_Gibbs_sampler_functions.R'))
source(file.path(repo_location, 'Mutation_Cluster_Dirichlet_posthoc_merge_fx.R'))
source(file.path(repo_location, 'label.switching.v2.R'))

#Load clustering results before label switching
args = commandArgs(trailingOnly=TRUE)
args 
Cluster_Res <- as.character(args[1]) #example: /lustre/scratch119/casm/team176tv/sg18/Prostate/ResultsSortedByMorphologicalStructure/Structure3/DirichletClustering/ndp_2019_04_28_tftjq/Rsession.dat"
load(Cluster_Res)
number.burn.in = 30000

# Correct label switching phenomenon
lymph.ls <- correct.label.switch(lymph.gs, method.set = c("ECR"), burn.in = number.burn.in)
ls_tbl = tibble(clust_assign = as.numeric(lymph.ls$clusters)) %>%
  mutate(mut_id = row_number())
fwrite(ls_tbl, file.path(output_dir, 'clust_assign.csv'))

saveRDS(lymph.ls, file.path(output_dir, 'object_lymph.ls.dat'))
save.image(file.path(output_dir, 'Rsession_ls.dat'))

#############################################

# Merge clusters which differ only at level of sequencing errors

lymph.merge.ls <- merge.clusters.differ.by.seq.error(lymph.gs, lymph.ls, min.true.VAF = 0.025, overlap.frac=0.025, min.num.muts = 20, ls.type="ECR", number.burn.in, version=2)
ls_tbl = tibble(clust_assign = as.numeric(lymph.merge.ls$final.cluster)) %>%
  mutate(mut_id = row_number())
ls_tbl$chrom = lymph.depth$chrom
ls_tbl$pos = lymph.depth$pos
fwrite(ls_tbl, file.path(output_dir, 'clust_assign_posthoc.csv'))
saveRDS(lymph.merge.ls, file.path(output_dir, 'object_lymph.merge.ls.dat'))

#############################################

# Final spectrum and cluster location plots
pdf(file.path(output_dir, "Cluster_and_spectrum_plots.pdf"), paper="a4", width = 8, height=10)

par_min.threshold = 10
post.cluster.pos <- post.param.dist_posthoc(gs.out = lymph.gs, ls.merge.out = lymph.merge.ls, 
                                    centiles = c(0.025, 0.5, 0.975), ls.type = "ECR", 
                                    burn.in = number.burn.in, samp.names = short.names, 
                                    plot.heatmap = TRUE, min.threshold = par_min.threshold)  

mut.spec.by.clust <- context.extract_posthoc(mut.spec, lymph.merge.ls)

dev.off()

saveRDS(post.cluster.pos, file.path(output_dir, 'object_post.cluster.pos.dat'))

## Write heatmap data to disk
cluster_tbl = tbl_df(post.cluster.pos$heat.dat*2)
cluster_tbl$cluster_id = rownames(post.cluster.pos$heat.dat)
cluster_tbl$estimated.no.of.mutations = as.numeric(post.cluster.pos$num.mut[which(post.cluster.pos$num.muts>=par_min.threshold)])
cluster_tbl$no.of.mutations.assigned = cluster_tbl$estimated.no.of.mutations

# Add a root node 
heatmap_tbl = rbind(cluster_tbl %>% dplyr::select(-cluster_id),
                    c(rep(1, dim(post.cluster.pos$heat.dat)[2]), sum(cluster_tbl$no.of.mutations.assigned), max(cluster_tbl$no.of.mutations.assigned)))

fwrite(heatmap_tbl, file.path(output_dir, 'heatmap.tsv'), sep='\t')

## Export a table with mutations per cluster
mut_per_cluster = tibble(cluster_id = names(post.cluster.pos$num.mut), num_mut = post.cluster.pos$num.mut)
fwrite(mut_per_cluster, file.path(output_dir, 'muts_per_cluster.csv'))

## Export a heatmap table that includes cluster IDs
fwrite(cluster_tbl %>% dplyr::select(-estimated.no.of.mutations), file.path(output_dir, 'cluster_and_samples.csv'))


#############################################

# Density plots of clusters with at least 100 mutations
pdf(file.path(output_dir, "Raw_mutation_VAF_by_cluster_plots.pdf"), width = 8, height = 10)

mut_threshold = 10

which.clusters <- as.double(names(which(table(lymph.merge.ls[["final.cluster"]]) >= mut_threshold)))

for (i in which.clusters) {
  temp.plot <- cluster.density.plot_posthoc(lymph.gs, lymph.merge.ls, post.cluster.pos, i, samp.names = short.names)
  print(temp.plot)
}

dev.off()

#############################################

# Boxplot of VAFs per sample/cluster using 95.0% centiles (as conf. intervals)
# Added by Fede (fa8) / changed by sg18
final_clusters <- unique(ls_tbl$clust_assign)
#restrict to minimal size
final_clusters_length <- c()
for(cluster_index in final_clusters) {
  num_muts_in_cluster <- length(which(ls_tbl$clust_assign==cluster_index))
  if(num_muts_in_cluster >= 10 ){
    final_clusters_length <- append(final_clusters_length,cluster_index)
  }
}
final_clusters <- sort(final_clusters_length)
samples        <- names(post.cluster.pos$centiles[1,,1])
num_muts       <- length(ls_tbl$clust_assign)
colores        <- rainbow(length(final_clusters))

pdf(file.path(output_dir, "NoMutSize_Cluster_cellular_prevalences.pdf"), width = 25, height=6)
for(sample in samples) {
  #par(mfrow=c(length(samples),1))
  par(mar=c(3,5,1,3))
  plot(NULL,NULL,xlim=c(0,1000),ylim=c(0,1.1),xaxt='n',xlab="",ylab="Cell. prev")
  title(sample, line = -1)
  for(h in c(.1,.2,.3,.4,.5,.6,.7,.8,.9)) {
    abline(h=h,col="gray"); 
  }
  xpos  <- 0
  increment <- (1000 / length(final_clusters)) / 2
  index <- 1
  for(cluster_index in final_clusters) {
    centiles <- post.cluster.pos$centiles[cluster_index,sample,]
    centiles <- centiles * 2 # cellular prevalence
    #num_muts_in_cluster <- length(which(ls_tbl$clust_assign==cluster_index))
    #rect(xleft, ybottom, xright, ytop, density = NULL, angle = 45,
    #     col = NA, border = NULL, lty = par("lty"), lwd = par("lwd"),
    #     ...)
    rect(xpos,centiles[1],xpos+increment,centiles[3],col=colores[index])
    lines(c(xpos,xpos+increment),c(centiles[2],centiles[2]),col="black",lwd=2)
    text((xpos + xpos + increment)/2,centiles[2]+0.075,cluster_index)
    xpos  <- xpos  + (2*increment)
    index <- index + 1 
  }
}
dev.off()

save.image(file.path(output_dir, 'Rsession_ls2.dat'))
