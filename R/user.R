#' Set and Unset User
#' 
#' Set or unset the user being tracked.
#' This is set, __in plain text__ as cookie.
#' 
#' @param user String identifying the user.
#' @param expires Number of days from time of creation when the cookie expires.
#' @param session A valid Shiny session.
#' 
#' @importFrom shiny observe
#' 
#' @name user
#' 
#' @export
shinymetrics_set_user <- function(
  user,
  expires = 9999,
  session = shiny::getDefaultReactiveDomain()
) {
  observe({
    session$sendCustomMessage(
      "shinymetrics-set-user", 
      list(
        user = user,
        opts = list(
          expires = expires
        )
      )
    )
  }, priority = 9999999)
}

#' @rdname user
#' @export
shinymetrics_unset_user <- function(
  expires = 9999,
  session = shiny::getDefaultReactiveDomain()
) {
  observe({
    session$sendCustomMessage(
      "shinymetrics-set-user", 
      list(
        user = "",
        opts = list(
          expires = expires
        )
      )
    )
  }, priority = 9999999)
}

