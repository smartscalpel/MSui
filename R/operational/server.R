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
library(data.table)
library(ggrepel)
library(FactoMineR)
library(factoextra)
library(Matrix)
library(DT)
load('MetaData.Rdata')
load('features.Rdat')
load('diag.Rdata')
# Define server logic required to draw a histogram
shinyServer(function(input, output) {
   
  dtParam<-reactiveValues(beg=1,fin=1,dt=data.table(),selection=c(1))
  output$metaS<-DT::renderDataTable(diagnosis[,1:3], rownames=FALSE,
                                    selection = list(mode = 'multiple', 
                                                     selected = c(1,2)))

  selectedPat<-reactive({
    cat('selected rows: [',input$metaS_rows_selected,']\n')
    diag<-diagnosis$Description[dtParam$selection]
    cat(diag,'\n')
    return(patients[grep(diag,patients$Локализация)])
  })
  
  observe({
    id<-input$metaS_rows_selected
    if(length(id)==0){id<-c(1)}
    dtParam$selection<-as.numeric(id)
    diag<-diagnosis$Description[dtParam$selection]
    cat(diag,'\n')
    dtParam$dt<-patients[grep(diag,patients$Локализация)]
    cat('metaS_rows_selected:',id,'\n')
    #    updateNumericInput(session,'spectr',value=id)
  })

  output$table<-DT::renderDataTable({selectedPat})
  output$patient<-DT::renderDataTable({dtParam$dt})
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
  
})
