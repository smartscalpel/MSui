#' Create intensity matrix from the database
#'
#' @param con connection to the database
#' @param sql query to take peaks
#' @param round number of digits to round mz to 
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
getIntensityMatrix<-function(con,sql,round=0){
  res<-
    data.table::data.table(
      DBI::dbGetQuery(con,
                 sql))
  idx<-match(c('mz','scan','intensity'),names(res))
  if(any(is.na(idx))){
    stop('SQL query should return three columns in any order: mz, scan, intensity.\n')
  }
  res$mzR<-round(res$mz,digits = round)
  dt<-res[,.(int=sum(intensity)),by=.(mzR)]
}

#' makeMassPeak.
#' 
#' Function converts data.table with columns 'scan','mz' and 'intensity' into list of MassPeaks objects.
#'
#' @param peakDT data.table to take data from
#' @param metadata dataFrame with scan-specific metadata.
#'
#' @return list of MassPeaks objects corresponding th data in peakDT
#' @export
#'
makeMassPeak<-function(peakDT,metadata=NULL){
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
  l<-lapply(scans,makeP)
}
