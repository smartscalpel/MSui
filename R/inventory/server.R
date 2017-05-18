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
source('plot.R')
load('MetaData.Rdata')
load('features.Rdat')
dbdir <- '~/Documents/Projects/MSpeaks/data/MonetDBPeaks/'
#my_db <- MonetDBLite::src_monetdblite(dbdir)
con <- prepareCon(dbdir)
monetdb_conn <- src_monetdb(con = con)
specT<-dplyr::collect(tbl(monetdb_conn,'spectra'))
specT$fname<-gsub('.raw$','',gsub('.mzXML','',specT$fname))
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
      if(is.null(ranges$mz)){
        cat(system.time(peakDT<-data.table(dbGetQuery(con,sqlTICset,dtParam$beg,dtParam$fin))),'\n')
      }else{
        cat(system.time(peakDT<-data.table(dbGetQuery(con,sqlTICsetMZ,dtParam$beg,dtParam$fin,ranges$mz[1],ranges$mz[2]))),'\n')
      }
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
  
  observe({
    id<-input$metaS_rows_selected
    updateNumericInput(session,'spectr',value=id)
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
      geom_smooth(alpha=0.3,span=0.15)+ 
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
output$rangesText<-renderText({
  if(!is.null(ranges$mz)&!is.null(ranges$rt)){
    s<-paste0("Ranges mz=[",round(ranges$mz[1],2),',',round(ranges$mz[2],2),'], rt=[',round(ranges$rt[1],2),',',round(ranges$rt[2],2),']')
  }else if(is.null(ranges$mz)&!is.null(ranges$rt)){
    s<-paste0("Ranges mz=[FULL range], rt=[",round(ranges$rt[1],2),',',round(ranges$rt[2],2),']')
  }else if(is.null(ranges$rt)&!is.null(ranges$mz)){
    s<-paste0("Ranges mz=[",round(ranges$mz[1],2),',',round(ranges$mz[2],2),'], rt=[FULL range]')
  }else{
    s<-paste0("Ranges mz=[FULL range], rt=[FULL range]")
  }
  cat('Ranges:',s,'\n')
  s
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
    geom_smooth(alpha=0.3,span=0.15)+
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

spans <- reactiveValues(rt=NULL)

output$tsxicPlot <- renderPlot({
    tic<-selectedXIC()
  cat("xicPlot ",dim(tic),'\n')
  p<-ggplot(tic, aes(rt, tic)) +
    geom_line() +
    geom_point(size=0.1)+
    geom_smooth(alpha=0.3,span=0.15)+
    coord_cartesian(xlim = ranges$rt)
  if(!is.null(spans$rt)){
    p<-p+    geom_rect(data=spans$rt, inherit.aes=FALSE, aes(xmin=min, xmax=max, ymin=min(tic$tic),
                                                             ymax=max(tic$tic), group=i), color="transparent", fill=spans$rt$color, alpha=0.3)
  }
  p
})



output$tsPlot <- renderPlot({
  if(is.null(ranges$mz)){
    mz<-selectedSpectr()
  }else{
    mz<-selectedSpectr()[mz>=ranges$mz[1]&mz<=ranges$mz[2]]
  }
  mz[,lab:=paste(round(mz,4))]
  mz[order(intensity,decreasing = TRUE)[-c(1:10)],lab:='']
  cat("tsPlot ",dim(mz),'\n')
  if(is.null(spans$rt)){cat('spans$rt is NULL\n')}else{cat('spans rt dim=',dim(spans$rt),'\n')}
  if(is.null(spans$rt)|dim(spans$rt)[1]>3){
  p<-ggplot(mz[intensity>0.005*max(intensity)], aes(x=mz,yend=0,xend=mz, y=intensity,color=factor(spectrid))) +
    geom_segment()+geom_point(size=0.15) + #scale_y_log10()+
    geom_text_repel(aes(x = mz,y=intensity,label=lab))+
    coord_cartesian(xlim = ranges$mz)+ 
    theme(legend.position="none")
  }else if(dim(spans$rt)[1]==1){
    r<-spans$rt
    mzDT<-selectedMZ()
    mz1<-mzDT[rt>=r$min[1]&rt<=r$max[1],.(intensity=sum(intensity),mz=mean(mz)),by=.(bin,spectrid)]
    if(!is.null(ranges$mz)){
      mz1<-mz1[mz>=ranges$mz[1]&mz<=ranges$mz[2]]
    }
    mz1[,lab:=paste(round(mz,4))]
    mz1[order(intensity,decreasing = TRUE)[-c(1:10)],lab:='']
    cat(dim(mz1),'\n')
    p<-ggplot(mz1[intensity>0.005*max(intensity)], aes(x=mz,yend=0,xend=mz, y=intensity,color=factor(spectrid))) +
      geom_segment()+geom_point(size=0.15) + #scale_y_log10()+
      geom_text_repel(aes(x = mz,y=intensity,label=lab))+
      coord_cartesian(xlim = ranges$mz)+ 
      labs(title=sprintf('rt [%.2f : %.2f]',r$min[1],r$max[2]))+
      theme(legend.position="none")
  }else if(dim(spans$rt)[1]==2){
    r<-spans$rt
    cat('len=2.1 len ',length(r),paste(unlist(r)),'\n')
    cat('len=2.1',r$i,r$color,r$range,'\n')
    mzDT<-selectedMZ()
    mz1<-mzDT[rt>=r$min[1]&rt<=r$max[1],.(intensity=sum(intensity),mz=mean(mz)),by=.(bin,spectrid)]
    if(!is.null(ranges$mz)){
      mz1<-mz1[mz>=ranges$mz[1]&mz<=ranges$mz[2]]
    }
    mz1[,lab:=paste(round(mz,4))]
    mz1[order(intensity,decreasing = TRUE)[-c(1:10)],lab:='']
    cat('len=2, mz1:',dim(mz1),'\n')
    p1<-ggplot(mz1[intensity>0.005*max(intensity)], aes(x=mz,yend=0,xend=mz, y=intensity,color=factor(spectrid))) +
      geom_segment()+geom_point(size=0.15) + #scale_y_log10()+
      geom_text_repel(aes(x = mz,y=intensity,label=lab))+
      coord_cartesian(xlim = ranges$mz)+ 
      labs(title=sprintf('rt [%.2f : %.2f]',r$min[1],r$max[1]))+
      theme(legend.position="none")
    mzDT<-selectedMZ()
    mz2<-mzDT[rt>=r$min[2]&rt<=r$max[2],.(intensity=sum(intensity),mz=mean(mz)),by=.(bin,spectrid)]
    if(!is.null(ranges$mz)){
      mz2<-mz2[mz>=ranges$mz[1]&mz<=ranges$mz[2]]
    }
    mz2[,lab:=paste(round(mz,4))]
    mz2[order(intensity,decreasing = TRUE)[-c(1:10)],lab:='']
    cat('len=2, mz2:',dim(mz2),'\n')
    p2<-ggplot(mz2[intensity>0.005*max(intensity)], aes(x=mz,yend=0,xend=mz, y=intensity,color=factor(spectrid))) +
      geom_segment()+geom_point(size=0.15) + #scale_y_log10()+
      geom_text_repel(aes(x = mz,y=intensity,label=lab))+
      coord_cartesian(xlim = ranges$mz)+ 
      labs(title=sprintf('rt [%.2f : %.2f]',r$min[2],r$max[2]))+
      theme(legend.position="none")
    p<-multiplot(p1, p2,cols=1)
  }else if(dim(spans$rt)[1]==3){
    r<-spans$rt
    mzDT<-selectedMZ()
    mz1<-mzDT[rt>=r$min[1]&rt<=r$max[1],.(intensity=sum(intensity),mz=mean(mz)),by=.(bin,spectrid)]
    if(!is.null(ranges$mz)){
      mz1<-mz1[mz>=ranges$mz[1]&mz<=ranges$mz[2]]
    }
    mz1[,lab:=paste(round(mz,4))]
    mz1[order(intensity,decreasing = TRUE)[-c(1:10)],lab:='']
    p1<-ggplot(mz1[intensity>0.005*max(intensity)], aes(x=mz,yend=0,xend=mz, y=intensity,color=factor(spectrid))) +
      geom_segment()+geom_point(size=0.15) + #scale_y_log10()+
      geom_text_repel(aes(x = mz,y=intensity,label=lab))+
      coord_cartesian(xlim = ranges$mz)+ 
      labs(title=sprintf('rt [%.2f : %.2f]',r$min[1],r$max[1]))+
      theme(legend.position="none")
    mzDT<-selectedMZ()
    mz2<-mzDT[rt>=r$min[2]&rt<=r$max[2],.(intensity=sum(intensity),mz=mean(mz)),by=.(bin,spectrid)]
    if(!is.null(ranges$mz)){
      mz2<-mz2[mz>=ranges$mz[1]&mz<=ranges$mz[2]]
    }
    mz2[,lab:=paste(round(mz,4))]
    mz2[order(intensity,decreasing = TRUE)[-c(1:10)],lab:='']
    p2<-ggplot(mz2[intensity>0.005*max(intensity)], aes(x=mz,yend=0,xend=mz, y=intensity,color=factor(spectrid))) +
      geom_segment()+geom_point(size=0.15) + #scale_y_log10()+
      geom_text_repel(aes(x = mz,y=intensity,label=lab))+
      coord_cartesian(xlim = ranges$mz)+ 
      labs(title=sprintf('rt [%.2f : %.2f]',r$min[2],r$max[2]))+
      theme(legend.position="none")
    mzDT<-selectedMZ()
    mz3<-mzDT[rt>=r$min[3]&rt<=r$max[3],.(intensity=sum(intensity),mz=mean(mz)),by=.(bin,spectrid)]
    if(!is.null(ranges$mz)){
      mz3<-mz3[mz>=ranges$mz[1]&mz<=ranges$mz[2]]
    }
    mz3[,lab:=paste(round(mz,4))]
    mz3[order(intensity,decreasing = TRUE)[-c(1:10)],lab:='']
    p3<-ggplot(mz3[intensity>0.005*max(intensity)], aes(x=mz,yend=0,xend=mz, y=intensity,color=factor(spectrid))) +
      geom_segment()+geom_point(size=0.15) + #scale_y_log10()+
      geom_text_repel(aes(x = mz,y=intensity,label=lab))+
      coord_cartesian(xlim = ranges$mz)+ 
      labs(title=sprintf('rt [%.2f : %.2f]',r$min[3],r$max[3]))+
      theme(legend.position="none")
    p<-multiplot(p1, p2,p3,cols=1)
  }
  p
})

output$spansText<-renderText({
  if(length(spans$rt)>6){
    s<-'At most 6 spans could be selected.'
  }else{
      s<-''
  }
  s
})
observeEvent(input$tsxic_dblclick, {
  brush <- input$tsxic_brush
  if (!is.null(brush)) {
    if(is.null(spans$rt)){
      cat('TS double click ',brush$xmin, brush$xmax,'\n')
    spans$rt <- data.frame(i=1,color=.palette[1],min=brush$xmin, max=brush$xmax,stringsAsFactors = FALSE)
    }else{
      i<-dim(spans$rt)[1]
      cat('TS double click ',i,brush$xmin, brush$xmax,'\n')
      spans$rt[i+1,]<-list(i=1,color=.palette[i+1],min=brush$xmin, max=brush$xmax)
    }
  } else {
    if(!is.null(spans$rt)){
      is.sel<-FALSE
      rt<-spans$rt
      x<-input$tsxic_dblclick$x
      for(i in 1:length(spans$rt)){
        if(x>=spans$rt[[i]]$range[1]&x<=spans$rt[[i]]$range[2]){
          is.sel<-TRUE
          rt<-rt[-i,]
        }
      }
      if(length(rt)==0){
      spans$rt <- NULL
      }else{
        spans$rt<-rt
      }
    }
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
output$metadataTS<-renderTable({specT[specT$id==input$spectr,]})
output$metaS<-DT::renderDataTable(specT[,c(2,3,5,7)], 
                                    selection = list(mode = 'single', 
                                                     selected = 1))
  
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
