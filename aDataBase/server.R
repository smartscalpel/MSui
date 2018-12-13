#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

source("./global.R")



# Server function
server <- function(input, output, session) {
        
        source("./server/generateHtmlScreensaver.R", local = TRUE)
        source("./server/generateErrorMessage.R",    local = TRUE)
        
        source("./server/01-tissues-srv/01-tissues-srv.R",         local = TRUE)
        source("./server/02-tissues-add-srv/02-tissues-add-srv.R", local = TRUE)
        
}