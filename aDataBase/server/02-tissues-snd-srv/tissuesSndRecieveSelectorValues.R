tissuesSndRecieveSelectorValues <- function(label, patient, location, diagnosisSelector, gradeSelector, coords, timeSelector) {
        
        tissueData <- c()
        
        
        # label non empty string
        tissueData <- c(tissueData, label)
        
        
        # patient is non empty integer
        patient <- patient[1]
        tissueData <- c(tissueData, patient)
        
        
        # Location Selector
        if (location != "" & ! is.null(location)) {
                tissueData <- c(tissueData, location)
        } else {
                tissueData <- c(tissueData, "null")
        }
        
        
        # Diagnosis Selector
        tissueData <- c(
                tissueData,
                diagnosisDictionary$id[match(diagnosisSelector[[2]](), diagnosisDictionary$name)]
        )
        
        
        # Grade Selector
        if (gradeSelector[[1]]() != "null") {
                tissueData <- c(
                        tissueData,
                        integer(gradeSelector[[2]]())
                )
        } else {
                tissueData <- c(tissueData, "null")
        }
        
        
        # Time Selector
        if (timeSelector[[1]]() != "null") {
                tissueData <- c(tissueData, as.Date(timeSelector[[2]]()))
        } else {
                tissueData <- c(tissueData, "null")
        }
        
        
        # Coords Selector
        if (coords != "" | is.null(coords)) {
                tissueData <- c(tissueData, coords)
        } else {
                tissueData <- c(tissueData, "null")
        }

        
        names(tissueData) <- c("label", "patient", "location", "diagnosis", "grade", "dt", "coords")

        return(tissueData)
}
