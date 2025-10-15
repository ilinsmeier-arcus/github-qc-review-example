#' Create ".gitignore" file for bootstrap output files
#'
#' @param bs_mod_path path to bootstrap model file.
#' @param bs_out_dir name of the bootstrap output directory, which must be a
#'   pre-existing subdirectory below the bootstrap parent folder.
#'
#' @return path to the bootstrap-specific ".gitignore" file created by this
#'   function.
#' @export
#'
#' @examples
#'
#' ## bootstrap with n=100 samples based on final model: "nm/final/run02.mod"
#' gen_bootstrap_gitignore(
#'     bs_mod_path = "nm/final/run02_bootstrap/run02_bs.mod",
#'     bs_out_dir  = "bs-results_n=100"
#'  )
#'
gen_bootstrap_gitignore <- function(bs_mod_path, bs_out_dir) {
  result_files <- c(
    "raw_results_{bs_mod_stem}.csv",
    "meta.yaml",
    "version_and_option_info.txt"
  )
  bs_mod_file <- basename(bs_mod_path)
  bs_mod_stem <- tools::file_path_sans_ext(bs_mod_file)
  bs_dir_path <- dirname(bs_mod_path)
  bs_out_path <- file.path(bs_dir_path, bs_out_dir)
  bs_res_path <- purrr::map_chr(result_files, ~ file.path(bs_out_path, glue::glue(.x)))
  bs_res_rela <- fs::path_rel(bs_res_path, start = bs_dir_path)

  ## verify existence of all required files
  if (!file.exists(bs_mod_path)) stop(glue::glue('bootstrap model file does not exist:  "{bs_mod_path}"'))
  if (!file.exists(bs_out_path)) stop(glue::glue('bootstrap output subdirectory does not exist:  "{bs_out_path}"'))
  if (!all(file.exists(bs_res_path)))  {
    bs_res_miss <- bs_res_path[!file.exists(bs_res_path)]
    bs_fmt_miss <- paste0(' \U25CF "', bs_res_miss, '"')
    glue::glue("bootstrap output file does not exist:\n{glue::glue_collapse(bs_fmt_miss, sep = '\n')}")
  }

  ## build path to bootstrap-specific ".gitignore" file
  gitignore_path <- file.path(bs_dir_path, ".gitignore")

  ## verify there isn't a ".gitignore" file in the target folder already
  if (file.exists(gitignore_path)) {
    stop(glue::glue('".gitignore" file already exists in the target folder:  "{bs_dir_path}"')) ## ERROR if file already exists
  }

  ## write ".gitignore" lines
  gitignore_comment <- '## ".gitignore" file for including bootstrap raw results (csv file) + metadata from PsN in the project repository'
  negate_bs_out_dir <- paste0("!", bs_out_dir, "/")
  ignore_bs_out_all <- paste0(bs_out_dir, "/*")
  negate_bs_results <- paste0("!", bs_res_rela)
  git_ignore_lines <- c(
    gitignore_comment,
    negate_bs_out_dir,
    ignore_bs_out_all,
    negate_bs_results
  )

  ## write ".gitignore" file
  writeLines(git_ignore_lines, gitignore_path)

  return(gitignore_path)
}

## TEST FUNCTION --> DO NOT USE IN R-SCRIPTS!
.test_gen_bootstrap_gitignore <- function() {

  ## successful
  gen_bootstrap_gitignore(
    bs_mod_path = "nm/final/run02_bootstrap/run02_bs.mod",
    bs_out_dir  = "bs-results_n=100"
  )

  ## error
  gen_bootstrap_gitignore(
    bs_mod_path = "nm/final/run04_bootstrap/run04_bs.mod",
    bs_out_dir  = "bs-results_n=100"
  )

}

