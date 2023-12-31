% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/prompts.R
\name{trackingToastBS5}
\alias{trackingToastBS5}
\title{Toast}
\usage{
trackingToastBS5(
  position = c("top-right", "top-left", "bottom-left", "bottom-right", "bottom", "top"),
  prompt = "Enable cookie tracking?",
  accept = "Accept",
  reject = "Reject",
  auto_hide = FALSE,
  delay = 5000L,
  animation = TRUE,
  background = c("", "white", "dark", "success", "danger", "warning", "info", "primary",
    "secondary"),
  full_width = FALSE,
  enable_opts = list()
)
}
\arguments{
\item{position}{Position of toast}

\item{prompt}{Text to display.}

\item{accept, reject}{Test to display on buttons.}

\item{auto_hide}{Whether to automatically hide the toast.}

\item{delay}{Delay before the toast is hidden, only applies if
\code{auto_hide} is \code{TRUE}.}

\item{animation}{Whether to animate the prompt.}

\item{background}{Background color of the toast.}

\item{full_width}{Whether to show the toast in full width.}

\item{enable_opts}{Options to pass to \code{\link[=shinymetrics_enable]{shinymetrics_enable()}}.}
}
\description{
This will display a toast prompting the user to enable
(or disable) tracking if it is not already enabled.
Place this function in your UI.
}
\note{
You can build your own fully custom prompt
this is here for convenience should you not want to do so.
}
