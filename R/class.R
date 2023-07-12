#' Shinymetrics
#' 
#' @importFrom htmltools tagList singleton tags
#' @importFrom jsonlite toJSON
#' @import R6
#' 
#' @field token Your [shinymetrics](https://shinymetrics.com) token.
#' 
#' @export 
Shinymetrics <- R6::R6Class(
  "Shinymetrics",
  cloneable = FALSE,
  public = list(
    #' @details Initialize tracker
    #' 
    #' @param token Your application token.
    #' @param prod Whether the events are tracked for production.
    #' @param ignore_global Whether to ignore "global" events,
    #' these are events that target the entire HTML document,
    #' they tend to add noise.
    #' They mainly are events sent by HTMLwidgetsand the likes.
    #' It is advised to ignore them.
    #' 
    #' These allow not polluting your dashboard with test data.
    #' It is `FALSE` by default.
    initialize = function(
      token = Sys.getenv("SHINYMETRICS_TOKEN"),
      prod = getOption("SHINYMETRICS_PROD", FALSE),
      ignore_global = TRUE
    ) {
      assert_that(has_var(token))

      cat(
        "shinymetrics tracking in",
        ifelse(prod, "prod", "test"),
        "\n",
        file = stdout()
      )

      private$.token <- token
      private$.prod <- prod
      private$.ignoreGlobal <- ignore_global
      invisible(self)
    },
    #' @details Recommended events to track.
    #' 
    #' Tracks the following:
    #' - `input`
    #' - `output`
    #' - `error`
    #' - `file_download`
    #' - `page_view`
    #' - `busy_idle`
    track_recommended = function() {
      self$track_input()
      self$track_output()
      self$track_error()
      self$track_file_download()
      self$track_busy_idle()
      self$track_page_view()
      invisible(self)
    },
    #' @details Track "connected" event fired when
    #' Shiny's server connects.
    #' 
    #' @param ignore `inputId`s or `outputId`s to ignore
    #' from the tracking.
    #' Must include the namespace.
    #' Cannot be used with `only`.
    #' @param only `inputId`s or `outputId`s to limit
    #' the tracking the tracking to. 
    #' Must include the namespace.
    #' Cannot be used with `ignore`.
    track_connected = function(ignore = c(), only = c()) {
      private$.track("connected", ignore, only)
      invisible(self)
    },
    #' @details Track "disconnected" event fired when
    #' Shiny's server disconnects.
    #' 
    #' @param ignore `inputId`s or `outputId`s to ignore
    #' from the tracking.
    #' Must include the namespace.
    #' Cannot be used with `only`.
    #' @param only `inputId`s or `outputId`s to limit
    #' the tracking the tracking to. 
    #' Must include the namespace.
    #' Cannot be used with `ignore`.
    track_disconnected = function(ignore = c(), only = c()) {
      private$.track("disconnected", ignore, only)
      invisible(self)
    },
    #' @details Track "sessioninitialized" event fired when
    #' Shiny's session is initialized.
    #' 
    #' @param ignore `inputId`s or `outputId`s to ignore
    #' from the tracking.
    #' Must include the namespace.
    #' Cannot be used with `only`.
    #' @param only `inputId`s or `outputId`s to limit
    #' the tracking the tracking to. 
    #' Must include the namespace.
    #' Cannot be used with `ignore`.
    track_session_initialialized = function(ignore = c(), only = c()) {
      private$.track("sessioninitialized", ignore, only)
      invisible(self)
    },
    #' @details Track "busy" and "idle" event fired when the server is performing
    #' calculations and stops.
    #' 
    #' @param ignore `inputId`s or `outputId`s to ignore
    #' from the tracking.
    #' Must include the namespace.
    #' Cannot be used with `only`.
    #' @param only `inputId`s or `outputId`s to limit
    #' the tracking the tracking to. 
    #' Must include the namespace.
    #' Cannot be used with `ignore`.
    track_busy_idle = function(ignore = c(), only = c()) {
      private$.track("busy", ignore, only)
      private$.track("idle", ignore, only)
      invisible(self)
    },
    #' @details Track "inputchanged" event fired when an
    #' input value changes.
    #' 
    #' @param ignore `inputId`s or `outputId`s to ignore
    #' from the tracking.
    #' Must include the namespace.
    #' Cannot be used with `only`.
    #' @param only `inputId`s or `outputId`s to limit
    #' the tracking the tracking to. 
    #' Must include the namespace.
    #' Cannot be used with `ignore`.
    track_input = function(ignore = c(), only = c()) {
      private$.track("inputchanged", ignore, only)
      invisible(self)
    },
    #' @details Track "message" event triggered when any messages
    #' are received from the server.
    #' 
    #' @param ignore `inputId`s or `outputId`s to ignore
    #' from the tracking.
    #' Must include the namespace.
    #' Cannot be used with `only`.
    #' @param only `inputId`s or `outputId`s to limit
    #' the tracking the tracking to. 
    #' Must include the namespace.
    #' Cannot be used with `ignore`.
    track_message = function(ignore = c(), only = c()) {
      private$.track("message", ignore, only)
      invisible(self)
    },
    #' @details Track "conditional" triggered when `shiny::conditionalPanel`
    #' are updated.
    #' 
    #' @param ignore `inputId`s or `outputId`s to ignore
    #' from the tracking.
    #' Must include the namespace.
    #' Cannot be used with `only`.
    #' @param only `inputId`s or `outputId`s to limit
    #' the tracking the tracking to. 
    #' Must include the namespace.
    #' Cannot be used with `ignore`.
    track_conditional = function(ignore = c(), only = c()) {
      private$.track("conditional", ignore, only)
      invisible(self)
    },
    #' @details Track "bound" triggered when an input or output
    #' is bound with the shiny server.
    #' 
    #' @param ignore `inputId`s or `outputId`s to ignore
    #' from the tracking.
    #' Must include the namespace.
    #' Cannot be used with `only`.
    #' @param only `inputId`s or `outputId`s to limit
    #' the tracking the tracking to. 
    #' Must include the namespace.
    #' Cannot be used with `ignore`.
    track_bound = function(ignore = c(), only = c()) {
      private$.track("bound", ignore, only)
      invisible(self)
    },
    #' @details Track "unbound" triggered when an input or output
    #' is no longer bound with the shiny server.
    #' 
    #' @param ignore `inputId`s or `outputId`s to ignore
    #' from the tracking.
    #' Must include the namespace.
    #' Cannot be used with `only`.
    #' @param only `inputId`s or `outputId`s to limit
    #' the tracking the tracking to. 
    #' Must include the namespace.
    #' Cannot be used with `ignore`.
    track_unbound = function(ignore = c(), only = c()) {
      private$.track("unbound", ignore, only)
      invisible(self)
    },
    #' @details Track the "value" event which is triggered when 
    #' an output receives a value from the server
    #' (when an output is updated).
    #' 
    #' @param ignore `inputId`s or `outputId`s to ignore
    #' from the tracking.
    #' Must include the namespace.
    #' Cannot be used with `only`.
    #' @param only `inputId`s or `outputId`s to limit
    #' the tracking the tracking to. 
    #' Must include the namespace.
    #' Cannot be used with `ignore`.
    track_output = function(ignore = c(), only = c()) {
      private$.track("value", ignore, only)
      invisible(self)
    },
    #' @details Track the "error" event, triggered when an 
    #' error is propagated to an output
    #' 
    #' @param ignore `inputId`s or `outputId`s to ignore
    #' from the tracking.
    #' Must include the namespace.
    #' Cannot be used with `only`.
    #' @param only `inputId`s or `outputId`s to limit
    #' the tracking the tracking to. 
    #' Must include the namespace.
    #' Cannot be used with `ignore`.
    track_error = function(ignore = c(), only = c()) {
      private$.track("error", ignore, only)
      invisible(self)
    },
    #' @details Track "outputinvalidated" event triggered,
    #' when an output’s value is invalidated on the server.
    #' 
    #' @param ignore `inputId`s or `outputId`s to ignore
    #' from the tracking.
    #' Must include the namespace.
    #' Cannot be used with `only`.
    #' @param only `inputId`s or `outputId`s to limit
    #' the tracking the tracking to. 
    #' Must include the namespace.
    #' Cannot be used with `ignore`.
    track_output_invalidated = function(ignore = c(), only = c()) {
      private$.track("outputinvalidated", ignore, only)
      invisible(self)
    },
    #' @details Track "recalculating" triggered before an output 
    #' value is recalculated.
    #' 
    #' @param ignore `inputId`s or `outputId`s to ignore
    #' from the tracking.
    #' Must include the namespace.
    #' Cannot be used with `only`.
    #' @param only `inputId`s or `outputId`s to limit
    #' the tracking the tracking to. 
    #' Must include the namespace.
    #' Cannot be used with `ignore`.
    track_recalculating = function(ignore = c(), only = c()) {
      private$.track("recalculating", ignore, only)
      invisible(self)
    },
    #' @details Track "recalculating" triggered after an output 
    #' value has been recalculated.
    #' 
    #' @param ignore `inputId`s or `outputId`s to ignore
    #' from the tracking.
    #' Must include the namespace.
    #' Cannot be used with `only`.
    #' @param only `inputId`s or `outputId`s to limit
    #' the tracking the tracking to. 
    #' Must include the namespace.
    #' Cannot be used with `ignore`.
    track_recalculated = function(ignore = c(), only = c()) {
      private$.track("recalculated", ignore, only)
      invisible(self)
    },
    #' @details Track "visualchange" triggered when an output is 
    #' resized, hidden, or shown.
    #' 
    #' @param ignore `inputId`s or `outputId`s to ignore
    #' from the tracking.
    #' Must include the namespace.
    #' Cannot be used with `only`.
    #' @param only `inputId`s or `outputId`s to limit
    #' the tracking the tracking to. 
    #' Must include the namespace.
    #' Cannot be used with `ignore`.
    track_visual_change = function(ignore = c(), only = c()) {
      private$.track("visualchange", ignore, only)
      invisible(self)
    },
    #' @details Track "updateinput" event is triggered when an input
    #' is updated from the server, e.g., when you call [shiny::updateTextInput()]
    #' in R to update the label or value of a text input.
    #' 
    #' @param ignore `inputId`s or `outputId`s to ignore
    #' from the tracking.
    #' Must include the namespace.
    #' Cannot be used with `only`.
    #' @param only `inputId`s or `outputId`s to limit
    #' the tracking the tracking to. 
    #' Must include the namespace.
    #' Cannot be used with `ignore`.
    track_update_input = function(ignore = c(), only = c()) {
      private$.track("updateinput", ignore, only)
      invisible(self)
    },
    #' @details Track when a page is loaded.
    #' 
    #' @param ignore `inputId`s or `outputId`s to ignore
    #' from the tracking.
    #' Must include the namespace.
    #' Cannot be used with `only`.
    #' @param only `inputId`s or `outputId`s to limit
    #' the tracking the tracking to. 
    #' Must include the namespace.
    #' Cannot be used with `ignore`.
    track_page_view = function(ignore = c(), only = c()) {
      private$.track("pageview", ignore, only)
      invisible(self)
    },
    #' @details Track "filedownload" event triggered when a file is downloaded
    #' via the [shiny::downloadButton()].
    #' 
    #' @param ignore `inputId`s or `outputId`s to ignore
    #' from the tracking.
    #' Must include the namespace.
    #' Cannot be used with `only`.
    #' @param only `inputId`s or `outputId`s to limit
    #' the tracking the tracking to. 
    #' Must include the namespace.
    #' Cannot be used with `ignore`.
    track_file_download = function(ignore = c(), only = c()) {
      private$.track("filedownload", ignore, only)
      invisible(self)
    },
    #' @details Track custom events.
    #' 
    #' @param type Type of event that is pushed.
    #' @param id A unique identifier for your custom event, used
    #' to identify specific events of a certain `type`.
    #' @param value Value of the event, this is converted to a character.
    #' @param session A valid Shiny session.
    track_custom = function(
      type,
      id = NULL,
      value = NULL,
      session = shiny::getDefaultReactiveDomain()
    ) {
      shinymetrics_custom_event(
        type,
        id = id,
        value = value,
        session = session
      )
      invisible(self)
    },
    #' @details Include the tracking code in your UI.
    include = function() {
      assert_that(has_tracking(private$.track))

      settings <- list(
        token = private$.token,
        prod = private$.prod,
        track = private$.events,
        global = private$.ignoreGlobal
      )

      json <- toJSON(
        settings,
        dataframe = "rows",
        auto_unbox = TRUE
      )

      x <- tagList(
        useShinymetrics(),
        tags$script(
          type = "application/json",
          id = "shinymetrics",
          HTML(json)
        ) ,
        tags$script(
          HTML(
            sprintf("shinymetrics.shiny();")
          )
        )
      )

      singleton(x)
    }
  ),
  active = list(
    token = function(value) {
      if(missing(value))
        return(private$.token)

      private$.token <- token
    }
  ),
  private = list(
    .track = function(event, ignore = c(), only = c()) {
      assert_that(xor(ignore, only))

      if(length(private$.events[[event]][["ignore"]]) == 0L)
        private$.events[[event]][["ignore"]] <- list()
      else
        private$.events[[event]][["ignore"]] <- append(private$.events[[event]][["ignore"]], ignore)

      if(length(private$.events[[event]][["only"]]) == 0L)
        private$.events[[event]][["only"]] <- list()
      else
        private$.events[[event]][["only"]] <- append(private$.events[[event]][["only"]], only)

      invisible(self)
    },
    .token = NULL,
    .prod = FALSE,
    .ignoreGlobal = TRUE,
    .events = list()
  )
)
