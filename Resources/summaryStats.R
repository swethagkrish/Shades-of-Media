library(dplyr)
library(gtools)
is.data.frame(combo)
is.data.frame(movies)

mergedData <- left_join(movies, combo)
mergedData <- na.omit(mergedData)

femalesOnly <- 