tissuesCheckEditTable <- function(diagnosisDictionary) {
        function(dataFromDB, j, newValue) {
                columnNames <- names(dataFromDB)
                
                check <- TRUE
                checkMessage <- NULL
                
                if (columnNames[j] == "id") {
                        check <- FALSE
                        checkMessage <- "You can't change the Id field."
                }
                
                if (columnNames[j] == "emsid") {
                        check <- FALSE
                        checkMessage <- "You can't change the EmsId field."
                }
                
                if (columnNames[j] == "yob") {
                        check <- FALSE
                        checkMessage <- "You can't change the Year of Bearth field."
                }
                
                if (columnNames[j] == "age") {
                        check <- FALSE
                        checkMessage <- "You can't change the Age field."
                }
                
                if (columnNames[j] == "sex") {
                        check <- FALSE
                        checkMessage <- "You can't change the Sex field."
                }
                
                if (columnNames[j] == "label") {
                        # check if it is unique
                }
                
                if (columnNames[j] == "loaction") {
                        # no check needed
                }
                
                if (columnNames[j] == "diagnosis") {
                        # check if in dictionary
                        if ( ! (newValue %in% diagnosisDictionary$name) ) {
                                check <- FALSE
                                checkMessage <- "Invalid Diagnosis."
                        }
                }
                
                if (columnNames[j] == "grade") {
                        # check if integer
                        if (! is.integer(newValue)) {
                                check <- FALSE
                                checkMessage <- "Grade is not an integer."
                        }
                }
                
                if (columnNames[j] == "dt") {
                        # check if date
                        # TODO: write corresponding check
                }
                
                # Maybe its better to return a named list
                return(list(check, checkMessage, newValue))
        }
}