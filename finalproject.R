library(dplyr)

mainData <- read.csv("mainData.csv", stringsAsFactors = FALSE)

charData <- select(mainData, title, imdb_character_name, words, gender)
write.csv(charData, file = "charData.csv")

testData <- filter(charData, title == "Toy Story")
write.csv(testData, file = "charTestData.csv")
