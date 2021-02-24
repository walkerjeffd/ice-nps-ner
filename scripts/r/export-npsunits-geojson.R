library(tidyverse)
library(sf)
library(jsonlite)

npsunits <- readRDS("rds/npsunits.rds")
nps_catchments <- readRDS("rds/npsunit-catchments.rds")
df_all <- readRDS("rds/dataset.rds")

df <- nps_catchments %>%
  left_join(df_all, by = c("featureid" = "id"))

featureid_nodata <- df %>%
  filter(is.na(cold)) %>%
  pull(featureid)

df_nps_count <- df %>%
  select(-starts_with("huc"), -state) %>%
  mutate(nodata = featureid %in% featureid_nodata) %>%
  group_by(unit_code) %>%
  summarize(
    n = n(),
    n_nodata = sum(nodata),
    .groups = "drop"
  )

df_nps_area <- df %>%
  select(-starts_with("huc"), -state) %>%
  pivot_longer(cols = -c(unit_code, featureid, area_km2)) %>%
  mutate(area_km2 = if_else(is.na(value), NA_real_, area_km2)) %>%
  group_by(unit_code, name) %>%
  summarise(
    value = sum(area_km2 * value, na.rm = TRUE) / sum(area_km2, na.rm = TRUE),
    .groups = "drop"
  ) %>%
  pivot_wider()

df_nps <- df_nps_area %>%
  left_join(df_nps_count, by = "unit_code")

npsunits %>%
  as_tibble() %>%
  select(id = UNIT_CODE, label = UNIT_NAME) %>%
  arrange(label) %>%
  write_json(file.path("json", "npsunits.json"))

npsunits %>%
  # tail(2) %>%
  select(id = UNIT_CODE, label = UNIT_NAME) %>%
  left_join(df_nps, by = c("id" = "unit_code")) %>%
  arrange(label) %>%
  st_write("../../data/npsunits/npsunits.json", driver = "GeoJSON", layer_options = list('COORDINATE_PRECISION=7', 'ID_FIELD=id'), append = FALSE)
