dataModal <- function(modalID = session$ns("ok"), failed, msg) {
        modalDialog(
                if (failed)
                        div(tags$b(msg, style = "color: red;")),
                
                if (! failed)
                        div(tags$b(msg, style = "color: green;")),
                
                footer = tagList(
                        actionButton(modalID, "OK")
                )
        )
}
