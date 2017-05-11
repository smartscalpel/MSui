#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(plotly)
#library(RSQLite)
library(DBI)
library(dplyr)
library(dtplyr)
library(stringr)
library(MonetDBLite)
library(data.table)
library(ggrepel)
source('db.R')
load('MetaData.Rdata')
load('features.Rdat')
dbdir <- '~/Documents/Projects/MSpeaks/data/MonetDBPeaks/'
#my_db <- MonetDBLite::src_monetdblite(dbdir)
con <- prepareCon(dbdir)
monetdb_conn <- src_monetdb(con = con)
specT<-collect(tbl(monetdb_conn,'spectra'))

dtParam<-list(beg=1,fin=1,dt=data.table())
#source(system.file("shinyApp", "serverRoutines.R", package = "TVTB"))

#Sys.sleep(2)

# Define server logic required to draw a histogram
shinyServer(function(input, output, session) {
  
  selectedTIC<-reactive({
    cat('iBeg=',input$beg,' iFin=',input$fin,'\n')
    if(is.numeric(input$beg)&
       dtParam$beg==input$beg&
       is.numeric(input$fin)&
       dtParam$fin==input$fin&dim(dtParam$dt)[1]>0){
      return(dtParam)
    }else{
      if(is.numeric(input$beg)&dtParam$beg!=input$beg){dtParam$beg<-input$beg}
      if(is.numeric(input$fin)){dtParam$fin<-max(input$fin,dtParam$beg)}
      cat('Beg=',dtParam$beg,' Fin=',dtParam$fin,'\n')
      # con<-getCon(con)
      # system.time(p<-data.table(dbGetQuery(con,sqlGetMZset,dtParam$beg,dtParam$fin)))
      # pdt<-p[,.(tic=sum(intensity)),by=.(rt,spectrid)]
      con<-getCon(con)
      cat(system.time(peakDT<-data.table(dbGetQuery(con,sqlTICset,dtParam$beg,dtParam$fin))),'\n')
      wdt<-merge(peakDT,specT,by.x = c('spectrid'),by.y = 'id')
      dtParam$dt<-wdt
      return(dtParam)
    }
  })

  observeEvent(input$beg,{
    cat('New beg=',input$beg,'\n')
    if(!is.numeric(input$begDT)){
      updateNumericInput(session,'beg',value=selectedTIC()$beg)
    } else if(selectedTIC()$beg>input$fin){
      updateNumericInput(session,'fin',value=selectedTIC()$beg)
      updateNumericInput(session,'beg',value=selectedTIC()$beg)
    }
  })
  
  observeEvent(input$fin, {
    cat('New fin=', input$fin, '\n')
    if (!is.numeric(input$finT)) {
      updateNumericInput(session, 'fin', value = selectedTIC()$fin)
    } else if (selectedTIC()$beg > input$fin) {
      updateNumericInput(session, 'fin', value = selectedTIC()$beg)
      updateNumericInput(session, 'beg', value = selectedTIC()$beg)
    }
  })
  
output$ticPlot <- renderPlotly({
    cat(paste('plot starts',Sys.time(),'\n'))
    cat('Beg=',selectedTIC()$beg,' Fin=',selectedTIC()$fin,'\n')
    # con<-getCon(con)
    # system.time(peakDT<-data.table(dbGetQuery(con,sqlTICset,beg,fin)))
    # wdt<-merge(peakDT,specT,by.x = c('spectrid'),by.y = 'id')
    cat(paste('peak is ready',Sys.time(),'\n'))
    p<-ggplot(selectedTIC()$dt,aes(x=rt,y=tic,color=fname,
                      patient=patient,
                      st=state,
                      diag=diagname,
                      grade=grade))
    pf<-p+scale_y_log10()+geom_line(alpha=0.5)+
      geom_point(size=0.1)+
      geom_smooth(alpha=0.3,span=0.25)+ 
      theme(legend.position="none")
    # generate bins based on input$bins from ui.R
    # x    <- faithful[, 2] 
    # bins <- seq(min(x), max(x), length.out = 1)
    # 
    # # draw the histogram with the specified number of bins
    # hist(x, breaks = bins, col = 'darkgray', border = 'white')
    ggplotly(pf)
  })
  
 
ranges <- reactiveValues(rt = NULL, mz = NULL)

selectedMZ<-reactive({
  cat('ID=',input$spectr,'\n')
  if(is.numeric(input$spectr)){spID<-input$spectr}else{spID<-1}
  con<-getCon(con)
  system.time(p<-data.table(dbGetQuery(con,sqlGetMZdata,spID)))
  # pdt<-p[,.(tic=sum(intensity)),by=.(rt,spectrid)]
  cat(dim(p),'\n')
  binz<-seq(min(p$mz),max(p$mz),by=0.01)
  p[,bin:=findInterval(mz, binz)]
  p
})

selectedXIC<-reactive({
  mzDT<-selectedMZ()
  cat(dim(mzDT),'\n')
  if(is.null(ranges$mz)){
    tic<-mzDT[,.(tic=sum(intensity)),by=.(rt,spectrid)]
  }else{
    tic<-mzDT[mz>=ranges$mz[1]&mz<=ranges$mz[2],.(tic=sum(intensity)),by=.(rt,spectrid)]
  }
  tic
})

selectedSpectr<-reactive({
  mzDT<-selectedMZ()
  cat(min(mzDT$spectrid),max(mzDT$spectrid),'\n')
  cat(dim(mzDT),ranges$rt,'\n')
  if(is.null(ranges$rt)){
    mz<-mzDT[,.(intensity=sum(intensity),mz=mean(mz)),by=.(bin,spectrid)]
  }else{
    mz<-mzDT[rt>=ranges$rt[1]&rt<=ranges$rt[2],.(intensity=sum(intensity),mz=mean(mz)),by=.(bin,spectrid)]
  }
  mz
})
# When a double-click happens, check if there's a brush on the plot.
# If so, zoom to the brush bounds; if not, reset the zoom.
output$xicPlot <- renderPlot({
  if(is.null(ranges$rt)){
    tic<-selectedXIC()
  }else{
    tic<-selectedXIC()[rt>=ranges$rt[1]&rt<=ranges$rt[2]]
  }
  cat("xicPlot ",dim(tic),'\n')
  ggplot(tic, aes(rt, tic)) +
    geom_line() +
    geom_point(size=0.1)+
    geom_smooth(alpha=0.3,span=0.25)+
    coord_cartesian(xlim = ranges$rt)
})

output$mzPlot <- renderPlot({
  if(is.null(ranges$mz)){
    mz<-selectedSpectr()
  }else{
    mz<-selectedSpectr()[mz>=ranges$mz[1]&mz<=ranges$mz[2]]
  }
  mz[,lab:=paste(round(mz,4))]
  mz[order(intensity,decreasing = TRUE)[-c(1:10)],lab:='']
  cat("mzPlot ",dim(mz),'\n')
  
  # ggplot(mz[intensity>0.05*max(intensity)], aes(x=mz,y=intensity)) +
  #   geom_line() +
  #   geom_point(size=0.1) + #scale_y_log10()+
  ggplot(mz[intensity>0.005*max(intensity)], aes(x=mz,yend=0,xend=mz, y=intensity,color=factor(spectrid))) +
    geom_segment()+geom_point(size=0.15) + #scale_y_log10()+
    geom_text_repel(aes(x = mz,y=intensity,label=lab))+
#    geom_col()+
#    geom_smooth(alpha=0.3,span=0.25)+
    coord_cartesian(xlim = ranges$mz)+ 
    theme(legend.position="none")
})

observeEvent(input$xic_dblclick, {
  brush <- input$xic_brush
  if (!is.null(brush)) {
    ranges$rt <- c(brush$xmin, brush$xmax)
    
  } else {
    ranges$rt <- NULL
  }
})

observeEvent(input$mz_dblclick, {
  brush <- input$mz_brush
  if (!is.null(brush)) {
    ranges$mz <- c(brush$xmin, brush$xmax)
    
  } else {
    ranges$mz <- NULL
  }
})
# 
# observe({
#   brush <- input$xic_brush
#   cat('XIC (',c(brush$xmin, brush$xmax),')\n')
#   if (!is.null(brush)) {
#     ranges$rt <- c(brush$xmin, brush$xmax)
#     
#   } 
# })
# 
# observe({
#   brush <- input$mz_brush
#   cat('MZ (',c(brush$xmin, brush$xmax),')\n')
#   if (!is.null(brush)) {
#     ranges$mz <- c(brush$xmin, brush$xmax)
#     
#   } else {
#     ranges$mz <- NULL
#   }
# })
# 

  output$metadata<-renderTable({specT[specT$id==input$spectr,]})

  output$table<-DT::renderDataTable({patients})
  # ,
  #                               options = list(
  #                                 orderClasses = TRUE,
  #                                 lengthMenu = c(15, 30, 50), 
  #                                 pageLength = 15))
  output$features<-DT::renderDataTable({
    t<-features[1:30,]
    t
  })
  session$onSessionEnded(function() {
    cat(paste('shut down the DB',Sys.time(),'\n'))
    con<-getCon(con)
    dbCommit(con)
    dbDisconnect(con, shutdown=TRUE)
  })
})
