###############################################################################|
##  Exploratory Data Analysis for Population PK Dataset (501.csv) -------------
###############################################################################|
##
## Description: This script performs comprehensive exploratory data analysis on
## the population pharmacokinetic dataset (501.csv) and generates publication-
## quality visualizations and summary tables. The analysis includes
## concentration- time profiles, covariate distributions, correlation analyses,
## and data quality assessments.
##
## Inputs:
##   - data/501.csv                        # Population PK data (NONMEM format)
##
## Outputs (in "graphs/eda/" directory):
##   - concentration_time_profiles.png     # Individual PK profiles (linear)
##   - concentration_time_profiles_log.png # Individual PK profiles (log scale)
##   - covariate_distributions.png         # Age, weight, and sex distributions
##   - age_weight_relationship.png         # Age vs weight scatter by sex
##   - correlation_matrix.png              # Covariate correlation heatmap
##   - concentration_distributions.png     # Concentration distribution analyses
##   - concentration_time_by_sex.png       # PK profiles stratified by sex
##
## Outputs (in "tables/eda/" directory):
##   - data_summary.csv                    # Overall dataset statistics
##   - demographic_summary.csv             # Demographics (age, weight, sex)
##   - concentration_by_time_summary.csv   # Concentration stats by time point
##   - missing_data_summary.csv            # Missing data tabulation
##
###############################################################################|

###############################################################################|
## script setup ----------------------------------------------------------------
###############################################################################|

## specify R-script configuration ----------------------------------------------
csv_rela <- "data/501.csv"  ## relative path to popPK dataset
out_plot <- "graphs/eda"    ## output directory path (relative) for EDA plots
out_tabl <- "tables/eda"    ## output directory path (relative) for EDA tables

### load dependent R packages --------------------------------------------------
pacman::p_load(ggplot2, dplyr, tidyr, tidylog)
crayon <- function(x) cat(crayon::magenta(x), sep = "\n")
options("tidylog.display" = list(crayon))

### set project root directory & source custom R functions for analysis --------
withr::with_dir(this.path::this.dir(), {
  proj_root_pth <- usethis::proj_get()
  here::i_am(fs::path_rel(this.path::this.path(), start = proj_root_pth))
})
purrr::walk(list.files(here::here("R"), "(?i).*\\.R$", full.names = TRUE), source)


###############################################################################|
## specify file paths ----------------------------------------------------------
###############################################################################|

## expand relative path into absolute/full path
csv_path <- here::here(csv_rela) %>% print()


## define output paths
out_plot_path <- here::here(glue::glue(out_plot)) %>% build_path()
out_tabl_path <- here::here(glue::glue(out_tabl)) %>% build_path()


###############################################################################|
## read model input data -------------------------------------------------------
###############################################################################|

pk_data_raw <- readr::read_csv(csv_path, skip = 1) %>% print()


###############################################################################|
## clean input dataset ---------------------------------------------------------
###############################################################################|


## derive additional variables to support EDA
pk_data <- pk_data_raw %>%
  mutate(
    ## Event ID: 1 = dosing, 0 = observation
    EVID = ifelse(AMT > 0, 1, 0), 
    
    ## log-transformed concentration
    LOGDV = ifelse(DV > 0, log(DV), NA), 
    
    ## Sex as factor with labels
    SEX_LABEL = factor(SEX, levels = c(0, 1), labels = c("Male", "Female"))
  )


## separate data into observations and dosing records
obs_data  <- pk_data %>% filter(EVID %in% 0)
dose_data <- pk_data %>% filter(EVID %in% 1)


###############################################################################|
## Overall data summary --------------------------------------------------------
###############################################################################|

## overall counts of subjects, observations, and doses
n_subjects <- length(unique(pk_data$ID))
n_observations <- nrow(obs_data)
n_doses <- nrow(dose_data)

## overall data summary table
data_summary <- list(
  "Number of Subjects" = n_subjects,
  "Number of Observations" = n_observations, 
  "Number of Dosing Records" = n_doses,
  "Study Duration (hours)" = max(pk_data$TIME, na.rm = TRUE),
  "Median Observations per Subject" = median(table(obs_data$ID))
) %>% 
  tibble::as_tibble() %>% 
  pivot_longer(
    cols = everything(), 
    names_to = "Description", 
    values_to = "Value"
  ) %>% 
  print()


## Save data summary table
readr::write_csv(data_summary, here::here(out_tabl_path, "data_summary.csv"))


###############################################################################|
## Demographic summary table ---------------------------------------------------
###############################################################################|

## Demographic summary
demo_summary <- obs_data %>%
  group_by(ID) %>%
  slice(1) %>%  # One record per subject
  ungroup() %>%
  summarise(
    N = n(),
    Age_Mean = round(mean(AGE, na.rm = TRUE), 1),
    Age_SD = round(sd(AGE, na.rm = TRUE), 1),
    Age_Range = paste(min(AGE, na.rm = TRUE), "-", max(AGE, na.rm = TRUE)),
    Weight_Mean = round(mean(WT, na.rm = TRUE), 1),
    Weight_SD = round(sd(WT, na.rm = TRUE), 1),
    Weight_Range = paste(min(WT, na.rm = TRUE), "-", max(WT, na.rm = TRUE)),
    Male_N = sum(SEX %in% 0, na.rm = TRUE),
    Male_Percent = round(100 * sum(SEX %in% 0, na.rm = TRUE) / n(), 1)
  ) %>% 
  ## convert summary values to character to convert the table to long format
  mutate(across(everything(), as.character)) %>%
  pivot_longer(cols = everything(), names_to = "Statistic", values_to = "Value") %>% 
  print()

## Save demographics summary table
readr::write_csv(demo_summary, here::here(out_tabl_path, "demographic_summary.csv"))



###############################################################################|
## Concentration-Time Profiles -------------------------------------------------
###############################################################################|

## individual concentration-time profiles
p1 <- obs_data %>%
  ggplot(aes(x = TIME, y = DV)) +
  geom_line(aes(group = ID), alpha = 0.6, color = "steelblue") +
  geom_point(aes(group = ID), alpha = 0.8, color = "darkblue", size = 0.8) +
  labs(
    title = "Individual Concentration-Time Profiles",
    subtitle = paste("N =", n_subjects, "subjects"),
    x = "Time (hours)",
    y = "Concentration"
  ) +
  theme_bw() +
  theme(
    plot.title = element_text(size = 14, face = "bold"),
    plot.subtitle = element_text(size = 12),
    axis.title = element_text(size = 12),
    axis.text = element_text(size = 10)
  )

ggsave(here::here(out_plot_path, "concentration_time_profiles.png"), 
       plot = p1, width = 10, height = 6, dpi = 300)

## log-scale concentration-time profiles
p2 <- obs_data %>%
  ggplot(aes(x = TIME, y = DV)) +
  geom_line(aes(group = ID), alpha = 0.6, color = "steelblue") +
  geom_point(aes(group = ID), alpha = 0.8, color = "darkblue", size = 0.8) +
  scale_y_log10() +
  labs(
    title = "Individual Concentration-Time Profiles (Log Scale)",
    subtitle = paste("N =", n_subjects, "subjects"),
    x = "Time (hours)",
    y = "Concentration - Log Scale"
  ) +
  theme_bw() +
  theme(
    plot.title = element_text(size = 14, face = "bold"),
    plot.subtitle = element_text(size = 12),
    axis.title = element_text(size = 12),
    axis.text = element_text(size = 10)
  )

ggsave(here::here(out_plot_path, "concentration_time_profiles_log.png"), 
       plot = p2, width = 10, height = 6, dpi = 300)



###############################################################################|
## Covariate distributions -----------------------------------------------------
###############################################################################|

## subset age and weight for plotting
age_weight_data <- obs_data %>%
  group_by(ID) %>%
  slice(1) %>%
  ungroup()

## age distribution
p3 <- age_weight_data %>%
  ggplot(aes(x = AGE)) +
  geom_histogram(bins = 15, fill = "lightblue", color = "darkblue", alpha = 0.7) +
  labs(
    title = "Age Distribution",
    x = "Age (years)",
    y = "Frequency"
  ) +
  theme_bw()

## weight distribution  
p4 <- age_weight_data %>%
  ggplot(aes(x = WT)) +
  geom_histogram(bins = 15, fill = "lightgreen", color = "darkgreen", alpha = 0.7) +
  labs(
    title = "Weight Distribution",
    x = "Weight (kg)",
    y = "Frequency"
  ) +
  theme_bw()

## sex distribution
p5 <- age_weight_data %>%
  ggplot(aes(x = SEX_LABEL, fill = SEX_LABEL)) +
  geom_bar(alpha = 0.7) +
  scale_fill_brewer(type = "qual", palette = "Set1") +
  labs(
    title = "Sex Distribution",
    x = "Sex",
    y = "Count"
  ) +
  theme_bw() +
  theme(legend.position = "none")

## Combine covariate plots
covariate_plots <- gridExtra::grid.arrange(p3, p4, p5, ncol = 2, nrow = 2)
ggsave(here::here(out_plot_path, "covariate_distributions.png"),
       plot = covariate_plots, width = 12, height = 8, dpi = 300)




###############################################################################|
## Covariate Relationships -----------------------------------------------------
###############################################################################|

## age vs Weight scatter plot
p6 <- age_weight_data %>%
  ggplot(aes(x = AGE, y = WT, color = SEX_LABEL)) +
  geom_point(size = 3, alpha = 0.7) +
  geom_smooth(method = "lm", se = TRUE) +
  scale_color_brewer(type = "qual", palette = "Set1") +
  labs(
    title = "Age vs Weight Relationship",
    x = "Age (years)",
    y = "Weight (kg)",
    color = "Sex"
  ) +
  theme_bw()

ggsave(here::here(out_plot_path, "age_weight_relationship.png"), 
       plot = p6, width = 8, height = 6, dpi = 300)



## correlation matrix for continuous variables
cont_vars <- age_weight_data %>%
  select(AGE, WT) %>%
  as.matrix()

png(here::here(out_plot_path, "correlation_matrix.png"), width = 600, height = 600)
corrplot::corrplot(cor(cont_vars, use = "complete.obs"), 
         method = "color", 
         type = "upper",
         addCoef.col = "black",
         title = "Covariate Correlation Matrix",
         mar = c(0,0,1,0))
dev.off()


###############################################################################|
## Concentration Distribution Analysis -----------------------------------------
###############################################################################|


## concentration distribution (all observations)
p7 <- obs_data %>%
  ggplot(aes(x = DV)) +
  geom_histogram(bins = 30, fill = "orange", color = "darkorange", alpha = 0.7) +
  labs(
    title = "Distribution of Observed Concentrations",
    x = "Concentration",
    y = "Frequency"
  ) +
  theme_bw()

## log-concentration distribution
p8 <- obs_data %>%
  filter(DV > 0) %>%
  ggplot(aes(x = log(DV))) +
  geom_histogram(bins = 30, fill = "purple", color = "darkmagenta", alpha = 0.7) +
  labs(
    title = "Distribution of Log-Concentrations",
    x = "Log(Concentration)",
    y = "Frequency"
  ) +
  theme_bw()

## concentration by time point
p9 <- obs_data %>%
  ggplot(aes(x = factor(TIME), y = DV)) +
  geom_boxplot(fill = "lightcoral", alpha = 0.7) +
  labs(
    title = "Concentration Distribution by Time Point",
    x = "Time (hours)",
    y = "Concentration"
  ) +
  theme_bw() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

## combine concentration distributions
conc_plots <- gridExtra::grid.arrange(p7, p8, p9, ncol = 2, nrow = 2)
ggsave(here::here(out_plot_path, "concentration_distributions.png"), 
       plot = conc_plots, width = 12, height = 8, dpi = 300)


###############################################################################|
## Covariate Effects on PK -----------------------------------------------------
###############################################################################|

## concentration-time by sex
p10 <- obs_data %>%
  ggplot(aes(x = TIME, y = DV, color = SEX_LABEL)) +
  geom_smooth(method = "loess", se = TRUE, alpha = 0.3, linewidth = 1) +
  geom_point(alpha = 0.5) +
  scale_color_brewer(type = "qual", palette = "Set1") +
  labs(
    title = "Concentration-Time Profiles by Sex",
    x = "Time (hours)",
    y = "Concentration",
    color = "Sex"
  ) +
  theme_bw()

suppressWarnings(
  ggsave(here::here(out_plot_path, "concentration_time_by_sex.png"), 
       plot = p10, width = 10, height = 6, dpi = 300)
)


###############################################################################|
## Concentration summary -------------------------------------------------------
###############################################################################|

## concentration statistics by time point
conc_by_time <- obs_data %>%
  group_by(TIME) %>%
  summarise(
    N = n(),
    Mean = round(mean(DV, na.rm = TRUE), 2),
    SD = round(sd(DV, na.rm = TRUE), 2),
    Median = round(median(DV, na.rm = TRUE), 2),
    Q25 = round(quantile(DV, 0.25, na.rm = TRUE), 2),
    Q75 = round(quantile(DV, 0.75, na.rm = TRUE), 2),
    Min = round(min(DV, na.rm = TRUE), 2),
    Max = round(max(DV, na.rm = TRUE), 2),
    .groups = 'drop'
  )

readr::write_csv(conc_by_time, here::here(out_tabl_path, "concentration_by_time_summary.csv"))


###############################################################################|
## summarize missing values ----------------------------------------------------
###############################################################################|

## tabulate missing values by dataset variable
missing_data <- pk_data %>%
  summarise(
    across(everything(), ~sum(is.na(.x))),
    .groups = 'drop'
  ) %>%
  pivot_longer(cols = everything(), names_to = "Variable", values_to = "Missing_Count") %>%
  mutate(
    Missing_Percent = round(100 * Missing_Count / nrow(pk_data), 2)
  ) %>%
  arrange(desc(Missing_Count))

readr::write_csv(missing_data, here::here(out_tabl_path, "missing_data_summary.csv"))




## QC Requested on 2025-10-17

