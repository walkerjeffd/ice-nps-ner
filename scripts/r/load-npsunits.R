# load NPS park units shapefile

library(tidyverse)
library(sf)

nps <- st_read("~/Dropbox/SHEDS/nps-ner/gis/NER_NPS_Units/NER_NPS_Units.shp")

head(nps)

nps_wgs84 <- st_transform(nps, 4326)

saveRDS(nps_wgs84, "rds/npsunits.rds")
