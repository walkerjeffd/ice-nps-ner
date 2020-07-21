library(tidyverse)
library(sf)
library(jsonlite)

npsunits <- readRDS("rds/npsunits.rds")

npsunits %>%
  as_tibble() %>%
  select(id = UNIT_CODE, label = UNIT_NAME) %>%
  arrange(label) %>%
  write_json(file.path("json", "npsunits.json"))

npsunits %>%
  tail(2) %>%
  select(id = UNIT_CODE, label = UNIT_NAME) %>%
  st_write("../../data/npsunits/npsunits.geojson", driver = "GeoJSON", layer_options = list('COORDINATE_PRECISION=7', 'ID_FIELD=id'), append = FALSE)
