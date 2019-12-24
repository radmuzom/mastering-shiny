# Take this very simple app based on the initial example in the chapter:
# How could you instead implement it using dynamic visibility?
# If you implement dynamic visiblity, how could you keep the values in
# sync when you change the controls?

library(shiny)

toni_tags <- tagList(
  tags$style("#toni {display:none;}"),
  tabsetPanel(
    id = "toni",
    tabPanel("slider",
      sliderInput("ns", "n", value = 0, min = 0, max = 100),
    ),
    tabPanel("numeric",
      numericInput("ni", "n", value = 0, min = 0, max = 100)
    )
  )
)

ui <- fluidPage(
  selectInput("type", "type", c("slider", "numeric")),
  toni_tags
)

server <- function(input, output, session) {
  observeEvent(input$type, {
    type <- input$type
    cns <- isolate(currentns())
    cni <- isolate(currentni())
    updateTabsetPanel(session, "toni", selected = type)
    if (type == "slider") {
      updateSliderInput(session, "ns", "n", value = cni, min = 0, max = 100)
    } else {
      updateNumericInput(session, "ni", "n", value = cns, min = 0, max = 100)
    }
  })
  
  currentns <- reactive({
    input$ns
  })
  currentni <- reactive({
    input$ni
  })
}

shinyApp(ui, server)