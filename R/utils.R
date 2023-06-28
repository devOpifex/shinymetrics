STANDARD_EVENTS <- c(
	"connected",
	"disconnected",
	"sessioninitialised",
	"busy",
	"idle",
	"input",
	"output",
	"message",
	"conditional",
	"bound",
	"unbound",
	"error",
	"outputinvalidated",
	"recalculating",
	"recalculated",
	"visualchange",
	"updateinput",
	"pageview",
	"filedownload"
)

is.Date <- function(x){
  return(inherits(x, "Date"))
}
