recieveDataFromSelectors <- function(label, patient, location, diagnosisSelector, gradeSelector, coords, timeSelector) {
        
        tissueData <- c()
        
        # label non empty string
        tissueData <- c(tissueData, label)
        
        # patient is non empty integer
        tissueData <- c(tissueData, integer(patient))
        
        print(tissueData)
        
        if (location != "" | ! is.null(location)) {
                tissueData <- c(tissueData, location)
        } else {
                tissueData <- c(tissueData, NA)
        }
        
        if (diagnosisSelector[[1]]() != "null") {
                tissueData <- c(
                        tissueData,
                        integer(diagnosisDictionary$id[match(diagnosisSelector[[2]](), diagnosisDictionary$name)])
                )
        } else {
                tissueData <- c(tissueData, NA)
        }
        
        if (gradeSelector[[1]]() != "null") {
                tissueData <- c(
                        tissueData,
                        integer(gradeSelector[[2]]())
                )
        } else {
                tissueData <- c(tissueData, NA)
        }
        
        if (timeSelector[[1]]() != "null") {
                tissueData <- c(tissueData, as.Date(timeSelector[[2]]()))
        } else {
                tissueData <- c(tissueData, NA)
        }
        
        if (coords != "" | is.null(coords)) {
                tissueData <- c(tissueData, coords)
        } else {
                tissueData <- c(tissueData, NA)
        }

        names(tissueData) <- c("label", "patient","location", "diagnosis", "grade", "dt", "coords")

        return(tissueData)
}