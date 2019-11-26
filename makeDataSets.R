library(plyr)
path<-'~/Dropbox/Скальпель/DBData/peaks/'
tmplRmd<-'/Users/lptolik/Documents/Projects/MSui/SDAfilesReport.Rmd'
tmpLip<-'/Users/lptolik/Documents/Projects/MSui/DetectedLipids.csv'
wd<-getwd()
cat(format(Sys.time(), "%b %d %X"),'Start:','\n\t',wd,'\n\t',
    path,'\n\t',tmplRmd,'\n\t',tmpLip,'\n')
flst<-dir(path)
l<-strsplit(x = flst,split = '\\.')
df<-ldply(l,.fun = function(l1)
  data.frame(name=l1[1],
             diag=sub('diag_', '',l1[2]),
             expt=sub('expt_', '',l1[3]),
             res=sub('res_', '',l1[4]),
             mode=sub('mode_', '',l1[5]),
             dev=sub('dev_', '',l1[6]),
             mz=sub('mz_', '',l1[7])))
df$fname<-flst
diagt<-unique(df$diag[df$diag!=32])
res<-unique(df$res)
mode<-unique(df$mode)
mz<-unique(df$mz)
expt<-unique(df$expt)
idx<-which(df$diag!=32)
cnt<-1
for(d in diagt){
    for(r in res){
      for(m in mode){
        for(z in mz){
          dname<-paste0('SDAreport.diag_',d,'.res_',r,'.mode_',m,'.mz_',z)
          dr<-paste0(path,'/',dname)
          dir.create(dr)
          file.copy(tmplRmd,dr)
          file.copy(tmpLip,dr)
          setwd(dr)
          idxH<-which(df$diag==32&df$res==r&df$mode==m&df$mz==z)
          idxD<-which(df$diag==d&df$res==r&df$mode==m&df$mz==z)
          fl<-c(df$fname[idxH],df$fname[idxD])
          cat(format(Sys.time(), "%b %d %X"),cnt,dname,'\n\t',fl,'\n')
          rmarkdown::render('SDAfilesReport.Rmd','pdf_document',clean = FALSE)
          setwd(wd)
          cnt<-cnt+1
        }
      }
    }
}

#rmarkdown::render('SDAfilesReport.Rmd','pdf_document',clean = FALSE)
