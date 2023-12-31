% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/prompts.R
\name{trackingModal}
\alias{trackingModal}
\alias{trackingModalBS5}
\alias{trackingModalBS4}
\alias{trackingModalBS3}
\title{Modal}
\usage{
trackingModalBS5(
  title = "Tracking",
  prompt = "Enable cookie tracking?",
  accept = "Accept",
  reject = "Reject",
  enable_opts = list()
)

trackingModalBS4(
  title = "tracking",
  prompt = "Enable cookie tracking?",
  accept = "Accept",
  reject = "Reject",
  enable_opts = list()
)

trackingModalBS3(
  title = "Tracking",
  prompt = "Enable cookie tracking?",
  accept = "Accept",
  reject = "Reject",
  enable_opts = list()
)
}
\arguments{
\item{title}{Title of the modal.}

\item{prompt}{Text to display.}

\item{accept, reject}{Test to display on buttons.}

\item{enable_opts}{Options to pass to \code{\link[=shinymetrics_enable]{shinymetrics_enable()}}.}
}
\description{
This will display a modal prompting the user to enable
(or disable) tracking if it is not already enabled.
Place this function in your UI.
}
\note{
You can build your own fully custom prompt
this is here for convenience should you not want to do so.
}
