#!/usr/bin/Rscript

############ Predefined parameters
dbname = "msinvent"
usr='msinvent'
pwd='msinvent'
dtPath = '/var/workspaceR/scalpelData/data/'
devID<-1 #Device
solID<-6 #Solvent
isID<-1 # ionsource
resID<-1 #ResolutionID
smplID<-1 #SampleID
stID<-1 #SampleTumorID
stpID<-1 #SampleTumorPatientID
nMode<-1 #Negative mode
path<-'/var/samba/share/Scalpel/BD_cdf/'
tolerance = 2e-4
#########################################

library(xMSannotator)
library(WGCNA)
data(adduct_table)
fl<-dir(path = dtPath,pattern = '*.RData')
for(f in fl){
  cat(f,'\n')
  if(!fie.exists(paste0('/var/workspaceR/scalpelData/annot/T3DB/',f,'/image.RData'))){
    cat('loading',f,'\n')
load(paste0(dtPath,f))
  # cls<-floor(sapply(spectra,function(.x) metaData(.x)$retentionTime)/5)
  # avgSpectra<-averageMassSpectra(spectra,cls,method='median')
  # peaks <- detectPeaks(avgSpectra, SNR=5, halfWindowSize=3,
  #                      method="SuperSmoother")
  # idx<-which(sapply(peaks,length)>10)
  # peaks2 <- binPeaks(peaks[idx],method = 'strict',tolerance = tolerance)
  # fpeaks2 <- filterPeaks(peaks2, minNumber = 10)
  # featureMatrix2 <- intensityMatrix(fpeaks2, avgSpectra)
  datA<-cbind(
    data.frame(mz=attr(featureMatrix2,'mass'),time=1),
    as.data.frame(t(1e6*featureMatrix2))
  )
  cat('datA',dim(datA),'\n')
  system(paste0('mkdir -p /var/workspaceR/scalpelData/annot/T3DB/',f,'/'))
  resT3DB<-multilevelannotation(datA,num_nodes = 5,
                            outloc = paste0('/var/workspaceR/scalpelData/annot/T3DB/',f),
                            queryadductlist = adduct_table$Adduct[
                              adduct_table$Mode=='negative'&
                                adduct_table$Type!='TFA'],
                            mode = 'neg',
                            db_name = "T3DB",
                            filter.by = "M-H",
                            biofluid.location = NA)
  cat(f,'Annotation done\n')
  save.image(paste0('/var/workspaceR/scalpelData/annot/T3DB/',f,'/image.RData'))
  rm(spectra,origSpectra,ncMD,peaks,peaks0,peaks2,fpeaks2,featureMatrix2)
  cat(f,'Done\n')
  }
}
