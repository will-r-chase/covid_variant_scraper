library(dplyr)
library(tidyr)
library(readr)
library(jsonlite)
library(lubridate)

data <- fromJSON("https://api.outbreak.info/genomics/prevalence-by-location-all-lineages?location_id=USA&other_threshold=0.03&nday_threshold=5&ndays=60&timestamp=18709")

percentize <- function(x)(x * 100)

data_df <- data %>% 
  as.data.frame() %>% 
  filter(ymd(results.date) >= ymd("2021-01-01")) %>%
  filter(ymd(results.date) <= ymd(today() - 10)) %>% 
  select(results.lineage, results.date, results.prevalence_rolling) %>%
  pivot_wider(names_from = results.lineage, values_from = results.prevalence_rolling) %>%
  mutate_if(is.numeric, percentize) %>%
  select(results.date, b.1.1.7, b.1.427, b.1.429, b.1.526, b.1.526.1, b.1.526.2, p.1, everything())

write_csv(data_df, "data-raw/data.csv")