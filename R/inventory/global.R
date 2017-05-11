# Messages ----------------------------------------------------------------

# Alphabetical order (ignoring ^default, ^choices, ^all, ...)
stopifnot(
  requireNamespace("BiocParallel"),
  requireNamespace("dplyr"),
  requireNamespace("DT"),
  requireNamespace("ensembldb"),
  requireNamespace("ensemblVEP"),
  requireNamespace("ggplot2"),
  requireNamespace("reshape2"),
  requireNamespace("Rsamtools"),
  requireNamespace("TVTB"),
  requireNamespace("VariantAnnotation"),
  requireNamespace("limma"),
  requireNamespace("rtracklayer")
)

.Msgs <- list(
  # VCF
  importVariants = "Please import/refresh variants.",
  filteredVcfNULL = "Please wait while variants are being filtered...",
  singleVcf = "Please select a VCF file.",
  
  # GRanges
  noGenomicRanges = "No genomic range defined. All variants considered.",
  
  # Phenotypes
  phenoFile = "No phenotype file provided. All samples considered.",
  phenoInvalid = "Invalid phenotype data. See console.",
  colDataEmptyNoFile = "No phenotype information available.",
  colDataEmptyImported = paste(
    "Phenotypes imported, but not attached to variants.",
    "Please import/refresh variants to attach phenotypes."),
  
  # Specials
  fileChooseCancelled = "file choice cancelled.",
  vepKeyNotFound = "VEP key not found in INFO slot"
)
