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

source('db.R')
source("../modules/readOnly.R", local = TRUE)
source("../modules/editable.R", local = TRUE)

options(shiny.maxRequestSize=500*1024^2) 


# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  callModule(editable, "tissue", pool,tabName="patisue",getTable=getTissueTable,
             makeEmptyRow=makeNewTissue,updateTable=updateTissue,
             colWidths=c(50,80,50,50,50,100,500,200,50,50,100),width=1300)
  # callModule(readOnly, "isource", pool,tabName="ionsource",colWidths=c(50,200,500))
  # callModule(readOnly, "sol", pool,tabName="solvent",colWidths=c(50,200,500))
  # callModule(readOnly, "dev", pool,tabName="device",colWidths=c(50,200,300,500))
  # callModule(readOnly, "ttype", pool,tabName="tissuetype",colWidths=c(50,200,500))
  #callModule(readOnly, "diag", pool,tabName='diagnosis',colWidths=c(50,200,500,50))
})
