### load required packages

library(RMariaDB)
library(tidyverse)


### update imdb tables in mysql

update_imdb()


### update movie lens data in mysql

update_ml()


### define function to update the imdb tables in mysql

update_imdb <- function(x) {
  
  ## connect to movies database
  
  movies_db <-
    dbConnect(
      MariaDB(),
      user = "root",
      password = password,
      dbname = "movies",
      host = "localhost"
    )
  
  
  ## update titles table
  
  dbWriteTable(
    movies_db,
    value = imdb_titles,
    row.names = FALSE,
    name = "imdb_titles",
    overwrite = TRUE
  )
  
  ## update basics table
  
  dbWriteTable(
    movies_db,
    value = imdb_basics,
    row.names = FALSE,
    name = "imdb_basics",
    overwrite = TRUE
  )
  
  ## update crew table
  
  dbWriteTable(
    movies_db,
    value = imdb_crew,
    row.names = FALSE,
    name = "imdb_crew",
    overwrite = TRUE
  )
  
  ## update names table
  
  names_sql <- imdb_names %>%
    
    mutate(nchar = nchar(primaryName)) %>%
    
    filter(nchar != max(nchar)) %>%
    
    select(-nchar)
  
  dbWriteTable(
    movies_db,
    value = names_sql,
    row.names = FALSE,
    name = "imdb_names",
    overwrite = TRUE
  )
  
}
  

### define function to update movie lens data in mysql

update_ml <- function(x) {
  
  ## connect to movies database
  
  movies_db <-
    dbConnect(
      MariaDB(),
      user = "root",
      password = password,
      dbname = "movies",
      host = "localhost"
    )
  
  
  ## update titles table
  
  dbWriteTable(
    movies_db,
    value = ml_movies,
    row.names = FALSE,
    name = "movie_lens_titles",
    overwrite = TRUE
  )
  
  ## update tags table
  
  dbWriteTable(
    movies_db,
    value = ml_tags,
    row.names = FALSE,
    name = "movie_lens_tags",
    overwrite = TRUE
  )
  
  ## updateratings table
  
  dbWriteTable(
    movies_db,
    value = ml_ratings,
    row.names = FALSE,
    name = "movie_lens_ratings",
    overwrite = TRUE
  )
  
  ## update links table
  
  dbWriteTable(
    movies_db,
    value = ml_links,
    row.names = FALSE,
    name = "movie_lens_links",
    overwrite = TRUE
  )
  
}
