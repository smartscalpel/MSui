generateErrorMessage <- function(errorText) {
        shiny::renderText({
                paste(
                        "<font color=\"#FF0000\" size=\"2\">",
                        paste(
                                "Error:",
                                paste(errorText, collapse = ', '),
                                collapse = ' '
                        ),
                        "</font>"
                )
        })
}
