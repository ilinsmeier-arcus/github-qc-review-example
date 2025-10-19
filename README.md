# GitHub QC Review Example Repository

A comprehensive example repository demonstrating the [GitHub-based QC Review Workflow for Pharmacometrics Projects](https://github.com/user-attachments/assets/48d87a1f-baa7-4838-a791-7a6796a8c824) presented at ACoP 2025. This repository includes fully reproducible example code for a population pharmacokinetic modeling project, which is QC reviewed to illustrate the details of the process. 

## Example QC Review

The example GitHub-based QC review process is demonstrated in this [pull request](https://github.com/ilinsmeier-arcus/github-qc-review-example/pull/4). 

The repo's [git history graph](https://github.com/ilinsmeier-arcus/github-qc-review-example/network) provides a high-level overview of the QC review branching strategy utilized for this process. The git history has also been carefully constructed to reflect a typical PMX project workflow.


### QC Review Roles
- Analyst: [`ilinsmeier-arcus`](https://github.com/ilinsmeier-arcus)
- QC Reviewer: [`ilinsmeier`](https://github.com/ilinsmeier)


### Additional Features

This example QC review demonstrates some additional key features not previously discussed in the [ACoP 2025 poster](https://github.com/user-attachments/assets/48d87a1f-baa7-4838-a791-7a6796a8c824):
- QC review specification in the PR description
- 4 types of QC review comments (note, suggestion, question, and change request)
- Response and resolution for each type of review comment
- Reviewer summary of QC review methodology and findings


<!-- ### ACoP 2025 Poster
<img width="14400" height="19200" alt="ACoP 2025 Poster" src="https://github.com/user-attachments/assets/48d87a1f-baa7-4838-a791-7a6796a8c824" /> -->


## 🚀 Getting Started

### Prerequisites

Before running the example project, ensure you have the required software installed:

- **R** (≥ 4.0.0) with required packages - see [Session Information](#session-information) for package versions
- **RTools** (R-version specific) - Windows only
- **NONMEM** (≥ 7.4.0) - optional, for population modeling step (can be skipped)
- **Perl speaks NONMEM (PsN)** (≥ 5.2.0) - optional, for population modeling step (can be skipped)
- **Git** - for version control


<!-- For detailed installation instructions, see [`SOFTWARE_DEPENDENCIES.md`](SOFTWARE_DEPENDENCIES.md) -->

### Running the Example Project

1. **Clone the repository**

2. **Open the R project in RStudio**

3. **Execute Reproducible Workflow**:
   
   The entire analysis workflow can be executed with a single command (all required packages will be installed automatically):

   ```r
   ## Run from project root directory
   source("scripts/_reproducible-workflow.R")
   ```

   **NOTE**: The example workflow is intended to work on both Windows and Unix systems, but it has only been tested on Windows at this time. 


   **The reproducible workflow script automatically executes all analysis steps in sequence**:
   1. Package installation and setup
   2. Exploratory data analysis
   3. NONMEM model execution (optional - can be skipped if NONMEM/PsN not installed)
   4. Model parameter table generation
   5. Model diagnostic plots

   **Expected runtime**: ~2 minutes 

   


<!-- ## 🗂️ Repository Structure

```
├── data/                          # Source datasets
├── docs/                          # Documentation and QC templates  
│   └── PULL_REQUEST_TEMPLATE/     # Preliminary QC Review PR templates
├── graphs/                        # Generated plots and figures
│   ├── eda/                       # Exploratory data analysis plots
│   ├── gof/                       # Goodness-of-fit plots
│   └── vpc/                       # Visual predictive checks
├── nm/                            # NONMEM model files
│   ├── base/                      # Base model development
│   ├── cov/                       # Covariate model building
│   └── final/                     # Final model files
├── R/                             # R helper functions
├── scripts/                       # Analysis scripts
├── tables/                        # Generated summary tables
└── reference/                     # Literature and reference materials
``` -->

## 🤝 Contributing

Contributions are welcome! Please open a pull request to contribute to this example repository.

## 🔗 References

**Example Dataset and Model Source**:
- Bauer, R.J. (2019). NONMEM Tutorial Part I: Description of Commands and Options, With Simple Examples of Population Analysis. *CPT Pharmacometrics Syst. Pharmacol.*, 8, 525–537. doi:[10.1002/psp4.12404](https://doi.org/10.1002/psp4.12404)

**Additional References**:
- NONMEM Users Guide: https://www.iconplc.com/innovation/nonmem/
- PsN Documentation: https://uupharmacometrics.github.io/PsN/
- tidyverse Documentation: https://www.tidyverse.org/

---


*This repository was developed as an educational resource for pharmacometric QC workflows and GitHub-based collaboration.*


## Session Information

Session information generated by the reproducible workflow script: `scripts/_reproducible-workflow.R`.

```
─ Session info ──────────────────────────────────────────────────────────────────────────────────
 setting  value
 version  R version 4.4.1 (2024-06-14 ucrt)
 os       Windows 11 x64 (build 26100)
 system   x86_64, mingw32
 ui       RStudio
 language (EN)
 collate  English_United States.utf8
 ctype    English_United States.utf8
 tz       America/Chicago
 date     2025-10-17
 rstudio  2024.04.0+735 Chocolate Cosmos (desktop)
 pandoc   2.5 @ C:\\apps\\PSN-52~1.6-W\\PSN-52~1.6\\STRAWB~1\\perl\\bin\\pandoc.exe
 quarto   1.4.549 @ C:\\Users\\ILINSM~1\\AppData\\Local\\Programs\\Quarto\\bin\\quarto.exe

─ Packages ──────────────────────────────────────────────────────────────────────────────────────
 package     * version    date (UTC) lib source
 callr         3.7.6      2024-03-25 [1] CRAN (R 4.4.1)
 cli           3.6.3      2024-06-21 [1] CRAN (R 4.4.1)
 clipr         0.8.0      2022-02-22 [1] CRAN (R 4.4.1)
 colorspace    2.1-1      2024-07-26 [1] CRAN (R 4.4.1)
 curl          5.2.2      2024-08-26 [1] CRAN (R 4.4.1)
 dplyr       * 1.1.4      2023-11-17 [1] CRAN (R 4.4.1)
 evaluate      1.0.1      2024-10-10 [1] CRAN (R 4.4.2)
 farver        2.1.2      2024-05-13 [1] CRAN (R 4.4.1)
 fs            1.6.4      2024-04-25 [1] CRAN (R 4.4.1)
 generics      0.1.3      2022-07-05 [1] CRAN (R 4.4.1)
 ggforce       0.4.2      2024-02-19 [1] CRAN (R 4.4.1)
 ggplot2       3.5.2      2025-04-09 [1] CRAN (R 4.4.3)
 glue          1.8.0      2024-09-30 [1] CRAN (R 4.4.2)
 gtable        0.3.5      2024-04-22 [1] CRAN (R 4.4.1)
 here          1.0.1      2020-12-13 [1] CRAN (R 4.4.1)
 knitr         1.49       2024-11-08 [1] CRAN (R 4.4.2)
 lifecycle     1.0.4      2023-11-07 [1] CRAN (R 4.4.1)
 magrittr      2.0.3      2022-03-30 [1] CRAN (R 4.4.1)
 MASS          7.3-60.2   2024-04-26 [2] CRAN (R 4.4.1)
 munsell       0.5.1      2024-04-01 [1] CRAN (R 4.4.1)
 pacman        0.5.1      2019-03-11 [1] CRAN (R 4.4.1)
 pillar        1.10.0     2024-12-17 [1] CRAN (R 4.4.1)
 pkgconfig     2.0.3      2019-09-22 [1] CRAN (R 4.4.1)
 polyclip      1.10-7     2024-07-23 [1] CRAN (R 4.4.1)
 processx      3.8.4      2024-03-16 [1] CRAN (R 4.4.1)
 ps            1.7.7      2024-07-02 [1] CRAN (R 4.4.1)
 purrr         1.0.2      2023-08-10 [1] CRAN (R 4.4.1)
 R6            2.5.1      2021-08-19 [1] CRAN (R 4.4.1)
 Rcpp          1.0.13     2024-07-17 [1] CRAN (R 4.4.1)
 remotes       2.5.0      2024-03-17 [1] CRAN (R 4.4.1)
 rlang         1.1.4      2024-06-04 [1] CRAN (R 4.4.1)
 rprojroot     2.0.4      2023-11-05 [1] CRAN (R 4.4.1)
 rstudioapi    0.17.1     2024-10-22 [1] CRAN (R 4.4.2)
 scales        1.3.0      2023-11-28 [1] CRAN (R 4.4.1)
 sessioninfo   1.2.3.9000 2025-10-16 [1] Github (r-lib/sessioninfo@ec4dd0c)
 this.path     2.7.0.8    2025-10-14 [1] Github (ArcadeAntics/this.path@afe581e)
 tibble        3.2.1      2023-03-20 [1] CRAN (R 4.4.1)
 tidyr       * 1.3.1      2024-01-24 [1] CRAN (R 4.4.1)
 tidyselect    1.2.1      2024-03-11 [1] CRAN (R 4.4.1)
 tweenr        2.0.3      2024-02-26 [1] CRAN (R 4.4.1)
 usethis       3.0.0      2024-07-29 [1] CRAN (R 4.4.1)
 vctrs         0.6.5      2023-12-01 [1] CRAN (R 4.4.1)
 withr         3.0.2      2024-10-28 [1] CRAN (R 4.4.2)
 xfun          0.49       2024-10-31 [1] CRAN (R 4.4.2)
 xpose         0.4.18     2024-02-01 [1] CRAN (R 4.4.1)

 [1] C:/Users/ilinsmeier/AppData/Local/R/win-library/4.4
 [2] C:/Users/ilinsmeier/AppData/Local/Programs/R/R-4.4.1/library
 * ── Packages attached to the search path.

─────────────────────────────────────────────────────────────────────────────────────────────────
```

