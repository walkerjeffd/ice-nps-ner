# merge catchments with nps units

library(tidyverse)
library(sf)

npsunits <- readRDS("rds/npsunits.rds")

# 81 nps units total
npsunits$UNIT_CODE %>% unique %>% length
stopifnot(all(!duplicated(npsunits$UNIT_CODE)))

# use subset for development
# npsunit <- head(npsunit)


config <- config::get()

con <- DBI::dbConnect(
  RPostgreSQL::PostgreSQL(),
  dbname = config$db$dbname,
  host = config$db$host,
  port = config$db$port,
  user = config$db$user
)

nps_catchments <- DBI::dbGetQuery(con, "select * from data.nps_catchments;")

DBI::dbDisconnect(con)

df <- as_tibble(nps_catchments)
# npsunits with no catchment

saveRDS(df, "rds/npsunit-catchments.rds")
