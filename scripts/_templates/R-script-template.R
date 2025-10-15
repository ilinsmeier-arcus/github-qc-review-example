###############################################################################|
## script setup ----------------------------------------------------------------
###############################################################################|

## specify R-script configuration ----------------------------------------------
molec_id  <- "<AB000>"                               ## molecule id
data_path <- "<relative/path/to/input/data>"         ## input data path
outpt_dir <- "<relative/path/to/output/directory>"   ## output directory

### load dependent R packages --------------------------------------------------
pacman::p_load(readr, dplyr, tidyr, tidylog)
crayon <- function(x) cat(crayon::magenta(x), sep = "\n")
options("tidylog.display" = list(crayon))

### set project root directory & source custom R functions for analysis --------
withr::with_dir(this.path::this.dir(), {
  proj_root_pth <- usethis::proj_get()
  here::i_am(fs::path_rel(this.path::this.path(), start = proj_root_pth))
})
purrr::walk(list.files(here::here("R"), "(?i).*\\.R$", full.names = TRUE), source)

###############################################################################|
## read input data -------------------------------------------------------------
###############################################################################|
nm_data <- readr::read_csv(here::here(data_path), na = c(".", ""))

###############################################################################|
## build output directory paths for saving script results ----------------------
###############################################################################|
outpt_path <- here::here(outpt_dir) %>% ## convert from relative to absolute path
  build_path()                          ## create output directories


## these paths can be defined prior to export as well
summ_stats_path <- file.path(outpt_path, "summary-statistics.csv")
data_defs_path  <- file.path(outpt_path, "data-definitions.csv")


###############################################################################|
## perform analysis ------------------------------------------------------------
###############################################################################|

## <insert analysis code here >>



