#!/usr/bin/Rscript

############ Predefined parameters
dbname = "msinvent"
usr='msinvent'
pwd='msinvent'
dtPath = '/Volumes/AS_WD_HFS/Scalpel/DBData/'
devID<-1 #Device
solID<-6 #Solvent
isID<-1 # ionsource
resID<-1 #ResolutionID
smplID<-1 #SampleID
stID<-1 #SampleTumorID
stpID<-1 #SampleTumorPatientID
nMode<-1 #Negative mode
path<-'/var/samba/share/Scalpel/BD_cdf/'
#########################################

fl<-dir(path=path,pattern='*.cdf$',recursive=TRUE)

for(f in fl[-c(1:2)]){
#  ls()->L
#  rm(list=L[!L%in%c('fl','f','rmd.name')])
  dir.name<-sub('.cdf','',basename(f))
  rmd.name<-sub('cdf$','Rmd',basename(f))
  system(paste0('mkdir -p ./',dir.name))
  cat(f,'\n',dir.name,'\n')
  rmd.fname<-paste0(getwd(),'/',dir.name,'/',rmd.name)
  if(!file.exists(rmd.fname)){
    file.copy('load2scalpel.Rmd',rmd.fname)
    if(FALSE){#file.exists(rmd.name)){
      rmarkdown::render(rmd.fname,'pdf_document')
    }
  }
  if(!file.exists(sub('Rmd','pdf',rmd.fname))){
    rmarkdown::render(rmd.fname,'pdf_document')
  }
}


for(f in fl){
  #rmd.name<-gsub('[ _\\(\\)]+','-',sub('cdf$','Rmd',f))
  rmd.name<-paste0(dirname(f),'/',gsub('[ _\\(\\)]+','-',sub('cdf$','Rmd',basename(f))))
  cat(f,'\n',rmd.name,'\n')
  if(!file.exists(rmd.name)){
    file.copy('/Volumes/AS_Backup/Scalpel/Students_extracts_747/ReadCDFfile_template.Rmd',rmd.name)
    cdf.file<-normalizePath(f)
    rmarkdown::render(rmd.name,'pdf_document')
  }
}

library(reshape2)
list10SNR<-list()
list5SNR<-list()
list2SNR<-list()
for(f in fl){
  #rmd.name<-gsub('[ _\\(\\)]+','-',sub('cdf$','Rmd',f))
  rdata.name<-paste0(dirname(f),'/',gsub('[ _\\(\\)]+','-',sub('cdf$','RData',basename(f))))
  cat(f,'\n',rdata.name,'\n')
  if(file.exists(rdata.name)){
    rm(featureMatrix10,featureMatrix5,featureMatrix2,avgSpectra,spectra,ncMD)
    load(rdata.name)
    fm<-melt(featureMatrix10,varnames = c('Time','MZ'))
    fm$fname<-basename(rdata.name)
    list10SNR[[basename(rdata.name)]]<-fm
    fm<-melt(featureMatrix5,varnames = c('Time','MZ'))
    fm$fname<-basename(rdata.name)
    list5SNR[[basename(rdata.name)]]<-fm
    fm<-melt(featureMatrix2,varnames = c('Time','MZ'))
    fm$fname<-basename(rdata.name)
    list2SNR[[basename(rdata.name)]]<-fm
  }
}
fm10<- do.call(rbind, list10SNR)
fm5<- do.call(rbind, list5SNR)
fm2<- do.call(rbind, list2SNR)

