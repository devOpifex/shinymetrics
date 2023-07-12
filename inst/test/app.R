library(shiny)
library(shinymetrics)

tracker <- Shinymetrics$new(prod = TRUE)$track_recommended()
print(Sys.getenv("SHINYMETRICS_TOKEN"))

ui <- fluidPage(
  theme = bslib::bs_theme(version = 5L),
  tracker$include(),
  trackingToastBS5(
    full_width = TRUE,
    background = "white",
    position = "bottom",
    enable_opts = list(
      expires = as.Date("2100-10-01")
    )
  ),
  actionButton(
    "longComputation",
    "Long computation"
  ),
  # promptTrackingModalBS5(),
  textInput("text", "Text"),
  selectInput(
    "select",
    "Select",
    letters
  ),
  selectInput(
    "select2",
    "Select2",
    letters,
    selectize = FALSE
  ),
  selectInput(
    "select3",
    "Select3",
    letters,
    multiple = TRUE,
    selectize = TRUE
  ),
  selectizeInput(
    "selectize", "Selectize",
    letters
  ),
  textAreaInput("textarea", "textArea"),
  sliderInput(
    "slider",
    "Slider",
    min = 0L,
    max = 10L,
    value = 1L,
    step = 1L
  ),
  actionButton(
    "button",
    "Button"
  ),
  DT::DTOutput("dt"),
  tableOutput("table"),
  radioButtons(
    "radio",
    "Radio",
    LETTERS[1:4]
  ),
  checkboxGroupInput(
    "checkboxGroup",
    "Checkbox Group",
    LETTERS[1:4]
  ),
  checkboxInput(
    "checkbox",
    "Checkbox"
  ),
  dateInput(
    "date",
    "Date"
  ),
  dateRangeInput(
    "daterange",
    "Date range",
    start = Sys.Date() - 10,
    end = Sys.Date()
  ),
  numericInput(
    "numeric",
    "Numeric",
    2L
  ),
  echarts4r::echarts4rOutput("ec"),
  textOutput("txt"),
  uiOutput("ui"),
  plotOutput("plot"),
  plotOutput("error"),
  actionButton(
    "enable",
    "Enable tracking"
  ),
  actionButton(
    "disable",
    "Disable tracking"
  ),
  downloadLink('downloadData', 'Download'),
  actionButton(
    "custom",
    "Custom Event"
  ),
  actionButton(
    "crash",
    "Crash"
  ),
  actionButton(
    "close",
    "Close"
  ),
  tags$a(
    "Custom input",
    onclick = "() => {Shiny.setInputValue('testCustom', Math.rand())}"
  ),
  actionButton(
    "err",
    "Random error"
  )
)

server <- function(input, output, session) {
  shinymetrics_server()

  ds <- eventReactive(input$err, {
    if(sample(1:10, 1) < 8)
      return(data.frame(x = letters, y = runif(length(letters))))
    
    get(input$datasetName, "package:datasets", inherits = FALSE)
  })

  output$plot <- renderPlot({
    plot(runif(100))
  })

  output$dt <- DT::renderDT({
    input$button
    DT::datatable(data.frame(x = 1:10, y = runif(10)))
  })

  output$table <- renderTable({
    ds()
    ds()
  })

  output$ec <- echarts4r::renderEcharts4r({
    input$button
    data.frame(x = 1:10, y = runif(10)) |>
      echarts4r::e_charts(x) |>
      echarts4r::e_line(y)
  })

  output$txt <- renderText({
    paste("rendered text", input$button)
  })

  output$ui <- renderUI({
    p("rendered text", input$button)
  })

  output$error <- renderPlot({
    print(input$button)
    if(input$button %% 3)
      plot(error)
    else
      plot(cars)
  })

  observeEvent(input$enable, {
    shinymetrics_enable()
  })

  observeEvent(input$disable, {
    shinymetrics_disable()
  })

  observeEvent(input$shinymetricsEnabled, {
    print(input$shinymetricsEnabled)
  })

  output$downloadData <- downloadHandler(
    filename = function() {
      "cars.csv"
    },
    content = function(con) {
      write.csv(cars, con)
    }
  )

  observeEvent(input$custom, {
    shinymetrics_custom_event(
      "register",
      "registeruser",
      value = "Bob"
    )
  })

  observeEvent(input$close, {
    session$close()
  })

  observeEvent(input$crash, {
    DBI::dbConnect()
  })

  observeEvent(input$longComputation, {
    s <- sample(3:10, 1)
    Sys.sleep(s)
    print("sth")
  })
}

shinyApp(ui, server, options = list(port = 3000L))
