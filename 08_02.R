# Complete the user interface below with a server function that updates
# input$county choices based on input$state. For an added challenge,
#also change the label from “County” to “Parrish” for Louisana and
# “Borrough” for “Alaska”.

library(tidyverse)
library(dplyr)
library(vroom)
library(shiny)
library(openintro)
states <- unique(county$state)

ui <- fluidPage(
  selectInput("state", "State", choices = states),
  selectInput("county", "County", choices = NULL)
)

server <- function(input, output, session) {
  observeEvent(input$state, {
    req(input$state)
    statec <- input$state
    counties <- dplyr::filter(county, state == statec) %>% pull(1)
    slabel <- if_else(statec == "Louisiana",
                      "Parrish",
                      if_else(statec == "Alaska",
                              "Borrough", "County"))
    updateSelectInput(session, "county", label = slabel, choices = counties)
  })
}

shinyApp(ui, server)
