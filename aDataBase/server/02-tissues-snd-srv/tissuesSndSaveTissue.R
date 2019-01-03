tissuesSndSaveTissue <- function(pool) {
        function(tissueData) {
                
                print(tissueData)
                
                conn <- pool::poolCheckout(pool)
                
                # Single update/insert/delete commands is already in a transaction
                dbSendQuery(
                        conn,
                        paste(
                                "INSERT INTO tissue (label, patientid, location, diagnosis, grade, dt, coords) VALUES (",
                                paste(tissueData, collapse = ", "),
                                ");",
                                sep = ""
                        )
                )
                
                pool::poolReturn(conn)
                
                return (TRUE)
        }
}
