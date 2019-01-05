tissuesSndSaveTissue <- function(pool) {
        function(tissueData) {
                
                print(tissueData)
                
                conn <- pool::poolCheckout(pool)
                
                # Single update/insert/delete commands is already in a transaction
                updatedResult <- tryCatch(
                        {
                                DBI::dbSendQuery(
                                        conn,
                                        paste(
                                                "INSERT INTO tissue (label, patientid, location, diagnosis, grade, dt, coords) VALUES (",
                                                paste(tissueData, collapse = ", "),
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
}
