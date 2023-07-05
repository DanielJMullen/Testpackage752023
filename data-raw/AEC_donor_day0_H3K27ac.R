## code to prepare `AEC_donor_day0_H3K27ac` dataset goes here

## First, let's download the narrowpeak data for hg38 H3K27ac ChIP-seq data from
## primary alveolar epithelial cells isolated from a donor on day 0
## (i.e. same day as ressection, so cells are most alveolar type2-like)

## Data was downloaded from GEO archive GSM4250941, in GSE143145, published in
## "TENET 2.0: Identification of key transcriptional regulators and enhancers in lung adenocarcinoma"
if(
  !file.exists('./data-noupload/GSM4250941_AEC_Donor1_H3K27ac_D0_VS_AEC_Donor1_INPUT_D0.narrowPeak.gz')
){

  download.file(
    "https://ftp.ncbi.nlm.nih.gov/geo/samples/GSM4250nnn/GSM4250941/suppl/GSM4250941_AEC_Donor1_H3K27ac_D0_VS_AEC_Donor1_INPUT_D0.narrowPeak.gz",
    './data-noupload/GSM4250941_AEC_Donor1_H3K27ac_D0_VS_AEC_Donor1_INPUT_D0.narrowPeak.gz'
  )
}

## R can load gzipped files natively:
AEC_donor_day0_H3K27ac <- read.delim(
  "./data-noupload/GSM4250941_AEC_Donor1_H3K27ac_D0_VS_AEC_Donor1_INPUT_D0.narrowPeak.gz",
  sep= '\t',
  header= FALSE,
  stringsAsFactors= FALSE
)

## Let's strip all but the chromosome, start, and end locations (in the first 3 columns)
## to make a bed3-like object:
AEC_donor_day0_H3K27ac <- AEC_donor_day0_H3K27ac[
  c(1:3)
]

## Let's rename the columns:
colnames(AEC_donor_day0_H3K27ac) <- c(
  "chromosome",
  "start",
  "end"
)

## Let's clear the workspace of all but the AEC_donor_day0_H3K27ac dataset
## This is to avoid any other objects potentially being saved in the
## data object - not necessary here, but good practice:
rm(
  list=setdiff(
    ls(),
    "AEC_donor_day0_H3K27ac"
  )
)

## This will prepare the dataset, and overwrite the previous dataset with the
## same name if it exists:
usethis::use_data(
  AEC_donor_day0_H3K27ac,
  overwrite = TRUE
)

## If you do want to remove the files you downloaded, you can run something like
## this. I have commented this out since the files are small, and I can preserve them
## locally:
# unlink(
#   c(
#     "GSM4250941_AEC_Donor1_H3K27ac_D0_VS_AEC_Donor1_INPUT_D0.narrowPeak.gz"
#   ),
#   recursive= TRUE
# )

## Generate the documentation
sinew::makeOxygen(
  AEC_donor_day0_H3K27ac,
  add_fields = "source"
)
