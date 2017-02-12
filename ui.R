library(shiny)
Encoding("UTF-8")
shinyUI(fluidPage(

  # Application title
  titlePanel("Strategia Luxor"),

  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
    
      textInput("stock",
                "Wpisz ticker akcji:",
                value = "AAPL"),
      
      sliderInput("fast",
                  "Długość \"szybkiej\" SMA:",
                  min = 5,
                  max = 20,
                  value = 10),
      
      sliderInput("slow",
                  "Długość \"powolnej\" SMA:",
                  min = 25,
                  max = 60,
                  value = 30)
    ),

    # Show a plot of the generated distribution
    mainPanel(
      plotOutput("chart", height = 350),
      plotOutput("perf"),
      verbatimTextOutput("perform")
  )
)
)
)