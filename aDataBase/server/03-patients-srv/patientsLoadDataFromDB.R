# Return a datatable
patientsLoadDataFromDB <- function(pool,
                                   sexSelector,
                                   ageSelector,
                                   yobSelector) {
        
        # The following sequence of operations never touches the database,
        # until we ask the data in the end
        
        dataFromDB <- dplyr::tbl(pool, "patient")
        
        if (sexSelector[[1]]() != "all") {
                if (sexSelector[[1]]() == "men") {
                        dataFromDB <- dataFromDB %>% filter(sex == 'М')
                }
                if (sexSelector[[1]]() == "women") {
                        dataFromDB <- dataFromDB %>% filter(sex == 'Ж')
                }
        }
        
        if (ageSelector[[1]]() != "all") {
                dataFromDB <- dataFromDB %>%
                        filter(age >= ageSelector[[2]]()[1]) %>%
                        filter(age <= ageSelector[[2]]()[2])
        }
        
        if (yobSelector[[1]]() != "all") {
                dataFromDB <- dataFromDB %>%
                        filter(yob >= yobSelector[[2]]()[1]) %>%
                        filter(yob <= yobSelector[[2]]()[2])
        }
        
        # Recive data from DB
        dataFromDB <- dplyr::as_data_frame(dataFromDB)
        dataFromDB <- data.frame(dataFromDB)
        
        return(dataFromDB)
}
