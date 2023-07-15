#' Assertions
#' 
#' @keywords internal
#' 
#' @import assertthat
xor <- function(x, y) {
  if(length(x) && length(y))
    return(FALSE)

  return(TRUE)
}

has_tracking <- function(x) {
  length(x) > 0
}

has_var <- function(x) {
  x != ""
}

not_missing <- function(x) {
  !missing(x)
}

is_standard_event <- function(x) {
  x %in% STANDARD_EVENTS
}

is_valid_expire <- function(x) {
  if(is.null(x))
    return(TRUE)

  if(isTRUE(x == ""))
    return(TRUE)

  if(is.numeric(x) && x <= 400)
    return(TRUE)

  return(is.Date(x))
}

assertthat::on_failure(is_valid_expire) <- function(call, env) {
  sprintf(
    "`%s` is not a valid `expires` value. It must be a numeric (< 400) or a Date It must be a numeric (< 400) or a Date.", 
    deparse(call$x)
  )
}

assertthat::on_failure(is_standard_event) <- function(call, env) {
  sprintf("`%s` is a reserved type", deparse(call$x))
}

assertthat::on_failure(not_missing) <- function(call, env) {
  sprintf("missing `%s`", deparse(call$x))
}

assertthat::on_failure(has_var) <- function(call, env) {
  sprintf("missing `%s`", deparse(call$x))
}

assertthat::on_failure(has_tracking) <- function(call, env){
  "nothing to track: see `track_*` methods"
}

assertthat::on_failure(xor) <- function(call, env) {
  sprintf(
    "can only set `%s` or `%s`, not both",
    call$x, call$y
  )
}
