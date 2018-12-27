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
library(DBI)
library(dplyr)
library(dtplyr)
library(tibble)
library(pool)
library(rlang)
library(MonetDBLite)
library(rhandsontable)
library(rhandsontable)

source('db.R')
source("../modules/readOnly.R", local = TRUE)
source("../modules/editable.R", local = TRUE)

options(shiny.maxRequestSize=500*1024^2) 


# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  callModule(editable, "files", pool,tabName="files",colWidths=c(50,80,80,150,350,100,80,100,80,100,80),width=1300,
             makeEmptyRow=makeDiag,updateTable=updateDiag)
  callModule(editable, "res", pool,tabName="resolution",colWidths=c(50,200,500),
             makeEmptyRow=makeDiag,updateTable=updateDiag)
  callModule(editable, "isource", pool,tabName="ionsource",colWidths=c(50,200,500),
             makeEmptyRow=makeDiag,updateTable=updateDiag)
  callModule(editable, "sol", pool,tabName="solvent",colWidths=c(50,200,500),
             makeEmptyRow=makeDiag,updateTable=updateDiag)
  callModule(editable, "dev", pool,tabName="device",colWidths=c(50,200,300,500),
             makeEmptyRow=makeDiag,updateTable=updateDiag)
  callModule(editable, "ttype", pool,tabName="tissuetype",colWidths=c(50,200,500),
             makeEmptyRow=makeDiag,updateTable=updateDiag)
  callModule(editable, "diag", pool,tabName='diagnosis',colWidths=c(50,200,500,50),
             makeEmptyRow=makeDiag,updateTable=updateDiag)
})
