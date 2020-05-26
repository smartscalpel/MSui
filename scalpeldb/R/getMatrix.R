#' Create intensity matrix from the set of files
#'
#' @param files list of file names to be combined into matrix
#' @param path path to the directory where files are located
#' @param round where to round the MZ values and aggregate intensities
#' @param digits number of digits to round mz to 
#' @param snrT minimal Signal-to-Noise ratio for peak to be included in the output.
#' 
#' @details 
#' We assume that files were created by the query from this package and contains
#' following columns:
#' * id
#' * scan
#' * spectrumid
#' * diagnosis
#' * num
#' * rt
#' * tic
#' * mz
#' * intensity
#' * norm2tic
#' * snr
#' 
#' @import data.table
#' @return matrix of peaks intensity.
#' @export
#'
#' 
getIntensityMatrix<-function(files,path,round=FALSE,digits=0,snrT=1.5){
  res<-getPeakList(files,path,round,digits,align = TRUE)
  mdt<-plyr::ldply(res,function(.x){as.data.frame(metaData(.x))})
  fm<-prepareMatrix(res,gropId = mdt$diagnosis)
  fm<-cbind(mdt,as.data.frame(fm))
}

#' Create peak list from the set of files
#'
#' @param files list of file names to be combined into matrix
#' @param path path to the directory where files are located
#' @param round where to round the MZ values and aggregate intensities
#' @param digits number of digits to round mz to 
#' @param snrT minimal Signal-to-Noise ratio for peak to be included in the output.
#' @param align should result peaklist be aligned 
#' 
#' @details 
#' We assume that files were created by the query from this package and contains
#' following columns:
#' * id
#' * scan
#' * spectrumid
#' * diagnosis
#' * num
#' * rt
#' * tic
#' * mz
#' * intensity
#' * norm2tic
#' * snr
#' 
#' @import data.table
#' @return matrix of peaks intensity.
#' @export
getPeakList<-function(files,path,round=FALSE,digits=0,snrT=1.5,align=FALSE){
  if(!dir.exists(path)){
    stop('Folder [',path,'] does not exists.\n')
  }
  fl<-dir(path = path)
  idx<-match(files,fl)
  if(any(is.na(idx))){
    stop('Files [',
         paste(files[is.na(idx)],collapse = ','),
         '] could not be found in the folder',path,'.\n')
  }
  res<-list()
  for(f in files){
    dt<-fread(paste0(path,'/',f))
    if(dim(dt)[2]==12){
      names(dt)<-c('id','scan','spectrumid',
                   'diagnosis','patientid','num',
                   'rt','tic','mz','intensity',
                   'norm2tic','snr')
    }else if( dim(dt)[2]==11){
      names(dt)<-c('id','scan','spectrumid',
                   'diagnosis','num',
                   'rt','tic','mz','intensity',
                   'norm2tic','snr')
      dt$patientid<-NA
    }
    dtSNR<-dt[snr>snrT]
    #dt<-setDT(dt)
    #mdt<-dt[,.(N=length(id)),by=.(scan,spectrumid,num,rt,diagnosis,tic)]
    mdt<-dtSNR[,.(scan,spectrumid,patientid,num,rt,diagnosis,tic)]
    md<-unique(mdt)
    p<-makeMassPeak(dtSNR,metadata = md,align = align)
    res<-c(res,p)
  }
  return(res)
}

#' Create peak list from the database
#'
#' @param con connection to the database
#' @param sql query to take peaks
#' @param round where to round the MZ values and aggregate intensities
#' @param digits number of digits to round mz to 
#'
#' @details 
#' SQL query should return three columns in any order: mz, scan, intensity. 
#' First two will be columns and rows of the matrix, the last one will be matrix 
#' content. MZ is truncated with round function before matrix generation, 
#' however it is better to use SQL functions to aggregate intensities of 
#' appropriate mass, as meaning of aggregation would depend upot type of the 
#' intensity (normalized, squared etc).
#' 
#' @return matrix of peaks intensity.
#' @export
#'
#' 
getPeakListSQL<-function(con,sql,round=FALSE,digits=0){
    res<-
    data.table::data.table(
      DBI::dbGetQuery(con,
                 sql))
  idx<-match(c('mz','scan','intensity'),names(res))
  if(any(is.na(idx))){
    stop('SQL query should return three columns in any order: mz, scan, intensity.\n')
  }
  if(round){
  res$mzR<-round(res$mz,digits = digits)
  dt<-res[,.(int=sum(intensity)),by=.(scan,mzR)]
  dt$mz<-dt$mzR
  }
}

#' makeMassPeak.
#' 
#' Function converts data.table with columns 'scan','mz' and 'intensity' into list of MassPeaks objects.
#'
#' @details 
#' Here we assume that the data is homogenious in experimental and measurement
#' properties such as mode, resolution, diagnosis etc. That assumption is required
#' as the final step of the conversion is alignment of peak lists which has no
#' sense for unhomogenious lists. To create unhomogenious peak list create peak lists
#' for each group, for example diagnosis, and merge them afterwords.
#' 
#' @param peakDT data.table to take data from
#' @param metadata dataFrame with scan-specific metadata.
#' @param align logical, should peaks in peakList be aligned.
#'
#' @import MALDIquant
#' @return list of MassPeaks objects corresponding th data in peakDT
#' @export
#'
makeMassPeak<-function(peakDT,metadata=NULL,align=FALSE,min_peaks=10){
  idx<-match(c('mz','scan','intensity'),names(peakDT))
  if(any(is.na(idx))){
    stop('Data.table should have three columns in any order: mz, scan, intensity.\n')
  }
  scans<-unique(peakDT$scan)
  makeProp<-function(sc){
    idx<-which(peakDT$scan==sc)
    snr<-rep.int(NA_real_, length(idx))
    if(!is.na(match('snr',names(peakDT)))){
      snr<-peakDT$snr[idx]
    }
    mass<-peakDT$mz[idx]
    intens<-peakDT$intensity[idx]
    return(list(mass=mass,intensity=intens,snr=snr))
  }
  
  if(!is.null(metadata)){
    if(is.na(match(c('scan'),names(metadata)))){
      stop('Metadata, if exists, shoul have column scan')
    }
    idx<-match(scans,metadata$scan)
    if(any(is.na(idx))){
      stop(paste('Metadata does not contains iformation about all', 
                 'scans in the peakTable:\n c(', paste(scans[is.na(idx)],collapse = ','),
                 ').\n'))
    }
    makeP<-function(sc){
      l<-makeProp(sc)
      p<-MALDIquant::createMassPeaks(l$mass,l$intensity,snr=l$snr,
                         metaData = as.list(metadata[metadata$scan==sc,]))
    }
  }else{
    makeP<-function(sc){
      l<-makeProp(sc)
      p<-MALDIquant::createMassPeaks(l$mass,l$intensity,snr=l$snr)
    }
  }
  pl<-lapply(scans,makeP)
  ln<-sapply(pl,length)
  pl<-pl[ln>min_peaks]
  if(align){
  wf<-determineWarpingFunctions(pl,
                                method="lowess",
                                plot=FALSE,
                                minFrequency=0.05)
  aPeaks<-warpMassPeaks(pl,wf)
  return(aPeaks)
  }else{
    return(pl)
  }
}


#' Prepare Feature Matrix from peak list.
#'
#' @param pl list of MassPeaks to convert
#' @param gropId group identity for peaklist
#' @param tolerance binPeaks tolerance
#' @param minFrequency minimal peak frequency for the filterPeaks
#' @param mergeWhitelists wether to merge white lists for the filterPeaks
#' @param digits number of digits in the Feature matrix column names
#'
#' @return matrix of peaks intensity.
#' @export
#'
prepareMatrix<-function(pl,gropId,tolerance=2e-3,minFrequency=0.25, mergeWhitelists=TRUE,digits=3){
  if(length(pl)!=length(gropId)){
    stop('Length of Peaklist',length(pl),'is not equal to the length of groupID',length(gropId),'\n')
  }
  bPeaks <- binPeaks(pl, tolerance=tolerance)
  fpeaks <- filterPeaks(bPeaks,
                        labels=gropId,
                        minFrequency=minFrequency, mergeWhitelists=mergeWhitelists)
  featureMatrix <- intensityMatrix(fpeaks)
  idNA<-which(is.na(featureMatrix),arr.ind =TRUE)
  featureMatrix[idNA]<-0
  colnames(featureMatrix)<-paste0('MZ_',
                                  as.character(round(as.double(colnames(featureMatrix)),
                                                     digits)))
  return(featureMatrix)
}
