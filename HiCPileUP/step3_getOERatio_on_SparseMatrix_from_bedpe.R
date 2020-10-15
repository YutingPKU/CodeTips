##################################################
## Project: ctcf dynamics
## Script purpose: get the submatrix based on bedpe location
## Date: 2020-10-12
## Author: Yuting Liu
##################################################

## Section: preparation work
##################################################
# using juicer Dump to extract sparse o/e matrix on 3kb resolution

## Section: set env
##################################################
library(data.table)

## Section: load positions
##################################################
args <- commandArgs(TRUE)


bed <- fread(args[1])
colnames(bed) <- c('chrx','startx', 'endx', 'chry', 'starty', 'endy')
bed$midx <- (bed$startx + bed$endx)/2
bed$midy <- (bed$starty + bed$endy)/2
bed <- bed[which(abs(bed$midx - bed$midy) > 20000 & abs(bed$midx - bed$midy) < 2e06),]
bed$indx <- ceiling(bed$midx/3000)
bed$indy <- ceiling(bed$midy/3000)

getSubmat <- function(chr){
  subbed <- bed[which(bed$chrx == chr),]
  subbed <- subbed[, 9:10]
  colnames(subbed) <- c('x','y')
  
  mat.f <- paste0('../../KR_matrix/3kb-oe/MKODM/MKO_DM.allValidPairs.hic_3kb_KR_OE_matrix.', chr, '.txt')
  mat <- fread(mat.f)
  colnames(mat) <- c('start', 'end', 'count')
  mat$start <- mat$start/3000
  mat$end <- mat$end/3000
  
  # get enrichment scores for position 
  #subbed$scores <- 0
  
  id.query <- ifelse(subbed$x < subbed$y, paste0(subbed$x, "-", subbed$y), paste0(subbed$y, "-", subbed$x))
  id.target <- paste0(mat$start, "-", mat$end)
  loci <- match(id.query, id.target)
  
  scores <- mat$count[loci]
  print(paste0(chr, " is done"))
  
  return(scores)
  
}

chr.ls <- unique(bed$chrx)

scores.ls <- lapply(chr.ls, getSubmat)

save(scores.ls, file = paste0(args[1], "_MKODM_3kb_OE_Scores.RData"))
