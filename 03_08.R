# Update the options for renderDataTable() below so that the table is
# displayed, but nothing else, i.e. remove the search, ordering, and
# filtering commands.

library(shiny)

# UI
ui <- fluidPage(
  dataTableOutput("table")
)

# Server
server <- function(input, output, session) {
  output$table <- renderDataTable(mtcars,
                                  options = list(
                                    pageLength = 5,
                                    searching = FALSE,
                                    ordering = FALSE,
                                    paging = FALSE
                                  )
  )
}

# Run the app
shinyApp(ui = ui, server = server)