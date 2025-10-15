# INSTRUCTIONS

   1. Copy and paste the contents of this template file into the Pull Request Description.

      - To copy the this file from GitHub, click the "copy raw file" button in the upper right corner (see screenshot below)

        <img src="https://github.com/arcusbio/Clin-Pharm-project-template/assets/123597875/22f55d79-274d-4a23-8ded-37be9979b5c4" width="70%" height="70%" alt = "00_copy-raw-contents-button_cropped_annotated">
   
   2. Replace all placeholder text included in this template file (see example placeholder text below):

      - `<placeholder-text-formatting>`
   
   3. Remove the INSTRUCTIONS section by deleting this line and everything above it.
   


# Requesting QC Review of AB000 PPK Analysis (2021/12/02)

## Project Description
Population PK analysis of AB000 for the following studies: ARC-6 and AB680CSP0001. 

NOTE: This example project was adapted from the AB680 PPK analysis (2023/04/08) QC review.

## QC Review Purpose
Example QC review workflow for GitHub-based QC workshop.

## Project Repository Information
  * GitHub Repository URL: `<specify-github-repo-URL>`
  * QC Submission Branch Name: `<specify-qc-submission-branch-name>`
  * Project Repository Path (CP Server): `<specify/full/path/to/project/repo/on/server>`

## Project Source Files for QC Review
  * "scripts/00_reproduce-workflow.Rmd"
  * "scripts/01_data-prep_ARC-6.Rmd"
  * "scripts/02_combine-data-nonmem.Rmd"
  * "scripts/03_gof-plots_base-model.R"
  * "nm/base/base.mod"
  * "nm/base/base.lst.txt"

## Project Output Files for QC Review
  * "data/prep_arc6/ARC6_updated_04052023.csv"
  * "data/nonmem_full/COMBINED_V2te_04052023.csv"
  * "graphs/eda/covariate-correlation-matrix.png"
  * "nm/base/base.ext"
  * "nm/base/base.lst"
  * "graphs/gof/poppk_report_GOF_base.png"

## Project Source Data on Egnyte
  * "Y:/Shared/BDM_Biometrics & Data Mgmt/To Share/Arc06/Datasets/SDTM/20221017/lb.sas7bdat"
  * "Y:/Shared/BDM_Biometrics & Data Mgmt/To Share/Arc06/Datasets/SDTM/20221017/qs.sas7bdat"
  * "Y:/Shared/BDM_Biometrics & Data Mgmt/To Share/Arc06/Datasets/SDTM/20221017/tr.sas7bdat"
  * "Y:/Shared/BDM_Biometrics & Data Mgmt/To Share/Arc06/Datasets/SDTM/20221017/vs.sas7bdat"
  * "Y:/Shared/BDM_Biometrics & Data Mgmt/To Share/Arc06/Datasets/SDTM/20221017/dm.sas7bdat"
  * "Y:/Shared/BDM_Biometrics & Data Mgmt/To Share/Arc06/Datasets/SDTM/20221017/ex.sas7bdat"
  * "Y:/Shared/BDM_Biometrics & Data Mgmt/To Share/Arc06/Datasets/PK/ProjectRZA03477_Covance_PK_20220628.xls"
  * "Y:/Shared/CP_Clinical Pharmacology/CP Projects_External/A2PG Collaboration/A2PG Models/Models/Datasets/PK_680CSP0001SD_20220309V3.csv"
  * "Y:/Shared/CP_Clinical Pharmacology/CP Projects_External/A2PG Collaboration/A2PG Models/Models/Datasets/PK_680CSP0001MD_20220309V3.csv"

## Reference Files
`[REPLACE OR REMOVE BULLETED LIST BELOW]`
  * Location of the data specification file used for NONMEM modeling.
  * Location of relevant slide decks, reports, or other supplemental information to provide context for the QC Reviewer.

## Notes for QC Reviewer
  * R version: `<specify-R-version>`
  * NONMEM version: `<specify-NONMEM-version>`
  * `<additional-notes>`
