#' Dependency
#' 
#' Shinymetrics dependencies. 
#' If you use the `track` method of the 
#' [Shinymetrics] class you __do not__
#' need this function.
#' It is only needed if you want to manually
#' set the tracking via JavaScript, if you use
#' functions of the package this is not needed.
#' 
#' @importFrom htmltools htmlDependency
#' 
#' @export 
useShinymetrics <- function() {
  htmlDependency(
    "shinymetrics",
    utils::packageVersion("shinymetrics"),
    package = "shinymetrics",
    src = "assets",
    script = "shinymetrics.min.js",
    stylesheet = "shinymetrics.min.css"
  )
}
