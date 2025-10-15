# INSTRUCTIONS

   1. Copy and paste the contents of this template file into the Pull Request Description.

      - To copy the this file from GitHub, click the "copy raw file" button in the upper right corner (see screenshot below)

        <img src="https://github.com/arcusbio/Clin-Pharm-project-template/assets/123597875/22f55d79-274d-4a23-8ded-37be9979b5c4" width="70%" height="70%" alt = "00_copy-raw-contents-button_cropped_annotated">
   
   2. Replace all placeholder text included in this template file (see example placeholder text below):

      - `<placeholder-text-formatting>`
   
   3. Remove the INSTRUCTIONS section by deleting this line and everything above it.
   


# QC Review Summary for `<Project-Label>` (`<YYYY/MM/DD>`)

## Project Repository Information
  * GitHub Repository URL:  `<specify-github-repo-URL>`
  * QC Submission Branch Name: `<specify-qc-submission-branch-name>`
  * Project Repository Path (CP Server): `<specify/full/path/to/project/repo/on/server>`
  * QC Review Location (CP Server): `<specify/full/path/to/qc/location/on/server>`

## Project Source Files Reviewed & Verified during QC
  * `<specify/relative/source/file/paths/verified/during/QC/review>`

## Project Output Files Reviewed & Verified during QC
  * `<specify/relative/output/file/paths/verified/during/QC/review>`

## Reference Files
  * `<reference-file-locations-if-any-were-used>`

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
  * `<specify-whether-there-were-any-findings-from-the-QC-review>`

## Comments
  * `<add-comments-for-any-non-impactful-findings-or-inconsistencies>`
