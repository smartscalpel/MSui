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
try(rmarkdown::render(rmd.fname,'pdf_document',clean=FALSE),FALSE,outFile=sub('Rmd$','try.out',rmd.fname))
cat('Report over',format(Sys.time(), "%b %d %X"),'\n')
repDate<-'2019-01-01'
rmd.fname<-paste0('scalpelReportDT.',format(Sys.time(), "%Y.%m.%d.%H_%M_%S"),'.Rmd')
cat('Report:',format(Sys.time(), "%b %d %X"),'\n')
file.copy('./scalpelDBReportDT.Rmd',rmd.fname)
try(rmarkdown::render(rmd.fname,'pdf_document',clean=FALSE),FALSE,outFile=sub('Rmd$','try.out',rmd.fname))
cat('Dated Report over',format(Sys.time(), "%b %d %X"),'\n')

