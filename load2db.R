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

for(f in fl){
#  ls()->L
#  rm(list=L[!L%in%c('fl','f','rmd.name')])
  dir.name<-sub('.cdf','',basename(f))
  rmd.name<-sub('cdf$','Rmd',basename(f))
  system(paste0('mkdir -p ./',dir.name))
  cat(f,'\n',dir.name,'\n')
  rmd.fname<-paste0(getwd(),'/',dir.name,'/',rmd.name)
  if(!file.exists(rmd.fname)){
    file.copy('load2scalpelDB.Rmd',rmd.fname)
    if(FALSE){#file.exists(rmd.name)){
      rmarkdown::render(rmd.fname,'pdf_document')
    }
  }
  if(!file.exists(sub('Rmd','pdf',rmd.fname))){
    cdf.file<-normalizePath(paste0(path,f))
    system(paste0('cd ./',shQuote(dir.name)))
    try(rmarkdown::render(rmd.name,'pdf_document'),FALSE,outFile=sub('Rmd$','try.out',rmd.name))
    system('cd ../')
  }
}

