###############################################################################|
## path helper functions -------------------------------------------------------
###############################################################################|

#' Recursively build directories
#'
#' `build_path()` recursively builds all directories specified in the vector of
#' input `paths`, which can include both file and folder paths. Input path
#' directories are only be created if they don't already exist. This function
#' ignores the file component of input paths (if it exists) and assumes all file
#' paths end with a file extension (e.g. "C:/dir/file.xyz").
#'
#' @param paths A character vector of one or more paths. Can be directory paths,
#'   file paths, or a mixture of each.
#'
#' @return The vector of input paths are returned unmodified even if no new
#' directories are created by this function.
#' @export
#'
#' @examples
#'
#' ## automatically build path when defining output directory
#' out_dir <- build_path(here::here("data/build-path-example/study-01"))
#'
#' ## also, can create paths by piping into `build_path()` function
#' out_dir <- here::here("data/build-path-example/study-02") |>
#'   build_path()
#'
#' ## `build_path()` will build only the parent directories for input file paths
#' csv_path <- here::here("data/build-path-example/study-03/study-03.csv") |>
#'   build_path()
#'
#' ## input paths are returned unmodified, so `build_path()` can be included in
#' calls to export function, such as `write.csv()`
#' write.csv(iris, file = build_path(here::here("data/build-path-example/iris/iris.csv")))
#'
build_path <- function(paths) {
  ## assumes all file paths end with a file extension (e.g. "C:/dir/file.xyz")
  fext <- tools::file_ext(paths)
  is_file <- dplyr::if_else(fext %in% "", FALSE, TRUE)
  target_paths <- dplyr::if_else(is_file, dirname(paths), paths)
  dir_res <- purrr::set_names(target_paths) |>
    purrr::map_lgl(~ ifelse(!dir.exists(.x), dir.create(.x, recursive = TRUE), dir.exists(.x)))
  print(dir_res)
  return(paths)
}


#' Copy files and append ".txt" extension
#'
#' @param paths A character vector of one or more file paths.
#'
#' @return A vector of file paths for the ".txt" copies created by this
#'   function.
#' @export
#'
#' @examples
#'
#' ## copy a base model ".lst" file ("nm/base/base.lst") and append ".txt" extension
#' copy_as_txt(here::here("nm/base/base.lst"))
#' #> "nm/base/base.lst.txt"
#'
#' ## copy multiple ".lst" files and append ".txt" extension
#' lst_files <- c("run01.lst", "run02.lst", "run03.lst")
#' copy_as_txt(here::here("nm/base", lst_files))
#' #> "nm/base/run01.lst.txt"
#' #> "nm/base/run02.lst.txt"
#' #> "nm/base/run03.lst.txt"
#'
copy_as_txt <- function(paths) {
  txt_paths <- paste0(paths, ".txt")
  txt_exists <- file.exists(txt_paths)
  if (any(txt_exists)) {
    stop(paste("\n", 'text file already exists:  "', txt_paths[txt_exists], '"', sep = "", collapse = "\n"))
  }
  copy_res <- file.copy(from = paths, to = txt_paths, overwrite = FALSE,
                        recursive = FALSE, copy.mode = TRUE, copy.date = TRUE)
  copy_fail <- !copy_res
  if (any(isTRUE(copy_fail))) {
    stop(paste("\n", 'unable to create copy:  "', txt_paths[copy_fail], '"', sep = "", collapse = "\n"))
  }
  return(txt_paths)
}


###############################################################################|
## execute PsN functions -------------------------------------------------------
###############################################################################|

#' Execute NONMEM model runs via PsN from RStudio
#'
#' @param mod_dir Path to a directory containing NONMEM model files (character vector, length 1).
#' @param mod_files Name of one or more model files (".mod") in the `mod_dir` directory (character vector, length >= 1).
#'
#' @return Outputs NONMEM messages to console.
#' @export
#'
#' @examples
#'
#' ## execute base model run "nm/base/run01.mod"
#' psn_execute(mod_dir = here::here("nm/base"), mod_files = "run01.mod")
#'
#' ## execute multiple model runs in "nm/base" folder
#' psn_execute(mod_dir = here::here("nm/base"), mod_files = c("run01.mod", "run02.mod", "run03.mod"))
#'
psn_execute <- function(mod_dir, mod_files) {
  psn_bin_path <- psn_path()
  psn_inst_path <- dirname(psn_bin_path)
  mod_files_str <- paste(mod_files, sep = "", collapse = " ")
  psn_exec_cmd <- glue::glue("Call {psn_bin_path}/execute -model_dir_name {mod_files_str}")
  withr::with_dir(mod_dir, shell(psn_exec_cmd))
}


#' `psn_path()` finds the location of the most recent PsN installation.
#' @keywords internal
psn_path <- function(search_str = NULL, psn_version = NULL) {

  ## for assigning default function arguments (rhs) if input argument is NULL
  `%||%` <- function(lhs, rhs) if (!is.null(lhs)) invisible(lhs) else invisible(rhs)

  psn_version <- psn_version %||% shell("psn --version", intern = TRUE)
  search_str <- search_str %||% gsub("^\\s*(PsN)\\s+version:\\s+((\\d+\\.?)+)$", "\\1-\\2", psn_version)
  path_env_vars <- shell("echo %Path%", intern = TRUE)
  env_path_split <- fs::path_norm(strsplit(path_env_vars, ";")[[1]])
  psn_path <- env_path_split[stringr::str_detect(env_path_split, search_str)]

  ## try to select most recent PsN installation if more than 1 version on PATH (MAY NEED TWEAKING)
  rev(sort(psn_path))[1]
}


###############################################################################|
## source R script in isolated environment -------------------------------------
###############################################################################|

#' Execute Rmd with logging
#'
#' This function converts an Rmd file into a temporary R-script and executes the
#' code in an isolated R session. A log file is created containing session
#' information as well as messages, output, results produced by the executed R
#' code.
#'
#' @param path Path to an Rmd file.
#'
#' @return An environment containing the results of the executed R code.
#'
#'   Before R script execution, the current text encoding is displayed in a
#'   message printed to the console.
#'
#' @seealso [log_script_exec()] which is called by this function to execute the
#'   temporary R-script generated from the input Rmd file via [knitr::purl()].
#' @export
#'
#' @examples
#'
#' ## execute Rmd file "scripts/build-data.Rmd"
#' source_rmd(here::here("scripts/build-data.Rmd"))
#'
source_rmd <- function(path) {
  stopifnot("input path must target an 'Rmd' file!" = tolower(tools::file_ext(path)) %in% "rmd")
  tmp_file <- paste0(tools::file_path_sans_ext(path), "_temp-R-script.R")
  if (file.exists(tmp_file)) {
    err_msg <- paste0('temporary R-script already exists:  "', tmp_file, '"')
    stop(err_msg)
  }
  on.exit(unlink(tmp_file), add = TRUE)
  message("\n\n <<< converting Rmd to R script before executing... >>>")
  knitr::purl(path, output = tmp_file)
  log_script_exec(tmp_file, quiet = FALSE)
}


#' Execute R-script with logging
#'
#' This function executes an R-script in an isolated R session and creates a log
#' file containing session information as well as messages, output, results
#' produced by the executed R code.
#'
#' @param path Path to an R-script.
#' @param quiet if `FALSE`, R script execution messages are printed to console
#'   (highly recommended). Messages are silenced if `quiet = TRUE` (intended for
#'   internal use, so use with caution!).
#'
#' @return An environment containing the results of the executed R code.
#'
#'   Before R script execution, the current text encoding is displayed in a
#'   message printed to the console.
#'
#' @seealso [logrx::axecute()] which is called by this function to log the
#'   execution of the input R-script. Documentation for the `{logrx}` package
#'   can be found here: https://pharmaverse.github.io/logrx/index.html
#' @export
#'
#' @examples
#'
#' ## execute R-script "scripts/plot-model-GOF.R"
#' log_script_exec(here::here("scripts/plot-model-GOF.R"))
#'
log_script_exec <- function(path, quiet = FALSE) {
  ## TODO: remove `quiet` argument from function (???)
  log_dir <- file.path(dirname(path), "logs")
  if (!dir.exists(log_dir)) dir.create(log_dir, recursive = TRUE)
  encoding <- getOption("encoding")
  script_res <- callr::r(function(script_path, log_dir, encoding, quiet) {
    script_env <- new.env()
    withr::local_options(list(log.rx.exec.env = script_env, encoding = encoding))
    if (!quiet) message(glue::glue("\n\n <<< executing R script with logging (encoding = {encoding}): >>>\n   {script_path}\n\n"))
    logrx::axecute(file = script_path,
                   log_name = fs::path_ext_set(basename(script_path), "log"),
                   log_path = log_dir)
    return(script_env)
  },
  args = list(
    script_path = path, log_dir = log_dir, encoding = encoding, quiet = quiet
  ),
  show = TRUE, spinner = FALSE)

  return(script_res)
}


#' Execute R-script
#'
#' This function executes an R-script in an isolated R session using the
#' `{callr}` package.
#'
#' @param path Path to an R-script.
#'
#' @return An environment containing the results of the executed R code.
#'
#'   Before R script execution, the current text encoding is displayed in a
#'   message printed to the console.
#'
#' @seealso [callr::r()] which is called by this function to execute the input
#'   R-script in a new R session. Documentation for the `{callr}` package can be
#'   found here: https://callr.r-lib.org/index.html
#' @export
#'
#' @examples
#'
#' ## execute R-script "scripts/plot-model-GOF.R"
#' log_script_exec(here::here("scripts/plot-model-GOF.R"))
#'
source_script <- function(path) {
  encoding <- getOption("encoding")
  message(glue::glue("\n\n <<< executing R script (encoding = {encoding}): >>>\n   {path}\n\n"))
  script_res <- callr::r(function(script_path, encoding, script_env) {
    script_env <- new.env()
    source(script_path, local = script_env, encoding = encoding)
    return(script_env)
  },
  args = list(script_path = path, encoding = encoding),
  cmdargs = c("--slave", "--no-save", "--no-restore"),
  show = TRUE, spinner = FALSE)
  return(script_res)
}


.get_default_encoding <- function() {
  ## TODO: consider removing this function (NOT CURRENTLY USED!!!)
  ## TODO: consider removing this function (NOT CURRENTLY USED!!!)
  ## TODO: consider removing this function (NOT CURRENTLY USED!!!)
  ## TODO: consider removing this function (NOT CURRENTLY USED!!!)
  ## TODO: consider removing this function (NOT CURRENTLY USED!!!)
  purrr::pluck(
    jsonlite::read_json(usethis:::rstudio_config_path("rstudio-prefs.json")),
    "default_encoding",
    .default = getOption("encoding")
  )
}


#' Save Environment to an RDS File
#'
#' This function converts the input environment object `env` to as list and
#' exports the result to an RDS file.
#'
#' @param env An environment object.
#' @param path File path for the exported RDS file (should end with ".rds"
#'   extension).
#' @param ... Parameters passed to `saveRDS()` function.
#'
#' @seealso [saveRDS()] which is called by this function.
#' @export
#'
#' @examples
#'
#' ## execute R-script "scripts/plot-model-GOF.R" and save result to an RDS file
#' GOF_env <- log_script_exec(here::here("scripts/plot-model-GOF.R"))
#' GOF_rds_path <- here::here("scripts/rds/plot-model-GOF.rds") |>  ## build RDS output path
#'   build_path()
#' save_env_RDS(env = GOF_env, path = GOF_rds_path)  ## save result to RDS
#'
save_env_RDS <- function(env, path, ...) {
  stopifnot("`env` must be an environment" = typeof(env) %in% "environment")
  env_list <- as.list(env)
  saveRDS(env_list, file = path, ...)
}

