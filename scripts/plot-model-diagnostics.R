###############################################################################|
## Generate Model Diagnostic Plots ---------------------------------------------
###############################################################################|
##
## Description: This script generates comprehensive goodness-of-fit (GOF)
## diagnostic plots for NONMEM population PK models using the pmplots and
## xpose packages. Creates standard diagnostic plots including residuals,
## observed vs predicted, ETA distributions, and individual profiles.
##
## Inputs:
##   - data/501.csv                       # Input popPK dataset (NONMEM format)
##   - nm/cov/504.mod                     # NONMEM model file
##   - nm/cov/504.tab                     # NONMEM output table with predictions
##
## Outputs (in "graphs/gof/cov/504/" directory):
##   - 504-individual-plots.png           # Individual concentration-time profiles
##   - 504-individual-plots.pdf           # Paged individual profiles (PDF)
##   - 504-ETA-distributions.png          # ETA histogram distributions
##   - 504-ETA-pairs.png                  # ETA correlation pairs plot
##   - 504-residual-distributions.png     # WRES, CWRES, NPDE distributions
##   - 504-obs-vs-pred-ipred.png          # Observed vs PRED/IPRED (linear & log)
##   - 504-residuals-plots.pdf            # Comprehensive residuals plots (PDF)
##
###############################################################################|

###############################################################################|
## script setup ----------------------------------------------------------------
###############################################################################|

## specify R-script configuration ----------------------------------------------
mod_rela <- "nm/cov/504.mod"      ## path to target model run
tabl_ext <- "tab"                 ## file extension of model output table
csv_rela <- "data/501.csv"
out_plot <- "graphs/gof/{mod_step}/{mod_name}"

## specify model details -------------------------------------------------------
yaxis_label <- "DV"  ## y-axis label used in primary diagnostoc plots
eta_labels  <- c("ETA1//ETA-CL", "ETA2//ETA-V")  ## eta parameter label map

### load dependent R packages --------------------------------------------------
pacman::p_load_gh("metrumresearchgroup/pmplots@0.5.1", update = FALSE)
pacman::p_load(xpose, purrr, GGally, ggplot2, readr, dplyr, tidyr, tidylog)
crayon <- function(x) cat(crayon::magenta(x), sep = "\n")
options("tidylog.display" = list(crayon))

### set project root directory & source custom R functions for analysis --------
withr::with_dir(this.path::this.dir(), {
  proj_root_pth <- usethis::proj_get()
  here::i_am(fs::path_rel(this.path::this.path(), start = proj_root_pth))
})
purrr::walk(list.files(here::here("R"), "(?i).*\\.R$", full.names = TRUE), source)

###############################################################################|
## define functions ------------------------------------------------------------
###############################################################################|

file_stem <- function(paths) {
  tools::file_path_sans_ext(basename(paths))
}

ls_mod_files <- function(mod_dir, mod_ext = "mod") {
  cln_ext <- sub("\\.", "", mod_ext)
  mod_ptrn <- paste0("\\.", cln_ext, "$")
  list.files(mod_dir, pattern = mod_ptrn, all.files = TRUE, full.names = TRUE, 
             recursive = FALSE, ignore.case = TRUE)
}

###############################################################################|
## specify file paths ----------------------------------------------------------
###############################################################################|

## expand relative path into absolute/full path
mod_path <- here::here(mod_rela) %>% print()
tab_path <- fs::path_ext_set(mod_path, tabl_ext) %>% print()
csv_path <- here::here(csv_rela) %>% print()

## extract model path components for constructing descriptive output paths
mod_name <- file_stem(mod_path) %>% print()
mod_step <- basename(dirname(mod_path)) %>% print()

## define output paths
out_plot_path <- here::here(glue::glue(out_plot)) %>% build_path()


###############################################################################|
## read model input data -------------------------------------------------------
###############################################################################|

mod_data <- readr::read_csv(csv_path, skip = 1) %>% print()

###############################################################################|
## read model output files -----------------------------------------------------
###############################################################################|

## read model output table
mod_tab <- readr::read_csv(tab_path, skip = 1) %>% print()

## create xpose database object from target model files
mod_xpdb <- xpose::xpose_data(
  file = basename(mod_path), 
  dir = dirname(mod_path)
)

###############################################################################|
## list all models with output data in the target directory --------------------
###############################################################################|

mod_tab_files <- ls_mod_files(dirname(mod_path), mod_ext = tabl_ext) %>% print()
mod_with_tab <- fs::path_ext_set(mod_tab_files, ext = "mod")
stopifnot(all(file.exists(mod_with_tab)))

###############################################################################|
## define iteration function for model diagnostic plots ------------------------
###############################################################################|


model_diagnostic_plots <- function(
    mod_path, 
    tab_path,
    etas, 
    yname = "DV", 
    plot_dir = here::here("graphs/gof/{mod_step}/{mod_name}")
) {
  
  try_pmplots_pkg <- try(find.package("pmplots"), silent = TRUE)
  if (class(try_pmplots_pkg) %in% "try-error") {
    err_msg_parts <- rev(strsplit(as.character(try_pmplots_pkg), " : ")[[1]])
    error_msg <- gsub(
      pattern = 'Error in find.package\\(([[:graph:]]+)\\)', 
      replacement = 'required package \\1 is not installed', 
      err_msg_parts[2], 
      perl = TRUE
    )
    stop(error_msg)
  }
  
  
  ## extract model path components for constructing descriptive output paths
  mod_name <- file_stem(mod_path)
  mod_step <- basename(dirname(mod_path))
  plt_dir <- glue::glue(plot_dir) %>% build_path()
  

  
  ## read in model output data
  mod_tab <- readr::read_csv(tab_path, skip = 1)
  
  
  #############################################################################|
  ## `{pmplots}` data specification --------------------------------------------
  #############################################################################|
  ## https://metrumresearchgroup.github.io/pmplots/articles/complete.html
  
  
  ## specify dependent variable label
  .yname <- yname  
  
  ## rename columns to match standard dataset variable names
  df <- mod_tab %>% 
    mutate(
      TIME = TIME,
      TAFD = TIME,
      DV = DV,
      ABSIWRES = abs(IWRES),
    )
  
  
  ## subset 1 record per subject (i.e., subject-level data)
  nsubj <- n_distinct(mod_tab$ID)
  id <- df %>% distinct(ID, .keep_all = TRUE)
  stopifnot(identical(nsubj, nrow(id)))  ## verify correct number of records
  
  
  #############################################################################|
  ## individual plots for each subject -----------------------------------------
  #############################################################################|
  
    
  ## pivot model output data to long format for {ggplot2} compatibility ------
  ind_data <- mod_tab %>% 
    pivot_longer(cols = c(DV, IPRED, PRED), names_to = "DVTYPE", values_to = "DVDATA") %>% 
    mutate(DVTYPE = if_else(DVTYPE %in% "DV", "Observed", DVTYPE)) %>% 
    mutate(DVFACT = factor(DVTYPE, levels = c("Observed", "IPRED", "PRED")))
  
  ## individual plots with a legend (using data in long-format)
  ymax <- ind_data %>% 
    filter(DVTYPE %in% c("Observed", "IPRED", "PRED")) %>% 
    pull(DVDATA) %>% 
    max()
  
  dv_profiles <- ggplot(ind_data, aes(x = TIME, y = DVDATA, group = DVFACT, color = DVFACT, linetype = DVFACT, shape = DVFACT)) +
    geom_point(data = ind_data %>% filter(DVTYPE %in% "Observed")) +
    geom_line(data = ind_data %>% filter(!DVTYPE %in% "Observed")) +
    facet_wrap(~ ID) +
    scale_color_manual(name = "", guide = 'legend',
                       labels = c("Observed", "IPRED", "PRED"),
                       values = c("#333333", "firebrick4", "steelblue4")
    ) +
    scale_linetype_manual(name = "",
                          labels = c("Observed", "IPRED", "PRED"),
                          values = c(NA, "solid", "dashed")
    )  +
    scale_shape_manual(name = "",
                       labels = c("Observed", "IPRED", "PRED"),
                       values = c(1, NA, NA)
    ) +
    scale_alpha_manual(name = "",
                       labels = c("Observed", "IPRED", "PRED"),
                       values = c(0.8, 0.8, 0.8)
    ) +
    scale_size_manual(name = "",
                      labels = c("Observed", "IPRED", "PRED"),
                      values = c(1.25, NA, NA)
    ) +
    labs(
      x = "Time after first dose (weeks)",
      y = .yname
    ) +
    ylim(c(0, (ymax*1.1))) +
    theme(legend.position = "top")
  
  dv_profiles_path <- here::here(plt_dir, glue::glue("{mod_name}-individual-plots.png"))
  ggsave(
    dv_profiles, 
    filename = dv_profiles_path,
    width = 20, height = 10
  )
  
  
  ## paged pdf plot
  ncol <- 5
  nrow <- 5
  panels <- ncol*nrow
  subj_total <- n_distinct(mod_tab$ID)
  page_total <- ceiling(subj_total/panels)
  pdf_height <- 7
  
  pdf(fs::path_ext_set(dv_profiles_path, "pdf"), width = 12, height = pdf_height)
  for (page_idx in 1:page_total) {
    dv_profiles_paged <- dv_profiles +
      facet_wrap_paginate(~ID, ncol = ncol, nrow = nrow, page = page_idx)
    print(dv_profiles_paged)
  }
  dev.off()
  
  
  #############################################################################|
  ## ETA distributions ---------------------------------------------------------
  #############################################################################|
  
  my_dnorm <- function(x, mean = 0, sd = NULL, log = FALSE) {
    if (is.null(sd)) sd <- sd(x)
    dnorm(x = x, mean = mean, sd = sd, log = log)
  }
  
  ## define colors for distribution overlay curves
  pm_opts <- pmplots::pm_opts
  pm_opts$density.col <- "#042F61"
  
  
  ## ETA distributions
  eta_dist <- pmplots::wrap_hist(id, x = etas, y = "density", add_density = FALSE, use_labels = TRUE, scales = "free", ncol = 2, fill = "darkgray") + 
    geom_density(aes(color = "smooth", linetype = "smooth"), linewidth = 1.1, alpha = 0.85, show.legend = FALSE) +   
    stat_density(aes(color = "smooth", linetype = "smooth"), linewidth = 1.1, alpha = 0.85, geom = "line", position = "identity") +
    stat_function(fun = my_dnorm, aes(color = "normal", linetype = "normal"), linewidth = 1.1, alpha = 0.75) +
    geom_vline(xintercept = 0, linewidth = 1.1, alpha = 0.75) + 
    scale_color_manual(
      name = "", guide = 'legend',
      labels = c("normal", "smooth"),
      values = c(pmplots::pm_opts$density.col, "#B1172A")
    ) + 
    scale_linetype_manual(
      name = "",
      labels = c("normal", "smooth"),
      values = c(2, 1)
    )  + 
    theme_bw() +
    theme(legend.position = "bottom", legend.key.width = unit(1.5, 'cm'))
  
  ggsave(
    eta_dist, 
    filename = here::here(plt_dir, glue::glue("{mod_name}-ETA-distributions.png")),
    width = 8,
    height = 5
  )
  
  ## ETA pairs
  eta_corr <- eta_pairs(id, etas, fill = "darkgray")
  ggsave(
    eta_corr, 
    filename = here::here(plt_dir, glue::glue("{mod_name}-ETA-pairs.png")),
    width = 8,
    height = 8
  )
  
  ## residuals
  res_cols <- c("WRES", "CWRES", "NPDE")
  res_dist <- pmplots::wrap_hist(df %>% filter(!TIME %in% 0), x = res_cols, y = "density", add_density = FALSE, use_labels = TRUE, scales = "free", ncol = 2, fill = "darkgray") +
    geom_density(aes(color = "smooth", linetype = "smooth"), linewidth = 1.1, alpha = 0.85, show.legend = FALSE) + 
    stat_density(aes(color = "smooth", linetype = "smooth"), linewidth = 1.1, alpha = 0.85, geom = "line", position = "identity") +
    stat_function(fun = dnorm, aes(color = "normal", linetype = "normal"), linewidth = 1.1, alpha = 0.75) +
    geom_vline(xintercept = 0, linewidth = 1.1, alpha = 0.75) + 
    scale_color_manual(
      name = "", guide = 'legend',
      labels = c("normal", "smooth"),
      values = c(pm_opts$density.col, "#B1172A")
    ) + 
    scale_linetype_manual(
      name = "",
      labels = c("normal", "smooth"),
      values = c(2, 1)
    )  + 
    theme_bw() +
    theme(legend.position = "bottom", legend.key.width = unit(1.5, 'cm'))
  
  ggsave(
    res_dist, 
    filename = here::here(plt_dir, glue::glue("{mod_name}-residual-distributions.png")),
    width = 8,
    height = 8
  )
  
  
  #############################################################################|
  ## Observed vs model-predictions (i.e., PRED, IPRED) -------------------------
  #############################################################################|
  
  ## specify axis limits to prevent exclusion of data points 
  ymax_dv_pred <- df %>% select(DV, PRED, IPRED) %>% unlist() %>% max()
  lims_dv_pres <- c(NA, ymax_dv_pred * 1.01)  ## increase upper limit by 1%
  def_xs <- modifyList(defx(), list(limits = lims_dv_pres))
  def_ys <- modifyList(defy(), list(limits = lims_dv_pres))
  
  
  ## Observed versus PRED, IPRED (linear scale)
  obs_pred_lin <- pmplots::dv_preds(
    df, xs = def_xs, ys = def_ys
  ) %>% 
    pmplots::pm_grid(ncol = 2)   
  
  ## Observed versus PRED, IPRED (log scale)
  obs_pred_log <- pmplots::dv_preds(
    df, xs = def_xs, ys = def_ys, loglog = TRUE
  ) %>% 
    pmplots::pm_grid(ncol = 2)   
  
  obs_vs_pred <- pmplots::pm_grid(list(obs_pred_lin, obs_pred_log), ncol = 1, nrow = 2)
  
  ggsave(
    obs_vs_pred, 
    filename = here::here(plt_dir, glue::glue("{mod_name}-obs-vs-pred-ipred.png")), 
    width = 8,
    height = 8
  )
  
  
  #############################################################################|
  ## generate standard residuals plots using `{pmplots}` -----------------------
  #############################################################################|
  ##  - https://metrumresearchgroup.github.io/pmplots/articles/complete.html
  wres_vs_time <- pmplots::wres_time(df)
  wres_vs_pred <- pmplots::wres_pred(df)
  cwres_vs_time <- pmplots::cwres_time(df)
  cwres_vs_pred <- pmplots::cwres_pred(df)
  iwres_vs_time <- pmplots::wres_time(
    df, 
    y = "IWRES//Individual weighted residual"
  )
  iwres_vs_ipred <- pmplots::wres_pred(
    df, 
    x = "IPRED//Individual predictions", 
    y = "IWRES//Individual weighted residual"
  )
  abs_iwres_vs_ipred <- pmplots::wres_pred(
    df, 
    x = "IPRED//Individual predictions", 
    y = "ABSIWRES//Absolute value individual weighted residual",
    hline = NULL
  )
  wres_qq <- pmplots::wres_q(df)
  cwres_qq <- pmplots::cwres_q(df)
  npde_qq <- pmplots::npde_q(df)
  
  gof_gg_list <- list(
    wres_vs_time,
    wres_vs_pred,
    cwres_vs_time,
    cwres_vs_pred,
    iwres_vs_time,
    iwres_vs_ipred,
    abs_iwres_vs_ipred,
    ggplot() + theme_void(),  ## blank panel
    wres_qq,
    cwres_qq,
    npde_qq
  ) %>% 
    purrr::map(., ggplotGrob)
  
  pdf(NULL)
  ggsave(
    filename = here::here(plt_dir, glue::glue("{mod_name}-residuals-plots.pdf")),
    plot = gridExtra::marrangeGrob(gof_gg_list, nrow = 2, ncol = 2, top = NULL), 
    width = 9, height = 9
  )
}


###############################################################################|
## iterate over model runs -----------------------------------------------------
###############################################################################|


## create diagnostic plots for all models in the target directory
purrr::walk(
  mod_with_tab, 
  ~ model_diagnostic_plots(
    mod_path = .x,
    tab_path = fs::path_ext_set(.x, tabl_ext),
    etas = eta_labels,
    yname = yaxis_label,
    plot_dir = out_plot_path
  )
)



## QC Requested on 2025-10-17

