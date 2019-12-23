# Extend the previous app so that you can also choose to select no continent,
# and hence see all countries. You’ll need to add "" to the list of choices,
# and then handle that specially when filtering.

library(gapminder)
library(shiny)
continents <- as.character(unique(gapminder$continent))

ui <- fluidPage(
  selectInput("continent", "Continent", choices = c("All", continents),
              selected = ""), 
  selectInput("country", "Country", choices = NULL),
  tableOutput("data")
)

server <- function(input, output, session) {
  observeEvent(input$continent, {
    req(input$continent)
    continentc <- input$continent
    countries <- dplyr::filter(gapminder, continent == continentc) %>% pull(1)
    if (continentc == "All") {
      countries <- unique(gapminder$country)
    }
    updateSelectInput(session, "country", choices = countries)
  })
  
  cntryds <- reactive({
    req(input$continent)
    req(input$country)
    ds <- filter(gapminder,
                 continent == input$continent & country == input$country)
    if (input$continent == "All")
      ds <- filter(gapminder, country == input$country)
    ds
  })
  
  output$data <- renderTable({
    cntryds()
  })
}

shinyApp(ui, server)
