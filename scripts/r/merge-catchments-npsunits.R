# merge catchments with nps units

library(tidyverse)
library(sf)

npsunits <- readRDS("rds/npsunits.rds")

# 77 nps units total
npsunits$UNIT_CODE %>% unique %>% length

# use subset for development
# npsunit <- head(npsunit)


config <- config::get()

con <- DBI::dbConnect(
  RPostgreSQL::PostgreSQL(),
  dbname = "sheds",
  host = "trout.local",
  port = 5432,
  user = "jeff"
)

nps_catchments <- DBI::dbGetQuery(con, "select * from data.nps_catchments;")

DBI::dbDisconnect(con)

df <- as_tibble(nps_catchments)
# npsunits with no catchment

saveRDS(df, "rds/npsunit-catchments.rds")
