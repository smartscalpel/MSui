patientsSndSavePatient <- function(pool, patientData) {
        
        conn <- pool::poolCheckout(pool)
        
        # Single update/insert/delete commands is already in a transaction
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
        
        pool::poolReturn(conn)
        
        return (TRUE)
}
