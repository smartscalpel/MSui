patientsSndCheckEmsIdUniqueness <- function(pool, emsIdValue) {
                
        if (emsIdValue == "" | is.null(emsIdValue))
                return(FALSE)
                
        emsIdValueWithSpace <- paste(emsIdValue, " ", sep = "")
                
        dataFromDB <- dplyr::tbl(pool, "patient")
        dataFromDB <- dataFromDB %>% filter(emsid == emsIdValue | emsid == emsIdValueWithSpace)
        dataFromDB <- data.frame(dataFromDB)
                
        if (dim(dataFromDB)[1] == 1) {
                return(FALSE)
        } else {
                return(TRUE)
        }
}
