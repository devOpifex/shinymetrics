#' Toast
#' 
#' This will display a toast prompting the user to enable
#' (or disable) tracking if it is not already enabled.
#' Place this function in your UI.
#' 
#' @note You can build your own fully custom prompt
#' this is here for convenience should you not want to do so.
#' 
#' @param position Position of toast
#' @param prompt Text to display.
#' @param accept,reject Test to display on buttons.
#' @param auto_hide Whether to automatically hide the toast.
#' @param delay Delay before the toast is hidden, only applies if
#' `auto_hide` is `TRUE`.
#' @param animation Whether to animate the prompt.
#' @param background Background color of the toast.
#' @param full_width Whether to show the toast in full width.
#' @param enable_opts Options to pass to [shinymetrics_enable()].
#' 
#' @importFrom shiny singleton tagList tags HTML
#' @importFrom jsonlite toJSON
#' 
#' @export 
trackingToastBS5 <- function(
  position = c(
    "top-right",
    "top-left",
    "bottom-left",
    "bottom-right",
    "bottom",
    "top"
  ),
  prompt = "Enable cookie tracking?",
  accept = "Accept",
  reject = "Reject",
  auto_hide = FALSE,
  delay = 5000L,
  animation = TRUE,
  background = c("", "white", "dark", "success", "danger", "warning", "info", "primary", "secondary"),
  full_width = FALSE,
  enable_opts = list()
) {
  position <- match.arg(position)

  if(!full_width)
    position <- paste(position, "m-2")

  opts <- list(
    position = make_toast_position(position),
    prompt = as.character(prompt),
    accept = accept,
    reject = reject,
    background = sprintf("bg-%s", background[1]),
    width = ifelse(full_width, "w-100", ""),
    enableOpts = make_enable_opts(enable_opts),
    toast = list(
      autoHide = auto_hide,
      delay = delay,
      animation = animation
    )
  )

  opts <- toJSON(opts, auto_unbox = TRUE)

  singleton(
    tagList(
      useShinymetrics(),
      tags$script(
        HTML(
          sprintf(
            "shinymetrics.promptToastBS5(%s);",
            opts
          )
        )
      )
    )
  )
}

#' Modal
#' 
#' This will display a modal prompting the user to enable
#' (or disable) tracking if it is not already enabled.
#' Place this function in your UI.
#' 
#' @param title Title of the modal.
#' @inheritParams trackingToastBS5
#' 
#' @note You can build your own fully custom prompt
#' this is here for convenience should you not want to do so.
#' 
#' @name trackingModal
#' @export 
trackingModalBS5 <- function(
  title = "Tracking",
  prompt = "Enable cookie tracking?",
  accept = "Accept",
  reject = "Reject",
  enable_opts = list()
) {
  promptTrackingModalBS(
    title = title,
    prompt = prompt,
    accept = accept,
    reject = reject,
    enableOpts = make_enable_opts(enable_opts),
    version = 5L
  )
}

#' @rdname trackingModal
#' @export 
trackingModalBS4 <- function(
  title = "tracking",
  prompt = "Enable cookie tracking?",
  accept = "Accept",
  reject = "Reject",
  enable_opts = list()
) {
  promptTrackingModalBS(
    title = title,
    prompt = prompt,
    accept = accept,
    reject = reject,
    enableOpts = make_enable_opts(enable_opts),
    version = 4L
  )
}

#' @rdname trackingModal
#' @export 
trackingModalBS3 <- function(
  title = "Tracking",
  prompt = "Enable cookie tracking?",
  accept = "Accept",
  reject = "Reject",
  enable_opts = list()
) {
  promptTrackingModalBS(
    title = title,
    prompt = prompt,
    accept = accept,
    reject = reject,
    enableOpts = make_enable_opts(enable_opts),
    version = 3L
  )
}

#' @importFrom shiny singleton tagList tags HTML
#' @importFrom jsonlite toJSON
#' @noRd 
#' @keywords internal
promptTrackingModalBS <- function(
  title = "Tracking",
  prompt = "Enable cookie tracking?",
  accept = "Accept",
  reject = "Reject",
  enableOpts = list(),
  version = c(3L, 4L, 5L)
) {
  # cannot match.arg on numeric
  version <- version[1]
  opts <- toJSON(as.list(environment()), auto_unbox = TRUE)

  singleton(
    tagList(
      useShinymetrics(),
      tags$script(
        HTML(
          sprintf(
            "shinymetrics.promptModalBS%s(%s);",
            version,
            opts
          )
        )
      )
    )
  )
}

#' Translate toast postion to CSS
#' 
#' @param position Position string.
#' 
#' @keywords internal
make_toast_position <- function(position) {
  if(position == "top-right")
    return("top-0 end-0")

  if(position == "top-left")
    return("top-0 start-0")

  if(position == "bottom-right")
    return("bottom-0 end-0")

  if(position == "top")
    return("top-0")

  if(position == "bottom")
    return("bottom-0")

  return("bottom-0 start-0")
}

make_enable_opts <- function(opts){
  if(is.null(opts$expires))
    return(opts)

  assert_that(is_valid_expire(opts$expires))
  opts$expires <- make_expire(opts$expires)

  return(opts)
}

