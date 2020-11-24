# Save updated data in database
tissuesSaveModifiedTable <- function(pool) {
        function (updatedPart) {
                updatedPart[c("yob", "sex", "age", "emsid")] <- NULL
                
                shiny::modalDialog(cat("diagnosis: ", updatedPart$diagnosis, "\n"), title = 'test error')
                # Preprocessing Step
                updatedPart$diagnosis <- sapply(
                        updatedPart$diagnosis,
                        function(x) diagnosisDictionary$id[match(x, diagnosisDictionary$name)]
                )
                
                
                updatedPart[is.na(updatedPart)] <- "null"
                updatedPart$label    <- sapply(updatedPart$label,
                                               function (x) {if (x != "null") paste("'", x, "'", sep = "") else x})
                updatedPart$location <- sapply(updatedPart$location,
                                               function (x) {if (x != "null") paste("'", x, "'", sep = "") else x})
                updatedPart$dt       <- sapply(updatedPart$dt,
                                               function (x) {if (x != "null") paste("'", x, "'", sep = "") else x})
                updatedPart$coords   <- sapply(updatedPart$coords,
                                               function (x) {if (x != "null") paste("'", x, "'", sep = "") else x})
                
                
                
                # Create a transaction
                conn <- pool::poolCheckout(pool)

                updatedResult <- tryCatch({
                                pool::poolWithTransaction(pool, function(conn) {
                                        for (i in 1:nrow(updatedPart)) {
                                                DBI::dbExecute(
                                                        conn,
                                                        paste(
                                                                "UPDATE tissue SET",
                                                                " label = ",     updatedPart[i, "label"],     ",",
                                                                " location = ",  updatedPart[i, "location"],  ",",
                                                                " diagnosis = ", updatedPart[i, "diagnosis"], ",",
                                                                " grade = ",     updatedPart[i, "grade"],     ",",
                                                                " dt = ",        updatedPart[i, "dt"],        ",",
                                                                " coords = ",    updatedPart[i, "coords"],    ",",
                                                                " histdiag = '",  updatedPart[i, "histdiag"],  "'",
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
