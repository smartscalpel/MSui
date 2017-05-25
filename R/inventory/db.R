getCon<-function(con){
  if(dbIsValid(con)){
    return(con)
  }else{
    res<-try(dbRollback(conn = con),silent = TRUE)
    if(class(res)=='try-error'){
      return(prepareCon)
    }else{
      if(dbIsValid(con)){
        return(con)
      }else{
        return(prepareCon)
      }
    }
  }
  
}

prepareCon<-function(dbdir){
  con <- dbConnect(MonetDBLite::MonetDBLite(), dbdir)
  if(dbIsValid(con)){
    cat(paste(dbGetInfo(con),collapse = '\n'))
  }else{
    stop('DB is not connected')
  }
  dbBegin(con)
  return(con)
}

sqlTICall<-paste0('select rt,sum(intensity) as tic,spectrid ',
                  'from peak ',
                  'where rt<= 600 ',
                  'group by spectrid,rt ',
                  'order by spectrid,rt')

sqlTICset<-paste0('select rt,sum(intensity) as tic,spectrid ',
                  'from peak ',
                  'where rt<= 600 and spectrid between ? and ?',
                  'group by spectrid,rt ',
                  'order by spectrid,rt')
sqlTICsetMZ<-paste0('select rt,sum(intensity) as tic,spectrid ',
                  'from peak ',
                  'where rt<= 600 and spectrid between ? and ?',
                  'and mz between ? and ?',
                  'group by spectrid,rt ',
                  'order by spectrid,rt')

sqlTICone<-paste0('select rt,sum(intensity) as tic,spectrid ',
                  'from peak ',
                  'where rt<= 600 and spectrid=?',
                  'group by spectrid,rt ',
                  'order by spectrid,rt')

sqlGetMZdata<-paste0('select id, mz,rt,scan,intensity,spectrid ',
                     'from peak ',
                     'where spectrid=? ')
sqlGetMZdataRange<-paste0('select id, mz,rt,scan,intensity,spectrid ',
                     'from peak ',
                     'where spectrid=? ',
                     'and mz between ? and ?',
                     'and intensity >= ?')
sqlGetMZset<-paste0('select id, mz,rt,scan,intensity,spectrid ',
                     'from peak ',
                     'where spectrid between ? and ? ')

getMZ<-function(con,spID,mzRange=c(0,5000),threshold=1e2){
  con<-getCon(con)
  cat(system.time(p<-
                    data.table(
                      dbGetQuery(con,
                                 sqlGetMZdataRange,
                                 spID,
                                 mzRange[1],
                                 mzRange[2],
                                 threshold))
                  ),
      '\n')
  cat(dim(p),'\n')
  binz<-seq(min(p$mz),max(p$mz),by=0.01)
  p[,bin:=findInterval(mz, binz)]
  p[,rcomp:=rcomp(intensity,total=1e6),by=.(spectrid)]
  return(p)
}
