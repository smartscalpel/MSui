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

options(shiny.maxRequestSize=500*1024^2) 


# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  callModule(readOnly, "tissue", pool,tabName="patisue",colWidths=c(80,50,50,50,100,500,150,50,50,100),width=1200)
  # callModule(readOnly, "isource", pool,tabName="ionsource",colWidths=c(50,200,500))
  # callModule(readOnly, "sol", pool,tabName="solvent",colWidths=c(50,200,500))
  # callModule(readOnly, "dev", pool,tabName="device",colWidths=c(50,200,300,500))
  # callModule(readOnly, "ttype", pool,tabName="tissuetype",colWidths=c(50,200,500))
  #callModule(readOnly, "diag", pool,tabName='diagnosis',colWidths=c(50,200,500,50))
})
