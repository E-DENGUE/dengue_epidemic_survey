library(dplyr)
library(ggplot2)
library(lubridate)


d1 <- readRDS('./Data/CONFIDENTIAL/Updated_full_data_with_new_boundaries_all_factors_cleaned.rds') %>%
  dplyr::select(district, date, m_DHF_cases, pop) %>%
  mutate(month=month(date),
         year=year(date),
         epiyr = if_else(month>=4, year, year-1)
         ) %>%
  group_by(district, epiyr) %>%
  mutate(inc=m_DHF_cases/pop*100000,
         n_obs=n()) %>%
  filter(n_obs==12) %>%
  mutate(graphID=cur_group_id()) %>%
  ungroup() 
  

d1 %>%
  filter(graphID==1) %>%
  ggplot(aes(x=date, y=inc))+
  geom_line() +
  theme_minimal() +
  ylab('Dengue cases/100000 people')+
  ylim(0,400)

