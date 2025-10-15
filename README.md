# Clin-Pharm-project-template
Template GitHub repository for Clinical Pharmacology projects.


## Table of contents

  - [Automatic Setup Instructions](#automatic-setup-instructions)
  - [Manual Setup Instructions](#manual-setup-instructions)
  - [GitHub Desktop Integration (optional)](#github-desktop-integration-optional)
  - [Installation & Setup](#installation--setup)


## Creating new Clin. Pharm. projects from template repo
Please follow the steps in either the "Automatic Setup Instructions" (***strongly recommended***) section OR the "Manual Setup Instructions" section below.

## Automatic Setup Instructions

1. Install the `{gitworkr}` R package

   * Copy-and-paste the code snippet below into the R console and run the commands verbatim to install the `{gitworkr}` package.
   
```r
## uncomment line below to install {remotes} package (if not already installed)
# install.packages("remotes")

## install {gitworkr} R package
remotes::install_github("ilinsmeier/gitworkr", force = TRUE)
```

&nbsp;

2. Replace placeholder text in the code snippet below:

   * `<repository-name>` = name of new project repository (same as project name)
   * `<repository-description>` = short description for repository (optional)
   * `<path/to/rstudio/project/directory>` = local path where RStudio project will be created

```r
## create new github repo from template & open RStudio project in new session
##  NOTE: RStudio git integration & github account authentication required to work
res <- gitworkr::gen_repo_from_template(
  repo_owner  = "arcusbio",
  repo_name   = "<repository-name>",
  repo_descr  = "<repository-description>",
  proj_dir    = "<path/to/rstudio/project/directory>",
  tmplt_owner = "arcusbio",
  tmplt_repo  = "Clin-Pharm-project-template"
)
```

&nbsp;

3. Run `gitworkr::gen_repo_from_template()` with updated arguments

    ***NOTE: RStudio git integration & github account authentication required for this function to work properly***

&nbsp;

## Manual Setup Instructions

1. Click "Use this template" button and select "Create a new repository" from the dropdown list.

&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; <img src="https://github.com/arcusbio/Clin-Pharm-project-template/assets/123597875/bad1ae1b-6464-4ef0-b337-63a49f213605" width="60%" height="60%" alt = "01_use-this-template-dropdown-gh-repo-button_cropped">


&nbsp;

2. Fill out the name and other information for your new repository. When finished, click the "Create repository" button to initialize the new project repo. 

&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; <img src="https://github.com/arcusbio/Clin-Pharm-project-template/assets/123597875/321c68ee-8d2d-41ec-a13c-7ef6ba459238" width="75%" height="75%" alt = "02_Create-New-GitHub-repo-from-template_zoom">


&nbsp;

3. Click the "Code" button on the new repository home page, and copy the "HTTPS" URL for the github repository from the dropdown menu.

&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; <img src="https://github.com/arcusbio/Clin-Pharm-project-template/assets/123597875/078d48dd-6656-49b8-a31a-04e053fc90b4" width="50%" height="50%" alt = "03_copy-new-github-repo-URL_copied-confirmation-message">


&nbsp;

4. Open RStudio, then navigate to `File` → `New Project...` in the top toolbar to open the "New Project Wizard"

&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; <img src="https://github.com/arcusbio/Clin-Pharm-project-template/assets/123597875/a07466e7-b61a-4b2e-aaab-27660ad92e8c" width="35%" height="35%" alt = "04_RStudio--File--New-Project_rstudio-bkg_cropped_screenshot">


&nbsp;

5. Select the "Version Control" option from the "Create Project" page.

&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; <img src="https://github.com/arcusbio/Clin-Pharm-project-template/assets/123597875/7fbab253-fc6f-40c2-9a00-1eb08c21d001" width="50%" height="50%" alt = "05_New-Project-Wizard_Create-Project_from-Version-Control_screenshot">


&nbsp;

6. Select "Git" as the version control system.

&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; <img src="https://github.com/arcusbio/Clin-Pharm-project-template/assets/123597875/98041c29-29c0-4dd5-86a4-7b6c0fcccc24" width="50%" height="50%" alt = "06_New-Project-Wizard_Clone-a-project-from-a-Git-repository_screenshot">


&nbsp;

7. Copy & paste the new github repository URL you created from the Clin. Pharm. template repo and select the location for the project on your local machine.

&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; <img src="https://github.com/arcusbio/Clin-Pharm-project-template/assets/123597875/1bc210fc-c0e0-4ac4-b2a0-b1fbe561a057" width="50%" height="50%" alt = "07_New-Project-Wizard_Clone-github-repo-from-url_screenshot">


&nbsp;

### GitHub Desktop Integration (optional)

1. Open GitHub Desktop application and navigate to `File` → `Add local repository...` in the top toolbar.

&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; <img src="https://github.com/arcusbio/Clin-Pharm-project-template/assets/123597875/fc2caaea-8a9a-41ad-9315-865b6429d362" width="50%" height="50%" alt = "08_github-desktop_File--add-local-repository_min-app-size_crop">


&nbsp;

2. Copy & paste the local path to your new Clin. Pharm. project and click the "Add repository" button when finished.

&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; <img src="https://github.com/arcusbio/Clin-Pharm-project-template/assets/123597875/0f80e04d-6963-4d72-8fe0-8940fca5c373" width="50%" height="50%" alt = "09_github-desktop_add-local-repo-path_cropped">


&nbsp;

### Installation & Setup

TODO:
<add installation & setup instructions>

