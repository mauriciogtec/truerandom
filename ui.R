
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(ggplot2)
library(Cairo)   # For nicer ggplot2 output when deployed on Linux


shinyUI(fluidPage(
  titlePanel("True random numbers monkey style!"),
  
  sidebarLayout(
    
    sidebarPanel(
      p("Click on the graph to generate random points (click with your eyes closed after moving the mouse around a bit)"),
      p("The distance between lines is exactly 2. We measure the distance from the point to the closest line and that is uniform (0,1). "),
      downloadButton('downloadData', 'Download data'),
      tableOutput("table")
    ),
    
    mainPanel(
      plotOutput("plot1", click = "plot_click"),
      tableOutput("table.descriptives"),
      plotOutput("hist")
    )
  )
))
