##################################################
## Project: most useful ploting functions
## Script purpose: barplot group by a factor
## Date: 2020-12-07
## Author: Yuting Liu
##################################################

## Section: set envs
##################################################
library(data.table)
library(ggpubr)


## Section: test data
##################################################
mat <- data.frame(type = c('DeCTCF-WithMYOD', 'DeCTCF-WithouTMYOD', 'StCTCF-WithMYOD loops', 'StCTCF-WithoutMYOD loops'), 
                  value = c(432/1105, 249/1048, 2483/7829, 5915/38025))
mat$type = factor(mat$type, levels = c('DeCTCF-WithMYOD', 'DeCTCF-WithouTMYOD', 'StCTCF-WithMYOD loops', 'StCTCF-WithoutMYOD loops'))
mat$value <- mat$value * 100


## Section: seting plot parameters
##################################################
fontsize = 10
linesize = 0.35


# with border
ggplot(mat, aes(x = type, y = value)) +
  geom_bar(aes(fill = type), stat = "identity", width = 0.5,position = "dodge") +
  theme_bw() +
  theme(panel.grid.major = element_blank(),panel.grid.minor = element_blank(),strip.background = element_blank())+
  theme(text = element_text(size = fontsize), line = element_line(size = linesize),
        axis.ticks.length = unit(.1, "cm"), axis.ticks.x = element_blank(), 
        plot.title = element_text(size=2, hjust = 0.5),
        legend.position = "none") +
  ylab('Insulation Strength (15kb)')+ xlab('Decreased Peaks')+ ggtitle(label = "")+ # labs 
  coord_cartesian(ylim = c(0,50))+
  scale_color_manual(values = c('WTGM' ='chartreuse3' , 'MKOGM' = 'coral3')) # colors 


#without border frame
ggplot(mat, aes(x = type, y = value)) +
  geom_bar(aes(fill = type), stat = "identity", width = 0.5,position = "dodge") +
  theme_bw() +
  theme(panel.grid.major = element_blank(),panel.grid.minor = element_blank(),
        strip.background = element_blank(),panel.border = element_blank())+
  theme(text = element_text(size = fontsize), line = element_line(size = linesize),
        axis.ticks.length = unit(.1, "cm"), axis.ticks.x = element_blank(), 
        axis.line = element_line(colour = "black", size = linesize),
        plot.title = element_text(size=2, hjust = 0.5),
        legend.position = "none") +
  ylab('Insulation Strength (15kb)')+ xlab('Decreased Peaks')+ ggtitle(label = "")+ # labs 
  coord_cartesian(ylim = c(0,50))+
  scale_color_manual(values = c('WTGM' ='chartreuse3' , 'MKOGM' = 'coral3')) # colors 

