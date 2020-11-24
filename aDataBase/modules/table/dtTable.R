js <- c(
  "function(settings){",
  "  $('tr td:nth-child(9)').bsDatepicker({",
  "    format: 'yyyy-mm-dd',",
  "    todayHighlight: true",
  "  });",
  "}"
) # available options: https://bootstrap-datepicker.readthedocs.io/en/latest/

dtTable <- function(dataFromDB, editable, hideColumns, height) {
        DT::datatable(
                data = dataFromDB,
                rownames = FALSE,
                
                extensions = list(
                        # Bottons
                        'Buttons'= NULL,
                        
                        # The Scroller extension makes it possible to only render
                        # the visible portion of the table.
                        'Scroller' = NULL
                ),
                
                options = list(
                        #initComplete = JS(js),
                        columnDefs = list(      
                          list(
                                        targets = c(0:(length(colnames(dataFromDB)) - 1)),
                                        render = JS(
                                                "function(data, type, row, meta) {",
                                                        "",
                                                        "return type === 'display' && !!data && data.length >= 15 ?",
                                                        "'<span title=\"' + data + '\">' + data.substr(0, 14) + '..</span>' : data;",
                                                "}"
                                        ),
                                        className = "td"
                                ),
                                list(
                                        visible = FALSE,
                                        targets = hideColumns
                                )
                        ),
                        editType = list(
                          "8" = "select",
                          "7" = "text",
                          "6" = "text",
                          "9" = "text",
                          "11" = "text",
                          "10" = "text",
                          "12" = "text"
                        ),
                        editAttribs = list(
                          "8" = list(
                            options = diagnosisDictionary$name,
                            value = diagnosisDictionary$id
                          ),
                          "7" = list(placeholder = colnames(dataFromDB)[8]),
                          "6" = list(placeholder = colnames(dataFromDB)[7]),
                          "9" = list(placeholder = colnames(dataFromDB)[10]),
                          "10" = list(placeholder = colnames(dataFromDB)[11]),
                          "11" = list(placeholder = colnames(dataFromDB)[12]),
                          "12" = list(placeholder = colnames(dataFromDB)[13])
                        ),
                        # Bottons
                        dom = 'Bfrtip',
                        buttons = list(
                                'colvis',
                                list(
                                        extend = 'collection',
                                        buttons = c('csv', 'excel', 'pdf'),
                                        text = 'Download'
                                )
                        ),
                        
                        # The Scroller extension makes it possible to only render
                        # the visible portion of the table.
                        deferRender = TRUE,
                        scrollX = TRUE,
                        scrollCollapse = TRUE,
                        paging = FALSE,
                        scrollY = height
                ),
                
                selection = "none",
                editable = editable
        )
}

patientsDtTable <- function(dataFromDB, editable, hideColumns, height) {
  DT::datatable(
    data = dataFromDB,
    rownames = FALSE,
    
    extensions = list(
      # Bottons
      'Buttons'= NULL,
      
      # The Scroller extension makes it possible to only render
      # the visible portion of the table.
      'Scroller' = NULL
    ),
    
    options = list(
      #initComplete = JS(js),
      columnDefs = list(      
        list(
          targets = c(0:(length(colnames(dataFromDB)) - 1)),
          render = JS(
            "function(data, type, row, meta) {",
            "",
            "return type === 'display' && !!data && data.length >= 15 ?",
            "'<span title=\"' + data + '\">' + data.substr(0, 14) + '..</span>' : data;",
            "}"
          ),
          className = "td"
        ),
        list(
          visible = FALSE,
          targets = hideColumns
        )
      ),
      editType = list(
        "1" = "text",
        "2" = "text",
        "3" = "text",
        "4" = "text"
      ),
      editAttribs = list(
        "1" = list(placeholder = colnames(dataFromDB)[1]),
        "2" = list(placeholder = colnames(dataFromDB)[2]),
        "3" = list(placeholder = colnames(dataFromDB)[3]),
        "4" = list(placeholder = colnames(dataFromDB)[4])
      ),
      # Bottons
      dom = 'Bfrtip',
      buttons = list(
        'colvis',
        list(
          extend = 'collection',
          buttons = c('csv', 'excel', 'pdf'),
          text = 'Download'
        )
      ),
      
      # The Scroller extension makes it possible to only render
      # the visible portion of the table.
      deferRender = TRUE,
      scrollX = TRUE,
      scrollCollapse = TRUE,
      paging = FALSE,
      scrollY = height
    ),
    
    selection = "none",
    editable = editable
  )
}
