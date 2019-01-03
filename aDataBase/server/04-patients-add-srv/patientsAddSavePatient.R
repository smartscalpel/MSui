patientsAddSavePatient <- function(pool, patientsAddData) {
        
        conn <- pool::poolCheckout(pool)
        
        # Single update/insert/delete commands is already in a transaction
        DBI::dbSendQuery(
                conn,
                paste(
                        "INSERT INTO patient (emsid, yob, sex, age) VALUES (",
                        paste(
                                c(
                                        patientsAddData["emsid"],
                                        patientsAddData["yob"],
                                        patientsAddData["sex"],
                                        patientsAddData["age"]
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
