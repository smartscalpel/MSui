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
library(FactoMineR)
library(factoextra)
library(Matrix)
library(compositions)
library(KernSmooth)
library("ggdendro")
source('db.R')
source('plot.R')
load('MetaData.Rdata')
load('features.Rdat')
dbdir <- '~/Documents/Projects/MSpeaks/data/MonetDBPeaks/'
#my_db <- MonetDBLite::src_monetdblite(dbdir)
con <- prepareCon(dbdir)
#monetdb_conn <- src_monetdb(con = con)
specT<-getSpectra(con=con)#dplyr::collect(tbl(monetdb_conn,'spectra'))
specT$fname<-gsub('_FT.*$','',gsub('.raw$','',gsub('.mzXML','',specT$fname)))
p1<-getMZ(con,1)
#source(system.file("shinyApp", "serverRoutines.R", package = "TVTB"))
load('~/Documents/Projects/MSpeaks/data/res20170404maxwell/0_00_747-15_FT100k.raw.mzXML/dataA.res.xMSAnnotator.RData')
#Sys.sleep(2)

# Define server logic required to draw a histogram
shinyServer(function(input, output, session) {
  dtParam<-reactiveValues(beg=1,fin=1,dt=data.table(),mz=p1,selection=c(1))
  
  selectedTIC<-reactive({
    cat('selected rows: [',input$metaS_rows_selected,']\n')
    cat('names: {',names(dtParam),'}\n')
    cat('p1: ',dim(p1),names(p1),'\n')
#    cat('iBeg=',input$beg,' iFin=',input$fin,'\n')
    # if(is.numeric(input$beg)&
    #    dtParam$beg==input$beg&
    #    is.numeric(input$fin)&
    #    dtParam$fin==input$fin&dim(dtParam$dt)[1]>0){
    #   return(dtParam)
    # }else{
    #   if(is.numeric(input$beg)&dtParam$beg!=input$beg){dtParam$beg<-input$beg}
    #   if(is.numeric(input$fin)){dtParam$fin<-max(input$fin,dtParam$beg)}
    # }
    if(!is.null(ranges$mz)){
    mzr<-ranges$mz
    }
    if(!is.null(ranges$rt)){
    rtr<-ranges$rt
    }
    spIDs<-unique(dtParam$mz$spectrid)
    sp_old<-spIDs
    cat('spIDs: [',spIDs,']\n')
    idx1<-match(spIDs,dtParam$selection)
    cat('idx1: [',idx1,']\n')
    if(any(is.na(idx1))){
      dtParam$mz<-dtParam$mz[!spectrid%in%spIDs[is.na(idx1)]]
      spIDs<-unique(dtParam$mz$spectrid)
    }
    idx2<-match(dtParam$selection,spIDs)
    cat('idx2: [',idx2,']\n')
    if(any(is.na(idx2))){
      id<-dtParam$selection[which(is.na(idx2))[1]]
      cat('p id=',id,'\n')
#      cat('Beg=',id,' Fin=',id,'\n')
      # con<-getCon(con)
      # system.time(p<-data.table(dbGetQuery(con,sqlGetMZset,dtParam$beg,dtParam$fin)))
      # pdt<-p[,.(tic=sum(intensity)),by=.(rt,spectrid)]
      
      con<-getCon(con)
#      if(is.null(ranges$mz)){
#        cat(system.time(peakDT<-data.table(dbGetQuery(con,sqlTICset,dtParam$beg,dtParam$fin))),'\n')
        p<-getMZ(con,id,threshold = ranges$intensity)
      # }else{
      #   p<-getMZ(con,id,)
      # }
      dtParam$mz<-rbind(dtParam$mz,p)
      spIDs<-unique(dtParam$mz$spectrid)
    }
    if(!identical(sp_old,spIDs)){
      p<-dtParam$mz[intensity>=ranges$intensity]
      if(is.null(ranges$mz)){
        peakDT<-p[,.(tic=sum(intensity)),by=.(rt,spectrid)]
      }else{
        peakDT<-p[mz>=ranges$mz[1]&mz<=ranges$mz[2],.(tic=sum(intensity)),by=.(rt,spectrid)]
      }
      if(!is.null(ranges$rt)){
        peakDT<-peakDT[rt>=ranges$rt[1]&rt<=ranges$rt[2]]
      }
      wdt<-merge(peakDT,specT,by.x = c('spectrid'),by.y = 'id')
      dtParam$dt<-wdt
    }
    cat('wdt names: ',names(dtParam$dt),'\n')
    cat('dim(mz)',dim(dtParam$mz),'\n')
    cat('range(mz$intensity)',range(dtParam$mz$intensity),'\n')
    return(dtParam)
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
    if(length(id)==0){id<-c(1,2)}
    dtParam$selection<-as.numeric(id)
    cat('metaS_rows_selected:',id,'\n')
#    updateNumericInput(session,'spectr',value=id)
  })
  
  # observeEvent(input$fin, {
  #   cat('New fin=', input$fin, '\n')
  #   if (!is.numeric(input$finT)) {
  #     updateNumericInput(session, 'fin', value = selectedTIC()$fin)
  #   } else if (selectedTIC()$beg > input$fin) {
  #     updateNumericInput(session, 'fin', value = selectedTIC()$beg)
  #     updateNumericInput(session, 'beg', value = selectedTIC()$beg)
  #   }
  # })
  
output$ticPlot <- renderPlotly({
    cat(paste('plot starts',Sys.time(),'\n'))
    cat('Beg=',min(selectedTIC()$dt$spectrid),' Fin=',max(selectedTIC()$dt$spectrid),'\n')
    # con<-getCon(con)
    # system.time(peakDT<-data.table(dbGetQuery(con,sqlTICset,beg,fin)))
    # wdt<-merge(peakDT,specT,by.x = c('spectrid'),by.y = 'id')
    cat(paste('peak is ready',Sys.time(),'\n'))
    cat('names: ',names(selectedTIC()$dt),'\n')
    
    p<-ggplot(selectedTIC()$dt,aes(x=rt,y=tic,color=fname,
                      patient=patient,
                      st=state,
                      diag=diagname,
                      grade=grade))
    pf<-p+scale_y_log10()+geom_line(alpha=0.5)+
      geom_point(size=0.1)+
      geom_smooth(alpha=0.3,span=0.15)+ 
      theme(legend.position="none")
    if(!is.null(ranges$rt)){
      pf<-pf+coord_cartesian(xlim = ranges$rt)
    }
    # generate bins based on input$bins from ui.R
    # x    <- faithful[, 2] 
    # bins <- seq(min(x), max(x), length.out = 1)
    # 
    # # draw the histogram with the specified number of bins
    # hist(x, breaks = bins, col = 'darkgray', border = 'white')
    ggplotly(pf)
  })

selectedMatrix<-reactive({
  mz<-selectedTIC()$mz
  if(!is.null(ranges$mz)){
    mz<-mz[mz>=ranges$mz[1]&mz<=ranges$mz[2]]
  }
  if(!is.null(ranges$rt)){
    mz<-mz[rt>=ranges$rt[1]&rt<=ranges$rt[2]]
  }
  pDTa<-mz[intensity>=ranges$intensity,.(mz=mean(mz),intensity=sum(intensity)),by=.(spectrid,bin)]
  pDTa[,rcomp:=rcomp(intensity,total=1e6),by=.(spectrid)]
  spIDs<-unique(pDTa$spectrid)
  m<-spMatrix(ncol = max(pDTa$bin),
              nrow = length(spIDs),
              j=pDTa$bin,
              i=match(pDTa$spectrid,spIDs),
              x = pDTa$intensity)
  row.names(m)<-specT$fname[dtParam$selection]#spIDs
  idx<-which(colSums(m)>0)
  cat('Matrix:',length(idx),dim(m),'\n')
  return(m[,idx])
})

pcaM<-reactive({
  pca=prcomp(selectedMatrix(),scale. = TRUE)
  cat('PCA\n')
  pca
  })

output$clusterPlot<- renderPlot({
  #cat('matrix dim',dim(pcaM()),'\n')
  #cat('selection len',length(dtParam$selection))
  #p <- fviz_pca_ind(pcaM(),label='none',habillage = specT$diagname[dtParam$selection],addEllipses = FALSE)
  pca.df<-cbind(as.data.frame(pcaM()$x),specT[dtParam$selection,])
  #cat(dim(pca.df),'\n')
  #cat(names(pca.df),'\n')
  ct<-hclust(dist(pcaM()$x[,1:10]),method = 'ward.D2')
  ggdendrogram(ct)
})


output$pcaIndPlot<- renderPlotly({
  cat('matrix dim',dim(pcaM()),'\n')
  cat('selection len',length(dtParam$selection))
  #p <- fviz_pca_ind(pcaM(),label='none',habillage = specT$diagname[dtParam$selection],addEllipses = FALSE)
  pca.df<-cbind(as.data.frame(pcaM()$x),specT[dtParam$selection,])
  cat(dim(pca.df),'\n')
  cat(names(pca.df),'\n')
  p<-ggplot(pca.df,
            aes(x=PC1,y=PC2,
                color=diagname,
                shape=state,
                diagname=diagname,
                fname=fname,
                grade=grade))+
    geom_point()

  ggplotly(p)
})

output$ecdfPlot<- renderPlot({
  mz<-selectedTIC()$mz
  if(!is.null(ranges$mz)){
    mz<-mz[mz>=ranges$mz[1]&mz<=ranges$mz[2]]
  }
  if(!is.null(ranges$rt)){
    mz<-mz[rt>=ranges$rt[1]&rt<=ranges$rt[2]]
  }
  mz<-mz[intensity>=ranges$intensity]
  kse<-bkde(x = log10(mz$intensity))
  kse$ydec<-dim(mz)[1]*(1-cumsum(kse$y)/sum(kse$y))
  p<-qplot(10^(kse$x),kse$ydec,geom ='line',log = 'xy',xlab = 'Intensity',ylab = 'N')
  p
})

output$pcaScreePlot<- renderPlot({
  fviz_screeplot(pcaM(),ncp=10)
})
output$pcaVarPlot<- renderPlotly({
  p<-fviz_pca_var(pcaM(),label='var',geom=c('point',text),select.var = list(cos2=5))
  ggplotly(p)
})

ranges <- reactiveValues(rt = NULL, mz = NULL,intensity=1e2)


selectedMZ<-reactive({
  n<-length(selectedTIC()$selection)
  cat('n=',n,'\n')
  if(n>0){spID<-selectedTIC()$selection[n]}else{spID<-1}
  #con<-getCon(con)
#  system.time(p<-data.table(dbGetQuery(con,sqlGetMZdata,spID)))
  system.time(p<-selectedTIC()$mz[spectrid==spID&intensity>=ranges$intensity])
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
    tic<-mzDT[intensity>=ranges$intensity,.(tic=sum(intensity)),by=.(rt,spectrid)]
  }else{
    tic<-mzDT[mz>=ranges$mz[1]&mz<=ranges$mz[2]&intensity>=ranges$intensity,.(tic=sum(intensity)),by=.(rt,spectrid)]
  }
  tic
})

selectedSpectr<-reactive({
  mzDT<-selectedMZ()
  cat(min(mzDT$spectrid),max(mzDT$spectrid),'\n')
  cat(dim(mzDT),ranges$rt,'\n')
  if(is.null(ranges$rt)){
    mz<-mzDT[intensity>=ranges$intensity,.(intensity=sum(intensity),mz=mean(mz)),by=.(bin,spectrid)]
  }else{
    mz<-mzDT[rt>=ranges$rt[1]&rt<=ranges$rt[2]&intensity>=ranges$intensity,.(intensity=sum(intensity),mz=mean(mz)),by=.(bin,spectrid)]
  }
  mz
})
output$rangesText<-renderText({
  if(is.null(ranges$mz)){
    mz<-range(selectedTIC()$mz$mz)
  }else{
    mz<-ranges$mz
  }
  if(is.null(ranges$rt)){
    rt<-range(selectedTIC()$mz$rt)
  }else{
    rt<-ranges$rt
  }
    s<-paste0("Ranges mz=[",round(mz[1],2),',',round(mz[2],2),'], rt=[',round(rt[1],2),',',round(rt[2],2),'], I=',sprintf('%.2g',ranges$intensity))
  cat('Ranges:',s,'\n')
  s
})
# When a double-click happens, check if there's a brush on the plot.
# If so, zoom to the brush bounds; if not, reset the zoom.
output$xicPlot <- renderPlot({
  if(is.null(ranges$rt)){
    tic<-selectedXIC()
    rrt<-range(tic$rt)
  }else{
    tic<-selectedXIC()[rt>=ranges$rt[1]&rt<=ranges$rt[2]]
    rrt<-ranges$rt
  }
  cat("xicPlot ",dim(tic),'\n')
  cat("xlim = ",rrt,'\n')
  ggplot(tic, aes(rt, tic)) +
    geom_line() +
    geom_point(size=0.1)+
    geom_smooth(alpha=0.3,span=0.15)+
    coord_cartesian(xlim = rrt)
})


output$mzPlot <- renderPlot({
  if(is.null(ranges$mz)){
    mz<-selectedSpectr()
    rmz<-range(mz$mz)
  }else{
    mz<-selectedSpectr()[mz>=ranges$mz[1]&mz<=ranges$mz[2]]
    rmz<-ranges$mz
  }
  mz[,lab:=paste(round(mz,4))]
  mz[order(intensity,decreasing = TRUE)[-c(1:10)],lab:='']
  cat("mzPlot ",dim(mz),'\n')
  cat("xlim = ",rmz,'\n')
  # ggplot(mz[intensity>0.05*max(intensity)], aes(x=mz,y=intensity)) +
  #   geom_line() +
  #   geom_point(size=0.1) + #scale_y_log10()+
  ggplot(mz[intensity>max(ranges$intensity,0.005*max(intensity))], aes(x=mz,yend=0,xend=mz, y=intensity,color=factor(spectrid))) +
    geom_segment()+geom_point(size=0.15) + #scale_y_log10()+
    geom_text_repel(aes(x = mz,y=intensity,label=lab))+
#    geom_col()+
#    geom_smooth(alpha=0.3,span=0.25)+
    coord_cartesian(xlim = rmz,expand = FALSE)+ 
    theme(legend.position="none")
})

observeEvent(input$xic_dblclick, {
  brush <- input$xic_brush
  if (!is.null(brush)) {
    ranges$rt <- c(brush$xmin, brush$xmax)
    cat('ranges$rt',ranges$rt,'\n')
  } else {
    ranges$rt <- NULL
  }
})

observeEvent(input$mz_dblclick, {
  brush <- input$mz_brush
  if (!is.null(brush)) {
    ranges$mz <- c(brush$xmin, brush$xmax)
    cat('ranges$mz',ranges$mz,'\n')
  } else {
    ranges$mz <- NULL
  }
})

observeEvent(input$ecdf_dblclick, {
  brush <- input$ecdf_brush
  if (!is.null(brush)) {
    ranges$intensity <- brush$xmin
    cat('ranges$intensity',ranges$intensity,'\n')
  } else {
    ranges$intensity <- 1e2
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
    xranges<-range(mz$mz)
  }else{
    mz<-selectedSpectr()[mz>=ranges$mz[1]&mz<=ranges$mz[2]]
    xranges<-ranges$mz
  }
  mz[,lab:=paste(round(mz,4))]
  mz[order(intensity,decreasing = TRUE)[-c(1:10)],lab:='']
  cat("tsPlot ",dim(mz),'\n')
  if(is.null(spans$rt)){cat('spans$rt is NULL\n')}else{cat('spans rt dim=',dim(spans$rt),'\n')}
  if(is.null(spans$rt)){#|dim(spans$rt)[1]>6){
  p<-ggplot(mz[intensity>0.005*max(intensity)], aes(x=mz,yend=0,xend=mz, y=intensity,color=factor(spectrid))) +
    geom_segment()+geom_point(size=0.15) + #scale_y_log10()+
    geom_text_repel(aes(x = mz,y=intensity,label=lab))+
    coord_cartesian(xlim = ranges$mz)+ 
    theme(legend.position="none")
  }else if(dim(spans$rt)[1]==1){
    r<-spans$rt
    mzDT<-selectedMZ()
    mz1<-getSpanMZ(mzDT,r,i=1,ranges$mz)
    p<-getSpanPlot(mz1,r,i=1,xranges,range(mz1$intensity))
  }else if(dim(spans$rt)[1]==2){
    r<-spans$rt
    mzDT<-selectedMZ()
    mz1<-getSpanMZ(mzDT,r,i=1,ranges$mz)
    mz2<-getSpanMZ(mzDT,r,i=2,ranges$mz)
    ylm<-range(c(mz1$intensity,mz2$intensity))
    p1<-getSpanPlot(mz1,r,i=1,xranges,ylm)
    p2<-getSpanPlot(mz2,r,i=2,xranges,ylm)
    p<-multiplot(p1, p2,cols=1)
  }else if(dim(spans$rt)[1]==3){
    r<-spans$rt
    mzDT<-selectedMZ()
    mz1<-getSpanMZ(mzDT,r,i=1,ranges$mz)
    mz2<-getSpanMZ(mzDT,r,i=2,ranges$mz)
    mz3<-getSpanMZ(mzDT,r,i=3,ranges$mz)
    ylm<-range(c(mz1$intensity,mz2$intensity,mz3$intensity))
    p1<-getSpanPlot(mz1,r,i=1,xranges,ylm)
    p2<-getSpanPlot(mz2,r,i=2,xranges,ylm)
    p3<-getSpanPlot(mz3,r,i=3,xranges,ylm)
    p<-multiplot(p1, p2,p3,cols=1)
  }else if(dim(spans$rt)[1]==4){
  r<-spans$rt
  mzDT<-selectedMZ()
  mz1<-getSpanMZ(mzDT,r,i=1,ranges$mz)
  mz2<-getSpanMZ(mzDT,r,i=2,ranges$mz)
  mz3<-getSpanMZ(mzDT,r,i=3,ranges$mz)
  mz4<-getSpanMZ(mzDT,r,i=4,ranges$mz)
  ylm<-range(c(mz1$intensity,mz2$intensity,mz3$intensity,mz4$intensity))
  p1<-getSpanPlot(mz1,r,i=1,xranges,ylm)
  p2<-getSpanPlot(mz2,r,i=2,xranges,ylm)
  p3<-getSpanPlot(mz3,r,i=3,xranges,ylm)
  p4<-getSpanPlot(mz4,r,i=4,xranges,ylm)
  p<-multiplot(p1, p2,p3,p4,cols=1)
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
      for(i in 1:dim(rt)[1]){
        if(x>=spans$rt$min[i]&x<=spans$rt$max[i]){
          is.sel<-TRUE
          rt<-rt[-i,]
        }
      }
      if(dim(rt)[1]==0){
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

output$metadata<-renderTable({specT[specT$id==selectedMZ()$spectrid[1],]})
output$metadataTS<-renderTable({specT[specT$id==selectedMZ()$spectrid[1],]})
output$metaS<-DT::renderDataTable(specT[,c(2,3,5,7)], rownames=FALSE,
                                    selection = list(mode = 'multiple', 
                                                     selected = c(1,2)))
  
  output$table<-DT::renderDataTable({patients})
  # ,
  #                               options = list(
  #                                 orderClasses = TRUE,
  #                                 lengthMenu = c(15, 30, 50), 
  #                                 pageLength = 15))
  output$features<-DT::renderDataTable({
#    t<-features[1:30,]
    t<-as.data.table(res$stage5[,-c(1:3)])
    t
  })
  session$onSessionEnded(function() {
    cat(paste('shut down the DB',Sys.time(),'\n'))
    con<-getCon(con)
    dbCommit(con)
    dbDisconnect(con, shutdown=TRUE)
  })
})
