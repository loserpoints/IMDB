### load required packages

library(tidyverse)


### download files from imdb site

download.file("https://datasets.imdbws.com/title.ratings.tsv.gz", destfile = "data/imdb/title.ratings.tsv.gz")

download.file("https://datasets.imdbws.com/title.basics.tsv.gz", destfile = "data/imdb//title.basics.tsv.gz")

download.file("https://datasets.imdbws.com/title.crew.tsv.gz", destfile = "data/imdb//title.crew.tsv.gz")

download.file("https://datasets.imdbws.com/name.basics.tsv.gz", destfile = "data/imdb//name.basics.tsv.gz")


### download and unzip files from movie lens
download.file("http://files.grouplens.org/datasets/movielens/ml-25m.zip", destfile = "data/movielens/ml-25.zip")

unzip("data/movielens/ml-25.zip", exdir = "data/movielens")


### read downloadeded imdb tsv files

imdb_titles <- read.csv("data/imdb//title.ratings.tsv.gz", sep = "\t", stringsAsFactors = F)

imdb_basics <- read.csv("data/imdb//title.basics.tsv.gz", sep = "\t", stringsAsFactors = F)

imdb_crew <- read.csv("data/imdb//title.crew.tsv.gz", sep = "\t", stringsAsFactors = F)

imdb_names <- read.csv("data/imdb//name.basics.tsv.gz", sep = "\t", stringsAsFactors = F)


### read unzipped movielens csv files

ml_tags <- read.csv("data/movielens/tags.csv")