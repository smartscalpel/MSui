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
        
        if (fridgeSelector[[1]]() != "all") {
                
        }
        
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
        
        if (diagnosisSelector[[1]]() != "all") {
                # Recive actial list of diagnosis
                dataFromDB <- dataFromDB %>% filter(diagnosis %in% diagnosisSelector[[2]]())
        }
        
        if (timeSelector[[1]]() != "all") {
                dataFromDB <- dataFromDB %>%
                        filter(dt >= timeSelector[[2]]()[1]) %>%
                        filter(dt <= timeSelector[[2]]()[2])
        }
        
        # Recive data from DB
        dataFromDB <- dplyr::as_data_frame(dataFromDB)
        dataFromDB <- data.frame(dataFromDB)
        
        return(dataFromDB)
}
