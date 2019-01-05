tissuesSndRecieveSelectorValues <- function(label, patientId, location, diagnosisSelector, gradeSelector, coords, timeSelector) {
        
        tissueData <- c("null", "null", "null", "null", "null", "null", "null")
        names(tissueData) <- c("label", "patient", "location", "diagnosis", "grade", "dt", "coords")
        
        
        # label non empty string
        tissueData["label"] <- paste("'", label, "'", sep = "")
        
        
        # patient is non empty integer
        tissueData["patient"] <- patientId
        
        
        # Location Selector
        if (location != "" & ! is.null(location)) {
                tissueData["location"] <- paste("'", location, "'", sep = "")
        }
        
        
        # Diagnosis Selector
        tissueData["diagnosis"] <- diagnosisDictionary$id[match(diagnosisSelector(), diagnosisDictionary$name)]
        
        
        # Grade Selector
        if (gradeSelector[[1]]() != "null") {
                tissueData["grade"] <- gradeSelector[[2]]()
        }
        
        
        # Time Selector
        if (timeSelector[[1]]() != "null") {
                tissueData["dt"] <- paste("'", as.Date(timeSelector[[2]](), format = "yyyy-mm-dd"), "'", sep = "")
        }
        
        
        # Coords Selector
        if (coords != "" & ! is.null(coords)) {
                tissueData["coords"] <- paste("'", coords, "'", sep = "")
        }
        
        
        return(tissueData)
}
