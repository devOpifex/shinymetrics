#' Toggle
#' 
#' Enable and disable the tracking from the server.
#' 
#' @param ... Passed to Cookie options, [MDN](https://developer.mozilla.org/en-US/docs/Web/HTTP/Cookies).
#' @param expires Number of days from time of creation when the cookie expires.
#' or an object of class `Date`, the date when the cookie should expire,
#' or an empty or `NULL` to make it a session cookie.
#' @param session A valid Shiny session.
#' 
#' @rdname toggle
#' 
#' @export 
shinymetrics_enable <- function(
  ...,
  expires = 400,
  session = shiny::getDefaultReactiveDomain()
){
  assert_that(is_valid_expire(expires))
  session$sendCustomMessage('shinymetrics-enable', list(..., expires = make_expire(expires)))
}

#' @rdname toggle
#' @export 
shinymetrics_disable <- function(
  session = shiny::getDefaultReactiveDomain()
){
  session$sendCustomMessage('shinymetrics-disable', list())
}

make_expire <- function(x) {
  if(is.null(x))
    return("")

  if(isTRUE(x == ""))
    return("")

  if(is.numeric(x))
    return(x)

  list(value = x, type = "date")
}

