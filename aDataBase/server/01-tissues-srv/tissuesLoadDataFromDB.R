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

# Return a datatable
tissuesLoadDataFromDB <- function(pool,
                                  fridgeSelector,
                                  sexSelector,
                                  ageSelector,
                                  diagnosisSelector,
                                  timeSelector) {
        
        # The following sequence of operations never touches the database,
        # until we ask the data in the end
        
        dataFromDB <- dplyr::tbl(pool, "patisue4abd")
        
        
        # Fridge Selector
        if (fridgeSelector[[1]]() != "all") {
                
        }
        
        
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
        
        
        # Diagnosis Selector
        if (diagnosisSelector[[1]]() != "all") {
                # Recive actial list of diagnosis
                dataFromDB <- dataFromDB %>% dplyr::filter(diagnosis %in% diagnosisSelector[[2]]())
        }
        
        
        # Time Selector
        if (timeSelector[[1]]() == "range") {
                dataFromDB <- dataFromDB %>%
                        dplyr::filter(dt >= timeSelector[[2]]()[1]) %>%
                        dplyr::filter(dt <= timeSelector[[2]]()[2])
        }
        
        if (timeSelector[[1]]() == "null") {
                dataFromDB <- dataFromDB %>% dplyr::filter(is.null(dt))
        }
        
        
        
        # Recive data from DB
        dataFromDB <- dplyr::as_data_frame(dataFromDB)
        dataFromDB <- data.frame(dataFromDB)
        
        return(dataFromDB)
}
