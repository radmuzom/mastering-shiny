# Add support for date and date-time columns make_ui() and filter_var()

make_ui <- function(x, var) {
  if (is.numeric(x)) {
    rng <- range(x, na.rm = TRUE)
    sliderInput(var, var, min = rng[1], max = rng[2], value = rng)
  } else if (is.factor(x)) {
    levs <- levels(x)
    selectInput(var, var, choices = levs, selected = levs, multiple = TRUE)
  } else if (inherits(x, "Date") || inherits(x, "POSIXct")) {
    rng <- range(x, na.rm = TRUE)
    dateRangeInput(var, var, min = rng[1], max = rng[2],
                   start = rng[1], end = rng[2])
  } else {
    # Not supported
    NULL
  }
}


filter_var <- function(x, val) {
  if (is.numeric(x)) {
    !is.na(x) & x >= val[1] & x <= val[2]
  } else if (is.factor(x)) {
    x %in% val
  } else if(inherits(x, "Date") || inherits(x, "POSIXct")) {
    !is.na(x) & x >= val[1] & x <= val[2]
  } else {
    # No control, so don't filter
    TRUE
  }
}

dfs <- keep(ls("package:datasets"), ~ is.data.frame(get(.x, "package:datasets")))
dfs <- c("d1","d2")
d1 <- data.frame(x = c(1,2,3), d = as.Date(c("2019-01-03", "2018-07-04", "2016-03-03")))
d2 <- data.frame(y = c(1,2,3), dt = as.POSIXct(c("2019-01-03 00:00:00", "2018-07-04 05:00:00", "2016-03-03 03:00:00")))

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
  
  output$filter <- renderUI(
    map(vars(), ~ make_ui(data()[[.x]], .x))
  )
  
  selected <- reactive({
    each_var <- map(vars(), ~ filter_var(data()[[.x]], input[[.x]]))
    reduce(each_var, `&`)
  })
  
  output$data <- renderTable(head(data()[selected(), ], 12))
}

shinyApp(ui, server)