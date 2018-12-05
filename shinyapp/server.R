library(R.utils)
library(ggplot2)
library(dplyr)
library(plotly)
library(shiny)
library(stringr)

source("../ratings_data.R")

charData <- read.csv("charData.csv") #For the app need to switch data set and put ../
fillColors <- c("f" = "lightpink", "m" = "lightblue1")

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

my_server <- function(input, output, session) {
  updateSelectizeInput(session, 'movie', choices = charData$title, server = TRUE)
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
      scale_y_continuous(breaks = seq(-60000, 60000, 20000), labels = abs(seq(-60000, 60000, 20000)), limits = c(-60000, 60000)) +
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
  

  output$charwords <- renderPlotly({
    charData %>%
      mutate(Character_Name = str_to_title(imdb_character_name))%>%
      filter(title == input$movie)%>%
      ggplot(aes(x= reorder(Character_Name, -words), y=words, fill=gender)) +
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
  
  date_range_male <- reactive({
    male_dates <- male_lead %>%
      filter(release_date >= input$date[1]) %>%
      filter(release_date <= input$date[2])
  })
  
  date_range_female <- reactive({
    female_dates <- female_lead %>%
      filter(release_date >= input$date[1]) %>%
      filter(release_date <= input$date[2])
  })
  
  num_decades <- reactive({length(input$checked_decade)})
  output$mybargraph = renderPlotly({
    if (num_decades() == 9) {
      specific_decades <- decades 
      ggplot(specific_decades, aes(x = decade, y = avg, fill = gender)) + 
        geom_bar(position = position_dodge2(preserve = "single"), stat = "identity") + 
        scale_fill_manual(name = "Lead Role Gender", values = c("lightpink", "lightblue2"), 
                          labels = c("Female", "Male")) +
        labs(title = "IMDB Movie Ratings", 
             subtitle = "Average Rating per Decade", 
             caption = "Source", x = "Decade",
             y = "Average IMDB Rating") + theme(panel.grid.minor = element_blank())
    } else if (num_decades() == 8) {
      specific_decades <- decades %>%
        filter(decade == input$checked_decade[1] | 
                 decade == input$checked_decade[2] | 
                 decade == input$checked_decade[3] | 
                 decade == input$checked_decade[4] | 
                 decade == input$checked_decade[5] | 
                 decade == input$checked_decade[6] | 
                 decade == input$checked_decade[7] | 
                 decade == input$checked_decade[8])
      ggplot(specific_decades, aes(x = decade, y = avg, fill = gender)) + 
        geom_bar(position = position_dodge2(preserve = "single"), stat = "identity") + 
        scale_fill_manual(name = "Lead Role Gender", values = c("lightpink", "lightblue2"), 
                          labels = c("Female", "Male")) +
        labs(title = "IMDB Movie Ratings", 
             subtitle = "Average Rating per Decade", 
             caption = "Source", x = "Decade",
             y = "Average IMDB Rating") + theme(panel.grid.minor = element_blank())
    } else if (num_decades() == 7) {
      specific_decades <- decades %>%
        filter(decade == input$checked_decade[1] | 
                 decade == input$checked_decade[2] | 
                 decade == input$checked_decade[3] | 
                 decade == input$checked_decade[4] | 
                 decade == input$checked_decade[5] | 
                 decade == input$checked_decade[6] | 
                 decade == input$checked_decade[7])
      ggplot(specific_decades, aes(x = decade, y = avg, fill = gender)) + 
        geom_bar(position = position_dodge2(preserve = "single"), stat = "identity") + 
        scale_fill_manual(name = "Lead Role Gender", values = c("lightpink", "lightblue2"), 
                          labels = c("Female", "Male")) +
        labs(title = "IMDB Movie Ratings", 
             subtitle = "Average Rating per Decade", 
             caption = "Source", x = "Decade",
             y = "Average IMDB Rating") + theme(panel.grid.minor = element_blank())
    } else if (num_decades() == 6) {
      specific_decades <- decades %>%
        filter(decade == input$checked_decade[1] | 
                 decade == input$checked_decade[2] | 
                 decade == input$checked_decade[3] | 
                 decade == input$checked_decade[4] | 
                 decade == input$checked_decade[5] | 
                 decade == input$checked_decade[6])
      ggplot(specific_decades, aes(x = decade, y = avg, fill = gender)) + 
        geom_bar(position = position_dodge2(preserve = "single"), stat = "identity") + 
        scale_fill_manual(name = "Lead Role Gender", values = c("lightpink", "lightblue2"), 
                          labels = c("Female", "Male")) +
        labs(title = "IMDB Movie Ratings", 
             subtitle = "Average Rating per Decade", 
             caption = "Source", x = "Decade",
             y = "Average IMDB Rating") + theme(panel.grid.minor = element_blank())
    } else if (num_decades() == 5) {
      specific_decades <- decades %>%
        filter(decade == input$checked_decade[1] | 
                 decade == input$checked_decade[2] | 
                 decade == input$checked_decade[3] | 
                 decade == input$checked_decade[4] | 
                 decade == input$checked_decade[5])
      ggplot(specific_decades, aes(x = decade, y = avg, fill = gender)) + 
        geom_bar(position = position_dodge2(preserve = "single"), stat = "identity") + 
        scale_fill_manual(name = "Lead Role Gender", values = c("lightpink", "lightblue2"), 
                          labels = c("Female", "Male")) +
        labs(title = "IMDB Movie Ratings", 
             subtitle = "Average Rating per Decade", 
             caption = "Source", x = "Decade",
             y = "Average IMDB Rating") + theme(panel.grid.minor = element_blank())
    } else if (num_decades() == 4) {
      specific_decades <- decades %>%
        filter(decade == input$checked_decade[1] | 
                 decade == input$checked_decade[2] | 
                 decade == input$checked_decade[3] | 
                 decade == input$checked_decade[4])
      ggplot(specific_decades, aes(x = decade, y = avg, fill = gender)) + 
        geom_bar(position = position_dodge2(preserve = "single"), stat = "identity") + 
        scale_fill_manual(name = "Lead Role Gender", values = c("lightpink", "lightblue2"), 
                          labels = c("Female", "Male")) +
        labs(title = "IMDB Movie Ratings", 
             subtitle = "Average Rating per Decade", 
             caption = "Source", x = "Decade",
             y = "Average IMDB Rating") + theme(panel.grid.minor = element_blank())
    } else if (num_decades() == 3) {
      specific_decades <- decades %>%
        filter(decade == input$checked_decade[1] | 
                 decade == input$checked_decade[2] | 
                 decade == input$checked_decade[3])
      ggplot(specific_decades, aes(x = decade, y = avg, fill = gender)) + 
        geom_bar(position = position_dodge2(preserve = "single"), stat = "identity") + 
        scale_fill_manual(name = "Lead Role Gender", values = c("lightpink", "lightblue2"), 
                          labels = c("Female", "Male")) +
        labs(title = "IMDB Movie Ratings", 
             subtitle = "Average Rating per Decade", 
             caption = "Source", x = "Decade",
             y = "Average IMDB Rating") + theme(panel.grid.minor = element_blank())
    } else if (num_decades() == 2) {
      specific_decades <- decades %>%
        filter(decade == input$checked_decade[1] | 
                 decade == input$checked_decade[2])
      ggplot(specific_decades, aes(x = decade, y = avg, fill = gender)) + 
        geom_bar(position = position_dodge2(preserve = "single"), stat = "identity") + 
        scale_fill_manual(name = "Lead Role Gender", values = c("lightpink", "lightblue2"), 
                          labels = c("Female", "Male")) +
        labs(title = "IMDB Movie Ratings", 
             subtitle = "Average Rating per Decade", 
             caption = "Source", x = "Decade",
             y = "Average IMDB Rating") + theme(panel.grid.minor = element_blank())
    } else if (num_decades() == 1) {
      specific_decades <- decades %>%
        filter(decade == input$checked_decade[1])
      ggplot(specific_decades, aes(x = decade, y = avg, fill = gender)) + 
        geom_bar(position = position_dodge2(preserve = "single"), stat = "identity") + 
        scale_fill_manual(name = "Lead Role Gender", values = c("lightpink", "lightblue2"), 
                          labels = c("Female", "Male")) +
        labs(title = "IMDB Movie Ratings", 
             subtitle = "Average Rating per Decade", 
             caption = "Source", x = "Decade",
             y = "Average IMDB Rating") + theme(panel.grid.minor = element_blank())
    }
  })
}
shinyServer(my_server)