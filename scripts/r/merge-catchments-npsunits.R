# merge catchments with nps units

library(tidyverse)
library(sf)

catch <- readRDS("rds/catchment-centroids.rds")
npsunit <- readRDS("rds/npsunits.rds")

# 77 nps units total
npsunits$UNIT_CODE %>% unique %>% length

# use subset for development
# npsunit <- head(npsunit)

df <- npsunits %>%
  select(npsunit = UNIT_CODE) %>%
  st_join(catch, join = st_contains) %>%
  as_tibble() %>%
  select(-geometry) %>%
  filter(!is.na(featureid))

catch %>%
  inner_join(df, by = "featureid") %>%
  filter(npsunit %in% unique(npsunits$UNIT_CODE)[1:5]) %>% # first five units only
  ggplot() +
  geom_sf(aes(color = npsunit))

# no. catchments per npsunit
df %>%
  group_by(npsunit) %>%
  tally() %>%
  print(n = Inf) %>%
  summary()

setdiff(sort(unique(npsunits$UNIT_CODE)), df$npsunit) %>% length

# no. npsunits per catchment > 1
df %>%
  group_by(featureid) %>%
  tally() %>%
  filter(n > 1)

# npsunits with no catchment

saveRDS(df, "rds/npsunit-catchment.rds")
