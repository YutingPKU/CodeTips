##################################################
## Project: most useful ploting functions
## Script purpose: boxplot group by a factor, add numbers and median values for group element
## Date: 2020-12-07
## Author: Yuting Liu
##################################################

## Section: set envs
##################################################
library(data.table)
library(ggpubr)


## Section: test data
##################################################
setwd("/lustre/user/liclab/liuyt/ChenQ/Figures/CTCF-diffBD-MKOGMvsMKODM")
file.ls <- list.files('data/HiC-Pileup/LocalInsulation/', pattern = "CTCF.WT-DMvsMKO-DM", full.names = T)
fc.ls <- lapply(file.ls, function(f){
  load(f)
  s.ls <- unlist(lapply(scores.ls, function(vec){
    vec = vec[which(!is.na(vec))]
    return(vec)
  }))
  return(s.ls)
})

mkogm.d <- fc.ls[[1]]
mkogm.s <- fc.ls[[2]]


## Section: generate the dataframe 
##################################################
df <- data.frame(cbind('type' = c(rep('WTGM',length(mkogm.d)), rep('MKOGM', length(mkogm.s))), 
                       'value' = c(mkogm.d, mkogm.s)))
df$type <- factor(df$type, levels = c('WTGM','MKOGM'))
df$value <- as.numeric(as.character(df$value))


## Section: seting plot parameters
##################################################
my_comparisons <- list(c('WTGM','MKOGM'))
stat_box_data <- function(y, upper_limit = quantile(df$value, 0.50) ) {
 return(  data.frame( y = upper_limit,
          label = paste('count =', length(y), '\n','mean =', round(mean(y), 3), '\n')))
}

fontsize = 4
linesize = 1

#pdf('test.boxplot.pdf', width = 2.5, height = 2.5)
ggboxplot(df, x = "type", y = "value", 
          color = 'type', size = .3, font.label = list(size = fontsize), outlier.shape = NA)+ 
  stat_summary(fun.data = stat_box_data, geom = "text", hjust = 0.5,vjust = 0.9)+
  theme(legend.position = "none", axis.ticks.x = element_blank())+
  stat_compare_means(comparisons = my_comparisons, label.y = c(10),method = 't.test', size = 2) +
  ylab('Insulation Strength (15kb)')+ xlab('Decreased Peaks')+ ggtitle(label = "")+ # labs 
  coord_cartesian(ylim = c(-25,25))+
  scale_color_manual(values = c('WTGM' ='chartreuse3' , 'MKOGM' = 'coral3')) # colors 
#dev.off()





