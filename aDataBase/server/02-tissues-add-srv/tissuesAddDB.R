# You need to be sure, that patient table exists.



tissuesCheckEmsId <- function(pool, emsIdValue) {
        
        # The following sequence of operations never touches the database,
        # until we ask the data in the end
        
        if (emsIdValue == "" | is.null(emsIdValue)) {
                return(list(NULL, NULL))        
        }
        
        dataFromDB <- dplyr::tbl(pool, "patient")
        dataFromDB <- dataFromDB %>% filter(emsid == emsIdValue)
        dataFromDB <- data.frame(dataFromDB)
        
        if (dim(dataFromDB)[1] == 1) {
                return(list(TRUE, dataFromDB))
        } else {
                return(list(FALSE, NULL))
        }
}



tissuesCheckLabelUniqueness <- function(pool) {
        function(labelValue) {
                
                if (labelValue == "" | is.null(labelValue))
                        return(FALSE)
                
                labelValueWithSpace <- paste(labelValue, " ", sep = "")
                
                dataFromDB <- dplyr::tbl(pool, "tissue")
                dataFromDB <- dataFromDB %>% filter(label == labelValue | label == labelValueWithSpace)
                dataFromDB <- data.frame(dataFromDB)
                
                if (dim(dataFromDB)[1] >= 1) {
                        return(FALSE)
                } else {
                        return(TRUE)
                }
        }
}



tissuesSaveEntry <- function(pool) {
        function(tissueData) {
                
                
                
                return (TRUE)
        }
}



tissuesAddNewPatient <- function(pool, emsid) {
                
        df <- base::data.frame(NA, emsid, -1, NA, NA)
        x <- c("id", "emsid", "yob", "sex", "age")
        base::colnames(df) <- x
        
        conn <- pool::poolCheckout(pool)
        
        dbSendQuery(
                conn,
                paste(
                        "INSERT INTO patient (emsid, yob) VALUES ('",
                        emsid,
                        "', -1);",
                        sep = ""
                )
        )
        
        pool::poolReturn(conn)
}

