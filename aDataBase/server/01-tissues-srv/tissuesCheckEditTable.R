tissuesCheckEditTable <- function(dataFromDB, j, newValue) {
        
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
                # check if it is unique
        }
        
        if (columnNames[j] == "loaction") {
                # no check needed
        }
        
        if (columnNames[j] == "diagnosis") {
                # check if in dictionary
        }
        
        if (columnNames[j] == "diagnosis") {
                # check if integer
        }
        
        if (columnNames[j] == "dt") {
                # check if date
        }
        
        return(list(checkOutput, checkOutputMessage, newValue))
}