custom_psn_cmd <- function(mod_dir, mod_file, cmd_str, ..., psn_bin_path = psn_path()) {
  arg_list <- c(as.list(environment()), list(...)) |> print()
  psn_cmd <- glue::glue(cmd_str, .envir = arg_list) |> print()
  withr::with_dir(mod_dir, shell(psn_cmd))
}
