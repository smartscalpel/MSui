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

load("def.feature.Rdat")
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
    features<-data.table(loadFeature(inFile)$pdts)
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
    return(peaks)
  })
  output$features<-DT::renderDataTable({
    inFile <- input$inFile
    if (is.null(inFile))
      return(def.peaks)
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
