#!/usr/bin/Rscript
args <- commandArgs(trailingOnly = TRUE)
print(args)
d=args[1]
r=args[2]
m=args[3]
z=args[4]
path<-'~/peaks/'
dname<-paste0('diag_',d,'.res_',r,'.mode_',m,'.mz_',z)
cat(format(Sys.time(), "%b %d %X"),d,r,m,z,'\n',dname,'\n')
df<-readRDS('../metaFL.rds')
idxH<-which(df$diag==32&df$res==r&df$mode==m&df$mz==z)
idxD<-which(df$diag==d&df$res==r&df$mode==m&df$mz==z)
fl<-c(df$fname[idxH],df$fname[idxD])
cat(format(Sys.time(), "%b %d %X"),dname,'\n\t',fl,'\n')
rmarkdown::render('SDAfilesReport.Rmd','pdf_document',clean = FALSE)
