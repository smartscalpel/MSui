# Save updated data in database
patientsSaveModifiedTable <- function(pool) {
        function (updatedPart) {
                updatedPart[is.na(updatedPart)] <- "null"
                
                updatedPart$sex <- sapply(updatedPart$sex,
                                          function (x) {if (x != "null") paste("'", x, "'", sep = "") else x})
                
                # Create a transaction
                conn <- pool::poolCheckout(pool)
                
                updatedResult <- tryCatch(
                        {
                                pool::poolWithTransaction(pool, function(conn) {
                                        for (i in 1:nrow(updatedPart)) {
                                                DBI::dbExecute(
                                                        conn,
                                                        paste(
                                                                "UPDATE patient SET",
                                                                " yob = ",      updatedPart[i, "yob"],  ",",
                                                                " sex = ",     updatedPart[i, "sex"],   ",",
                                                                " age = ",      updatedPart[i, "age"],  "",
                                                                " WHERE id = ", updatedPart[i, "id"],   ";",
                                                                sep = ""
                                                        )
                                                )
                                        }
                                })
                                TRUE
                        },
                        error = function(c) FALSE
                )
                
                pool::poolReturn(conn)
                
                return(updatedResult)
                
                return(TRUE)
        }
}
