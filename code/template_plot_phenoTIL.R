library(R.matlab)
library(survcomp)
library(Gmisc)
library(skimr)
library(Hmisc)
library(boot) 
library(table1)
require("survival")
library(survminer)
library(gsubfn)
library(ggplot2)
library(ggnetwork)
library(ggforce)
library(waffle)
library(ggpubr)
library(uwot)
library(gridExtra)
library(grid)
library(cowplot)
library(lattice)
library("ggsci")
library(tidyverse)
library(colourlovers)
library(dplyr)
library(RColorBrewer)
library(hexbin)
library(viridis)
library(patchwork)
library(hrbrthemes)
library(circlize)
library(chorddiag)
library(TCGAWorkflowData)
library(DT)
library(TCGAbiolinks)
library(ggcorrplot)
library(ComplexHeatmap)
library(colorspace)
library(GetoptLong)
library('caret')
library(pheatmap)
library(EDASeq)
library(RColorBrewer)
library(GISTools)

# Plot Kaplan-Meier plots found in Figure 2
# Load the files
dataset <- read.csv('data/R/test_ac_data.csv')

# KM plot
# Survival fit curve
# Riskbin = Output binary of the risk scores (1 = high risk, 0 = low risk)
# OS = Overall Survival (months)
# OSCensor = Censor vector for the OS; 0 = Alive; 1 = Dead
train_os_dataset_ac <- survfit(Surv(OS, OSCensor) ~ Riskbin, data = dataset)
# Hazard Ratio
# Cox proportional Hazard ratio
res.cox <- coxph(Surv(OS, OSCensor) ~ Riskbin, data = dataset)
sum_res <- summary(res.cox)
# Hazard ratio
HR <- round(sum_res$conf.int[1],2)
# lower interval
lowinter <-round(sum_res$conf.int[3],2)
# upper interval
upperinter <- round(sum_res$conf.int[4],2)
# number of cases
nn <- length(dataset$ID)
# p-value
pvall <- round(sum_res$sctest[3],3)
# ggplot plot style
train_os_dataset_km <- ggsurvplot(
  train_os_dataset_ac,        # survfit object with calculated statistics.
  data = dataset,            # data used to fit survival curves.
  risk.table = "nrisk_cumcensor",       # show risk table.
  pval = paste0("p = ",pvall," \n HR = ",HR," (",lowinter,"; ",upperinter," ) \n n = ",nn),
  conf.int = TRUE,         # show confidence intervals for point estimates of survival curves.
  xlim = c(0,60),         # present narrower X axis, but not affect survival estimates. 0 to 60 months.
  xlab = "Months after diagnosis",   # customize X axis label.
  ylab = "Probability of \n overall survival",   # customize X axis label.
  break.time.by = 12,     # break X axis in time intervals by 12 months.
  ggtheme = theme_classic( ), # customize plot and risk table with a theme.
  risk.table.y.text.col = T,# colour risk table text annotations.
  risk.table.height = 0.25, # the height of the risk table
  risk.table.y.text = TRUE,# show bars instead of names in text annotations
  # in legend of risk table.
  ncensor.plot = TRUE,      # plot the number of censored subjects at time t
  ncensor.plot.height = 0.25,
  title = expression('KM plot - UBern AC (OS)'),
  conf.int.style = "ribbon",  # customize style of confidence intervals
  conf.int.alpha = 0.15,
  surv.median.line = "hv",  # add the median survival pointer.
  legend.labs =
    c("High-Risk", "Low-risk")    # change legend labels.
)
# plot the KM
# Save in size 700x700 (width x length) and two formats EPS and SVG for using in Adobe Illustrator
train_os_dataset_km

# Concordance Index
cindx <- concordance.index(x=dataset$Riskbin, surv.time=dataset$OS, surv.event = dataset$OSCensor, method="noether")
# Lower interval
cindx$lower
# CI
cindx$c.index
# upper interval
cindx$upper
# associated p-value
cindx$p.value
# Standard error
cindx$se

# Plot image style found in Figure 5 and Figure 6
load(file = '/data/R/dataset_final.Rda')

d1nsclc_cell_acolr_clus <- brewer.pal(n=8,"Set3")

dffinal$cluster_type_color <- dffinal$cluster_type
dffinal$cluster_type_color[dffinal$cluster_type == 'C1'] <- colr_clus[1]
dffinal$cluster_type_color[dffinal$cluster_type == 'C2'] <- colr_clus[2]
dffinal$cluster_type_color[dffinal$cluster_type == 'C3'] <- colr_clus[3]
dffinal$cluster_type_color[dffinal$cluster_type == 'C4'] <- colr_clus[4]
dffinal$cluster_type_color[dffinal$cluster_type == 'C5'] <- colr_clus[5]
dffinal$cluster_type_color[dffinal$cluster_type == 'C6'] <- colr_clus[6]
dffinal$cluster_type_color[dffinal$cluster_type == 'C7'] <- colr_clus[7]
dffinal$cluster_type_color[dffinal$cluster_type == 'C8'] <- colr_clus[8]

sp <- ggplot(dffinal, aes(x = round(x_pos_patch), y = round(y_pos_patch), 
      color = cluster_type)) + geom_point(size = 1) + scale_color_manual(breaks = c("C1", "C2", "C3","C4","C5","C6","C7","C8"), 
      values=colr_clus) + guides(colour = guide_legend(override.aes = list(size=4))) + theme_linedraw() + guides(colour = guide_legend(override.aes = list(size=4))) +   labs(title = "phenoTIL cluster at WSI level - Ubern - Case 141 \n",
      x = "pixel (px)", y = "pixel (px)", color = "Cluster\n")
sp

# Density plot - 1
ggplot(dffinal, aes(x = round(x_pos_patch), y = round(y_pos_patch))) +
  stat_density_2d(aes(fill = ..density..), geom = "raster", contour = FALSE, show.legend=TRUE) +
  scale_fill_distiller(palette= "Spectral", direction=-1) +
  scale_x_continuous(expand = c(0, 0)) +
  scale_y_continuous(expand = c(0, 0))

# density plot - 2
ggplot(dffinal, aes(x = round(x_pos_patch), y = round(y_pos_patch))) + stat_density_2d(aes(alpha = ..level.., fill = cluster_main), geom = "polygon", bins = 20) + scale_alpha_continuous(range = c(0, 1)) + ylim(75000,145000) + xlim(5000,75000) + theme_linedraw()
# density plot - 3
ggplot(dffinal, aes(x = round(x_pos_patch), y = round(y_pos_patch))) + stat_density_2d(aes(alpha = ..level.., fill = cluster_type), geom = "polygon", bins = 20) + scale_alpha_continuous(range = c(0, 1.0)) + ylim(70000,145000) + xlim(5000,75000) + theme_linedraw() + scale_fill_manual(values=c("#8DD3C7", "#FFFFB3", "#BEBADA", "#FB8072", "#80B1D3", "#B3DE69", "#FCCDE5"))



# Plots from figure 3
ac_v1 <- read.csv('/data/R/clus_cdx_ac_v1.csv')

mat_val <- cor(ac_v1[,c(13:15)],ac_v1[,c(2:9)])

df = data.frame(from = rep(rownames(mat_val), times = ncol(mat_val)),
                to = rep(colnames(mat_val), each = nrow(mat_val)),
                value = as.vector(mat_val),
                stringsAsFactors = FALSE)

grid.col = c(C1 = "#8dd3c7", C2 = "#ffffb3", C3 = "#bebada", C4 = "#fb8072", C5 = "#80b1d3", C6 = "#fdb462", C7 = "#b3de69", C8 = "#fccde5")
grid.row = c(CD4 = "#fc8d62", CD8 = "#8da0cb", CD20 = "#66c2a5")
grid.col = c(C1 = "#8dd3c7", C2 = "#ffffb3", C3 = "#bebada", C4 = "#fb8072", C5 = "#80b1d3", C6 = "#fdb462", C7 = "#b3de69", C8 = "#fccde5", CD4 = "#fc8d62", CD8 = "#8da0cb", CD20 = "#66c2a5")

# Base plot
# parameters
circos.clear()
circos.par(start.degree = 90, gap.degree = 4, track.margin = c(-0.1, 0.1), points.overflow.warning = FALSE)
par(mar = rep(0, 4))

# Base plot
circos.clear()
circos.par(start.degree = 90)
chordDiagram(df, grid.col = grid.col, big.gap = 20, transparency = 0.50, annotationTrack = c("name", "grid"), directional = 1)
abline(v = 0, lty = 2, col = "#00000080")

# Base plot - CDx
mat_val_cd <- cor(ac_v1[,c(13:15)])
mat_val_cd[mat_val_cd==1] <- 0
dfcdx = data.frame(from = rep(rownames(mat_val_cd), times = ncol(mat_val_cd)),
                   to = rep(colnames(mat_val_cd), each = nrow(mat_val_cd)),
                   value = as.vector(mat_val_cd),
                   stringsAsFactors = FALSE)

circos.clear()
circos.par(start.degree = 90)
chordDiagram(dfcdx, grid.col = grid.col, big.gap = 20, transparency = 0.50, annotationTrack = c("name", "grid"), directional = 1)

# Important Clusters - AC
mat_val_clusimport <- cor(ac_v1[,c(13:15)],ac_v1[,c(2,5,7)])

dfclusimport = data.frame(from = rep(rownames(mat_val_clusimport), times = ncol(mat_val_clusimport)),
                          to = rep(colnames(mat_val_clusimport), each = nrow(mat_val_clusimport)),
                          value = as.vector(mat_val_clusimport),
                          stringsAsFactors = FALSE)
# parameters
circos.clear()
circos.par(start.degree = 90, gap.degree = 4, track.margin = c(-0.1, 0.1), points.overflow.warning = FALSE)
par(mar = rep(0, 4))

# Base plot
circos.clear()
circos.par(start.degree = 90)
chordDiagram(dfclusimport, grid.col = grid.col, big.gap = 20, transparency = 0.50, annotationTrack = c("name", "grid"), directional = 1)
abline(v = 0, lty = 2, col = "#00000080")


# Plots from FIgure 7
query.expluad <- GDCquery(project = "TCGA-LUAD", 
                          legacy = TRUE,
                          data.category = "Gene expression",
                          data.type = "Gene expression quantification",
                          platform = "Illumina HiSeq", 
                          file.type = "results",
                          experimental.strategy = "RNA-Seq",
                          sample.type = c("Primary Tumor","Solid Tissue Normal"))
GDCdownload(query.expluad)
luad.exp <- GDCprepare(query = query.expluad, save = TRUE, save.filename = "luadExp.rda")

dataPrep_luad <- TCGAanalyze_Preprocessing(object = luad.exp, cor.cut = 0.6)
dataNorm_luad <- TCGAanalyze_Normalization(tabDF = dataPrep_luad,geneInfo = geneInfo,method = "gcContent")
dataFilt_luad <- TCGAanalyze_Filtering(tabDF = dataNorm_luad,method = "quantile",qnt.cut =  0.25)

d1ac <- read.table(file = "/data/d5_clus_acc_ver1.csv", header = TRUE, sep = ",")


# Example for LUAD
colnames(dataFilt_luad) <- luad.exp$patient
dataFilt_luad_sub <- subset(dataFilt_luad, select = unique(colnames(dataFilt_luad)))

colnam_luad <- colnames(dataFilt_luad_sub)
sub_luad_clus <- subset(dataFilt_luad_sub, select = colnam_luad %in% d1ac$ID)
# Make sure both share same column name
d1ac_sub <- d1ac[d1ac$ID %in% unique(colnames(sub_luad_clus)),]
rownames(d1ac_sub) <- d1ac_sub$ID
d1ac_sub <- d1ac_sub[,c(2:9)]
# sort both by column name, or case/patient
d1ac_sub_dt <- data.frame(matrix(unlist(d1ac_sub), nrow=length(d1ac_sub), byrow=T))
colnames(d1ac_sub_dt) <- rownames(d1ac_sub)
rownames(d1ac_sub_dt) <- colnames(d1ac_sub)
d1ac_sub_dt <- t(d1ac_sub_dt)


# curernt genes
gene_names <- rownames(sub_luad_clus)
# Filter out the genes that has correlation with immune resposne
# genes https://www.ncbi.nlm.nih.gov/pmc/articles/PMC3570049/
# genes HLA (IL12B, IL12RB1, IL2, IL10) CD46 CD28
genes <- c("HLA","IL12B", "IL12RB1", "IL2", "IL10", "CD46", "CD28", "CD8","EGFR")
sub_luad_gene <- sub_luad_clus[gene_names %in% gene_names[1:600],]
all_luad_gene <- sub_luad_clus[gene_names %in% gene_names,]
sub_luad_gene_dt <- t(as.data.frame(sub_luad_gene))
all_luad_gene_dt <- t(as.data.frame(all_luad_gene))
rcorr_sol <- cor(sub_luad_gene_dt, d1ac_sub_dt, method='pearson')
all_rcorr_sol <- cor(all_luad_gene_dt, d1ac_sub_dt, method='pearson')

# Filter out the genes that shows most positive value or corr
all_cor_mat <- all_rcorr_sol[apply(all_rcorr_sol, 1, function(x) any(x > 0.5*max(all_rcorr_sol) | x < 0.5*min(all_rcorr_sol)) ),
                             apply(all_rcorr_sol, 2, function(x) any(x > 0.5*max(all_rcorr_sol) | x < 0.5*min(all_rcorr_sol)) )]
curr_gene_luad <- rownames(all_cor_mat)

heat_out_luad <- pheatmap(all_cor_mat, show_rownames = FALSE, main = "LUAD - Gene correlatlion with clusters", color = rev(brewer.pal(n = 10, name = "Spectral")), cluster_cols=TRUE, cex=1,clustering_distance_rows = "euclidean",cex=1, clustering_distance_cols = "euclidean", clustering_method = "complete",border_color = FALSE)

plot(heat_out_luad$tree_row)
abline(h=0.5, col="red", lty=2, lwd=2)
gene_clus_group <- sort(cutree(heat_out_luad$tree_row, h=0.5))
library(plyr)
gene_clus_group_name <- colnames(t(gene_clus_group))
gene_clus_group_cn <- count(gene_clus_group)$freq

annotation_row2 = data.frame(GeneClass = factor(rep(c("NRF2-mediated Oxidative Stress Response","4-1BB signaling in T-lymphocytes","IL-6 and IL-9 signaling","NRF2-mediated Oxidative Stress Response","NRF2-mediated Oxidative Stress Response"), c(gene_clus_group_cn))))
rownames(annotation_row2) = gene_clus_group_name
#
heat_out_luad <- pheatmap(all_cor_mat, show_rownames = FALSE, main = "LUAD - Cluster correlation with gene expression", color = rev(brewer.pal(n = 10, name = "Spectral")), cluster_cols=TRUE, cex=1,clustering_distance_rows = "euclidean",cex=1, clustering_distance_cols = "euclidean", clustering_method = "complete",border_color = FALSE, annotation_row = annotation_row2)

# Identify the OG pathway of those groups 
group_gene_c1 <- gene_clus_group_name[gene_clus_group==1]
group_gene_c2 <- gene_clus_group_name[gene_clus_group==2]
group_gene_c3 <- gene_clus_group_name[gene_clus_group==3]
group_gene_c4 <- gene_clus_group_name[gene_clus_group==4]
group_gene_c5 <- gene_clus_group_name[gene_clus_group==5]

ansEAclus <- TCGAanalyze_EAcomplete(TFname="LUAD - Cluster vs Gene expression",
                                    RegulonList = c(group_gene_c1,group_gene_c4,group_gene_c5))

luad_gene_group1 <- c(group_gene_c1,group_gene_c4,group_gene_c5)
luad_gene_group2 <- c(group_gene_c2)
luad_gene_group2 <- c(group_gene_c2)
luad_gene_group3 <- c(group_gene_c3)

TCGAvisualize_EAbarplot(tf = rownames(ansEAclus$ResBP),
                        filename = NULL,
                        GOBPTab = ansEAclus$ResBP,
                        GOCCTab = ansEAclus$ResCC,
                        GOMFTab = ansEAclus$ResMF,
                        PathTab = ansEAclus$ResPat,
                        nRGTab =  c(group_gene_c1,group_gene_c4,group_gene_c5),
                        nBar = 20,
                        text.size = 0.7)

ansEAclus <- TCGAanalyze_EAcomplete(TFname="LUAD - Cluster vs Gene expression",
                                    RegulonList = group_gene_c2)  

TCGAvisualize_EAbarplot(tf = rownames(ansEAclus$ResBP),
                        filename = NULL,
                        GOBPTab = ansEAclus$ResBP, 
                        GOCCTab = ansEAclus$ResCC,
                        GOMFTab = ansEAclus$ResMF,
                        PathTab = ansEAclus$ResPat,
                        nRGTab =  group_gene_c2,
                        nBar = 20,
                        text.size = 0.7)

colorset <- brewer.pal(n=4,"Pastel2")
colorset<- add.alpha(brewer.pal(n=7,"Set3"),0.4)
colorset <- colorset[c(1,3,5,7)]

ansEAclus <- TCGAanalyze_EAcomplete(TFname="LUAD - Cluster vs Gene expression",
                                    RegulonList = gene_clus_group_name)  

TCGAvisualize_EAbarplot(tf = rownames(ansEAclus$ResBP),
                        filename = NULL,
                        GOBPTab = ansEAclus$ResBP, 
                        GOCCTab = ansEAclus$ResCC,
                        GOMFTab = ansEAclus$ResMF,
                        PathTab = ansEAclus$ResPat,
                        nRGTab =  gene_clus_group_name,
                        nBar = 20,
                        text.size = 0.7,
                        color = colorset)
