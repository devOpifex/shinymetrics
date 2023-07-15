#' Initialise server tracking
#' 
#' This functions is only required if you want to
#' make use of [shinymetrics_custom_event()].
#' 
#' @param session A valid Shiny session.
#' 
#' @note You can also observe whether Shinymetrics tracking
#'  is enabled by listening to the `input$shinymetricsEnabled` input.
#' 
#' @importFrom shiny observeEvent
#' 
#' @export
shinymetrics_server <- function(
  session = shiny::getDefaultReactiveDomain()
){
  observeEvent(session$input$shinymetricsDebug, {
    obj <- session$input$shinymetricsDebug

    if(obj$type == "error") {
      print_error(obj$message)
      return()
    }

    print_info(obj$message)
  })
}

print_info <- function(message) {
  cat_("INFO -", message, "\n", file = stdout())
}

print_error <- function(message) {
  cat_("ERROR -", message, "\n", file = stderr())
}

cat_ <- function(...) {
  cat("[shinymetrics]", format(Sys.time(), "%Y-%m-%d %H:%M %Z |"), ...)
}

#' Shinymetrics Custom Event
#' 
#' Push __custom events__ from the server.
#' Requires running [shinymetrics_server()] prior.
#' 
#' @details It will not work for standard events.
#' 
#' Standard events:
#' 
#' - `connected`
#' - `disconnected`
#' - `disconnected`
#' - `sessioninitialised`
#' - `busy`
#' - `idle`
#' - `input`
#' - `output`
#' - `message`
#' - `conditional`
#' - `bound`
#' - `unbound`
#' - `error`
#' - `outputinvalidated`
#' - `recalculating`
#' - `recalculated`
#' - `visualchange`
#' - `updateinput`
#' - `pageview`
#' - `filedownload`
#' 
#' These must be custom events of your choosing, e.g.:
#' a custom event when registering or logging in a user. 
#' 
#' @param id A unique identifier for your custom event, used
#' to identify specific events of a certain `type`.
#' @param type Type of event that is pushed.
#' @param value Value of the event, this is converted to a character.
#' @param session A valid Shiny session.
#' 
#' @export 
shinymetrics_custom_event <- function(
  type,
  id = NULL,
  value = NULL,
  session = shiny::getDefaultReactiveDomain()
) {
  assert_that(not_missing(type))
  assert_that(!is_standard_event(type))

  if(is.null(id))
    id <- ""

  id <- gsub(" ", "", id)
  id <- session$ns(id)

  if(is.null(value))
    value <- ""

  params <- list(
    type = "custom",
    subtype = as.character(type),
    id = as.character(id),
    value = as.character(value)
  )

  session$sendCustomMessage(
    "shinymetrics-push",
    params
  )
}

