#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

library(shiny)
library(shinydashboard)
library(rhandsontable)
source("../modules/readOnly.R", local = TRUE)

# Define UI for application that draws a histogram
dashboardPage(
  dashboardHeader(title = 'Dictionaries'),
  dashboardSidebar(width = 350,
                   sidebarMenu(
                     textInput("searchField", "Search"),
                     menuItem("Diagnosis",tabName = 'Diagnosis'),
                     menuItem("Tissue type",tabName = 'Ttype'),
                     menuItem("Device",tabName = 'Device'),
                     menuItem("Solvent",tabName = 'Solvent'),
                     menuItem("Ion source",tabName = 'Isource'),
                     menuItem("Resolution",tabName = 'Resolution')#,
                   )),
  dashboardBody(
    tabItems(
      tabItem('Diagnosis',readOnlyUI("diag")),
      tabItem('Ttype',readOnlyUI("ttype")),
      tabItem('Device',readOnlyUI("dev")),
      tabItem('Solvent',readOnlyUI("sol")),
      tabItem('Isource',readOnlyUI("isource")),
      tabItem('Resolution',readOnlyUI("res"))#,
    )
   ),
  title = "Dashboard example"
)
