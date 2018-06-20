#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(RColorBrewer)
library(ggplot2)
library(DBI)
library(dplyr)
library(dtplyr)
library(tibble)
library(pool)
library(rlang)
library(MonetDBLite)
library(rhandsontable)
library(rhandsontable)

source('db.R')
source("../modules/readOnly.R", local = TRUE)

options(shiny.maxRequestSize=500*1024^2) 

makeDiag<-function(){
  lev<-pool %>% tbl('diagnosis') %>% collect
  data.frame(name=factor(lev$name[1],levels = lev$name),
             description="",ref=NA)
}

preparePeakList<-function(s,
                          transMetod="sqrt",
                          calibMethod="TIC",
                          noiseMethod="SuperSmoother",
                          avgMethod='median',
                          tolerance = 2e-4,
                          SNR=2, 
                          halfWindowSize=5){
  # s1 <- transformIntensity(s, method=transMetod)
  # s1 <- calibrateIntensity(s1, method=calibMethod)
  # tic<-sapply(s,totalIonCurrent)
  # imTIC<-which.max(tic)
  # s1a <- alignSpectra(s1,reference = s1[[imTIC]],tolerance = tolerance)
  # fn<-sapply(s1a,function(.x)metaData(.x)$fName)
  as1a<-  averageMassSpectra(s,method = avgMethod)
  peaks1 <- detectPeaks(as1a, SNR=SNR, halfWindowSize=halfWindowSize,method=noiseMethod)
  return(peaks1)
}

plotSNR<-function(sp){
  snrs <- c(seq(from=1, to=2.5, by=0.5),5,10)
  ## define different colors for each step 
  col <- rainbow(length(snrs))
  ## estimate noise
  md<-metaData(sp)
  noise <- MALDIquant::estimateNoise(sp,
                                     method="SuperSmoother")
  maxNoise<-max(noise[,2])*max(snrs)
  maxSig<-max(sp@intensity)
  plot(sp,
       ylim=c(0,max(maxNoise,maxSig)),
       main=paste0('I=',md$number,', t=',round(md$retentionTime,3)))
  for (i in seq(along=snrs)) { lines(noise[, "mass"],
                                     noise[, "intensity"]*snrs[i],
                                     col=col[i], lwd=2)
  }
  legend("topright", legend=snrs, col=col, lwd=1)
}

plotBaseLine<-function(sp){
  iterations <- seq(from=25, to=100, by=25) ## define different colors for each step 
  col <- rainbow(length(iterations))
  md<-metaData(sp)
  plot(sp,
       main=paste0('I=',md$number,', t=',round(md$retentionTime,3)))
  ## draw different baseline estimates
  for (i in seq(along=iterations)) {
    baseline <- estimateBaseline(sp, method="SNIP",
                                 iterations=iterations[i])
    lines(baseline, col=col[i], lwd=2)
  }
  legend("topright", legend=iterations, col=col, lwd=1)
}

halfWindowSize<-5
iterations <- 100 
## define different colors for each step 
col <- rainbow(length(iterations))


# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  callModule(readOnly, "sol", pool,tabName="solvent",colWidths=c(50,200,500))
  callModule(readOnly, "diag", pool,tabName='diagnosis',colWidths=c(50,200,500,50))
})
