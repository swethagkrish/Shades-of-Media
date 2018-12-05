data <- read.csv("mainData.csv", stringsAsFactors = FALSE)
gender_list <- data.frame(matrix(ncol = 4, nrow = 0))
x <- c("Movie","Year", "Gender", "Revenue")
colnames(gender_list) <- x
movies_list <- unique(as.matrix(data$title))
for(movie in movies_list){
  movie_Data <- filter(data, data$title == movie)
  males<- filter(movie_Data, movie_Data$gender == "m")
  male_sum <- sum(males$words)
  females <- filter(movie_Data, movie_Data$gender == "f")
  female_sum <- sum(females$word)
  gender <- "Male"
  year <- unique(movie_Data$year)
  if (male_sum < female_sum) { 
      gender <- "Female"
    }  
  revenue <- unique(movie_Data$revenue)
  revenue <- revenue / 1000000000
  gender_list <- rbind(gender_list, data.frame(Movie = movie, Year = year,
                                               Gender = gender, 
                                               Revenue = revenue))
}
write.csv(gender_list, file = "rev.csv", row.names = FALSE)