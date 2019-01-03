tissuesAddCheckLabelUniqueness <- function(pool) {
        function(labelValue) {
                
                if (labelValue == "" | is.null(labelValue))
                        return(FALSE)
                
                labelValueWithSpace <- paste(labelValue, " ", sep = "")
                
                dataFromDB <- dplyr::tbl(pool, "tissue")
                dataFromDB <- dataFromDB %>% filter(label == labelValue | label == labelValueWithSpace)
                dataFromDB <- data.frame(dataFromDB)
                
                if (dim(dataFromDB)[1] == 1) {
                        return(FALSE)
                } else {
                        return(TRUE)
                }
        }
}
