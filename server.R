library(shiny)
library(quantmod)
library(zoo)
library(TTR)

shinyServer(function(input, output) {
  Sys.setenv(TZ = "UTC")
  
  init_date <- "2014-12-31"
  start_date <- "2015-01-01"
  end_date <- "2016-12-31"
  init_equity <- 1e4 #10,000
  adjustment <- T
  
  dataInput <- reactive({
    getSymbols(
      input$stock,
      src = "yahoo",
      from = as.Date(start_date),
      to = as.Date(end_date),
      auto.assign = F
      )
  })
  
  sma_fast <- reactive({
        runMean(dataInput()[,1], input$fast)
        })
  
  sma_slow <- reactive({
    runMean(dataInput()[,1], input$slow)
    })

  sig <- reactive({
    Lag(ifelse(sma_fast()[,1] >= sma_slow()[,1], 1, -1))
  })
  
  zwrot <- reactive({
    ROC(Cl(dataInput()))*sig()
  })
  
  output$chart = renderPlot({
        chart_Series(Cl(dataInput()), TA = NULL)
        add_TA(x = sma_fast(), on=1, col=2)
        add_TA(x= sma_slow(), on=1, col=3)
      })
  output$perf = renderPlot({
    charts.PerformanceSummary(zwrot())
  })
  output$perform = renderPrint({
    table.Drawdowns(zwrot()[,1], top=5)
    table.DownsideRisk(zwrot()[,1])
      })
})