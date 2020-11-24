# Return a datatable
patientsLoadDataFromDB <- function(pool,
                                   sexSelector,
                                   ageSelector,
                                   yobSelector) {
        
        # The following sequence of operations never touches the database,
        # until we ask the data in the end
        
        dataFromDB <- dplyr::tbl(pool, "patient")
        
        
        # Sex Selector
        if (sexSelector[[1]]() != "all" & sexSelector[[1]]() != "null") {
                if (sexSelector[[1]]() == "men") {
                        dataFromDB <- dataFromDB %>% dplyr::filter(sex %in% c('М', 'M', 'm', 'м'))
                }
                if (sexSelector[[1]]() == "women") {
                        dataFromDB <- dataFromDB %>% dplyr::filter(sex %in% c('Ж', 'F', 'f', 'ж'))
                }
        }
        
        if (sexSelector[[1]]() == "null") {
                dataFromDB <- dataFromDB %>% dplyr::filter(is.null(sex))
        }
        
        
        # Age Selector
        if (ageSelector[[1]]() == "range") {
                l_value <- ageSelector[[2]]()[1]
                r_value <- ageSelector[[2]]()[2]
                dataFromDB <- dataFromDB %>%
                        dplyr::filter(between(age, l_value, r_value))
        }
        
        if (ageSelector[[1]]() == "null") {
                dataFromDB <- dataFromDB %>% dplyr::filter(is.null(age))
        }
        
        
        # Year of Birth Selector
        if (yobSelector[[1]]() == "range") {
                l_value <- yobSelector[[2]]()[1]
                r_value <- yobSelector[[2]]()[2]
                dataFromDB <- dataFromDB %>%
                        dplyr::filter(between(yob, l_value, r_value))
        }
        
        if (yobSelector[[1]]() == "-1") {
                dataFromDB <- dataFromDB %>% dplyr::filter(yob == -1) 
        }
        
        out <- tryCatch(
                {
                        dataFromDB <- dplyr::as_data_frame(dataFromDB)
                        dataFromDB <- data.frame(dataFromDB)
                },
                error = function(c) {
                        return(list('error', paste(c[[1]])))
                }
        )
        #browser()
        if (
                length(out) > 0 & isTRUE(out[[1]] == 'error')
        ){
                return(list(FALSE, 'Failed to load data from DataBase!', out[[2]]))
                #dataFromDB$errordescr <-      
        }
        
        return(list(TRUE, dataFromDB))
        # Recive data from DB
        #dataFromDB <- dplyr::as_data_frame(dataFromDB)
        #dataFromDB <- data.frame(dataFromDB)
        
        #return(dataFromDB)
}
