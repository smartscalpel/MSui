patientsSndRecieveDataFromSelectors <- function(emsId, yob, sex, age) {
        
        patientData <- c("null", "null", "null", "null")
        names(patientData) <- c("emsid", "yob", "sex", "age")
        
        # emsid non empty string
        patientData["emsid"] <- emsId
        
        # yob has to be not null
        patientData["yob"] <- yob()
        
        if (sex[[1]]() != "null") {
                patientData["sex"] <- sex[[2]]()
        }
        
        if (age[[1]]() != "null") {
                patientData["age"] <- age[[2]]()
        }
        
        return(patientData)
}
