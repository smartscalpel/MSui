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

options(shiny.maxRequestSize=500*1024^2) 

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
     dataRV<-reactiveValues(ncMD=list(),spectra=defSpectra,TIC=0,XIC100=1e-7,XIC400=1e-7,time=1,scans=c())

# Load spectra from file
  observeEvent(input$inFile,{
    inFile <- input$inFile
    if (is.null(inFile))
      return(defSpectra)
    cat(names(inFile),'\n')
    cat('name: ',inFile$name,', size: ',inFile$size,', type: ',inFile$type,', datapath: ',inFile$datapath,'\n')
    #dataRV$fncMD<- ncatt_get(nc_open(inFile$datapath),0)
    spectra<-import(inFile$datapath,verbose=FALSE)
    tic<-sapply(spectra,totalIonCurrent)
    spectra400 <- trim(spectra,range = c(400,1000))
    spectra100 <- trim(spectra,range = c(100,400))
    XIC100<-sapply(spectra100,totalIonCurrent)
    XIC400<-sapply(spectra400,totalIonCurrent)
    time<-sapply(spectra,function(.x)metaData(.x)$retentionTime)
    dataRV$spectra<-spectra
    dataRV$ind<-sapply(spectra,function(.x)metaData(.x)$number)
    dataRV$time<-time
    dataRV$tic<-tic
    dataRV$XIC100<-XIC100
    dataRV$XIC400<-XIC400
    dataRV$scans<-dataRV$ind
  })
  
  observeEvent(input$tic_dblclick, {
    brush <- input$tic_brush
    if (!is.null(brush)) {
      dataRV$scans <- seq(from=as.integer(brush$xmin), to=as.integer(brush$xmax))
      cat('dataRV$scans',dataRV$scans,'\n')
    } else {
      dataRV$scans <- dataRV$ind
    }
  })
  
  observeEvent(input$xic_dblclick, {
    brush <- input$xic_brush
    if (!is.null(brush)) {
      dataRV$scans <- seq(from=as.integer(brush$xmin), to=as.integer(brush$xmax))
      cat('dataRV$scans',dataRV$scans,'\n')
    } else {
      dataRV$scans <- dataRV$ind
    }
  })
  
  
  output$ticPlot<-renderPlot({
    if(length(dataRV$tic[dataRV$scans])==1){return()}
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
    sc<-input$scale
    nr<-input$norm
    bl<-input$corBL
    #if(spId>length(dataRV$spectra)){
    if(!spId%in%dataRV$scans){
      if(any(dataRV$scans>spId)){
        cat(spId,min(which(dataRV$scans>spId)),'\n')
        spId<-dataRV$scan[min(which(dataRV$scans>spId))]
        cat(spId,'\n')
      }else{
        spId<-max(dataRV$scans)
      }
    }
    cat(spId,'\n')
    sp<-dataRV$spectra[[spId]]
    if(sc){    
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
  
  output$snrPlot<-renderPlot({
    cat('snrPlot:',length(spSelected()),metaData(spSelected())$number,input$sID,'\n')
    plotSNR(spSelected())   
  })
})
