# You need to be sure, that 'patisue4abd' view exisits. To create it you need to run the following
# 
# CREATE VIEW patisue4abd AS
# (
#         SELECT t.id, t.patientid, emsid, yob, age, sex, label, location, d.name 
#         AS diagnosis, grade, coords, dt
#         FROM ms.Patient p
#         JOIN ms.Tissue t ON p.id=t.patientid
#         JOIN ms.diagnosis d ON t.diagnosis=d.id
# );
#

get_numeric <- function(f) {
        return(as.numeric(levels(f))[as.integer(f)])
}

# Return a datatable
tissuesLoadDataFromDB <- function(pool,
                                  fridgeSelector,
                                  sexSelector,
                                  ageSelector,
                                  diagnosisSelector,
                                  timeSelector) {
        
        # The following sequence of operations never touches the database,
        # until we ask the data in the end
        
        dataFromDB <- dplyr::tbl(pool, "patissue4ui")
        
        # Fridge Selector
        if (fridgeSelector[[1]]() != "all") {
                
        }
        
        
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
                #browser()
                l_value <- ageSelector[[2]]()[1]
                r_value <- ageSelector[[2]]()[2]
                dataFromDB <- dataFromDB %>%
                        dplyr::filter(between(age, l_value, r_value))
        }
        
        if (ageSelector[[1]]() == "null") {
                dataFromDB <- dataFromDB %>% dplyr::filter(is.null(age))
        }
        
        
        # Diagnosis Selector
        if (diagnosisSelector[[1]]() != "all") {
                # Recive actial list of diagnosis
                dataFromDB <- dataFromDB %>% dplyr::filter(diagnosis %in% diagnosisSelector[[2]]())
        }
        
        
        # Time Selector
        if (timeSelector[[1]]() == "range") {
                start_date <- timeSelector[[2]]()[1]
                end_date <- timeSelector[[2]]()[2]
                dataFromDB <- dataFromDB %>%
                        dplyr::filter(dt >= start_date) %>%
                        dplyr::filter(dt <= end_date)
        }
        
        if (timeSelector[[1]]() == "null") {
                dataFromDB <- dataFromDB %>% dplyr::filter(is.null(dt))
        }
        #browser()
        # Recive data from DB
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
}
