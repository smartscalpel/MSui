tissuesSndRecieveSelectorValues <- function(label, patientId, location, diagnosisSelector, gradeSelector, coords, timeSelector) {
        
        tissueData <- c("null", "null", "null", "null", "null", "null", "null")
        names(tissueData) <- c("label", "patient", "location", "diagnosis", "grade", "dt", "coords")
        
        
        # label non empty string
        tissueData["label"] <- label
        
        
        # patient is non empty integer
        tissueData["patient"] <- patientId
        
        
        # Location Selector
        if (location != "" & ! is.null(location)) {
                tissueData["location"] <- location
        }
        
        
        # Diagnosis Selector
        tissueData["diagnosis"] <- diagnosisDictionary$id[match(diagnosisSelector(), diagnosisDictionary$name)]
        
        
        # Grade Selector
        if (gradeSelector[[1]]() != "null") {
                tissueData["grade"] <- integer(gradeSelector[[2]]())
        }
        
        
        # Time Selector
        if (timeSelector[[1]]() != "null") {
                tissueData["dt"] <- as.Date(timeSelector[[2]]())
        }
        
        
        # Coords Selector
        if (coords != "" & ! is.null(coords)) {
                tissueData["coords"] <- coords
        }
        
        
        return(tissueData)
}
