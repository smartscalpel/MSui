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
library(stringr)
library(MonetDBLite)
library(data.table)
source('db.R')
load('MetaData.Rdata')
load('features.Rdat')
dbdir <- '~/Documents/Projects/MSpeaks/data/MonetDBPeaks/'
#my_db <- MonetDBLite::src_monetdblite(dbdir)
con <- prepareCon(dbdir)
monetdb_conn <- src_monetdb(con = con)
specT<-collect(tbl(monetdb_conn,'spectra'))

#source(system.file("shinyApp", "serverRoutines.R", package = "TVTB"))

#Sys.sleep(2)

# Define server logic required to draw a histogram
shinyServer(function(input, output, session) {
  observeEvent(input$beg,{
    cat('New beg=',input$beg,'\n')
    if(input$beg>input$fin){
    updateNumericInput(session,'fin',value=input$beg)
    }
    })
  output$ticPlot <- renderPlotly({
    cat(paste('plot starts',Sys.time(),'\n'))
    beg<-input$beg
    fin<-max(input$fin,input$beg)
    cat('Beg=',beg,' Fin=',fin,'\n')
    con<-getCon(con)
    system.time(peakDT<-data.table(dbGetQuery(con,sqlTICset,beg,fin)))
    wdt<-merge(peakDT,specT,by.x = c('spectrid'),by.y = 'id')
    cat(paste('peak is ready',Sys.time(),'\n'))
    p<-ggplot(wdt,aes(x=rt,y=tic,color=fname,
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
