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
       arrange(desc(words))%>%
       ggplot(aes(x=reorder(Character_Name, -words), y=words, fill=gender)) +
       geom_bar(stat = "identity", color="black")+
       scale_fill_manual(values = fillColors)+
       labs(x = "Characters", y = "Number of Words Spoken", title = paste0("Characters in ", input$movie))+
       theme_bw() + theme(
         panel.border = element_blank(), panel.grid.major = element_blank(),
         panel.grid.minor = element_blank(), axis.line = element_line(colour = "black")) +
       theme(axis.text.x = element_text(angle = 90, hjust = 1)) #changes angle of x axis labels
     
   })
   
   output$sumStatement <- renderText({
     charData %>%
       mutate(Character_Name = str_to_title(imdb_character_name))%>%
       filter(title == input$movie)
     totalChar <- count(charData, "Character_Name")
     maleChar <- charData %>%
       filter(gender == "m")%>%
       nrow()
     mWordsTotal <- charData %>%
       filter(gender == "m")%>%
       sum(words)
     mMaxWord <- charData %>%
       filter(gender == "m")%>%
       max(words)
     mMaxChar <- charData %>%
       filter(gender == "m")%>%
       filter(words== max(words))%>%
       charName
     femaleChar <- charData %>%
       filter(gender == "f")%>%
       nrow()
     fWordsTotal <- charData %>%
       filter(gender == "f")%>%
       sum(words)
     fMaxWord <- charData %>%
       filter(gender == "f")%>%
       max(words)
     fMaxChar <- charData %>%
       filter(gender == "f")%>%
       filter(words== max(words))%>%
       charName
     totalWords <- sum(charData$words)
     paste0("In ", input$movie, "there are ", totalChar, "characters and ", totalWords, " spoken. There are ",
            femaleChar, "female characters that say a total of ", fWordsTotal, " words. ")
     
   })
  
})
