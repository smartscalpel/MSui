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
                        dataFromDB <- dataFromDB %>% dplyr::filter(sex == 'М')
                }
                if (sexSelector[[1]]() == "women") {
                        dataFromDB <- dataFromDB %>% dplyr::filter(sex == 'Ж')
                }
        }
        
        if (sexSelector[[1]]() == "null") {
                dataFromDB <- dataFromDB %>% dplyr::filter(is.null(sex))
        }
        
        
        # Age Selector
        if (ageSelector[[1]]() == "range") {
                dataFromDB <- dataFromDB %>%
                        dplyr::filter(age >= ageSelector[[2]]()[1]) %>%
                        dplyr::filter(age <= ageSelector[[2]]()[2])
        }
        
        if (ageSelector[[1]]() == "null") {
                dataFromDB <- dataFromDB %>% dplyr::filter(is.null(age))
        }
        
        
        # Year of Birth Selector
        if (yobSelector[[1]]() == "range") {
                dataFromDB <- dataFromDB %>%
                        dplyr::filter(yob >= yobSelector[[2]]()[1]) %>%
                        dplyr::filter(yob <= yobSelector[[2]]()[2])
        }
        
        if (yobSelector[[1]]() == "-1") {
                dataFromDB <- dataFromDB %>% dplyr::filter(yob == -1) 
        }
        
        
        # Recive data from DB
        dataFromDB <- dplyr::as_data_frame(dataFromDB)
        dataFromDB <- data.frame(dataFromDB)
        
        return(dataFromDB)
}
