library(shiny)
library(bs4Dash)
library(shinymetrics)

tracker <- Shinymetrics$new("U2RNKYXJFCWSBCN44C3LPEO67A", prod = FALSE)$track_recommended()

shinyApp(
  ui = dashboardPage(
    title = "Basic Dashboard",
    fullscreen = TRUE,
    header = dashboardHeader(
      tracker$include(),
      trackingModalBS4(),
      title = dashboardBrand(
        title = "bs4Dash",
        color = "primary",
        href = "https://www.google.fr",
        image = "https://adminlte.io/themes/AdminLTE/dist/img/user2-160x160.jpg",
      ),
      skin = "light",
      status = "white",
      border = TRUE,
      sidebarIcon = icon("bars"),
      controlbarIcon = icon("th"),
      fixed = FALSE,
      leftUi = tagList(
        dropdownMenu(
          badgeStatus = "info",
          type = "notifications",
          notificationItem(
            inputId = "triggerAction2",
            text = "Error!",
            status = "danger"
          )
        ),
        dropdownMenu(
          badgeStatus = "info",
          type = "tasks",
          taskItem(
            inputId = "triggerAction3",
            text = "My progress",
            color = "orange",
            value = 10
          )
        )
      ),
      rightUi = dropdownMenu(
        badgeStatus = "danger",
        type = "messages",
        messageItem(
          inputId = "triggerAction1",
          message = "message 1",
          from = "Divad Nojnarg",
          image = "https://adminlte.io/themes/v3/dist/img/user3-128x128.jpg",
          time = "today",
          color = "lime"
        )
      )
    ),
    sidebar = dashboardSidebar(
      skin = "light",
      status = "primary",
      elevation = 3,
      sidebarUserPanel(
        image = "https://image.flaticon.com/icons/svg/1149/1149168.svg",
        name = "Welcome Onboard!"
      ),
      sidebarMenu(
        sidebarHeader("Header 1"),
        menuItem(
          "Item 1",
          tabName = "item1",
          icon = icon("sliders")
        ),
        menuItem(
          "Item 2",
          tabName = "item2",
          icon = icon("id-card")
        )
      )
    ),
    controlbar = dashboardControlbar(
      skin = "light",
      pinned = TRUE,
      collapsed = FALSE,
      overlay = FALSE,
      controlbarMenu(
        id = "controlbarmenu",
        controlbarItem(
          title = "Item 1",
          sliderInput(
            inputId = "obs",
            label = "Number of observations:",
            min = 0,
            max = 1000,
            value = 500
          ),
          column(
            width = 12,
            align = "center",
            radioButtons(
              inputId = "dist",
              label = "Distribution type:",
              c(
                "Normal" = "norm",
                "Uniform" = "unif",
                "Log-normal" = "lnorm",
                "Exponential" = "exp"
              )
            )
          )
        ),
        controlbarItem(
          "Item 2",
          "Simple text"
        )
      )
    ),
    footer = dashboardFooter(
      left = a(
        href = "https://twitter.com/divadnojnarg",
        target = "_blank", "@DivadNojnarg"
      ),
      right = "2018"
    ),
    body = dashboardBody(
      tabItems(
        tabItem(
          tabName = "item1",
          fluidRow(
            lapply(1:3, FUN = function(i) {
              sortable(
                width = 4,
                p(class = "text-center", paste("Column", i)),
                lapply(1:2, FUN = function(j) {
                  box(
                    title = paste0("I am the ", j, "-th card of the ", i, "-th column"),
                    width = 12,
                    "Click on my header"
                  )
                })
              )
            })
          )
        ),
        tabItem(
          tabName = "item2",
          box(
            title = "Card with messages",
            width = 9,
            userMessages(
              width = 12,
              status = "success",
              userMessage(
                author = "Alexander Pierce",
                date = "20 Jan 2:00 pm",
                image = "https://adminlte.io/themes/AdminLTE/dist/img/user1-128x128.jpg",
                type = "received",
                "Is this template really for free? That's unbelievable!"
              ),
              userMessage(
                author = "Dana Pierce",
                date = "21 Jan 4:00 pm",
                image = "https://adminlte.io/themes/AdminLTE/dist/img/user5-128x128.jpg",
                type = "sent",
                "Indeed, that's unbelievable!"
              )
            )
          )
        )
      )
    )
  ),
  server = function(input, output) {}
)

