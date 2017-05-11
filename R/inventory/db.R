getCon<-function(con){
  if(dbIsValid(con)){
    return(con)
  }else{
    return(prepareCon)
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

sqlTICone<-paste0('select rt,sum(intensity) as tic,spectrid ',
                  'from peak ',
                  'where rt<= 600 and spectrid=?',
                  'group by spectrid,rt ',
                  'order by spectrid,rt')
