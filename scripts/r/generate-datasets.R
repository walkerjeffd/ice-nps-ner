# generate ICE input datasets

cat("generate-datasets: starting\n")

suppressPackageStartupMessages(library(tidyverse))

config <- config::get()

con <- DBI::dbConnect(
  RPostgreSQL::PostgreSQL(),
  dbname = config$db$dbname,
  host = config$db$host,
  port = config$db$port,
  user = config$db$user,
  password = config$db$password
)

# covariates --------------------------------------------------------------

cat("fetching covariates...")
# local
df_cov_local <- tbl(con, "covariates") %>%
  select(featureid, zone, riparian_distance_ft, variable, value) %>%
  filter(
    variable %in% c("AreaSqKM", "elevation", "forest", "agriculture", "jun_prcp_mm", "jul_prcp_mm", "aug_prcp_mm"),
    zone == "local",
    is.null(riparian_distance_ft)
  ) %>%
  collect() %>%
  select(-zone, -riparian_distance_ft) %>%
  spread(variable, value) %>%
  mutate(
    summer_prcp_mm = (jun_prcp_mm + jul_prcp_mm + aug_prcp_mm) / 3
  ) %>%
  select(-jun_prcp_mm, -jul_prcp_mm, -aug_prcp_mm) %>%
  rename(area_km2 = AreaSqKM) %>%
  mutate(
    forest = forest / 100,
    agriculture = agriculture / 100
  )

# upstream
df_cov_upstream <- tbl(con, "covariates") %>%
  select(featureid, zone, riparian_distance_ft, variable, value) %>%
  filter(
    variable %in% c("AreaSqKM"),
    zone == "upstream",
    is.null(riparian_distance_ft)
  ) %>%
  collect() %>%
  select(-zone, -riparian_distance_ft) %>%
  spread(variable, value) %>%
  rename(upstream_area_km2 = AreaSqKM)

# merge
df_cov <- full_join(df_cov_local, df_cov_upstream, by = "featureid")
cat("done\n")

# temp-model --------------------------------------------------------------

COLD_REFUGIA_THRESHOLD <- 1 # max no. of days < 22 degC

cat("fetching temp-model predictions...")
df_temp_db <- tbl(con, "temp_model") %>%
  select(featureid, version, variable, value) %>%
  filter(
    version == !!config$`temp-model`$version,
    variable %in% c("mean_summer_temp", "mean_summer_temp_air2", "mean_summer_temp_air4", "mean_summer_temp_air6", "n_day_temp_gt_22", "n_day_temp_gt_22_air2", "n_day_temp_gt_22_air4", "n_day_temp_gt_22_air6")
  ) %>%
  collect() %>%
  select(-version) %>%
  spread(variable, value)

df_temp_db %>%
  select(starts_with("n_day_temp")) %>%
  pivot_longer(cols = everything()) %>%
  ggplot(aes(value)) +
  geom_histogram() +
  xlim(0, 20) +
  facet_wrap(vars(name))

df_temp <- df_temp_db %>%
  mutate(
    cold = n_day_temp_gt_22 < COLD_REFUGIA_THRESHOLD,
    cold_air2 = n_day_temp_gt_22_air2 < COLD_REFUGIA_THRESHOLD,
    cold_air4 = n_day_temp_gt_22_air4 < COLD_REFUGIA_THRESHOLD,
    cold_air6 = n_day_temp_gt_22_air6 < COLD_REFUGIA_THRESHOLD
  )

cat("done\n")

# bto-model ---------------------------------------------------------------

cat("fetching bto-model predictions...")
df_bto <- tbl(con, "bto_model") %>%
  filter(
    version == !!config$`bto-model`$version,
    variable %in% c("occ_current", "occ_air_2", "occ_air_4", "occ_air_6", "max_air_occ30", "max_air_occ50", "max_air_occ70")
  ) %>%
  collect() %>%
  select(-version) %>%
  spread(variable, value)
cat("done\n")

# state -------------------------------------------------------------------

cat("fetching states...")
df_state <- tbl(con, "catchment_state") %>%
  select(featureid, state = stusps) %>%
  collect()
cat("done\n")

# huc ---------------------------------------------------------------------

cat("fetching hucs...")
df_huc <- tbl(con, "catchment_huc12") %>%
  select(featureid, huc12) %>%
  collect() %>%
  mutate(
    huc6 = str_sub(huc12, 1, 6),
    huc8 = str_sub(huc12, 1, 8),
    huc10 = str_sub(huc12, 1, 10)
  )
cat("done\n")

# merge -------------------------------------------------------------------

cat("merging datasets...")
df <- df_huc %>%
  full_join(df_state, by = "featureid") %>%
  full_join(df_cov, by = "featureid") %>%
  full_join(df_temp, by = "featureid") %>%
  full_join(df_bto, by = "featureid") %>%
  filter(
    state %in% c("ME", "NH","VT", "MA", "RI", "CT", "NY", "NJ", "PA", "DE", "MD", "DC", "WV", "VA")
  ) %>%
  rename(id = featureid) %>%
  mutate_at(vars(-c(id, huc6, huc8, huc10, huc12, state)), signif, digits = 4)
cat("done\n")

# fraction of cold water refugia catchments
df %>% summarise(across(starts_with("cold"), mean, na.rm = TRUE))

# export ------------------------------------------------------------------

huc_columns <- tidyselect::vars_select(names(df), starts_with("huc"))

for (id in c("huc6", "huc8", "huc10")) {
  fname <- glue::glue("../../data/{id}/dataset.csv")
  cat("saving: ", fname, "\n")
  df %>%
    select(!!setdiff(names(df), setdiff(huc_columns, id))) %>%
    write_csv(fname, na = "")
}

id <- "huc12"
huc2_ids <- str_sub(df$huc12, 1, 2) %>% unique() %>% sort()

for (huc2_id in huc2_ids) {
  fname <- glue::glue("../../data/{id}-{huc2_id}/dataset.csv")
  cat("saving: ", fname, "\n")
  df %>%
    filter(str_sub(df$huc12, 1, 2) == huc2_id) %>%
    select(!!setdiff(names(df), setdiff(huc_columns, id))) %>%
    write_csv(fname, na = "")
}

df %>%
  saveRDS("rds/dataset.rds")

cat("generate-datasets: finished\n")
