## code to prepare `A549_TAD` dataset goes here

## First, let's download the data for hg38 topologically associating domains (TADs)
## from the Yue lab 3D genome browser. From this, we will acquire data for A549 lung
## adenocarcinoma cells:

## Let's download the full .zip folder with all hg38 TADs if it hasn't been
## downloaded already. This check is good practice when downloading large
## datasets which may take awhile to download:
## This was accessed 7/3/2023:
if(
  !file.exists('./data-noupload/hg38.TADs.zip')
){

  download.file(
    "http://3dgenome.fsm.northwestern.edu/downloads/hg38.TADs.zip",
    './data-noupload/hg38.TADs.zip'
  )
}

## Now we need to unzip the folder:
unzip(
  './data-noupload/hg38.TADs.zip',
  exdir= './data-noupload'
)

## Now that our folder is unzipped, we can load the A549 TAD file:
A549_TAD <- read.delim(
  "./data-noupload/hg38/A549_raw-merged_TADs.txt",
  sep= '\t',
  header= FALSE,
  stringsAsFactors= FALSE
)

## Let's rename the columns:
colnames(A549_TAD) <- c(
  "chromosome",
  "start",
  "end"
)

## Let's make the start column 1-indexed:
## Make sure not to run this line more than once!
A549_TAD$start <- A549_TAD$start+1

## Let's clear the workspace of all but the A549_TAD dataset
## This is to avoid any other objects potentially being saved in the
## data object - not necessary here, but good practice:
rm(
  list=setdiff(
    ls(),
    "A549_TAD"
  )
)

## This will prepare the dataset, and overwrite the previous dataset with the
## same name if it exists:
usethis::use_data(
  A549_TAD,
  overwrite = TRUE
)

## If you do want to remove the files you downloaded, you can run something like
## this. I have commented this out since the files are small, and I can preserve them
## locally:
# unlink(
#   c(
#     "./data-noupload/hg38.TADs.zip",
#     "./data-noupload/hg38"
#   ),
#   recursive= TRUE
# )

## Generate the documentation
sinew::makeOxygen(
  A549_TAD,
  add_fields = "source"
)
