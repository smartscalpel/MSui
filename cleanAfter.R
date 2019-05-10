#!/usr/bin/Rscript
if(!require(xlsx)){stop('Library "xlsx" is missing.\n')}
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
getSpec<-paste('select s.id from spectrum s where filename like ?')

mfl<-dir(path=path,pattern='^(M|m)eta.*.xls(x|m)',recursive = TRUE)
cnames<-c('data','num','patient','tissue','sample','mode','resolution','type','status','mass-range','protocol','comment')
wd<-getwd()
conn <- dbConnect(MonetDB.R::MonetDB(), 
                  dbname = dbname,
                  user=usr,password=pwd)
cat('connect, ',length(mfl),'metafiles\n')
for(mf in mfl){
  wdir<-dirname(normalizePath(paste0(path,mf)))
  cat('start ',wdir,'\n')
  mdt<-xlsx::read.xlsx(paste0(path,mf),1)
  if(any(grepl('(wash|bg)',names(mdt)))){# to fix crasy Excel without header row
    cat(mf,'\n')
    mdt<-read.xlsx(paste0(path,mf),colNames=FALSE)
    while(dim(mdt)[2]<length(cnames)){mdt<-cbind(mdt,rep(NA,dim(mdt)[1]))}
    names(mdt)<-cnames
  }
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
        f<-paste0(wdir,'/cdf/',mdt$num[i],'.cdf')
        cdf.file<-normalizePath(f)
        cdf.fname<-paste0(ifelse(mdt$protocol[i]=='190130','Burdenko/','Neurosurgery/'),sub(path,'',cdf.file),'_%')
        spid<-dbGetQuery(conn,getSpec,cdf.fname)
        cat(i,cdf.fname,dim(spid),mdt$num[i],'\n')
        if(dim(spid)[1]==0){
          res<-FALSE
          misL<-c(misL,paste0(tdir,'/',i,', ',mdt$num[i],', ',cdf.fname))
        }
      }
      if(res){
        cat('move ',wdir,' to archive\n')
        adir<-dirname(sub(path,archPath,wdir))
        system(paste0('mkdir -p ',adir))
        system(paste0('mv ',wdir,' ',adir))
        system(paste0('tar cvjf ',tdir,".tbz2 --exclude='*_cache' ",tdir))
        #system(paste0('rm -rf ',tdir))
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
