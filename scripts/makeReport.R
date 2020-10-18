#!/usr/bin/Rscript

############ Predefined parameters
# dbname = "msinvent"
# usr='msinvent'
# pwd='msinvent'
# dtPath = '/Volumes/AS_WD_HFS/Scalpel/DBData/' #'/var/workspaceR/scalpelData/data/'
# tmpPath = '/Volumes/AS_WD_HFS/Scalpel/Burdenko/' #'/var/workspaceR/scalpelData/data/'
# archPath = '/var/workspaceR/scalpelData/archive/Burdenko/'
# path<-'/Volumes/AS_WD_HFS/Scalpel/DBData/'
#########################################
source('./Burdenko/path.R')
rmd.fname<-paste0('scalpelReport.',format(Sys.time(), "%Y.%m.%d.%H_%M_%S"),'.Rmd')
cat('Report:',format(Sys.time(), "%b %d %X"),'\n')
file.copy('./scalpelDBReport.Rmd',rmd.fname)
try(rmarkdown::render(rmd.fname,
                      'pdf_document',
                      clean=TRUE,
                      intermediates_dir = 'scalpeldb_report_files'),
    FALSE,
    outFile=sub('Rmd$','try.out',rmd.fname))
cat('Report over',format(Sys.time(), "%b %d %X"),'\n')
repDate<-'2019-01-01'
rmd.fname<-paste0('scalpelReportDT.',format(Sys.time(), "%Y.%m.%d.%H_%M_%S"),'.Rmd')
cat('Report:',format(Sys.time(), "%b %d %X"),'\n')
file.copy('./scalpelDBReportDT.Rmd',rmd.fname)
try(rmarkdown::render(rmd.fname,
                      'pdf_document',
                      clean=TRUE,
                      intermediates_dir = 'scalpeldb_report_files'),
    FALSE,
    outFile=sub('Rmd$','try.out',rmd.fname))
cat('Dated Report over',format(Sys.time(), "%b %d %X"),'\n')
defDate <- as.Date(Sys.time()) - 7
weekly.rmd.fname <- paste0('scalpelReportLast7Days.',format(Sys.time(), "%Y.%m.%d.%H_%M_%S"),'.Rmd')
file.copy('./scalpelDBReportDT.Rmd', weekly.rmd.fname)

try(rmarkdown::render(weekly.rmd.fname,
                      'pdf_document',
                      clean = TRUE,
                      intermediates_dir = 'scalpeldb_report_files',
                      params = list(defDate = format(defDate, "%Y-%m-%d"))),
    FALSE,
    outFile=sub('Rmd$','try.out', weekly.rmd.fname))

