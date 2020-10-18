#!/usr/bin/Rscript

library(mailR)

dt <- format(Sys.time(), "%d.%m.%Y %H:%M")
sender <- "dataloader@scalpeldb.mipt.ru"  # Replace with a valid address
recipients <- c("denis.zavorotnyuk@gmail.com", "lptolik@gmail.com", "hexapole@gmail.com")  # Replace with one or more valid addresses
rfn <- paste0('scalpelReportDT.', format(Sys.time(), "%Y.%m.%d."), '*.pdf')
rfn2 <- paste0('scalpelReport.', format(Sys.time(), "%Y.%m.%d."), '*.pdf')
rfn3 <- paste0('scalpelReportLast7Days.', format(Sys.time(), "%Y.%m.%d."), '*.pdf')
rfPath <- '/var/workspaceR/scalpelData/archive/loaded_data'
files_all <- c(list.files(rfPath, pattern = rfn, full.names = TRUE), 
               list.files(rfPath, pattern = rfn2, full.names = TRUE),
               list.files(rfPath, pattern = rfn3, full.names = TRUE))
body <- paste0('<html>',
               '<head>',
               '<style>.error {color: red; font-weight: bold;} .ok {color: green; font-weight: bold;}</style>',
               '</head>',
               '<body>',
               '<p>',
               'Data loading into DataBase has been finished verd at ',
               dt,
               '.</p>report</body></html>')

if (length(files_all) > 0) {
  body <- stringr::str_replace(body, "verd", '<span class="ok">successfully</span>')
  body <- stringr::str_replace(body, "report", paste0('<p>The reports are attached</p>',
                                                      '<ul><li>',
                                                      paste(basename(files_all), sep = '</li><li>'),
                                                      '</li>'))
  email <- send.mail(from = sender,
                     to = recipients,
                     subject="Nightly dataloading",
                     body = body,
                     smtp = list(host.name = "smtp.mipt.ru", port = 25),
                     authenticate = FALSE,
                     send = FALSE,
                     html = TRUE,
                     attach.files	= files_all)
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
