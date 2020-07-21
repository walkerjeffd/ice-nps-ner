# load catchments (centroids)

library(tidyverse)
library(sf)


config <- config::get()

con <- DBI::dbConnect(
  RPostgreSQL::PostgreSQL(),
  dbname = config$db$dbname,
  host = config$db$host,
  port = config$db$port,
  user = config$db$user,
  password = config$db$password
)

catch <- st_read(con, query = "select featureid, st_centroid(geom) from catchments;")

DBI::dbDisconnect(con)

saveRDS(catch, "rds/catchment-centroids.rds")
