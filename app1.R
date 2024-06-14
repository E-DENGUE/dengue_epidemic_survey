library(dplyr)
library(ggplot2)
library(lubridate)
library(shiny)
#library(googlesheets4)
#gs4_auth()


d1 <- readRDS('./Data/CONFIDENTIAL/Updated_full_data_with_new_boundaries_all_factors_cleaned.rds') %>%
  dplyr::select(district, date, m_DHF_cases, pop) %>%
  mutate(month=month(date),
         year=year(date),
         epiyr = if_else(month>=4, year, year-1)
  ) %>%
  group_by(district, epiyr) %>%
  mutate(inc=m_DHF_cases/pop*100000,
         n_obs=n()) %>%
  filter(n_obs==12) %>%
  mutate(graphID=cur_group_id()) %>%
  ungroup() %>%
  filter(graphID==1)

# Define the Google Sheet ID or URL
#sheet_id <- "https://docs.google.com/spreadsheets/d/1Jns54VC2uZ1UouXumsX75y8EQfjug0ccfTTtR6YuT_k/edit?usp=sharing"

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
                         min = min(d1$date), max = max(d1$date), 
                         value = c(min(d1$date), max(d1$date)), step = 10, width = '100%')
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
    ggplot(d1,aes(x=date, y=inc))+
      geom_line() +
      theme_minimal() +
      ylab('Dengue cases/100000 people')+
      geom_vline(xintercept = input$range, color = "red") +
      ylim(0,400)
  })
  
  output$rangeText <- renderText({
    paste("Selected range: Start =", input$range[1], "End =", input$range[2])
  })
  
  observeEvent(input$saveButton, {
    # Save the selected range to a CSV file
    selected_range <- data.frame(Start = input$range[1], End = input$range[2])
    write.csv(selected_range, file = "selected_range.csv", row.names = FALSE)
    
    showModal(modalDialog(
      title = "Selection Saved",
      "Your selection has been saved successfully!",
      easyClose = TRUE,
      footer = NULL
    ))
  })
}
# Run the application 
shinyApp(ui = ui, server = server)
