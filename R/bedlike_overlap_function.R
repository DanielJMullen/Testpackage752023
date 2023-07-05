#' bedlike_overlap_function
#'
#' This function takes two bed-like data frames or GRanges objects as primary arguments,
#' the first three columns of which contain chromosome, start, and end locations, respectively.
#' The function then returns the rownames of the regions in the "dataset_to_overlap_with" which
#' overlap with each of the regions in the "dataset_to_annotate".
#'
#' @param dataset_to_annotate A data frame or GRanges object, consisting of regions for which the user wants to find overlaps in the dataset_to_overlap_with dataset. This dataset should have bed-like formatting, with the first column containing the chromosome each region is located on, the second column containing the 1-indexed start position of each region, and the third column containing the 1-indexed end position of each region.
#' @param dataset_to_overlap_with A second data frame or GRanges object, which contains the regions the user wishes to record that overlap with each of the regions in the dataset_to_annotate. This dataset should also have bed-like formatting, with the first column containing the chromosome each region is located on, the second column containing the 1-indexed start position of each region, and the third column containing the 1-indexed end position of each region.
#' @param within_distance Specify a buffer size which is effectively added to the regions in the dataset_to_overlap_with to calculate potential overlaps i.e., positive values specify the buffer region in which overlaps between the two can be identified, even if they would not be found normally. Defaults to 0.
#' @param overlap_type Specifies the type of overlaps the user would like to identify. Valid options include "partial" which still counts overlaps if only part of the regions in the dataset_to_overlap_with dataset overlap with each region in the dataset_to_annotate dataset, and "complete", which requires that each region in the dataset_to_overlap_with dataset completely enclose a region in the dataset_to_annotate dataset for an overlap to be counted between the two. Defaults to "partial".
#' @return Returns a vector with the length of the number of regions in the dataset_to_annotate dataset, with the rownames of the dataset_to_overlap_with that each region of the dataset_to_annotate dataset was found to overlap with.
#' @export
#'
#' @examples
#' # Generate two example datasets:
#' annotate <- data.frame(
#'    "chromosome"= c("chr1","chr1","chr1"),
#'    "start"= c(50,150,400),
#'    "end"= c(100,200,500),
#'    stringsAsFactors= FALSE
#' )
#'
#' overlap <- data.frame(
#'    "chromosome"= c("chr1","chr1"),
#'    "start"= c(25,130,190),
#'    "end"= c(125,160,250),
#'    stringsAsFactors= FALSE
#' )
#'
#' # Perform overlapping with defaults
#' bedlike_overlap_function(
#'    dataset_to_annotate= annotate,
#'    dataset_to_overlap_with= overlap
#' )
#'
bedlike_overlap_function <- function(
  dataset_to_annotate,
  dataset_to_overlap_with,
  within_distance = 0,
  overlap_type = "partial"
){

  ## Check the class of the dataset_to_annotate, and dataset_to_overlap_with.
  ## If they are not granges objects create a granges object for them.
  ## However, if they are granges, create a data.frame version of them:
  ## We will assume they are 1-indexed:
  if(
    class(dataset_to_annotate) %in% "GRanges"
  ){

    dataset_to_annotate <- data.frame(
      "chromosome"= as.character(
        GenomicRanges::seqnames(dataset_to_annotate)
      ),
      "start"= as.numeric(
        GenomicRanges::start(dataset_to_annotate)
      )-1,
      "end"= as.numeric(
        GenomicRanges::end(dataset_to_annotate)
      ),
      stringsAsFactors= FALSE
    )

  }

  if(
    class(dataset_to_overlap_with) %in% "GRanges"
  ){

    dataset_to_overlap_with <- data.frame(
      "chromosome"= as.character(
        GenomicRanges::seqnames(dataset_to_overlap_with)
      ),
      "start"= as.numeric(
        GenomicRanges::start(dataset_to_overlap_with)
      )-1,
      "end"= as.numeric(
        GenomicRanges::end(dataset_to_overlap_with)
      ),
      stringsAsFactors= FALSE
    )

  }

  ## Now let's make sure the column names in the datasets are in the proper
  ## format to use my peak overlapping function:
  colnames(dataset_to_annotate) <- c(
    "chromosome",
    "start",
    "end"
  )

  colnames(dataset_to_overlap_with) <- c(
    "chromosome",
    "start",
    "end"
  )

  ## Now that both datasets are data frames, let's write internal functions
  ## which can take the chromosome, start, and end locations from the annotated
  ## regions, along with an argument for the overlap dataset and the buffer size
  ## and return the rows of the overlap dataset which overlap with each row
  ## in the dataset_to_annotate later.
  peak_overlapper <- function(
    chromosome,
    start,
    end,
    reference_peaks,
    buffer
  ){
    paste(
      rownames(
        reference_peaks[
          (
            (reference_peaks[['chromosome']] == chromosome) &
            (reference_peaks[['start']] <= (end+buffer)) &
            (reference_peaks[['end']] >= (start-buffer))
          ),
        ]
      ), collapse=","
    )
  }

  peak_overlapper_full_overlap <- function(
    chromosome,
    start,
    end,
    reference_peaks,
    buffer
  ){
    paste(
      rownames(
        reference_peaks[
          (
            (reference_peaks[['chromosome']] == chromosome) &
            (reference_peaks[['start']] <= (start+buffer)) &
            (reference_peaks[['end']] >= (end-buffer))
          ),
        ]
      ), collapse=","
    )
  }

  ## For each of the rows in the dataset to annotate, note which of the rows
  ## in the dataset to overlap the peaks in the annotate set partially, or completely,
  ## overlap with, depending on user preferences, also taking into an account a possible
  ## buffer to overlap with:
  if(overlap_type=="partial"){

    output <- unname(
      mapply(
        peak_overlapper,
        chromosome= dataset_to_annotate[,1],
        start= dataset_to_annotate[,2],
        end= dataset_to_annotate[,3],
        MoreArgs = list(
          reference_peaks=dataset_to_overlap_with,
          buffer=within_distance
        )
      )
    )

  } else if(overlap_type=="complete"){

    output <- unname(
      mapply(
        peak_overlapper_full_overlap,
        chromosome= dataset_to_annotate[,1],
        start= dataset_to_annotate[,2],
        end= dataset_to_annotate[,3],
        MoreArgs = list(
          reference_peaks=dataset_to_overlap_with,
          buffer=within_distance
        )
      )
    )

  } else(

    stop("The input for overlap_type is incorrect. Please select one from \"partial\" or \"complete\"!")
  )

  return(output)
}
