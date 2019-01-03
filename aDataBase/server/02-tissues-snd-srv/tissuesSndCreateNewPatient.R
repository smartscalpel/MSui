tissuesSndCreateNewPatient <- function(pool) {
        function(emsid) {
                
                df <- base::data.frame(NA, emsid, -1, NA, NA)
                x <- c("id", "emsid", "yob", "sex", "age")
                base::colnames(df) <- x
                
                conn <- pool::poolCheckout(pool)
                
                # Single update/insert/delete commands is already in a transaction
                dbSendQuery(
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
