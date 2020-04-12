# (Advanced) If you know the S3 OOP system, consider how you could replace
# the if blocks in make_ui() and filter_var() with generic functions.

library(shiny)
library(purrr)

make_ui.numeric <- function(x, var) {
  rng <- range(x, na.rm = TRUE)
  sliderInput(var, var, min = rng[1], max = rng[2], value = rng)
}

make_ui.factor <- function(x, var) {
  levs <- levels(x)
  selectInput(var, var, choices = levs, selected = levs, multiple = TRUE)
}

make_ui.default <- function(x, var) {
  NULL
}

make_ui <- function(x, ...) {
  UseMethod("make_ui")
}

filter_var.numeric <- function(x, val) {
  !is.na(x) & x >= val[1] & x <= val[2]
}

filter_var.factor <- function(x, val) {
  x %in% val
}

filter_var.default <- function(x, val) {
  TRUE
}

filter_var <- function(x, ...) {
  UseMethod("filter_var")
}

dfs <- keep(ls("package:datasets"), ~ is.data.frame(get(.x, "package:datasets")))

ui <- fluidPage(
  sidebarLayout(
    sidebarPanel(
      selectInput("dataset", label = "Dataset", choices = dfs),
      uiOutput("filter")
    ),
    mainPanel(
      tableOutput("data")
    )
  )
)

server <- function(input, output, session) {
  data <- reactive({
    #get(input$dataset, "package:datasets")
    get(input$dataset)
  })
  vars <- reactive(names(data()))
  
  output$filter <- renderUI({
    map(vars(), ~ make_ui(data()[[.x]], .x))
  })
  
  selected <- reactive({
    each_var <- map(vars(), ~ filter_var(data()[[.x]], input[[.x]]))
    reduce(each_var, `&`)
  })
  
  output$data <- renderTable(head(data()[selected(), ], 12))
}

shinyApp(ui, server)