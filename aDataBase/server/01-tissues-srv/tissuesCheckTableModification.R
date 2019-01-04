tissuesCheckTableModification <- function(dataFromDB, j, newValue) {
        
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
                checkOutput <- FALSE
                checkOutputMessage <- "You can't change the Year of Bearth field."
        }
        
        if (columnNames[j] == "age") {
                checkOutput <- FALSE
                checkOutputMessage <- "You can't change the Age field."
        }
        
        if (columnNames[j] == "sex") {
                checkOutput <- FALSE
                checkOutputMessage <- "You can't change the Sex field."
        }
        
        if (columnNames[j] == "label") {
                # no check needed
        }
        
        if (columnNames[j] == "location") {
                # no check needed
        }
        
        if (columnNames[j] == "diagnosis") {
                # check if in dictionary
                if (! newValue %in% diagnosisDictionary) {
                        checkOutput <- FALSE
                        checkOutputMessage <- "Not in diagnosis dictionary."
                }
        }
        
        if (columnNames[j] == "dt") {
                # check if date
                if (
                        tryCatch(
                                as.Date(x, format = "%Y-%m-%d"),
                                error = function(c) "error"
                        ) == "error"
                ) {
                        checkOutput <- FALSE
                        checkOutputMessage <- "Format is not proper (yyyy-mm-dd)."
                }
                
        }
        
        return(list(checkOutput, checkOutputMessage, newValue))
}
