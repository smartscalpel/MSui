# Save updated data in database
tissuesSaveUpdated <- function(pool) {
        function (updatedPart) {
                updatedPart[c("yob", "sex", "age", "emsid")] <- NULL
                
                # Preprocessing Step
                updatedPart$diagnosis <- sapply(
                        updatedPart$diagnosis,
                        function(x) diagnosisDictionary$id[match(x, diagnosisDictionary$name)]
                )
                updatedPart[is.na(updatedPart)] <- "null"
                
                # Create a transaction
                conn <- pool::poolCheckout(pool)

                updatedResult <- tryCatch({
                                pool::poolWithTransaction(pool, function(conn) {
                                        for (i in 1:nrow(updatedPart)) {
                                                DBI::dbExecute(
                                                        conn,
                                                        paste(
                                                                "UPDATE tissue SET",
                                                                " label = '",    updatedPart[i, "label"],     "',",
                                                                " patientid = ", updatedPart[i, "patientid"], ",",
                                                                " location = '", updatedPart[i, "location"],  "',",
                                                                " diagnosis = ", updatedPart[i, "diagnosis"], ",",
                                                                " grade = ",     updatedPart[i, "grade"],     ",",
                                                                " dt = '",       updatedPart[i, "dt"],        "',",
                                                                " coords = '",   updatedPart[i, "coords"],    "'",
                                                                " WHERE id = ",  updatedPart[i, "id"],        ";",
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
        }
}
