
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(ggplot2)
library(Hmisc)

# The following two files control the current points in the graph and the random numbers.
write.csv(data.frame(x = -1, y = -1), "dta.csv", row.names=FALSE)
write.csv(data.frame(x = -1), "nlist.csv", row.names=FALSE)
new.point <- numeric(0)
#

shinyServer(function(input, output) {
  
  # ------------------------------------------------------------------------------------------
  output$plot1 <- renderPlot({
    # These two are two save current list into the files. 
    # Every time we click it rewrites.
    data <- read.csv("dta.csv", header = TRUE)  
    #
    
    # We introduce the effect of clicking
    new.point <- c(input$plot_click$x, input$plot_click$y)
    if(length(new.point) != 0){
      data <- rbind(data, data.frame(x = new.point[1], y = new.point[2]))
    }
    #
    
    # Write the results into files (if not, everytime we clicked it'd erase the previous point)
    write.csv(data, "dta.csv", row.names = FALSE)
    #
    
    # Create the plot with current data
    plot(data, xlim=c(0,15), ylim=c(0,20), pch=16, col="blue")
    abline(h=seq(0,20,2), lty=2)
    #
  })
  
  
  # ------------------------------------------------------------------------------------------------
  output$table <- renderTable({
    # Every time we click it rewrites.
    nlist <- read.csv("nlist.csv", header = TRUE)
    #
    
    # We introduce the effect of clicking 
    new.point <- c(input$plot_click$x, input$plot_click$y)
    if(length(new.point) != 0){
      dist.to.line <- min(abs(seq(0,20,2)-new.point[2]))
      nlist <- rbind(nlist, data.frame(x = dist.to.line))
    }
    #
    
    # Write the results into files (if not, everytime we clicked it'd erase the previous point)
    write.csv(nlist, "nlist.csv", row.names = FALSE)
    #
    
    #data <- dataInput()
    # the "if" needs to be used for the case when we haven't cliked yet
    if (nrow(nlist) == 1){
      data.frame()
    } else{
      data.frame(Generated = nlist[-1, ])
    }
  }, digits = 10)
  
  
  # --------------------------------------------------------------------------------------------------
  output$table.descriptives <- renderTable({
    # These two are two save current list into the files. 
    # Every time we click it rewrites.
    nlist <- read.csv("nlist.csv", header = TRUE)
    #
    
    # We introduce the effect of clicking
    new.point <- c(input$plot_click$x, input$plot_click$y) # we won't really use it.
    #

        # the "if" needs to be used for the case when we haven't cliked yet
    if (nrow(nlist) == 1){
      data.frame()
    } else{
      stats <- Hmisc::describe(nlist[-1,])$counts[-c(2,3,4)]
      dat <- data.frame(c(stats, sd = sd(nlist[-1, ])))
      names(dat) <- "Some statistics"
      dat
    }
  })
  

  
  
  # ----------------------------------------------------------------------------
  datasetInput <- reactive({
    new.point <- c(input$plot_click$x, input$plot_click$y)
    list <- read.csv("nlist.csv", header = TRUE)
    list[-1, ]
  })

  output$downloadData <- downloadHandler(
    # This line forces to update when clicking. I am sure there are better options.
    filename = function() {paste('data-', Sys.Date(), '.csv', sep='')},
    content = function(file) {
      write.csv(datasetInput(), file, row.names = FALSE)
    }
  ) 
  output$hist <- renderPlot({
    if(length(as.numeric(datasetInput())) >= 2){
      hist(datasetInput(), main = "Histogram of generated numbers", breaks=5)
    }
  })
  
  
})
