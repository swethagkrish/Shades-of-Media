library(R.utils)
library(ggplot2)
library(dplyr)
library(plotly)
library(shiny)
library(stringr)

charData <- read.csv("../charData.csv") #For the app need to switch data set and put ../
fillColors <- c("f" = "lightpink", "m" = "lightblue1")

my_server <- function(input, output) {
  data <- read.csv("yearly.csv", stringsAsFactors = FALSE)
  output$plot <- renderPlotly({
    if (is.null(input$Year)) {
      return()
    }
    year_data <- filter(data, Year == input$Year)
    if (nrow(year_data) > 15 && input$Rankings == "IMDB") {
      year_data <- year_data %>%
        arrange(desc(IMDB)) %>%
        slice(1:30)
    } else if (nrow(year_data) > 15 && input$Rankings == "Revenue") {
      year_data <- year_data %>%
        arrange(desc(Revenue)) %>%
        slice(1:30)
    }
    ggplot(data = year_data) +
      geom_bar(aes(Movie, Words, fill = Gender),
        subset(year_data, year_data$Gender == "Male"),
        stat = "identity"
      ) +
      geom_bar(aes(Movie, Words, fill = Gender),
        subset(year_data, year_data$Gender == "Female"),
        stat = "identity"
      ) +
      scale_y_continuous(breaks = seq(-60000, 60000, 10000), labels = abs(seq(-60000, 60000, 10000))) +
      labs(aes(x = "Movies", y = "Words")) + theme_bw() + theme(
        panel.border = element_blank(), panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(), axis.line = element_line(colour = "black"),
        axis.ticks.x = element_blank(), axis.ticks.y = element_blank(),
        axis.title.y = element_text(margin = margin(t = 0, r = 20, b = 0, l = 0))
      ) +
      ggtitle(paste0("Gender Representation in ", input$Year, " by ", input$Rankings, " Rankings")) +
      scale_fill_manual(values = c("lightpink", "lightblue")) + coord_flip()
  })
  output$summary <- renderText({
    if (is.null(input$Year)) {
      return()
    }
    year_data <- filter(data, Year == input$Year)
    male <- filter(year_data, Gender == "Male")
    male <- select(male, Words)
    female <- filter(year_data, Gender == "Female")
    movies <- select(female, Movie)
    revenue <- select(female, Revenue)
    imdb <- select(female, IMDB)
    female <- select(female, Words)
    movies <- bind_cols(movies, male, female, revenue, imdb)
    movies <- mutate(movies, difference = Words - (-1) * Words1)
    female_led <- nrow(filter(movies, difference < 0))
    f_led <- filter(movies, difference < 0)
    biggest_difference <- filter(movies, difference == max(abs(difference)))
    big_movie <- biggest_difference$Movie
    big_diff <- abs(biggest_difference$difference)
    imdb_data <- movies %>%
      arrange(desc(IMDB)) %>%
      slice(1:30)
    rev_data <- movies %>%
      arrange(desc(Revenue)) %>%
      slice(1:30)
    imdb_top <- sum(f_led$Movie %in% imdb_data$Movie, na.rm = TRUE)
    rev_top <- sum(f_led$Movie %in% rev_data$Movie, na.rm = TRUE)
    return(paste0(
      input$Year, " had ", female_led, " female-led movies overall. ",
      imdb_top, " of these movies were in the Top 15 (by IMDB) and ", rev_top,
      " movies were in the Top 15 (by revenue).", "The movie with the 
                  biggest gender disparity was ", big_movie, " with a difference of ",
      big_diff, " words between male and female characters"
    ))
  })
   updateSelectizeInput(session, 'movie', choices = charData$title, server = TRUE)
  
   output$charwords <- renderPlotly({
     charData %>%
       mutate(Character_Name = str_to_title(imdb_character_name))%>%
       filter(title == input$movie)%>%
       ggplot(aes(x=Character_Name, y=words, fill=gender)) +
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
}
shinyServer(my_server)
