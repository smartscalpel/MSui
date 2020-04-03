patientsCheckTableModification <- function(dataFromDB, j, newValue) {
        
        columnNames <- names(dataFromDB)
        
        checkOutput <- TRUE
        checkOutputMessage <- ""
        
        if (columnNames[j] == "id") {
                checkOutput <- FALSE
                checkOutputMessage <- "You can't change the Id field."
        }
        
        if (columnNames[j] == "emsid") {
                checkOutput <- FALSE
                checkOutputMessage <- "You can't change the EmsId field."
        }
        
        if (columnNames[j] == "yob") {
                newValue <- as.integer(newValue)
                if (! is.na(newValue)) {
                        if (! (newValue > 1900 & newValue < 2020)) {
                                checkOutput <- FALSE
                                checkOutputMessage <- "Year of birth should be greater than 1900 and less than 2019."
                        }
                } else {
                        checkOutput <- FALSE
                        checkOutputMessage <- "Year of birth should be integer."
                }
        }
        
        if (columnNames[j] == "sex") {
                if (is.character(newValue)) {
                        if (newValue != "M" & newValue != "F") {
                                checkOutput <- FALSE
                                checkOutputMessage <- "Incorrect value of sex."
                        }
                } else {
                        checkOutput <- FALSE
                        checkOutputMessage <- "Year of birth should be character."
                }
        }
        
        if (columnNames[j] == "age") {
                newValue <- as.integer(newValue)
                if (! is.na(newValue)) {
                        if (! (newValue > -1 & newValue < 100)) {
                                checkOutput <- FALSE
                                checkOutputMessage <- "Age should be greater than 0 and less than 100."
                        }
                } else {
                        checkOutput <- FALSE
                        checkOutputMessage <- "Age should be integer."
                }
        }
        
        return(list(checkOutput, checkOutputMessage, newValue))
}
