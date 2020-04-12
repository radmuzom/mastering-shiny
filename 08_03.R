# Complete the user interface below with a server function that updates
# input$country choices based on the input$continent.
# Use output$data to display all matching rows.

library(gapminder)
library(shiny)
continents <- unique(gapminder$continent)

ui <- fluidPage(
  selectInput("continent", "Continent", choices = continents), 
  selectInput("country", "Country", choices = NULL),
  tableOutput("data")
)

server <- function(input, output, session) {
  observeEvent(input$continent, {
    req(input$continent)
    continentc <- input$continent
    countries <- dplyr::filter(gapminder, continent == continentc) %>% pull(1)
    updateSelectInput(session, "country", choices = countries)
  })
  
  cntryds <- reactive({
    req(input$continent)
    req(input$country)
    filter(gapminder, continent == input$continent & country == input$country)
  })
  
  output$data <- renderTable({
    cntryds()
  })
}

shinyApp(ui, server)
