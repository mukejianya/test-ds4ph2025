options(repos = c(CRAN = "https://cran.rstudio.com"))


install.packages("tidyverse")

library(tidyverse)

#read in the data
population <- read_csv("https://raw.githubusercontent.com/opencasestudies/ocs-bp-opioid-rural-urban/master/data/simpler_import/county_pop_arcos.csv")
annual <- read_csv("https://raw.githubusercontent.com/opencasestudies/ocs-bp-opioid-rural-urban/master/data/simpler_import/county_annual.csv")
land <- read_csv("https://raw.githubusercontent.com/opencasestudies/ocs-bp-opioid-rural-urban/master/data/simpler_import/land_area.csv") 

names(population)
names(annual)
names(land)

#check and clean the data following steps from the online textbook
population %>% 
    select(countyfips, population, year) %>%
    head()

annual %>%
    filter(is.na(countyfips) | countyfips == "NA") %>%
    select(BUYER_COUNTY, BUYER_STATE, countyfips) %>%
    distinct()

annual %>% 
    filter(BUYER_STATE != "PR") %>%
    count(BUYER_STATE) %>%
    print(n=56)

annual <- annual %>%
  mutate(countyfips = if_else(
    is.na(countyfips) & BUYER_COUNTY == "MONTGOMERY" & BUYER_STATE == "AR", 
    "05097", 
    countyfips
  ))

  annual <- annual %>%
  filter(!is.na(countyfips))

land_area <- land %>%
  select(STCOU, Areaname, LND110210D) %>%
  rename(countyfips = STCOU)


annual_joined <- annual %>%
left_join(population, by = c("countyfips", "year")) %>%
left_join(land_area, by = "countyfips")
