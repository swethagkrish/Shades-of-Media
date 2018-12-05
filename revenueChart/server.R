
library(shiny)
library(ggplot2)
library(dplyr)

dataF <- read.csv(file = "../mainData.csv" , sep = ",", stringsAsFactors = TRUE)
dataF <- as.data.frame(dataF)



predomFRev <- c()
predomMRev <- c()
predomFYear <- c()
predomMYear <- c()


# Sort out the imdb_ids of movies that are predominantly female and male in loop
for (i in levels(dataF$imdb_id)) {
  data = subset(dataF, dataF$imdb_id == i)
  numFemales = count(data[data$gender == "f",])
  numMales = count(data[data$gender == "m",])
  rev <- c(data[1,"revenue"])
  year <- c(data[1,"year"])
  if (numFemales > numMales) {
    predomFRev <- c(predomFRev, rev)
    predomFYear <- c(predomFYear, year)
  } else {
    predomMRev <- c(predomMRev, rev)
    predomMYear <- c(predomMYear, year)
  }
}



shinyServer(function(input, output) {
  output$distPlot <- renderPlot({
    dateRange <- reactive({return(input$daterange)})
    #Convert string date value into interger to use for plotting the years
    startYear <- strtoi(substring(dateRange()[1], 1, 4))
    endYear <- strtoi(substring(dateRange()[2], 1, 4))
    #plot made, male data first
    plot(predomMYear, predomMRev / 100000000, xlim = c(startYear, endYear), pch = 16, col = "lightblue1", xlab = ("Year"), ylab = ("Revenue (100M USD)"))
    #adding female data points
    points(predomFYear, predomFRev / 100000000, xlim = c(startYear, endYear), pch = 16, col = "lightpink")
    
    
  })
  
})
