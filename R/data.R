#' @title A549_TAD file
#' @description A bed-3 file with a collection of hg38-annotated topologically associated domains from A549 cell lines, created by the Yue lab (3D genome browser)
#' @format A data frame with 1866 rows and 3 variables:
#' \describe{
#'   \item{\code{chromosome}}{character chromosome location of TADs}
#'   \item{\code{start}}{integer 1-indexed start position of TADs}
#'   \item{\code{end}}{integer 1-indexed end position of TADs} 
#'}
#' @source \url{http://3dgenome.fsm.northwestern.edu/publications.html}
"A549_TAD"
#' @title Day 0 donor AEC H3K27ac ChIP-seq peak dataset
#' @description A bed-3 file with hg38-annotated H3K27ac ChIP-seq peaks from AEC cells derived day 0 from donor lung (i.e. type2-like)
#' @format A data frame with 126069 rows and 3 variables:
#' \describe{
#'   \item{\code{chromosome}}{character chromosome location of peaks}
#'   \item{\code{start}}{integer 1-indexed start position of peaks}
#'   \item{\code{end}}{integer 1-indexed start position of peaks} 
#'}
#' @source \url{https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSM4250941}
"AEC_donor_day0_H3K27ac"