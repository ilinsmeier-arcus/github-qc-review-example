# QC Review Summary for AB000 PPK Analysis (2021/12/02)

## Project Repository Information
  * GitHub Repository URL:  https://github.com/arcusbio/cp-20211202-AB000-PPK
  * QC Submission Branch Name: "jj/qc-submission"
  * Project Repository Path (CP Server): "C:/MIDD/AB000/PK/cp-20211202-AB000-PPK"
  * QC Review Location (CP Server): "C:/Users/ilinsmeier/Desktop/QC/cp-20211202-AB000-PPK"

## Project Source Files Reviewed & Verified during QC
  * "scripts/00_reproduce-workflow.Rmd"
  * "scripts/01_data-prep_ARC-6.Rmd"
  * "scripts/02_combine-data-nonmem.Rmd"
  * "scripts/03_gof-plots_base-model.R"
  * "nm/base/base.mod"
  * "nm/base/base.lst.txt"

## Project Output Files Reviewed & Verified during QC
  * "data/prep_arc6/ARC6_updated_04052023.csv"
  * "data/nonmem_full/COMBINED_V2te_04052023.csv"
  * "graphs/eda/covariate-correlation-matrix.png"
  * "nm/base/base.ext"
  * "nm/base/base.lst"
  * "graphs/gof/poppk_report_GOF_base.png"

## Reference Files
  * Location of any files referenced during QC review (if any were used)

## Description of QC Review Methodology
  1. Clone the GitHub repository to your Desktop QC folder on the CP server (same path as the "QC Review Location"" above):
     * "C:/Users/ilinsmeier/Desktop/QC/cp-20211202-AB000-PPK"
  2. Switch to the "qc-submission" branch created by the Project Owner. Then create a new branch with the following name: "<initials>/qc-review" (after replacing "<initials>" with your first and last initial). Conduct the QC review process on this new branch.
     * "il/-qc-review"
  3. Successfully reproduce the analysis workflow using the reproducible workflow script provided by the Project Owner:
     * "scripts/00_reproduce-workflow.Rmd"
  4. Verify that the specified output files now exist in the expected locations within your QC Review folder. 
  5. Complete the conceptual and contextual review of the project files submitted for QC review (includes both the source and output files specified by the Project Owner).
  6. Verify that the reproduced output files in your Desktop QC folder match the outputs located in the Project Repository on the Clin Pharm Server.
  7. Confirm that the methodology and results are sensible for the current type of analysis and project objectives.

## Findings
  * There were no major findings to report from this QC review.

## Comments
  * The data specification file was modified to reflect the different coding of the `RACEN` covariate between the study-specific derived datasets for ARC-6 and AB680CSP0001. The different coding of the `RACEN` variable should not impact the results of the population PK analysis.
