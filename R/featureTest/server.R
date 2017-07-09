#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(data.table)
library(DT)
library(ggplot2)
library(plyr)
library(cluster)
library(dynamicTreeCut)
library(dbscan)

multiplot <- function(..., plotlist=NULL, file, cols=1, layout=NULL) {
  library(grid)
  
  # Make a list from the ... arguments and plotlist
  plots <- c(list(...), plotlist)
  
  numPlots = length(plots)
  
  # If layout is NULL, then use 'cols' to determine layout
  if (is.null(layout)) {
    # Make the panel
    # ncol: Number of columns of plots
    # nrow: Number of rows needed, calculated from # of cols
    layout <- matrix(seq(1, cols * ceiling(numPlots/cols)),
                     ncol = cols, nrow = ceiling(numPlots/cols))
  }
  
  if (numPlots==1) {
    print(plots[[1]])
    
  } else {
    # Set up the page
    grid.newpage()
    pushViewport(viewport(layout = grid.layout(nrow(layout), ncol(layout))))
    
    # Make each plot, in the correct location
    for (i in 1:numPlots) {
      # Get the i,j matrix positions of the regions that contain this subplot
      matchidx <- as.data.frame(which(layout == i, arr.ind = TRUE))
      
      print(plots[[i]], vp = viewport(layout.pos.row = matchidx$row,
                                      layout.pos.col = matchidx$col))
    }
  }
}


loadFeature <- function(fname, env = new.env()) {
  cat(names(fname),'\n')
  cat('name: ',fname$name,', size: ',fname$size,', type: ',fname$type,', datapath: ',fname$datapath,'\n')
  load(file = fname$datapath, envir = env)
  return(env)#data.table(env$pdts))
}

featureQTab<-function(p,
                      ions,
                      ppm = 20,
                      minClusterSize=30,
                      minPTS=20){
  qualityTab<-data.frame(ion=maxMZ,
                         medOutlier=NA,
                         numClass=NA,
                         numZero=NA,
                         N=NA,
                         ppmSD=NA,
                         ppmRange=NA,
                         ppmIQR=NA)
  for(i in 1:length(ions)){
    ion<-ions[i]
    idxIon<-which(abs(p$ion-ion)<1e-5)
    cP<-which.max(p$intensity[idxIon])
    ionI<-idxIon[cP]
    maxMZ<-p$mz[ionI]
    idx <- which(abs(p$mz - maxMZ) < (ppm * 1e-6 * maxMZ))
    p. <- p[idx, ]
    rl <- get_runLen(p$scan[idxIon], scanLen)
    l<-lm(mz ~ time, data = p[idxIon, ])
    range(l$residuals[abs(rstandard(l)) <= 2]) -> bnd
    pl <- predict(l, p.)
    rl <- p.$mz - pl
    idL <- which(rl >= bnd[1] & rl <= bnd[2])
    ct2 <- hdbscan(scale(p.[,c('mz')]), minPts = min(minPTS,dim(p.)[1]/4))
    qualityTab$medOutlier[i]<-median(ct2$outlier_scores,na.rm = TRUE)
    qualityTab$numClass[i]<-max(ct2$cluster)
    qualityTab$numZero[i]<-length(which(ct2$cluster==0))
    qualityTab$N[i]<-dim(p.)[1]
    qualityTab$ppmSD[i]<-1e6*sd(p.$mz,na.rm = TRUE)/maxMZ
    qualityTab$ppmRange[i]<-1e6*diff(range(p.$mz))/maxMZ
    qualityTab$ppmIQR[i]<-1e6*IQR(p.$mz,na.rm = TRUE)/maxMZ
  }
  qualityTab$logOutlier<-log10(qualityTab$medOutlier)
  qualityTab$Range2SD<-qualityTab$ppmRange/qualityTab$ppmSD
  qualityTab$SD2IQR<-qualityTab$ppmSD/qualityTab$ppmIQR
  return(qualityTab)
}

prepPlotFeature<-function(p,ion,ppm=20,minClusterSize = 30){
  cat(sprintf('ion=%f',ion),'\n')
  idxIon<-which(abs(p$ion-ion)<1e-5)
  cP<-which.max(p$intensity[idxIon])
  ionI<-idxIon[cP]
  maxMZ<-p$mz[ionI]
  ion2<-p$clIon2[ionI]
  cat(sprintf('maxMZ=%f',maxMZ),'\n')
  idx <- which(abs(p$mz - maxMZ) < (ppm * 1e-6 * maxMZ))
  p. <- p[idx, ]
  p.$mark<-'env'
  p.$mark[abs(p.$clIon2-ion2)<1e-5]<-'feature'
  p.$ppm<-(p.$mz - maxMZ)*1e6/maxMZ
  dissim1 = dist(p.$mz)
  dendro1 <- hclust(d = dissim1, method = 'ward.D2')
  ct1 <- cutreeDynamic(
    dendro1,
    cutHeight = NULL,
    minClusterSize = minClusterSize,
    method = "hybrid",
    deepSplit = 0,
    pamStage = TRUE,
    distM = as.matrix(dissim1),
    maxPamDist = 0,
    verbose = 0
  )
  cct1 <- ct1[which.min(abs(p.$mz - maxMZ))]
  id.1 <- idx[ct1 == cct1]
  mz1 <- median(p$mz[id.1])
  p.$color<-factor(ct1)
  rl <- get_runLen(p$scan[id.1], scanLen)
  l<-lm(mz ~ time, data = p[id.1, ])
  attr(p.,'lm')<-l
  return(p.)
}

plotFeature<-function(p,ion,ppm=20,minClusterSize = 30){
  p.<-prepPlotFeature(p,ion,ppm,minClusterSize)
  attr(p.,'lm')->l
  p6 = qplot(time,
             mz,
             data = p.,
             color = color,
             shape=mark) +
    geom_abline(intercept = l$coefficients[1],
                slope = l$coefficients[2])
  
}
load("def.feature.Rdat")
qN<-10
options(shiny.maxRequestSize=50*1024^2) 

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
   
  dataRV<-reactiveValues(features=def.features,peaks=def.peaks,Nf=1)
  
  # featuresT<-reactive({
  #   inFile <- input$inFile
  #   #cat('file:',inFile)
  #   if (is.null(inFile))
  #     return(def.features)
  #   features<-data.table(loadFeature(inFile)$pdts)[is.finite(ion)]
  #   features$Q<-NA
  #   cat(class(features),'\n')
  #   cat(dim(features),'\n')
  #   return(features)
  # })
  
  observeEvent(input$inFile,{
    inFile <- input$inFile
    #cat('file:',inFile)
    if (is.null(inFile))
      return(def.peaks)
    peaks<-data.table(loadFeature(inFile)$pdt)
    cat(class(peaks),'\n')
    cat(dim(peaks),'\n')
    peaks$delta[!is.na(peaks$ion)]<-peaks[!is.na(ion),abs(ion-mz)]
    cat(names(peaks),'\n')
    cat(dim(peaks),'\n')
    dataRV$peaks<-peaks
    features<-data.table(loadFeature(inFile)$pdts)[is.finite(ion)]
    features$Q<-NA
    dataRV$features<-features
    dataRV$Nf<-dim(features)[1]
  })
  
  output$peaks<-DT::renderDataTable({
    # inFile <- input$inFile
    # if (is.null(inFile))
    #   return(def.peaks)
    DT::datatable(dataRV$peaks[is.finite(ion)]) %>%
      formatSignif(c('intensity','lm','corTIC','relTIC','delta'),3) %>%
      formatRound(c('mz','ion','time','clIon1','clIon2','corRel'),4)
  })
  
  output$featuresRev<-DT::renderDataTable({
    # inFile <- input$inFile
    # if (is.null(inFile))
    #   return(def.features)
    DT::datatable(dataRV$features)
  })
  
  output$features<-DT::renderDataTable({
    # inFile <- input$inFile
    # if (is.null(inFile))
    #   return(def.features)
    featuresDT<-DT::datatable(cbind(
      Pick=paste0('<input type="checkbox" id="row', dataRV$features$ion, '" value="', dataRV$features$ion, '">',""), 
      dataRV$features),
      options = list(orderClasses = TRUE,
                     lengthMenu = c(5, 25, 50),
                     pageLength = 25 ,
                     
                     drawCallback= JS(
                       'function(settings) {
                       Shiny.bindAll(this.api().table().node());}')
                     ),selection='none',escape=F
      )
    return(featuresDT)
    })
  qIdx<-reactiveVal(value=1,label = 'qtabIdx')
  output$qText<-renderText({
    s<-sprintf('Features from %d to %d out of %d',qIdx(),(qIdx()+qN-1),dataRV$Nf)
  })
  output$qPlot<-renderPlot({
    p1<-plotFeature(dataRV$peaks,dataRV$features$ion[qIdx()])
    cat(qIdx(),dataRV$features$ion[qIdx()],'\n')
    p2<-plotFeature(dataRV$peaks,dataRV$features$ion[qIdx()+1])
    cat(qIdx()+1,dataRV$features$ion[qIdx()+1],'\n')
    p3<-plotFeature(dataRV$peaks,dataRV$features$ion[qIdx()+2])
    cat(qIdx()+2,dataRV$features$ion[qIdx()+2],'\n')
    p4<-plotFeature(dataRV$peaks,dataRV$features$ion[qIdx()+3])
    cat(qIdx()+3,dataRV$features$ion[qIdx()+3],'\n')
    p5<-plotFeature(dataRV$peaks,dataRV$features$ion[qIdx()+4])
    cat(qIdx()+4,dataRV$features$ion[qIdx()+4],'\n')
    p6<-plotFeature(dataRV$peaks,dataRV$features$ion[qIdx()+5])
    cat(qIdx()+5,dataRV$features$ion[qIdx()+5],'\n')
    p7<-plotFeature(dataRV$peaks,dataRV$features$ion[qIdx()+6])
    cat(qIdx()+6,dataRV$features$ion[qIdx()+6],'\n')
    p8<-plotFeature(dataRV$peaks,dataRV$features$ion[qIdx()+7])
    cat(qIdx()+7,dataRV$features$ion[qIdx()+7],'\n')
    p9<-plotFeature(dataRV$peaks,dataRV$features$ion[qIdx()+8])
    cat(qIdx()+8,dataRV$features$ion[qIdx()+8],'\n')
    p10<-plotFeature(dataRV$peaks,dataRV$features$ion[qIdx()+9])
    cat(qIdx()+9,dataRV$features$ion[qIdx()+9],'\n')
    multiplot(p1,p2,p3,p4,p5,p6,p7,p8,p9,p10)
  })
  
  observeEvent(input$prevQ, {
    qIdx(max(qIdx()-qN,1))
    if((qIdx()-qN)< 1){
      shinyjs::disable("prevQ")
    }
    shinyjs::enable("nextQ")   
    
    
  })
  observeEvent(input$nextQ, {
    qIdx(min(qIdx()+qN,dataRV$Nf))
    if((qIdx()+qN)>=dataRV$Nf){
      shinyjs::disable("nextQ")    
    }
    shinyjs::enable("prevQ")   
    
  })
  mqIdx<-reactiveVal(value=1,label = 'mqtabIdx')
  output$mqText<-renderText({
    s<-sprintf('Feature %d out of %d',mqIdx(),dataRV$Nf)
  })
  observeEvent(input$prevQm, {
    mqIdx(max(mqIdx()-1,1))
    if((mqIdx())<= 1){
      shinyjs::disable("prevQm")
    }
    shinyjs::enable("nextQm")   
  })
  observeEvent(input$nextQm, {
    mqIdx(min(mqIdx()+1,dataRV$Nf))
    if((mqIdx())>=dataRV$Nf){
      shinyjs::disable("nextQm")    
    }
    shinyjs::enable("prevQm")   
  })

  observe({
    cat('dataRV$Nf="',dataRV$Nf,'"\n')
    if(mqIdx()>=dataRV$Nf){
      shinyjs::disable("nextQm")    
    }else{
      shinyjs::enable("nextQm") 
    }
    if((mqIdx())<= 1){
      shinyjs::disable("prevQm")
    }else{
      shinyjs::enable("prevQm")
    }
    
  })
  observeEvent(input$yesQm, {
    dataRV$features$Q[mqIdx()]<-'g'
    mqIdx(min(mqIdx()+1,dataRV$Nf))
  })
  observeEvent(input$noQm, {
    dataRV$features$Q[mqIdx()]<-'b'
    mqIdx(min(mqIdx()+1,dataRV$Nf))
  })
  output$mqPlot<-renderPlot({
    p.<-prepPlotFeature(dataRV$peaks,dataRV$features$ion[mqIdx()])
    l<-attr(p.,'lm')
    p1<-qplot(time,intensity,data = p.,main=paste0('mz=',dataRV$features$ion[mqIdx()]),log='y',color=color,shape=mark)
    p2<-qplot(time,mz,data = p.,color=color,shape=mark) +
      geom_abline(intercept = l$coefficients[1],
                  slope = l$coefficients[2])
    p3<-qplot(ppm,intensity,data = p.,color=color,shape=mark)
    print(multiplot(p1, p2, p3, cols=1))
    
  } )
  # output$mytable = DT::renderDataTable({
  #   DT::datatable(cbind(Pick=paste0('<input type="checkbox" id="row', mymtcars$id, '" value="', mymtcars$id, '">',""), mymtcars[, input$show_vars, drop=FALSE]),
  #               options = list(orderClasses = TRUE,
  #                              lengthMenu = c(5, 25, 50),
  #                              pageLength = 25 ,
  #                              
  #                              drawCallback= JS(
  #                                'function(settings) {
  #                                Shiny.bindAll(this.api().table().node());}')
  #                              ),selection='none',escape=F)
  # })
})
