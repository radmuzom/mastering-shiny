# (Hard) Make a wizard that allows the user to upload their own dataset.
# The first page should handle the upload. The second should handle reading it,
# providing one drop down for each variable that lets the user select the
# column type. The third page should provide some way to get a summary of
# the dataset.

library(shiny)
library(data.table)
library(purrr)

data_ui <- function(id, label = "CSV file") {
  
  ns <- NS(id)
  
  tagList(
    fileInput(ns("datafile"), label = label)
  )
  
}
data_server <- function(input, output, session) {
  
  datafile <- reactive({
    validate(need(input$datafile, message = FALSE))
    input$datafile
  })
  
  data <- reactive({
    fread(datafile()$datapath)
  })
  
  return(data)
  
}

variables_ui <- function(id) {
  
  ns <- NS(id)
  
  tagList(
    tableOutput(ns("datavartypes")),
    uiOutput(ns("datavars"))
  )
  
}
variables_server <- function(input, output, session, data) {
  
  datavars <- reactive({
    req(data())
    names(data())
  })
  
  make_var_ui <- function(var, x) {
    xclass <- class(x)
    if (xclass %in% c("integer", "numeric")) {
      xclass <- "numeric"
    } else {
      xclass <- "character"
    }
    selectInput(session$ns(var), var, choices = c("numeric", "character"),
                selected = xclass)
  }
  
  output$datavars <- renderUI({
    req(data())
    map(datavars(), ~ make_var_ui(.x, data()[[.x]]))
  })
  
  datavartypes <- reactive({
    req(datavars())
    vtypes <- reduce(map(datavars(), ~ input[[.x]]), c)
    if (is.null(vtypes)) {
      return(NULL)
    }
    names(vtypes) <- datavars()
    vtypes
  })
  
  output$datavartypes <- renderTable({
    data.frame(vtypes = datavartypes())
  })
  
  return(datavartypes)
  
}

summary_ui <- function(id) {
  
  ns <- NS(id)
  
  tagList(
    uiOutput(ns("summaryui"))
  )
  
}
summary_server <- function(input, output, session, data, datavartypes) {
  
  output$summaryui <- renderUI({
    tagList(
      selectInput(session$ns("choosevar"), "Choose variable:",
                  choices = names(datavartypes())),
      tableOutput(session$ns("varsumm"))
    )
  })
  
  output$varsumm <- renderTable({
    vtype <- datavartypes()[[input$choosevar]]
    x <- data()[[input$choosevar]]
    x <- x[!is.na(x)]
    if (vtype == "numeric") {
      qs <- quantile(x, probs = c(0.25, 0.5, 0.75))
      data.frame(min = min(x), max = max(x),
                 mean = mean(x), median = qs[2],
                 q1 = qs[1], q3 = qs[3])
    } else {
      data.frame(table(x))
    }
  })
  
}

ui <- fluidPage(
  tags$style("#wizard { display:none; }"),
  tabsetPanel(
    id = "wizard",
    tabPanel(
      "Data",
      data_ui("data_module"),
      actionButton("page12", "Next"),
      value = "data"
    ),
    tabPanel(
      "Variables",
      variables_ui("variables_module"),
      actionButton("page21", "Previous"),
      actionButton("page23", "Next"),
      value = "variables"
    ),
    tabPanel(
      "Summary",
      summary_ui("summary_module"),
      actionButton("page32", "Previous"),
      value = "summary"
    )
  )
)

server <- function(input, output, session) {
  
  data <- callModule(data_server, "data_module")
  datavartypes <- callModule(variables_server, "variables_module", data)
  callModule(summary_server, "summary_module", data, datavartypes)
  
  switch_tab <- function(page) {
    updateTabsetPanel(session, "wizard", selected = page)
  }
  
  observeEvent(input$page12, switch_tab("variables"))
  observeEvent(input$page21, switch_tab("data"))
  observeEvent(input$page23, switch_tab("summary"))
  observeEvent(input$page32, switch_tab("variables"))
  
}

shinyApp(ui = ui, server = server)