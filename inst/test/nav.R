library(shiny)
library(shinymetrics)

tracker <- Shinymetrics$new(prod = FALSE)$track_recommended()

script <- "$(document).on('shiny:inputchanged', (e) => {
  console.log(e);
});";

ui <- navbarPage(
  "Test",
  id = "nav",
  header = list(
    tracker$include()
  ),
  tabPanel(
    "home",
    h1("Home"),
    actionButton("test", "Test")
  ),
  tabPanel(
    "Dash",
    h1("Dashboard"),
    tabsetPanel(
      tabPanel("firstTabPanel", h2("asdas")),
      tabPanel("secondTabPanel", h2("asdas"))
    )
  )
)

server <- function(input, output, session){

}

shinyApp(ui, server, options = list(port = 3000L))

