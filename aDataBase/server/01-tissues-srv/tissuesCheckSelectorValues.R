tissuesCheckSelectorValues <- function(diagnosisSelector, timeSelector) {
        
        check <- TRUE
        checkMessage <- ""
        
        # Check Diagnosis
        if (diagnosisSelector[[1]]() == "list") {
                if (is.null(diagnosisSelector[[2]]())) {
                        check <- FALSE
                        checkMessage <- paste(checkMessage, "Empty Diagnosis")
                }
        }
        
        # Check Time Input
        if (timeSelector[[1]]() == "range") {
                if (as.Date(timeSelector[[2]]()[1], format = "%Y-%m-%d") >
                    as.Date(timeSelector[[2]]()[2], format = "%Y-%m-%d")) {
                        check <- FALSE
                        checkMessage <- paste(checkMessage, "Invalid Time")
                }
        }

        return(list(check, checkMessage))
}
