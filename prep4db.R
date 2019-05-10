#!/usr/bin/Rscript
if(!require(xlsx)){stop('Library "xlsx" is missing.\n')}
############ Predefined parameters
# dbname = "msinvent"
# usr='msinvent'
# pwd='msinvent'
# tmpPath = '/Volumes/AS_WD_HFS/Scalpel/Burdenko/' #'/var/workspaceR/scalpelData/data/'
# protocol<-data.frame(id=2,devID=4,solID=10,isID=5)
# Protocol #2 for Burdenko data
# devID<-4 #Device
# solID<-10 #Solvent
# isID<-5 # ionsource
resID<-1 #ResolutionID
smplID<-1 #SampleID
stID<-1 #SampleTumorID
stpID<-1 #SampleTumorPatientID
nMode<-1 #Negative mode
rangeID<-1 #MZrange
# path<- '/Volumes/AS_Backup/Scalpel/Burdenko/'
#########################################
source('./path.R')

protocol<-read.delim(paste0(protocolPath,protocolName,'.txt'))
protocol$rt<-protocol$timestamp*60
mfl<-dir(path=path,pattern='^(M|m)eta.*.xls(x|m)',recursive = TRUE)
cnames<-c('data','num','patient','tissue','sample','mode','resolution','type','status','mass-range','protocol','comment')
peaks<-list()
wd<-getwd()
for(mf in mfl){
  wdir<-dirname(normalizePath(paste0(path,mf)))
  mdt<-xlsx::read.xlsx(paste0(path,mf),1)
  if(any(grepl('(wash|bg)',names(mdt)))){# to fix crasy Excel without header row
    cat(mf,'\n')
    mdt<-read.xlsx(paste0(path,mf),colNames=FALSE)
    while(dim(mdt)[2]<length(cnames)){mdt<-cbind(mdt,rep(NA,dim(mdt)[1]))}
    names(mdt)<-cnames
  }
  idx2Load<-which(mdt$type=='signal'&!is.na(mdt$status)&mdt$status=='good')
  mdt<-mdt[idx2Load,]
  # if(dim(mdt)[1]>0){
  if((dim(mdt)[1]>0)&(all(grepl(protocolName,mdt$protocol)))){
    for(i in 1:dim(mdt)[1]){
      f<-paste0(wdir,'/cdf/',mdt$num[i],'.cdf')
      if(file.exists(f)){
        # pIdx<-match(mdt$protocol[i],protocol$id)
        # devID<-protocol$devID[pIdx] #Device
        # solID<-protocol$solID[pIdx] #Solvent
        # isID<-protocol$isID[pIdx] # ionsource
        # resID<-switch (mdt$resolution[i],
        #                'trap' = 2, 'ft'=1) #ResolutionID
        smplID<-mdt$sample[i] #SampleID
        stID<-mdt$tissue[i] #SampleTumorID
        stpID<-mdt$patient[i] #SampleTumorPatientID
        # nMode<-switch(mdt$mode[i],
        #               'neg'=1,'pos'=2) #Negative/Positive mode
        # rangeID<-switch (mdt$`mass-range`[i],
        #                  '120-2000'=1,'500-1000'=2)
        dir.name<-sub(path,'',sub('.cdf$','',f))
        rmd.name<-paste0(dir.name,'/prep.Rmd')
        system(paste0('mkdir -p ',tmpPath,shQuote(dir.name)))
        cat('cdf:',f,'\ndir:',dir.name,'\nrmd:',rmd.name,'\n')
        rmd.fname<-paste0(tmpPath,rmd.name)
        cat('fname',rmd.fname,'\n')
        if(!file.exists(rmd.fname)){
          file.copy('./prepare4scalpelDB.Rmd',rmd.fname)
        }
        rmd.fname<-normalizePath(rmd.fname)
        if(!file.exists(sub('Rmd','pdf',rmd.fname))){
          cdf.file<-normalizePath(f)
          cdf.fname<-paste0(ifelse(protocolName=='190130','Burdenko/','Neurosurgery/'),sub(path,'',cdf.file))
          try(rmarkdown::render(rmd.fname,'pdf_document'),FALSE,outFile=sub('Rmd$','try.out',rmd.fname))
        }
      }
    }
  }
}

