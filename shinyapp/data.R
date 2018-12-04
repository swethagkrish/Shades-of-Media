data <- read.csv("mainData.csv", stringsAsFactors = FALSE)
gender_list <- data.frame(matrix(ncol = 6, nrow = 0))
x <- c("Movie","Year","IMDB", "Gender", "Words", "Revenue")
colnames(gender_list) <- x
movies_list <- unique(as.matrix(data$title))
for(movie in movies_list){
  movie_Data <- filter(data, data$title == movie)
  males<- filter(movie_Data, movie_Data$gender == "m")
  male_sum <- sum(males$words)
  females <- filter(movie_Data, movie_Data$gender == "f")
  female_sum <- -1 *sum(females$word)
  year <- unique(movie_Data$year)
  imdb <- unique(movie_Data$vote_average)
  revenue <- unique(movie_Data$revenue)
  gender_list <- rbind(gender_list, data.frame(Movie = movie, Year = year, IMDB = imdb,
                                               Gender = "Male", Words = male_sum, 
                                               Revenue = revenue))
  gender_list <- rbind(gender_list, data.frame(Movie = movie, Year = year, IMDB = imdb,
                                               Gender= "Female", Words = female_sum, 
                                               Revenue = revenue))
}
write.csv(gender_list, file = "yearly.csv", row.names = FALSE)