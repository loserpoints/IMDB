library(tidyverse)
library(ggthemes)
library(extrafont)
library(ggrepel)
library(scales)

loadfonts(device = "win")

titles <- read.csv("title.ratings.tsv.gz", sep = "\t", stringsAsFactors = F)

basics <- read.csv("title.basics.tsv.gz", sep = "\t", stringsAsFactors = F)

crew <- read.csv("title.crew.tsv.gz", sep = "\t", stringsAsFactors = F)

names <- read.csv("name.basics.tsv.gz", sep = "\t", stringsAsFactors = F)



horror <- basics %>%
  
  filter(grepl("Horror", genres),
         !grepl("Documentary", genres)) %>%
  
  left_join(., titles) %>%
  
  left_join(., crew) %>%
  
  mutate(runtimeMinutes = as.numeric(runtimeMinutes),
         startYear = as.numeric(startYear)) %>%
  
  filter(titleType == "movie",
         runtimeMinutes > 75,
         numVotes > 500)
  



years <- unique(horror$startYear)

df_list <- lapply(years, function(x) {
  
  df <- horror %>%
  
  filter(startYear < x + 2, 
         startYear > x -2) %>%
  
  arrange(numVotes) %>%
    
  mutate(vote_rank = row_number(),
         popularity = rescale(vote_rank, to = c(0, 5))) %>%
  
  filter(startYear == x)
  
})


horror_adj <- do.call(rbind, df_list) %>%
  
  arrange(averageRating) %>%
  
  mutate(rating_rank = row_number(),
         quality = rescale(rating_rank, to = c(0, 5)),
         adj_score = popularity + quality)

