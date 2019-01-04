#
# This is a part of Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#



#
# Structure of the project:
# 
# 
# ./www/
# 
# 
# ./modules/01-tissues
#           02-tissues-snd
#           03-patients
#           04-patients-snd
#           table
# 
# 
# ./ui
# 
# 
# ./server/01-tissues-srv
#          02-tissues-snd-srv
#          03-patients-srv
#          04-patients-snd-srv
#



#
# The following code style is accepted:
# 
# 1. If an external library is used (maybe exept for shiny and base), it is suggested to
#    explicitly specify the library. For example:
#
#            MonetDBLite::MonetDB()
#
#    Generally, this agreement allows to improve readability of the source code.
# 2. Another suggestion regards to variable names. The first part of variable name
#    should repeat section name
#



# Required libraries
suppressMessages(library(shiny))
suppressMessages(library(shinydashboard))
suppressMessages(library(shinyjs))
suppressMessages(library(DT))
suppressMessages(library(MonetDBLite))
suppressMessages(library(DBI))
suppressMessages(library(pool))
suppressMessages(library(dplyr))
suppressMessages(library(magrittr))
suppressMessages(library(V8))



# 01-tissues section: selector modules
source("./modules/01-tissues/selector/tissues-fridge-selector.R")
source("./modules/01-tissues/selector/tissues-id-selector.R")
source("./modules/01-tissues/selector/tissues-sex-selector.R")
source("./modules/01-tissues/selector/tissues-age-selector.R")
source("./modules/01-tissues/selector/tissues-diagnosis-selector.R")
source("./modules/01-tissues/selector/tissues-time-selector.R")

# 02-tissues-snd section: selector modules
source("./modules/02-tissues-snd/selector/tissues-snd-age-selector.R")
source("./modules/02-tissues-snd/selector/tissues-snd-diagnosis-selector.R")
source("./modules/02-tissues-snd/selector/tissues-snd-grade-selector.R")
source("./modules/02-tissues-snd/selector/tissues-snd-time-selector.R")

# 02-tissues-snd section: other (used by both ui and server)
source("./modules/02-tissues-snd/tissuessndCreateTissue.R")

# 03-patients section: selector modules
source("./modules/03-patients/selector/patients-age-selector.R")
source("./modules/03-patients/selector/patients-sex-selector.R")
source("./modules/03-patients/selector/patients-yob-selector.R")

# 04-patients-snd section: selector modules
source("./modules/04-patients-snd/selector/patients-snd-sex-selector.R")
source("./modules/04-patients-snd/selector/patients-snd-yob-selector.R")
source("./modules/04-patients-snd/selector/patients-snd-age-selector.R")

# Table modules
source("./modules/table/editable.R")
source("./modules/table/readOnly.R")
source("./modules/table/dtTable.R")



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
