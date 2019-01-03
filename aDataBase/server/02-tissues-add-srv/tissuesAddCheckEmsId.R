# You need to be sure, that patient table exists.
tissuesAddCheckEmsId <- function(pool, emsIdValue) {
        
        # The following sequence of operations never touches the database,
        # until we ask the data in the end
        
        emsIdValue <- toString(emsIdValue)
        
        if (emsIdValue == "" | is.null(emsIdValue)) {
                return(list(NULL, NULL))        
        }
        
        dataFromDB <- dplyr::tbl(pool, "patient")
        dataFromDB <- dataFromDB %>% filter(emsid == emsIdValue)
        dataFromDB <- data.frame(dataFromDB)
        
        if (dim(dataFromDB)[1] >= 1) {
                return(list(TRUE, dataFromDB))
        } else {
                return(list(FALSE, NULL))
        }
}
