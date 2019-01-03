#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

source("./global.R")



# Header
header <- shinydashboard::dashboardHeader(
        title = "ScalpelDB"
)



# Sidebar panel
sidebar <- shinydashboard::dashboardSidebar(
        shinydashboard::sidebarMenu(
                menuItem("Tissues",     tabName = "tissues",     icon = icon("flask")),
                menuItem("Add Tissue",  tabName = "tissuesadd",  icon = icon("plus-square")),
                menuItem("Patients",    tabName = "patients",    icon = icon("address-card")),
                menuItem("Add Patient", tabName = "patientsadd", icon = icon("plus-square")),
                menuItem("Help",        tabName = "help",        icon = icon("question-circle"))
        )
)



# Body
body <- shinydashboard::dashboardBody(
        tags$head(
                tags$link(
                        rel = "stylesheet",
                        type = "text/css",
                        href = "styles.css"
                ),
                tags$script(src = "custom.js")
        ),
        
        shinydashboard::tabItems(
                source(file = "./ui/01-tissues-ui.R",      local = TRUE)$value,
                source(file = "./ui/02-tissues-add-ui.R",  local = TRUE)$value,
                source(file = "./ui/03-patients-ui.R",     local = TRUE)$value,
                source(file = "./ui/04-patients-add-ui.R", local = TRUE)$value,
                source(file = "./ui/05-help-ui.R",         local = TRUE)$value
        )
)



# Main structure
shinydashboard::dashboardPage(
        header,
        sidebar,
        body,
        skin = "black"
)
