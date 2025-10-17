###############################################################################|
## Package Installation Script -------------------------------------------------
###############################################################################|
##
## Description: This script installs all R package dependencies required for
## the reproducible workflow, including packages from CRAN and GitHub. It checks
## for missing packages and installs only those that are not already present.
##
## Inputs:  None (checks currently installed packages)
## 
## Outputs: None (installs packages to R library)
##   - Installs CRAN packages: remotes, pacman, withr, usethis, here, fs, purrr
##   - Installs GitHub packages: pmplots (v0.5.1)
##   - Installs analysis packages: callr, corrplot, crayon, devtools, dplyr,
##     GGally, ggplot2, glue, gridExtra, knitr, logrx, readr, rmarkdown,
##     rprojroot, sessioninfo, stringr, this.path, tibble, tidylog, tidyr,
##     tools, xpose
##
###############################################################################|

###############################################################################|
## install required packages ---------------------------------------------------
###############################################################################|
installed_packages <- rownames(installed.packages())
required_cran_pkgs <- c(
  "remotes", "pacman", "withr", "usethis", "here", "fs", "purrr"
)
pkg_missing <- !required_cran_pkgs %in% installed_packages
if (any(pkg_missing)) {
  cran_pkgs_to_install <- required_cran_pkgs[pkg_missing]
  install_res <- lapply(cran_pkgs_to_install, install.packages)
}


###############################################################################|
## install specific package versions -------------------------------------------
###############################################################################|

## install pmplots version 0.5.1
remotes::install_github(
  repo = "metrumresearchgroup/pmplots@0.5.1", 
  dependencies = TRUE,
  upgrade = "never"
)


###############################################################################|
## install remaining package dependencies --------------------------------------
###############################################################################|

pkg_deps <- c(
  "callr",
  "corrplot",
  "crayon",
  "devtools",
  "dplyr",
  "fs",
  "GGally",
  "ggplot2",
  "glue",
  "gridExtra",
  "here",
  "knitr",
  "logrx",
  "pacman",
  "pmplots",
  "purrr",
  "readr",
  "rmarkdown",
  "rprojroot",
  "stringr",
  "this.path",
  "tibble",
  "tidylog",
  "tidyr",
  "tools",
  "usethis",
  "withr",
  "xpose"
)

pkgs_not_installed <- !pkg_deps %in% rownames(installed.packages())

if (any(pkgs_not_installed)) {
  pkgs_to_install <- pkg_deps[pkgs_not_installed]
  pkg_deps_install_res <- lapply(pkgs_to_install, install.packages)
}
