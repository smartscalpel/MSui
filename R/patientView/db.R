library(pool)
library(rlang)
library(pander)
library(MonetDBLite)

pool <- dbPool(MonetDBLite::MonetDB(),
               dbname = 'msinvent',
               user='msinvent',password='msinvent')


#### Tissue part #########

getTissueTable<-function(con,tabName){
  as_data_frame(con %>% tbl('patisue'))
}

makeNewTissue<-function(){
  data.frame(id=-1,emsid="",yob=-1,
             age=-1,sex="",label="",location="",
             diagnosis="",grade="",coords="",dt=""
    
  )
}


updateTissue<-function(con,name,olddata,newdata){
  cat(name,'\n',pander(head(olddata),caption = "old"),'\n=====\n',pander(head(newdata),caption = "new"),'\n====\n')
  
}

insertTissue<-function(con,data){
  
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

sqlGetMZset<-paste0('select id, mz,rt,scan,intensity,spectrid ',
                    'from peak ',
                    'where spectrid between ? and ? ')

sqlSpectra<-'select * from spectra '

getSpectra<-function(con){
  con<-getCon(con)
  cat(system.time(p<-
                    data.table(
                      dbGetQuery(con,
                                 sqlSpectra))
  ),
  '\n')
  return(p)
}

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

# Views for patient
#create view patisue as select t.id,emsid,yob,age,sex,label,location,d.name as diagnosis,grade,coords,dt from ms.Patient p join ms.Tissue t on p.id=t.patientid join ms.diagnosis d on t.diagnosis=d.id;
