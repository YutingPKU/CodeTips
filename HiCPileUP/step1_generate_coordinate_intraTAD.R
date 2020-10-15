##################################################
## Project: ctcf dynamics
## Script purpose: calculate all the cis combination coordinates for pair-interactions
## Date: 2020-10-10
## Author: Yuting Liu
##################################################

## Section: set env
##################################################
library(data.table)
library(reshape)
setwd("/lustre/user/liclab/liuyt/ChenQ/Figures/CTCF-diffBD-WTGMvsWTDM")


## Section: load the  two regions and tad positions
##################################################
df <- fread('../../ChIP/data/DiffBD/CTCF/CTCF.notDiffBD.WT-GMvsWT-DM.log2FC1.PValue001.bed')
colnames(df) <- c('chr', 'start', 'end')
df$mid <- (df$start + df$end)/2
df$indx <- ceiling(df$mid/5000)

#df2 <- fread('../../ChIP/peaks/WT-GM-K4me3_peaks.narrowPeak.intersect.Ensembl.TSS.up2kdown2k.bed')
df2 <- fread('../../ChIP/data/DiffBD/CTCF/CTCF.notDiffBD.WT-GMvsWT-DM.log2FC1.PValue001.bed')
df2 <- df2[,1:3]
colnames(df2) <- c('chr', 'start', 'end')
df2$mid <- (df2$start + df2$end)/2
df2$indx <- ceiling(df2$mid/5000)

tad <- fread('../../HiC/basicData/Boundaries/InsulationScore/wholegenome/TAD/WT_DM.allValidPairs_wholegenome_40kb_KR_insulation.boundaries.bed.40kbmergeBoundaries.TAD.40kb.to.10Mb.bed')
colnames(tad) <- c('chr', 'start', 'end')
tad$id <- seq(1, nrow(tad))
tad$id <- paste0('TAD', tad$id)

## Section: assign regions to tad
##################################################
df.gr <- makeGRangesFromDataFrame(df)
df2.gr <- makeGRangesFromDataFrame(df2)
tad.gr <- makeGRangesFromDataFrame(tad, keep.extra.columns = T)

comm1 <- findOverlaps(df.gr, tad.gr, select = 'first')
comm2 <- findOverlaps(df2.gr, tad.gr, select = 'first')

df$tad <- tad$id[comm1]
df2$tad <- tad$id[comm2]


chr.ls <- unique(df$chr)



getExpand <- function(chr){
  loci <- which(df$chr == chr)
  df.x <- df[loci,]
  loci <- which(df2$chr == chr)
  df.y <- df2[loci,]
  
  expand.df <- reshape::expand.grid.df(df.x, df.y)
  colnames(expand.df) <- c(paste0(colnames(df), "x"), paste0(colnames(df), "y"))
  expand.df$tadx <- as.character(expand.df$tadx)
  expand.df$tady <- as.character(expand.df$tady)
  
  expand.df <- expand.df[which(expand.df$tadx == expand.df$tady), ]
  expand.df <- expand.df[which(expand.df$indxx > expand.df$indxy), ] # for self interactions
  return(expand.df)
  
}

coord.ls <- lapply(chr.ls, getExpand)

coord.bed <- Reduce("rbind", coord.ls)

## for ctcf and e/p
#write.table(coord.bed, file = 'data/HiC-Pileup/CisCoordinates_intraWTGMTAD_between_CTCF.WT-DMvsWT-GM.downinDM.log2FC1.PValue001_vs_WT-GM-K4me3_peaks.narrowPeak.intersect.Ensembl.TSS.up2kdown2k.txt',
#            row.names = F, col.names = F, quote = F, sep ='\t')
#write.table(coord.bed[, c(1:3,7:9)], file = 'data/HiC-Pileup/CisCoordinates_intraWTGMTAD_between_CTCF.WT-DMvsWT-GM.downinDM.log2FC1.PValue001_vs_WT-GM-K4me3_peaks.narrowPeak.intersect.Ensembl.TSS.up2kdown2k.bedpe',
#            row.names = F, col.names = F, quote = F, sep ='\t')

## for ctcf self interactions
write.table(coord.bed, file = 'data/HiC-Pileup/CisCoordinates_selfinteractions_intraWTDMTAD_between_CTCF.notDiffBD.WT-GMvsWT-DM.log2FC1.PValue001.txt', 
            row.names = F, col.names = F, quote = F, sep ='\t')
write.table(coord.bed[, c(1:3,7:9)], file = 'data/HiC-Pileup/CisCoordinates_selfinteractions_intraWTDMTAD_between_CTCF.notDiffBD.WT-GMvsWT-DM.log2FC1.PValue001.bedpe', 
            row.names = F, col.names = F, quote = F, sep ='\t')
#write.table(tad, file = 'data/HiC-Pileup/WT_GM.allValidPairs_wholegenome_40kb_KR_insulation.boundaries.bed.40kbmergeBoundaries.TAD.40kb.to.10Mb.bed',
#            row.names = F, col.names = F, quote = F, sep = '\t')