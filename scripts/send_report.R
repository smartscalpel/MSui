#!/usr/bin/Rscript

dt <- format(Sys.time(), "%d.%m.%Y %H:%M")
sender <- "dataloader@scalpeldb.mipt.ru"  # Replace with a valid address
recipients <- c("denis.zavorotnyuk@gmail.com")  # Replace with one or more valid addresses
rfn <- paste0('scalpelReportDT.', format(Sys.time(), "%Y.%m.%d.%H"), '*.pdf')
rfPath <- '/var/workspaceR/scalpelData/archive/loaded_data'
files <- list.files(dtPath, pattern = rfn, full.names = FALSE)
body <- paste0('<html>',
               '<head>',
               '<style>.error {color: red; font-weight: bold;} .ok {color: green; font-weight: bold;}</style>',
               '</head>',
               '<body>',
               '<p>',
               'Data loading into DataBase has been finished verd at ',
               dt,
               '.</p>report</body></html>')

if (length(files) > 0) {
  body <- stringr::str_replace(body, "verd", '<span class="ok">successfully</span>')
  body <- stringr::str_replace(body, "report", '<p>The report is attached</p>')
  email <- send.mail(from = sender,
                     to = recipients,
                     subject="Nightly dataloading",
                     body = body,
                     smtp = list(host.name = "smtp.mipt.ru", port = 25),
                     authenticate = FALSE,
                     send = FALSE,
                     html = TRUE,
                     attach.files	= paste(rfPath, files[[1]], sep='/'))
} else {
  body <- stringr::str_replace(body, "verd", '<span class="error">with errors</span>')
  body <- stringr::str_replace(body, "report", '')
  email <- send.mail(from = sender,
                     to = recipients,
                     subject="Nightly dataloading",
                     body = body,
                     smtp = list(host.name = "smtp.mipt.ru", port = 25),
                     authenticate = FALSE,
                     html = TRUE,
                     send = FALSE)
}

email$send()
