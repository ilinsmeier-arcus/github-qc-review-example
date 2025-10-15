# INSTRUCTIONS

   1. Copy and paste the contents of this template file into the Pull Request Description.

      - To copy the this file from GitHub, click the "copy raw file" button in the upper right corner (see screenshot below)

        <img src="https://github.com/arcusbio/Clin-Pharm-project-template/assets/123597875/22f55d79-274d-4a23-8ded-37be9979b5c4" width="70%" height="70%" alt = "00_copy-raw-contents-button_cropped_annotated">
   
   2. Replace all placeholder text included in this template file (see example placeholder text below):

      - `<placeholder-text-formatting>`
   
   3. Remove the INSTRUCTIONS section by deleting this line and everything above it.



# QC Review Summary for AB000 PPK Analysis (2021/12/02)

## Project Repository Information
  * GitHub Repository URL:  `<specify-github-repo-URL>`
  * QC Submission Branch Name: `<specify-qc-submission-branch-name>`
  * Project Repository Path (CP Server): `<specify/full/path/to/project/repo/on/server>`
  * QC Review Location (CP Server): `<specify/full/path/to/qc/location/on/server>`

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
`[REPLACE OR REMOVE BULLETED LIST BELOW]`
  * Location of any files referenced during QC review (if any were used)

## Description of QC Review Methodology
  1. Clone the GitHub repository to your Desktop QC folder on the CP server (same path as the "QC Review Location" above):
     * `<specify/full/path/to/qc/location/on/server>`
  2. Switch to the "qc-submission" branch created by the Project Owner. Then create a new branch with the following name: "<initials>/qc-review" (after replacing "<initials>" with your first and last initial). Conduct the QC review process on this new branch.
     * `<specify-name-of-qc-review-branch>`
  3. Successfully reproduce the analysis workflow using the reproducible workflow script provided by the Project Owner:
     * `<specify/relative/path/to/reproducible/workflow/script/used>`
  4. Verify that the specified output files now exist in the expected locations within your QC Review folder. 
  5. Complete the conceptual and contextual review of the project files submitted for QC review (includes both the source and output files specified by the Project Owner).
  6. Verify that the reproduced output files in your Desktop QC folder match the outputs located in the Project Repository on the Clin Pharm Server.
  7. Confirm that the methodology and results are sensible for the current type of analysis and project objectives.

## Findings
  * There were no major findings to report from this QC review.
  * `<additional-findings>`

## Comments
  * The data specification file was modified to reflect the different coding of the `RACEN` covariate between the study-specific derived datasets for ARC-6 and AB680CSP0001. The different coding of the `RACEN` variable should not impact the results of the population PK analysis.
  * `<additional-comments>`
