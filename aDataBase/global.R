#
# This is a part of Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#


# Structure of the project:
# 
# 
# ./www/
# 
# 
# ./modules/addentry
#           selector
#           table
# 
# 
# ./ui
# 
# 
# ./server/01-tissues-srv
#          02-tissues-add-srv
#          03-patient-srv



# The following code style is accepted:
# 
# 1. If an external library is used (maybe exept for shiny and base), it is suggested to
#    explicitly specify the library. For example:
#
#            MonetDBLite::MonetDB()
#
#    Generally, this agreement allows to improve readability of the source code.
# 2. Another suggestion regards to variable names. The first part of variable name
#    should repeat  



library(shiny)
library(shinydashboard)
library(shinyjs)
library(DT)
library(MonetDBLite)
library(pool)
library(dplyr)
library(magrittr)



# Selector modules
source("./modules/selector/fridge-selector.R")
source("./modules/selector/id-selector.R")
source("./modules/selector/sex-selector.R")
source("./modules/selector/age-range-selector.R")
source("./modules/selector/age-single-selector.R")
source("./modules/selector/diagnosis-multiple-selector.R")
source("./modules/selector/diagnosis-single-selector.R")
source("./modules/selector/time-selector.R")
source("./modules/selector/time-single-selector.R")
source("./modules/selector/grade-single-selector.R")


# Table modules
source("./modules/table/tissuesEditable.R")
source("./modules/table/readOnly.R")
source("./modules/table/dtTable.R")



# AddEntry modules
source("./modules/addentry/tissuesAddEntry.R")
source("./modules/addentry/tissuesAddPatient.R")



# Create a pool. It is sufficient to have one pool per app. It will be closed automatically,
# when all sessions will be stopped
pool <- pool::dbPool(
        MonetDBLite::MonetDB(),
        dbname = "msinvent",
        user = "msinvent",
        password = "msinvent"
)



# This variable is used by both ui and server
diagnosisDictionary <- data.frame(tbl(pool, "diagnosis"))
