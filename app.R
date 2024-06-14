library(shiny)
library(ggplot2)
library(googlesheets4)
gs4_auth()

# Sample data for plot
data <- data.frame(
  x = rnorm(100),
  y = rnorm(100)
)

# Define the Google Sheet ID or URL
sheet_id <- "https://docs.google.com/spreadsheets/d/1Jns54VC2uZ1UouXumsX75y8EQfjug0ccfTTtR6YuT_k/edit?usp=sharing"

# Define UI for application
ui <- fluidPage(
  tags$head(
    tags$style(HTML("
      .slider-container {
        width: 100%;
        position: relative;
        top: -20px; /* Adjust this value to align with the plot x-axis */
      }
    "))
  ),
  
  titlePanel("Interactive Plot with Sliders Below Plot"),
  
  fluidRow(
    column(12,
           plotOutput("plot", height = "600px")
    )
  ),
  
  fluidRow(
    column(12,
           div(
             class = "slider-container",
             sliderInput("range", "Select Range:",
                         min = min(data$x), max = max(data$x), 
                         value = c(min(data$x), max(data$x)), step = 0.1, width = '100%')
           )
    )
  ),
  
  fluidRow(
    column(12,
           verbatimTextOutput("rangeText"),
           actionButton("saveButton", "Save Selection")
    )
  )
)

# Define server logic
server <- function(input, output) {
  
  output$plot <- renderPlot({
    ggplot(data, aes(x = x, y = y)) +
      geom_point() +
      geom_vline(xintercept = input$range, color = "red") +
      ggtitle("ggplot with Interactive Sliders")
  })
  
  output$rangeText <- renderText({
    paste("Selected range: Start =", input$range[1], "End =", input$range[2])
  })
  
  observeEvent(input$saveButton, {
    # Append the selected range to the Google Sheet
    selected_range <- data.frame(Start = input$range[1], End = input$range[2], Timestamp = Sys.time())
    sheet_append(sheet_id, selected_range)
    
    showModal(modalDialog(
      title = "Selection Saved",
      "Your selection has been saved to the Google Sheet successfully!",
      easyClose = TRUE,
      footer = NULL
    ))
  })
}
# Run the application 
shinyApp(ui = ui, server = server)
