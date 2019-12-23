# Complete the user interface below with a server function that updates
# input$date so that you can only select dates in input$year.

library(tidyverse)
library(vroom)
library(shiny)

ui <- fluidPage(
  numericInput("year", "year", value = 2020, step = 1),
  dateInput("date", "date")
)

server <- function(input, output, session) {
  observeEvent(input$year, {
    yr <- input$year
    min_date <- paste0(yr, "-01", "-01")
    max_date <- paste0(yr, "-12", "-31")
    updateDateInput(session, "date", value = NULL,
                    min = min_date, max = max_date)
  })
}

shinyApp(ui, server)