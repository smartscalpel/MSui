#!/usr/bin/Rscript
if(!require(openxlsx)){stop('Library "openxlsx" is missing.\n')}
if(!require(DBI)){stop('Library "DBI" is missing.\n')}
if(!require(MonetDB.R)){stop('Library "MonetDB.R" is missing.\n')}
############ Predefined parameters
#dbname = "msinvent"
# usr='msinvent'
# pwd='msinvent'
# tmpPath = '/var/workspaceR/dataloading/Burdenko/' #'/var/workspaceR/scalpelData/data/'
# archPath = '/var/workspaceR/scalpelData/archive/Burdenko/'
# path<- '/var/samba/share/Burdenko/'
#########################################
source('./path.R')
getSpec<-paste('select s.id from spectrum s join patient p on s.sampletumorpatientid=p.id ',
               'join tissue t on s.sampletumorid=t.id',
               'join smpl l on s.sampleid=l.id',
               'where p.emsid=? and t.label=? and l.label=?')

mfl<-dir(path=path,pattern='^(M|m)eta.*.xlsx',recursive = TRUE)
wd<-getwd()
conn <- dbConnect(MonetDB.R::MonetDB(), 
                  dbname = dbname,
                  user=usr,password=pwd)
cat('connect, ',length(mfl),'metafiles\n')
for(mf in mfl){
  wdir<-dirname(normalizePath(paste0(path,mf)))
  cat('start ',wdir,'\n')
  mdt<-read.xlsx(paste0(path,mf))
  idx2Load<-which(mdt$type=='signal'&!is.na(mdt$status)&mdt$status=='good')
  mdt<-mdt[idx2Load,]
  if(dim(mdt)[1]>0){
    sub(path,tmpPath,wdir)->tdir
    tsvl<-dir(tdir,'*.tsv',recursive=TRUE)
    rmdl<-dir(tdir,'prep.Rmd',recursive=TRUE)
    if(length(tsvl)==length(rmdl)){
      res<-TRUE
      misL<-c()
      for(i in 1:dim(mdt)[1]){
        spid<-dbGetQuery(conn,getSpec,mdt$patient[i],mdt$tissue[i],mdt$sample[i])
        if(dim(spid)[1]==0){
          res<-FALSE
          misL<-c(misL,paste0(tdir,'/',dirname(rmdl[i])))
        }
      }
      if(res){
      cat('move ',wdir,' to archive\n')
      adir<-dirname(sub(path,archPath,wdir))
      system(paste0('mkdir -p ',adir))
      system(paste0('mv ',wdir,' ',adir))
      }else{
       cat('not loaded: \n',paste(misL,collapse='\n'),'\n')
      }
    }else{
      idx<-match(dirname(rmdl),dirname(tsvl))
      cat('not loaded: \n',paste0(tdir,'/',dirname(rmdl[is.na(idx)]),collapse = '\n'),'\n')
    }
  }else{
    cat('move unprocessed ',wdir,' to archive\n')
    adir<-dirname(sub(path,archPath,wdir))
    system(paste0('mkdir -p ',adir))
    system(paste0('mv ',wdir,' ',adir))
  }
}

dbDisconnect(conn)
