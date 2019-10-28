# What happens if you flip fct_infreq() and fct_lump() in the code that
# reduces the summary tables?

# Answer: The results are now sorted with the Other category in it's proper
# order by count rather than at the end

library(tidyverse)
library(vroom)
library(shiny)

if (!exists("injuries")) {
  injuries <- vroom::vroom("injuries.tsv.gz")
  products <- vroom::vroom("products.tsv")
  population <- vroom::vroom("population.tsv")
}

count_top <- function(df, var, n = 5) {
  # df %>%
  #   mutate({{ var }} := fct_lump(fct_infreq({{ var }}), n = n)) %>%
  #   group_by({{ var }}) %>%
  #   summarise(n = as.integer(sum(weight)))
  df %>%
    mutate({{ var }} := fct_infreq(fct_lump({{ var }}, n = n))) %>%
    group_by({{ var }}) %>%
    summarise(n = as.integer(sum(weight)))
}

# UI
ui <- fluidPage(
  fluidRow(
    column(6,
           selectInput("code", "Product", setNames(products$prod_code, products$title))
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
  
  output$diag <- renderTable(count_top(selected(), diag), width = "100%")
  output$body_part <- renderTable(count_top(selected(), body_part), width = "100%")
  output$location <- renderTable(count_top(selected(), location), width = "100%")
  
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