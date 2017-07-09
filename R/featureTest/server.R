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
loadFeature <- function(fname, env = new.env()) {
  cat(names(fname),'\n')
  cat('name: ',fname$name,', size: ',fname$size,', type: ',fname$type,', datapath: ',fname$datapath,'\n')
  load(file = fname$datapath, envir = env)
  return(env)#data.table(env$pdts))
}

#' Calculate quality tab for particular feature
#'
#' @param p
#' @param ion
#' @param ppm
#' @param minClusterSize
#'
#' @return
#' @export
#'
#' @examples

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
    idxIon<-which((p$ion-ion)<1e-5)
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

plotFeature<-function(){
  
}

load("def.feature.Rdat")
qN<-10
options(shiny.maxRequestSize=50*1024^2) 

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
   
  observe({
    print(input$row1)
  })
  featuresT<-reactive({
    inFile <- input$inFile
    #cat('file:',inFile)
    if (is.null(inFile))
      return(def.features)
    features<-data.table(loadFeature(inFile)$pdts)[!is.na(ion)]
    cat(class(features),'\n')
    cat(dim(features),'\n')
    return(features)
  })
  dataT<-reactive({
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
    return(peaks)
  })
  
  output$peaks<-DT::renderDataTable({
    inFile <- input$inFile
    if (is.null(inFile))
      return(def.peaks)
    DT::datatable(dataT()[is.finite(ion)]) %>%
      formatSignif(c('intensity','lm','corTIC','relTIC','delta'),3) %>%
      formatRound(c('mz','ion','time','clIon1','clIon2','corRel'),4)
  })
  
  output$featuresRev<-DT::renderDataTable({
    inFile <- input$inFile
    if (is.null(inFile))
      return(def.features)
    DT::datatable(featuresT())
  })
  
  output$features<-DT::renderDataTable({
    inFile <- input$inFile
    if (is.null(inFile))
      return(def.features)
    featuresDT<-DT::datatable(cbind(
      Pick=paste0('<input type="checkbox" id="row', featuresT()$ion, '" value="', featuresT()$ion, '">',""), 
      featuresT()),
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
    s<-sprintf('Features from %d to %d out of %d',qIdx(),(qIdx()+qN-1),dim(featuresT())[1])
  })
  observeEvent(input$prevQ, {
    qIdx(max(qIdx()-qN,1))
    if((qIdx()-qN)< 1){
      shinyjs::disable("prevQ")
    }
    shinyjs::enable("nextQ")   
    
    
  })
  observeEvent(input$nextQ, {
    qIdx(min(qIdx()+qN,dim(featuresT())[1]))
    if((qIdx()+qN)>=dim(featuresT())[1]){
      shinyjs::disable("nextQ")    
    }
    shinyjs::enable("prevQ")   
    
  })
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
