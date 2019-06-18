patientsSndSavePatient <- function(pool, patientData) {
        
        conn <- pool::poolCheckout(pool)
        
        # Single update/insert/delete commands is already in a transaction
        updatedResult <- tryCatch(
                {
                        DBI::dbSendQuery(
                                conn,
                                paste(
                                        "INSERT INTO patient (emsid, yob, sex, age) VALUES (",
                                        paste(
                                                c(
                                                        patientData["emsid"],
                                                        patientData["yob"],
                                                        patientData["sex"],
                                                        patientData["age"]
                                                ),
                                                collapse = ", "
                                        ),
                                        ");",
                                        sep = ""
                                )
                        )
                        TRUE
                },
                error = function(c) FALSE
        )
        
        pool::poolReturn(conn)
        
        return (updatedResult)
}
