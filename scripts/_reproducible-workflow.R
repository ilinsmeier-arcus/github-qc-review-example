###############################################################################|
## title:   Reproducible Workflow Script: GitHub QC Example
## author:  Ian Linsmeier
## date:    2025/10/14
## approximate run time:  ~2 minutes
###############################################################################|
##
## Description: This main control script executes the complete reproducible
## workflow for the GitHub QC review example project. It runs all analysis steps
## in sequence with automated logging via the logrx package. Scripts are
## executed in isolated R sessions using callr to ensure reproducibility.
##
## Workflow Steps:
##   1. Install required R packages
##   2. Perform exploratory data analysis (EDA)
##   3. Execute NONMEM covariate model via PsN (optional - requires NONMEM/PsN)
##   4. Extract model parameter estimates and export as formatted tables
##   5. Generate model diagnostic plots
##
## Inputs:  None (script paths are defined internally)
##
## Outputs (documented at the top of each R/Rmd script called in this workflow)
##   
##   Execution logs are automatically saved in "scripts/logs/" for all R/Rmd
##   scripts executed via `log_script_exec()` or `source_rmd()`.
##
###############################################################################|

###############################################################################|
## setup project workflow script -----------------------------------------------
###############################################################################|

## install required R packages -------------------------------------------------
required_pkgs <- c(
  "remotes", "pacman", "withr", "usethis", "here", "fs", "purrr", "callr", 
  "glue", "logrx"
)
lapply(
  required_pkgs[!required_pkgs %in% rownames(installed.packages())], 
  install.packages, type = .Platform$pkgType
)

### install selected packges from github ---------------------------------------
remotes::install_github(repo = "ArcadeAntics/this.path", upgrade = "never")
remotes::install_github(repo = "r-lib/sessioninfo", upgrade = "never")


### load dependent R packages --------------------------------------------------
pacman::p_load(tidyr, dplyr)

### set project root directory & source custom R functions for analysis --------
withr::with_dir(this.path::this.dir(), {
  proj_root_pth <- usethis::proj_get()
  here::i_am(fs::path_rel(this.path::this.path(), start = proj_root_pth))
})

## source custom reproducibility functions defined in the "R/" directory -------
## NOTE: reproducibility functions described below & documented in ".R" file
purrr::walk(list.files(here::here("R"), "(?i)\\.R$", full.names = TRUE), source)


###############################################################################|
## record start time -----------------------------------------------------------
###############################################################################|

## start timing script execution
start_time <- Sys.time() |> print() ## print start time


###############################################################################|
## Rerun primary analysis steps to reproduce key output files ------------------
###############################################################################|


### custom reproducibility functions -------------------------------------------
##
##  custom functions for reproducing the primary analysis steps are defined in
##  "R/reproducible-workflow-fns.R" (described briefly below)
##
##   - `log_script_exec()` = execute R scripts with logging (via `logrx::axecute()`)
##   - `source_rmd()`  = execute Rmd scripts with logging (via `logrx::axecute()`)
##   - `build_path()`  = recursively creates directories specified in input path(s)
##   - `copy_as_txt()` = copy file & append ".txt" extension (for QC of ".lst" NONMEM output files)
##   - `psn_execute()` = execute NONMEM models via PsN from RStudio (only tested on Windows)
##
##  for additional details, see documentation in "R/reproducible-workflow-fns.R"


### project setup --------------------------------------------------------------
log_script_exec(here::here("scripts/install-packages.R"))


### EDA ------------------------------------------------------------------------
### execute "R" scripts via `log_script_exec()` (logging by `logrx::axecute()`)
log_script_exec(here::here("scripts/exploratory-data-analysis.R")) 


### run NONMEM model via PsN ---------------------------------------------------
### NOTE: comment out this step if missing NONMEM or PsN installation
log_script_exec(here::here("scripts/run-covariate-model.R"))


### model diagnostics ----------------------------------------------------------
### execute "Rmd" scripts via `source_rmd()` (logging by `logrx::axecute()`)
source_rmd(here::here("scripts/model-parameter-estimates.Rmd")) 
log_script_exec(here::here("scripts/plot-model-diagnostics.R"))


### End of script message ------------------------------------------------------
cat("\n\n  >>>  REPRODUCTION COMPLETE!  <<<  \n\n\n")



###############################################################################|
## delete spurious "Rplots.pdf" (if it exists in project root directory) -------
###############################################################################|

## produced by knitr/ggplot2 bug: https://github.com/tidyverse/ggplot2/issues/2787
rplots_path <- here::here("Rplots.pdf")

## check the project root directory for "Rplots.pdf"
if (file.exists(rplots_path)) {
  file.remove(rplots_path)   ## delete the file if it exists
}


###############################################################################|
## R session information -------------------------------------------------------
###############################################################################|
si_log <- "scripts/logs/_reproducible-workflow_session-info.log" %>% 
  here::here() %>%  ## expand to full path
  build_path()      ## create "scripts/logs/" directory (if it doesn't exist)

## save reproducible workflow session information to file and print to console
sessioninfo::session_info(to_file = si_log) %>% print()


###############################################################################|
## Compute workflow execution time ---------------------------------------------
###############################################################################|

## finish timing script execution
end_time <- Sys.time() |> print() ## print end time
elapsed_time <- (end_time - start_time) |> print() ## print total run time



## QC Requested on 2025-10-17

