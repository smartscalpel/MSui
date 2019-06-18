tissuesSndCreateNewPatient <- function(pool) {
        function(emsid) {
                
                df <- data.frame(NA, emsid, -1, NA, NA)
                x <- c("id", "emsid", "yob", "sex", "age")
                colnames(df) <- x
                
                conn <- pool::poolCheckout(pool)
                
                # Single update/insert/delete commands is already in a transaction
                DBI::dbSendQuery(
                        conn,
                        paste(
                                "INSERT INTO patient (emsid, yob) VALUES ('",
                                emsid,
                                "', -1);",
                                sep = ""
                        )
                )
                
                pool::poolReturn(conn)
                
                return(TRUE)
        }
}
