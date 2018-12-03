library(shiny)
library(plotly)
library(dplyr)
library(stringr)

charData <- read.csv("../charData.csv") #For the app need to switch data set and put ../
fillColors <- c("f" = "lightpink", "m" = "lightblue1")

shinyServer(function(input, output, session) {
   updateSelectizeInput(session, 'movie', choices = charData$title, server = TRUE)
  
   output$charwords <- renderPlotly({
     charData %>%
       mutate(Character_Name = str_to_title(imdb_character_name))%>%
       filter(title == input$movie)%>%
       ggplot(aes(x=Character_Name, y=words, fill=gender)) +
       geom_bar(stat = "identity", color="black")+
       scale_fill_manual(values = fillColors)+
       labs(x = "Characters", y = "Number of Words Spoken")+
       theme(axis.text.x = element_text(angle = 90, hjust = 1)) #changes angle of x axis labels
   })
   
  
})
