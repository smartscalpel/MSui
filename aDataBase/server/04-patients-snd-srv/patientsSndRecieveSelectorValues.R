patientsSndRecieveSelectorValues <- function(emsId, yob, sex, age) {
        
        patientData <- c("null", "null", "null", "null")
        names(patientData) <- c("emsid", "yob", "sex", "age")
        
        
        # emsid non empty string
        patientData["emsid"] <- emsId
        
        
        # Year of Birth Selector
        if (yob[[1]]() != "-1") {
                patientData["yob"] <- yob[[2]]()
        } else {
                patientData["yob"] <- -1
        }
        
        
        # Sex Selector
        if (sex[[1]]() != "null") {
                patientData["sex"] <- sex[[2]]()
        }
        
        
        # Age Selector
        if (age[[1]]() != "null") {
                patientData["age"] <- age[[2]]()
        }
        
        
        return(patientData)
}
