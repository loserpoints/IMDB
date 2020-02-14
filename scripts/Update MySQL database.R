library(RMariaDB)
library(tidyverse)

ml_movies <- read.csv("data/ml-25m/movies.csv", stringsAsFactors = F)

ml_tags <- read.csv("data/ml-25m/tags.csv", stringsAsFactors = F)

ml_links <- read.csv("data/ml-25m/links.csv")

ml_ratings <- read.csv("data/ml-25m/ratings.csv")

ml_tags <- ml_tags %>%
  
  left_join(., ml_links)


movies_db <- 
  dbConnect(
    MariaDB(), 
    user = "root", 
    password = password, 
    dbname = "movies", 
    host = "localhost")


create_table_ml_titles <- "CREATE TABLE movie_lens_titles (
  
  movieId BIGINT,

  title TEXT,

  genres TEXT);"

results <- dbSendQuery(movies_db, create_table)

dbClearResult(results)

dbWriteTable(movies_db, value = ml_movies, row.names = FALSE, name = "movie_lens_titles", append = TRUE )





create_table_ml_links <- "CREATE TABLE movie_lens_links (
  
  movieId BIGINT,

  imdbId BIGINT,

  tmdbId BIGINT);"

results <- dbSendQuery(movies_db, create_table_ml_links)

dbClearResult(results)

dbWriteTable(movies_db, value = ml_links, row.names = FALSE, name = "movie_lens_links", append = TRUE )






create_table_ml_tags <- "CREATE TABLE movie_lens_tags (
  
  userId BIGINT,

  movieId BIGINT,
  
  tag TEXT,
  
  timestamp BIGINT,
  
  imdbId BIGINT,

  tmdbId BIGINT);"

results <- dbSendQuery(movies_db, create_table_ml_tags)

dbClearResult(results)

dbWriteTable(movies_db, value = ml_tags, row.names = FALSE, name = "movie_lens_tags", append = TRUE )








create_table_ml_ratings <- "CREATE TABLE movie_lens_ratings (
  
  userId BIGINT,

  movieId BIGINT,
  
  rating DECIMAL(2, 1),
  
  timestamp BIGINT);"

results <- dbSendQuery(movies_db, create_table_ml_ratings)

dbClearResult(results)

dbWriteTable(movies_db, value = ml_ratings, row.names = FALSE, name = "movie_lens_ratings", append = TRUE )







create_table_imdb_titles <- "CREATE TABLE imdb_titles (
  
  tconst TEXT,

  averageRating DECIMAL(2, 1),
  
  numVotes BIGINT);"

results <- dbSendQuery(movies_db, create_table_imdb_titles)

dbClearResult(results)

dbWriteTable(movies_db, value = titles, row.names = FALSE, name = "imdb_titles", append = TRUE )



create_table_imdb_crew <- "CREATE TABLE imdb_crew (
  
  tconst TEXT,

  directors TEXT,
  
  writers TEXT);"

results <- dbSendQuery(movies_db, create_table_imdb_crew)

dbClearResult(results)

dbWriteTable(movies_db, value = crew, row.names = FALSE, name = "imdb_crew", append = TRUE )


names_sql <- names %>% slice(-4227238)

dbWriteTable(movies_db, value = names_sql, row.names = FALSE, name = "imdb_names", append = TRUE )

max(nchar(names$nconst))

write.csv(names_sql, file = "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/names_sql.csv", row.names = F)

names_sql <- names %>%
  
  mutate(nchar = nchar(primaryName)) %>%
  
  filter(nchar != max(nchar)) %>%
  
  select(-nchar)









create_table_imdb_basics <- "CREATE TABLE imdb_basics (
  
  tconst TEXT,
  
  titleType TEXT,
  
  primaryTitle TEXT,
  
  originalTitle TEXT,
  
  isAdult TEXT,
  
  startYear TEXT,
  
  endYear TEXT,

  runtimeMinutes TEXT,
  
  genres TEXT);"

results <- dbSendQuery(movies_db, create_table_imdb_basics)

dbRemoveTable(movies_db, "imdb_basics")

dbClearResult(results)

dbWriteTable(movies_db, value = basics, row.names = FALSE, name = "imdb_basics", append = TRUE )


























horror_query <- 
  
  "
  SELECT * FROM imdb_basics 
	
	INNER JOIN imdb_titles
	
	ON imdb_basics.tconst = imdb_titles.tconst
    AND numVotes > 500
	
	WHERE genres LIKE '%Horror%'
    AND genres NOT LIKE '%Documentary%'
    AND titleType = 'movie'
    AND runtimeMinutes > 75;
    
    "


horror_db <- dbSendQuery(movies_db, horror_query)

horror <- dbFetch(horror_db)

dbClearResult(horror_db)
