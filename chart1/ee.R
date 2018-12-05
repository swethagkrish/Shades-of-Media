library(shiny)
library(ggplot2)
library(dplyr)

dataR <- read.csv(file = "rev.csv" , sep = ",", stringsAsFactors = TRUE)

rev_year <- filter(dataR,Year == 1999)
ggplot(rev_year, aes(x = Gender, y = Revenue)) +
 geom_boxplot() + theme_bw()