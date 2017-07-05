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
  return(data.table(env$pdts))
}

load("def.feature.Rdat")
options(shiny.maxRequestSize=50*1024^2) 

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
   
  
  output$features<-DT::renderDataTable({
    inFile <- input$inFile
    #cat('file:',inFile)
    if (is.null(inFile))
      return(def.features)
    features<-loadFeature(inFile)
    cat(class(features),'\n')
    cat(dim(features),'\n')
    return(features)
    }, rownames=FALSE,
    selection = list(mode = 'multiple',
                     selected = c(1,2)))
  
})
