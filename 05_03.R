# Add an input control that lets the user decide how many rows to show in
# the summary tables.

library(tidyverse)
library(vroom)
library(shiny)

if (!exists("injuries")) {
  injuries <- vroom::vroom("injuries.tsv.gz")
  products <- vroom::vroom("products.tsv")
  population <- vroom::vroom("population.tsv")
}

count_top <- function(df, var, n = 5) {
  df %>%
    mutate({{ var }} := fct_lump(fct_infreq({{ var }}), n = n)) %>%
    group_by({{ var }}) %>%
    summarise(n = as.integer(sum(weight)))
}

# UI
ui <- fluidPage(
  fluidRow(
    column(6,
           selectInput("code", "Product", setNames(products$prod_code, products$title))
    ),
    column(6,
           sliderInput("numrows", "Number of rows",
                       value = 5, min = 1, max = 100)
    )
  ),
  fluidRow(
    column(4, tableOutput("diag")),
    column(4, tableOutput("body_part")),
    column(4, tableOutput("location"))
  ),
  fluidRow(
    column(12, plotOutput("age_sex"))
  )
)

# Server
server <- function(input, output, session) {
  selected <- reactive(injuries %>% filter(prod_code == input$code))
  nrows <- reactive(input$numrows)
  
  output$diag <- renderTable(count_top(selected(), diag, nrows()), width = "100%")
  output$body_part <- renderTable(count_top(selected(), body_part, nrows()), width = "100%")
  output$location <- renderTable(count_top(selected(), location, nrows()), width = "100%")
  
  summary <- reactive({
    selected() %>%
      count(age, sex, wt = weight) %>%
      left_join(population, by = c("age", "sex")) %>%
      mutate(rate = n / population * 1e4)
  })
  
  output$age_sex <- renderPlot({
    summary() %>%
      ggplot(aes(age, n, colour = sex)) +
      geom_line() +
      labs(y = "Estimated number of injuries") +
      theme_grey(15)
  })
}

# Run app
shinyApp(ui = ui, server = server)