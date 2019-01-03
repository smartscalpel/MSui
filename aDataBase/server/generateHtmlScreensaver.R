# Show Screensaver with inputText instead of table
# if error is occured
generateHtmlScreenSaver <- function(inputText) {
        shiny::renderUI({
                shiny::fluidRow(
                        shiny::column(
                                width = 12,
                                align = "center",
                                HTML(
                                        paste(
                                                '<div style="display: table; height: 78vh; overflow: hidden;">
                                                        <div style="display: table-cell; vertical-align: middle;">
                                                                <div>
                                                                        <span style="opacity: 0.4;">
                                                                        <font color=\"gray\" face=\"Helvetica\" size=\"3\">',
                                                                                inputText,
                                                                        '</font>
                                                                </div>
                                                        </div>
                                                </div>'
                                        )
                                )
                        )
                )
        })
}

