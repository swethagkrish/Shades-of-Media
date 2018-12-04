
library(shiny)
library(ggplot2)
library(dplyr)

dataF <- read.csv(file = "../mainData.csv" , sep = ",", stringsAsFactors = TRUE)
dataF <- as.data.frame(dataF)


#dataF <- dataF %>% 
#  filter(revenue != 0)
#dataF <- na.omit(dataF)

predomF <- c()
predomM <- c()

# Sort out the imdb_ids of movies that are predominantly female and male
for (i in levels(dataF$imdb_id)) {
  data = subset(dataF, dataF$imdb_id == i)
  numFemales = count(data[data$gender == "f",])
  numMales = count(data[data$gender == "m",])
  if (numFemales > numMales) {
    predomF <- c(predomF, data[1,"revenue"])
  } else {
    predomM <- c(predomM, data[1,"revenue"])
  }
}



shinyServer(function(input, output) {
   
  output$distPlot <- renderPlot({
    plot(density(predomM))
    lines(density(predomF))

  })
  
})
