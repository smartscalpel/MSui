patientsSndRecieveSelectorValues <- function(emsId, yob, sex, age) {
        
        patientData <- c("null", "null", "null", "null")
        names(patientData) <- c("emsid", "yob", "sex", "age")
        
        
        # EmsId
        patientData["emsid"] <- paste("'", emsId, "'", sep = "")
        
        
        # Year of Birth Selector
        if (yob[[1]]() != "-1") {
                patientData["yob"] <- yob[[2]]()
        } else {
                patientData["yob"] <- -1
        }
        
        
        # Sex Selector
        if (sex() != "null") {
                if (sex() == "men") {
                        patientData["sex"] <- "'M'"
                }
                if (sex() == "women") {
                        patientData["sex"] <- "'F'"
                }
        }
        
        
        # Age Selector
        if (age[[1]]() != "null") {
                patientData["age"] <- age[[2]]()
        }
        
        
        return(patientData)
}
