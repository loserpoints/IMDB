### load required packages

library(tidyverse)
library(scales)



### select only the horror genre and filter for full length movies

horror <- imdb_basics %>%
  
  filter(grepl("Horror", genres),
         !grepl("Documentary", genres)) %>%
  
  left_join(., imdb_titles) %>%
  
  left_join(., imdb_crew) %>%
  
  mutate(runtimeMinutes = as.numeric(runtimeMinutes),
         startYear = as.numeric(startYear)) %>%
  
  filter(titleType == "movie",
         runtimeMinutes > 75,
         numVotes > 500)


### create the scaled popularity and quality metrics based on number of reviews and average rating

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

