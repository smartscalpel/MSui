#!/usr/bin/Rscript

############ Predefined parameters
dbname = "msinvent"
usr='msinvent'
pwd='msinvent'
dtPath = '/Volumes/AS_WD_HFS/Scalpel/DBData/' #'/var/workspaceR/scalpelData/data/'
tmpPath = '/Volumes/AS_WD_HFS/Scalpel/Burdenko/' #'/var/workspaceR/scalpelData/data/'
archPath = '/var/workspaceR/scalpelData/archive/Burdenko/'
path<-'/Volumes/AS_WD_HFS/Scalpel/DBData/'
#########################################

fl<-dir(path=tmpPath,pattern='.*tmp_peak.tsv$',recursive=TRUE)
wd<-getwd()
for(f in fl){
#  ls()->L
#  rm(list=L[!L%in%c('fl','f','rmd.name')])
  dir.name<-sub('tmp_peak.tsv','',f)
  rmd.name<-paste0(dir.name,'load.Rmd')
  cat('peaks:',f,'\ndir:',dir.name,'\nrmd:',rmd.name,'\n')
  rmd.fname<-paste0(tmpPath,'/',rmd.name)
  pdf.fname<-sub('.Rmd$','.pdf',rmd.fname)
  cat('fname',rmd.fname,'\npdf',pdf.fname,'\n')
  file.copy('../load2scalpelDB.Rmd',rmd.fname)
  rmd.fname<-normalizePath(rmd.fname)
  if(!file.exists(sub('Rmd','pdf',rmd.fname))){
    cdf.file<-normalizePath(paste0(path,f))
    try(rmarkdown::render(rmd.fname,'pdf_document'),FALSE,outFile=sub('Rmd$','try.out',rmd.fname))
  }
}

