#!/usr/bin/Rscript

dt <- format(Sys.time(), "%d.%m.%Y %H:%M")
sender <- "dataloader@scalpeldb.mipt.ru"  # Replace with a valid address
recipients <- c("denis.zavorotnyuk@gmail.com")  # Replace with one or more valid addresses
rfn <- paste0('scalpelReportDT.', format(Sys.time(), "%Y.%m.%d.%H"), '*.pdf')
rfPath <- '/var/workspaceR/scalpelData/archive/loaded_data'
files <- list.files(dtPath, pattern = rfn, full.names = FALSE)
body <- paste0('<html>',
               '<head></head>',
               '<body>',
               '<p>',
               'Data loading into DataBase has been finished verd at ',
               dt,
               '.</p>report</body></html>')

if (length(files) > 0) {
  body <- stringi::stri_replace(body, "verd", '<span color="green">successfully</span>')
  body <- stringi::stri_replace(body, "report", '<p>The report is attached</p>')
  email <- send.mail(from = sender,
                     to = recipients,
                     subject="Nightly dataloading",
                     body = body,
                     smtp = list(host.name = "smtp.mipt.ru", port = 25),
                     authenticate = FALSE,
                     send = FALSE,
                     attach.files	= files[[1]])
} else {
  body <- stringi::stri_replace(body, "verd", '<span color="red">with errors</span>')
  body <- stringi::stri_replace(body, "report", '')
  email <- send.mail(from = sender,
                     to = recipients,
                     subject="Nightly dataloading",
                     body = body,
                     smtp = list(host.name = "smtp.mipt.ru", port = 25),
                     authenticate = FALSE,
                     send = FALSE)
}

email$send()
