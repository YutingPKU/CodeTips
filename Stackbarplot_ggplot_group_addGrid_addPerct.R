##################################################
## Project: most useful ploting functions
## Script purpose: stackedbarplot group by a factor, add grid lines, add percentages
## Date: 2020-12-07
## Author: Yuting Liu
##################################################

## Section: set envs
##################################################
setwd("/lustre/user/liclab/liuyt/ChenQ/ChIP/")



## Section: calculate by peak numbers
##################################################
f.ls <- list.files('data/PeakAnnotate/WTvsMKO/', pattern = "genomeOnto.txt", recursive = T, full.names = T)
f.ls <- f.ls[grep('K27ac', f.ls)]
# calculate ratio by peak number
getPerct <- function(file){
  f <- fread(file, header = T)
  n1 <- length(which(abs(f$`Distance to TSS`) < 2000) )
  n2 <- length(grep("5' UTR", f$Annotation))
  n3 <- length(grep("3' UTR", f$Annotation))
  n4 <- length(grep("TTS", f$Annotation))
  n5 = length(grep('exon', f$Annotation))
  n6 = length(grep('intron', f$Annotation))
  n7 = length(grep('Intergenic', f$Annotation))
  pct <- c(n1,n2,n3,n4,n5,n6,n7)
  pct <- pct/sum(pct)
  return(pct)
}

pct.ls <- lapply(f.ls, getPerct)

# freq mat
mat <- data.frame(cbind(type = rep(c( 'Stable', 'Decreased', 'Increased'), each = 7) , 
                        deg = rep(c('promoters','utr5','utr3','tts','exons','introns','intergenic'),3), 
                        value = c(pct.ls[[1]], pct.ls[[3]], pct.ls[[4]])))
mat$value <- as.numeric(as.character(mat$value))
mat$deg <- factor(mat$deg, levels = c('promoters','utr5','utr3','tts','exons','introns','intergenic'))
mat$type <- factor(mat$type, levels = c('Stable', 'Decreased', 'Increased'))

## Section: plot genome distribution calculated by length/peak numbers
##################################################
linesize = .35
fontsize = 10
#pdf('test.pdf', width = 4.3, height = 3)
ggplot(mat, aes(fill=deg, y=value, x=type)) + 
  geom_bar(position="stack", stat="identity")+
  scale_fill_brewer(palette = "Dark2")+
  geom_text(aes(label = paste0(round(value,4)*100,"%")), 
            position = position_stack(vjust = 0.5), size = 2)+
  scale_y_continuous(breaks = seq(0,1,0.1), expand = c(0,0), name = 'Percentage')+
  scale_x_discrete(labels = c('WTDM', 'MKODM', 'MKO\ndecreased', 'MKO\nincreased'))+
  theme_bw()+
  theme( panel.grid.major.x = element_blank(), panel.grid.major.y = element_line( size= linesize, colour = 'black' ),
         panel.grid.minor = element_blank(),
         strip.background = element_blank(),panel.border = element_rect(size = linesize),
         axis.ticks = element_blank(), axis.title.x = element_blank())

ggplot(mat, aes(fill=deg, y=value, x=type)) + 
  geom_bar(position="stack", stat="identity")+
  scale_fill_brewer(palette = "Dark2", name = 'Features')+
  scale_y_continuous(breaks = seq(0,1,0.1), expand = c(0,0), name = 'Percentage')+
#  scale_y_continuous(breaks = seq(0,1,0.1), name = 'Percentage')+
  scale_x_discrete(labels = c('WTDM', 'MKODM', 'MKO\ndecreased', 'MKO\nincreased'))+
  theme_bw()+
  theme( panel.grid.major.x = element_blank(), panel.grid.major.y = element_line( size= linesize, colour = 'black' ),
         panel.grid.minor = element_blank(),
         strip.background = element_blank(),panel.border = element_rect(size = linesize),
         axis.ticks = element_blank(), axis.title.x = element_blank())

ggplot(mat, aes(fill=deg, y=value, x=type)) + 
  geom_bar(position="stack", stat="identity")+
  scale_fill_brewer(palette = "Dark2", name = 'Features')+
  scale_y_continuous(breaks = seq(0,1,0.1), name = 'Percentage')+
  scale_x_discrete(labels = c('WTDM', 'MKODM', 'MKO\ndecreased', 'MKO\nincreased'))+
  theme_bw()+
  theme( panel.grid.major.x = element_blank(), panel.grid.major.y = element_blank(),
         panel.grid.minor = element_blank(),
         strip.background = element_blank(),panel.border = element_rect(size = linesize),
         axis.ticks = element_blank(), axis.title.x = element_blank())
