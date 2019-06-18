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
library(MALDIquant)
library(MALDIquantForeign)
library(corrplot)
library(plyr)

options(shiny.maxRequestSize=500*1024^2) 

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

defSpectra<-list(
  createMassSpectrum(
    mass=sort(sample(x = 100:1300,size = 1000,replace = FALSE)),
    intensity = rep(0,1000),
    metaData = list(name='default empty spectra')))

halfWindowSize<-5
iterations <- 100 
## define different colors for each step 
col <- rainbow(length(iterations))


# Define server logic required to draw a histogram
shinyServer(function(input, output) {
# Global identifier of the scan to play with
     scanID<-reactive({return(input$sID)})
# Global RV for data
     dataRV<-reactiveValues(ncMD=list(),spectra=defSpectra,TIC=0,XIC100=1e-7,XIC400=1e-7,time=1,scans=c(),inFile='')

     fragments<-reactiveValues(spectra=list(),
                               fragNames=c(),
                               files=c(),
                               fType=c(),
                               patients=c(),
                               numFrag=0,
                               numFiles=0)
     
     peaks<-reactiveValues(fragNames=c(),blacklist=c(),featureMatrix=matrix(NA,1,1))
     
     output$metadata<-renderTable({
       input$blackList
       bl<-blackList()
       d=ldply(fragments$spectra,
               .fun=function(.x)data.frame(metaData(.x[[1]])[-1]))
       d$blacklist=FALSE
       d$blacklist[peaks$blacklist]=TRUE
       return(d)
       })
     
# Load spectra from file
  observeEvent(input$inFile,{
    inFile <- input$inFile
    if (is.null(inFile))
      return(defSpectra)
    cat(names(inFile),'\n')
    cat('name: ',inFile$name,', size: ',inFile$size,', type: ',inFile$type,', datapath: ',inFile$datapath,'\n')
    #dataRV$fncMD<- ncatt_get(nc_open(inFile$datapath),0)
    spectra<-import(inFile$datapath,verbose=FALSE)
    if(any(sapply(spectra, MALDIquant::isEmpty))){
      spectra<-spectra[!sapply(spectra, MALDIquant::isEmpty)]
    }
    tic<-sapply(spectra,totalIonCurrent)
    spectra400 <- trim(spectra,range = c(400,1000))
    spectra100 <- trim(spectra,range = c(100,400))
    XIC100<-sapply(spectra100,totalIonCurrent)
    XIC400<-sapply(spectra400,totalIonCurrent)
    time<-sapply(spectra,function(.x)metaData(.x)$retentionTime)
    dataRV$spectra<-spectra
    dataRV$inFile<-inFile$name
    dataRV$ind<-sapply(spectra,function(.x)metaData(.x)$number)
    dataRV$time<-time
    dataRV$tic<-tic
    dataRV$XIC100<-XIC100
    dataRV$XIC400<-XIC400
    dataRV$scans<-seq_along(dataRV$spectra)
  })
  
  observeEvent(input$tic_dblclick, {
    brush <- input$tic_brush
    if (!is.null(brush)) {
      dataRV$scans <- seq(from=max(1,as.integer(brush$xmin)), 
                          to=min(as.integer(brush$xmax),
                                 length(dataRV$spectra)))
      cat('dataRV$scans',dataRV$scans,'\n')
    } else {
      dataRV$scans <- seq_along(dataRV$spectra)
    }
  })
  
  observeEvent(input$xic_dblclick, {
    brush <- input$xic_brush
    if (!is.null(brush)) {
      dataRV$scans <- seq(from=max(1,as.integer(brush$xmin)), 
                          to=min(as.integer(brush$xmax),
                                 length(dataRV$spectra)))
      cat('dataRV$scans',dataRV$scans,'\n')
    } else {
      dataRV$scans <- seq_along(dataRV$spectra)
    }
  })
  
  output$textFrag<-renderText({
    sprintf('Fragments: %d; Files: %d',fragments$numFrag,fragments$numFiles)
  })
  
  observeEvent(input$addFrag,{
    if(length(trimws(input$fragName))==0){
      cat('there is no name for the fragment\n')
      return()
    }
    i<-fragments$numFrag+1
    fragments$fragNames<-c(fragments$fragNames,input$fragName)
    f<-dataRV$spectra[dataRV$scans]
    cat(length(dataRV$scans),length(f),class(f),class(dataRV$spectra),'\n')
    for(k in 1:length(f)){
      f[[k]]@metaData$fName<-trimws(input$fragName)
      f[[k]]@metaData$fType<-trimws(input$fragType)
      f[[k]]@metaData$fRes<-trimws(input$fragRes)
      f[[k]]@metaData$fDiag<-trimws(input$diag)
      f[[k]]@metaData$pID<-trimws(input$patID)
      f[[k]]@metaData$inFile<-trimws(dataRV$inFile)
    }
    fragments$spectra[[i]]<-f
    fragments$numFrag<-i
    fragments$fType[i]<-trimws(input$fragType)
    fragments$files<-unique(c(metaData(f[[1]])$inFile,fragments$files))
    fragments$patients<-unique(c(metaData(f[[1]])$pID,fragments$patients))
    fragments$numFiles<-length(fragments$files)
  })
  
  # Downloadable Rdata of selected dataset ----
  output$saveBtn <- downloadHandler(
    filename = function() {
      paste0(input$outFile, ".Rdata")
    },
    content = function(file) {
      spectra<-fragments$spectra[-fragments$blacklist]
      fragNames<-fragments$fragNames[-fragments$blacklist]
      save(spectra,fragNames, file=file)
    }
  )
  
  output$corrPlot<-renderPlot({
    cat('corrplot\n')
    blTxt<-input$blackList
    bl<-blackList()
    cat('|',blTxt,'|',fragments$blacklist,'\n')
    if(length(fragments$blacklist)==0){
      peaks<-lapply(fragments$spectra,preparePeakList)
      rn<-c(1:length(fragments$spectra))
      lab<-fragments$fType
    }else{    
      peaks<-lapply(fragments$spectra[-fragments$blacklist],preparePeakList)
      rn<-c(1:length(fragments$spectra))[-fragments$blacklist]
      lab<-fragments$fType[-fragments$blacklist]
    }
    cat(length(peaks),'\n')
    wf<-determineWarpingFunctions(peaks,method="lowess",plot=FALSE)
    aPeaks<-warpMassPeaks(peaks,wf)
    bPeaks <- binPeaks(aPeaks, tolerance=0.002)
    fpeaks <- filterPeaks(bPeaks,
                          labels=lab,
                          minFrequency=0.25, mergeWhitelists=TRUE)
    featureMatrix <- intensityMatrix(fpeaks)
    idNA<-which(is.na(featureMatrix),arr.ind =TRUE)
    featureMatrix[idNA]<-0
    rownames(featureMatrix)<-rn
    cv<-cor(t(featureMatrix))
    corrplot(cv, method="color",tl.pos='b')
  })
  
  output$ticPlot<-renderPlot({
    if(length(dataRV$tic[dataRV$scans])<=1){return()}
    cat(length(dataRV$scans),dim(dataRV),'\n')
    qtic<-quantile(dataRV$tic[dataRV$scans],probs = seq(0, 1, 0.1),names = TRUE)
    ctic<-factor(findInterval(dataRV$tic[dataRV$scans],qtic),labels = names(qtic))
    qplot(dataRV$ind[dataRV$scans],dataRV$tic[dataRV$scans],colour=ctic,shape = ".")+
      scale_colour_brewer(palette = 'Spectral')+
      geom_line(aes(group=1))
  })
  output$xicPlot<-renderPlot({
    if(length(dataRV$tic)==1){return()}
    df<-rbind(data.frame(ind=dataRV$ind[dataRV$scans],XIC=dataRV$XIC100[dataRV$scans],type='XIC100'),
              data.frame(ind=dataRV$ind[dataRV$scans],XIC=dataRV$XIC400[dataRV$scans],type='XIC400'))
    qplot(ind,XIC,colour=type,data=df,shape = ".")+
      scale_colour_brewer(palette = 'Spectral')+
      geom_line()
  })
  output$blPlot<-renderPlot({
    if(input$corBL){
      plot(spSelected())
    }else{
      plotBaseLine(spSelected())
    }
  })
  
  spSelected<-reactive({
    spId<-input$sID
    cat('\n SpID=',spId,'\n')
    scl<-input$scale
    nr<-input$norm
    bl<-input$corBL
    sc<-dataRV$scans
    cat('\n lenSC=',length(sc),'\n')
    #if(spId>length(dataRV$spectra)){
    if(!spId%in%sc){
      if(any(sc>spId)){
        cat(sc)
        cat(spId,min(which(sc>spId)),'|',sc[min(which(sc>spId))],'|','\n')
        spId<-sc[min(which(sc>spId))]
        cat(spId,'\n')
      }else{
        spId<-max(sc)
      }
    }
    cat(spId,'\n')
    sp<-dataRV$spectra[[spId]]
    if(scl){    
      sp<-transformIntensity(sp, method="sqrt")
    }
    sp <- MALDIquant::smoothIntensity(sp, method="SavitzkyGolay",halfWindowSize=halfWindowSize)
    if(nr){
    sp <- MALDIquant::calibrateIntensity(sp, method="TIC")
    }
    if(bl){
      sp<- MALDIquant::removeBaseline(sp, method="SNIP",iterations=iterations)
    }
    return(sp)
  })
  
  blackList<-reactive({
    input$update
    blTxt<-input$blackList
    cat(blTxt,'\n')
    bl<-unlist(strsplit(blTxt,'[,; ]+'))
    if(suppressWarnings(any(is.na(as.integer(bl))))){
      showModal(modalDialog(
        title = "Non-integers in the Black List",
        "Elements of the Blak List should be indices of rows in metaData separated by any combination of comma and space characters.",
        easyClose = TRUE,
        footer = NULL
      ))
    }else{
      fragments$blacklist<-as.integer(bl)
      return(bl)
    }
  })
  output$snrPlot<-renderPlot({
    cat('snrPlot:',length(spSelected()),metaData(spSelected())$number,input$sID,'\n')
    plotSNR(spSelected())   
  })
})
