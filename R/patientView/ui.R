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
source("../modules/editable.R", local = TRUE)

# Define UI for application that draws a histogram
dashboardPage(
  dashboardHeader(title = 'Patients'),
  dashboardSidebar(width = 250,
                   sidebarMenu(
                     textInput("searchField", "Search"),
                     menuItem("Tissues",tabName = 'tissues')#,
                     # menuItem("Tissue type",tabName = 'Ttype'),
                     # menuItem("Device",tabName = 'Device'),
                     # menuItem("Solvent",tabName = 'Solvent'),
                     # menuItem("Ion source",tabName = 'Isource'),
                     # menuItem("Resolution",tabName = 'Resolution')#,
                   )),
  dashboardBody(
    tabItems(
      tabItem('tissues',editableUI("tissue",width=1300))#,
      # tabItem('Ttype',readOnlyUI("ttype")),
      # tabItem('Device',readOnlyUI("dev")),
      # tabItem('Solvent',readOnlyUI("sol")),
      # tabItem('Isource',readOnlyUI("isource")),
      # tabItem('Resolution',readOnlyUI("res"))#,
    )
   ),
  title = "Dashboard example"
)
