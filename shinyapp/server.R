library(R.utils)
library(ggplot2)
library(dplyr)
library(plotly)
library(shiny)
library(stringr)

# A file needed to compile the analysis on ratings
source("ratings_data.R")

# Dataset for individual movie analysis
charData <- read.csv("charData.csv")
fillColors <- c("f" = "lightpink", "m" = "lightblue1")

my_server <- function(input, output, session) {
  # Dataset for revenue analysis
  dataR <- read.csv(file = "rev.csv", sep = ",", stringsAsFactors = TRUE)

  updateSelectizeInput(session, "movie", choices = charData$title, server = TRUE)
  # Dataset for yearly analysis
  data <- read.csv("yearly.csv", stringsAsFactors = FALSE)

  # This functions displays the population pyramid chart that shows the gender disparity
  # in the number of words said between male and female. It also ranks the movies
  # by top 15 IMDB and top 15 revenue.
  output$plot <- renderPlotly({
    if (is.null(input$Year)) {
      return()
    }
    year_data <- filter(data, Year == input$Year)
    if (input$Rankings == "IMDB" && nrow(year_data) > 15) {
      year_data <- year_data %>%
        arrange(desc(IMDB)) %>%
        slice(1:30)
    } else if (input$Rankings == "Revenue" && nrow(year_data) > 15) {
      year_data <- year_data %>%
        arrange(desc(Revenue)) %>%
        slice(1:30)
    } else if (input$Rankings == "Revenue" && nrow(year_data) < 15) {
      length <- nrow(year_data)
      year_data <- year_data %>%
        arrange(desc(Revenue)) %>%
        slice(1:length)
    } else if (input$Rankings == "IMDB" && nrow(year_data) < 15) {
      length <- nrow(year_data)
      year_data <- year_data %>%
        arrange(desc(Revenue)) %>%
        slice(1:length)
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

  # The following function inputs text information about the dataset including how
  # many female-led movies were there, how many were in the top 15 in IMDB and how many
  # were in the top 15 in revenue. It also highlights the movie with the largest gender
  # disparity in that year.
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

  # This function outputs a barchart that shows the number of words said by characters in the film
  # and then color codes them by gender. The data is arranged in ascending order.
  output$charwords <- renderPlotly({
    charData %>%
      mutate(Character_Name = str_to_title(imdb_character_name)) %>%
      filter(title == input$movie) %>%
      ggplot(aes(x = reorder(Character_Name, -words), y = words, fill = gender)) +
      geom_bar(stat = "identity", color = "black") +
      scale_fill_manual(values = fillColors) +
      labs(x = "Characters", y = "Number of Words Spoken", title = paste0("Characters in ", input$movie)) +
      theme_bw() + theme(
        panel.border = element_blank(), panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(), axis.line = element_line(colour = "black")
      ) +
      theme(axis.text.x = element_text(angle = 90, hjust = 1)) # changes angle of x axis labels
  })

  # The function outputs a summary of the data, including how many characters of each gender
  # and how many words all the male characters say and how many words all the females characters say.
  # The percentage of words said by male characters and female character is also outputed
  output$sumStatement <- renderText({
    charData2 <- charData %>%
      mutate(Character_Name = str_to_title(imdb_character_name)) %>%
      filter(title == input$movie)
    totalChar <- nrow(charData2)
    maleDF <- charData2 %>%
      filter(gender == "m")
    maleChar <- nrow(maleDF)
    mWordsTotal <- sum(maleDF$words)
    mMaxWord <- max(maleDF$words)
    femaleDF <- charData2 %>%
      filter(gender == "f")
    femaleChar <- nrow(femaleDF)
    fWordsTotal <- sum(femaleDF$words)
    totalWords <- sum(charData2$words)
    return(paste0(
      "In ", input$movie, " there are ", totalChar, " characters and they say ", totalWords, " qords in total. There are ",
      femaleChar, " female characters that say a total of ", fWordsTotal, " words. There are ",
      maleChar, " male characters that say a total of ", mWordsTotal, " words. Male characters
      make-up ", round(maleChar / totalChar * 100, 1), "% of the cast and say ",
      round(mWordsTotal / totalWords * 100, 1), "% of the words. 
      Female characters make-up ", round(femaleChar / totalChar * 100, 1), "% and say ",
      round(fWordsTotal / totalWords * 100, 1), "% of the words."
    ))
  })

  # This function outputs a boxplot that compares the range of revenue for male-led movies
  # and the range for female-led movies
  output$boxPlot <- renderPlotly({
    if (is.null(input$RevYear)) {
      return()
    }
    colours <- c("Female" = "lightpink", "Male" = "lightblue1")
    rev_year <- filter(dataR, Year == input$RevYear)
    ggplot(rev_year, aes(x = Gender, y = Revenue, fill = Gender)) +
      geom_boxplot() + ylim(0, 3) + scale_fill_manual(values = colours) +
      theme_bw() +
      theme(
        panel.border = element_blank(), panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(), axis.line = element_line(colour = "black")
      ) +
      ggtitle(paste0("Revenue Generated by Male-Led Movies Versus Female-Led Movies in ", input$RevYear))
  })

  # The following function outputs the barcharts that compare the IMDB rankings
  # between male-led and female-led movies by the decade.
  num_decades <- reactive({
    length(input$checked_decade)
  })
  output$mybargraph <- renderPlotly({
    if (num_decades() == 9) {
      specific_decades <- decades
      ggplot(specific_decades, aes(x = decade, y = avg, fill = gender)) +
        geom_bar(position = position_dodge2(preserve = "single"), stat = "identity") +
        scale_fill_manual(
          name = "Lead Role Gender", values = c("lightpink", "lightblue2"),
          labels = c("Female", "Male")
        ) +
        labs(
          title = "IMDB Movie Ratings",
          subtitle = "Average Rating per Decade",
          caption = "Source", x = "Decade",
          y = "Average IMDB Rating"
        ) + theme(panel.grid.minor = element_blank())
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
        scale_fill_manual(
          name = "Lead Role Gender", values = c("lightpink", "lightblue2"),
          labels = c("Female", "Male")
        ) +
        labs(
          title = "IMDB Movie Ratings",
          subtitle = "Average Rating per Decade",
          caption = "Source", x = "Decade",
          y = "Average IMDB Rating"
        ) + theme(panel.grid.minor = element_blank())
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
        scale_fill_manual(
          name = "Lead Role Gender", values = c("lightpink", "lightblue2"),
          labels = c("Female", "Male")
        ) +
        labs(
          title = "IMDB Movie Ratings",
          subtitle = "Average Rating per Decade",
          caption = "Source", x = "Decade",
          y = "Average IMDB Rating"
        ) + theme(panel.grid.minor = element_blank())
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
        scale_fill_manual(
          name = "Lead Role Gender", values = c("lightpink", "lightblue2"),
          labels = c("Female", "Male")
        ) +
        labs(
          title = "IMDB Movie Ratings",
          subtitle = "Average Rating per Decade",
          caption = "Source", x = "Decade",
          y = "Average IMDB Rating"
        ) + theme(panel.grid.minor = element_blank())
    } else if (num_decades() == 5) {
      specific_decades <- decades %>%
        filter(decade == input$checked_decade[1] |
          decade == input$checked_decade[2] |
          decade == input$checked_decade[3] |
          decade == input$checked_decade[4] |
          decade == input$checked_decade[5])
      ggplot(specific_decades, aes(x = decade, y = avg, fill = gender)) +
        geom_bar(position = position_dodge2(preserve = "single"), stat = "identity") +
        scale_fill_manual(
          name = "Lead Role Gender", values = c("lightpink", "lightblue2"),
          labels = c("Female", "Male")
        ) +
        labs(
          title = "IMDB Movie Ratings",
          subtitle = "Average Rating per Decade",
          caption = "Source", x = "Decade",
          y = "Average IMDB Rating"
        ) + theme(panel.grid.minor = element_blank())
    } else if (num_decades() == 4) {
      specific_decades <- decades %>%
        filter(decade == input$checked_decade[1] |
          decade == input$checked_decade[2] |
          decade == input$checked_decade[3] |
          decade == input$checked_decade[4])
      ggplot(specific_decades, aes(x = decade, y = avg, fill = gender)) +
        geom_bar(position = position_dodge2(preserve = "single"), stat = "identity") +
        scale_fill_manual(
          name = "Lead Role Gender", values = c("lightpink", "lightblue2"),
          labels = c("Female", "Male")
        ) +
        labs(
          title = "IMDB Movie Ratings",
          subtitle = "Average Rating per Decade",
          caption = "Source", x = "Decade",
          y = "Average IMDB Rating"
        ) + theme(panel.grid.minor = element_blank())
    } else if (num_decades() == 3) {
      specific_decades <- decades %>%
        filter(decade == input$checked_decade[1] |
          decade == input$checked_decade[2] |
          decade == input$checked_decade[3])
      ggplot(specific_decades, aes(x = decade, y = avg, fill = gender)) +
        geom_bar(position = position_dodge2(preserve = "single"), stat = "identity") +
        scale_fill_manual(
          name = "Lead Role Gender", values = c("lightpink", "lightblue2"),
          labels = c("Female", "Male")
        ) +
        labs(
          title = "IMDB Movie Ratings",
          subtitle = "Average Rating per Decade",
          caption = "Source", x = "Decade",
          y = "Average IMDB Rating"
        ) + theme(panel.grid.minor = element_blank())
    } else if (num_decades() == 2) {
      specific_decades <- decades %>%
        filter(decade == input$checked_decade[1] |
          decade == input$checked_decade[2])
      ggplot(specific_decades, aes(x = decade, y = avg, fill = gender)) +
        geom_bar(position = position_dodge2(preserve = "single"), stat = "identity") +
        scale_fill_manual(
          name = "Lead Role Gender", values = c("lightpink", "lightblue2"),
          labels = c("Female", "Male")
        ) +
        labs(
          title = "IMDB Movie Ratings",
          subtitle = "Average Rating per Decade",
          caption = "Source", x = "Decade",
          y = "Average IMDB Rating"
        ) + theme(panel.grid.minor = element_blank())
    } else if (num_decades() == 1) {
      specific_decades <- decades %>%
        filter(decade == input$checked_decade[1])
      ggplot(specific_decades, aes(x = decade, y = avg, fill = gender)) +
        geom_bar(position = position_dodge2(preserve = "single"), stat = "identity") +
        scale_fill_manual(
          name = "Lead Role Gender", values = c("lightpink", "lightblue2"),
          labels = c("Female", "Male")
        ) +
        labs(
          title = "IMDB Movie Ratings",
          subtitle = "Average Rating per Decade",
          caption = "Source", x = "Decade",
          y = "Average IMDB Rating"
        ) + theme(panel.grid.minor = element_blank())
    }
  })
}
shinyServer(my_server)