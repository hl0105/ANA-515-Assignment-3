# check working environment
getwd()

# set up
install.packages("tidyverse")
install.packages("dplyr")
install.packages("stringr")
install.packages("tidyr")
install.packages("ggplot2")
library(tidyverse)
library(dplyr)
library(stringr)
library(tidyr)
library(ggplot2)

# store target dataset
storms<-read.csv("C:/Users/12052/Desktop/StormEvents_details-ftp_v1.0_d1997_c20220425.csv")


# select variables as required 
myvars <- c("BEGIN_DATE_TIME", "END_DATE_TIME" , "EPISODE_ID", "EVENT_ID","STATE","STATE_FIPS", "CZ_NAME", "CZ_TYPE", "CZ_FIPS", "EVENT_TYPE", "DATA_SOURCE", "BEGIN_LAT", "BEGIN_LON", "END_LAT", "END_LON")
new_storms <- storms[myvars]

# chech my datasets 
head(new_storms)

# arrange data by state
new_storms2<-new_storms %>% 
  arrange (STATE) %>%
  print()

# Change state and county names to title case
new_storms2$STATE=str_to_title(new_storms2$STATE)
new_storms2$CZ_NAME=str_to_title(new_storms2$CZ_NAME)

# Limit to the events listed by county FIPS (CZ_TYPE of "C") and then remove the CZ_TYPE column
storms3 <- new_storms2 %>% 
  filter(CZ_TYPE=="C") %>%
  select(-CZ_TYPE)

# Pad the state and county FIPS with a "0" at the beginning (hint: there's a function in stringr to do this) and then unite the two columns to make one fips column with the 5 or 6-digit county FIPS code 
storms3$STATE_FIPS=str_pad(storms3$STATE_FIPS, width = 3, side = "left", pad = "0")
storms3$CZ_FIPS=str_pad(storms3$CZ_FIPS, width = 3, side = "left", pad = "0")
storms4=unite(storms3,col="FIPS", c("STATE_FIPS","CZ_FIPS"))

# Rename all columns to lower case
storms5=rename_all(storms4,tolower)

# data("state")
data("state")
us_state<-data.frame(state=state.name,area=state.area ,region=state.region)

# 
storms5<- data.frame(table(storms4$STATE))
storms5<- rename(storms5,c("state"="Var1"))
storms6 <- merge(x=storms5,y=us_state,by.x="state", by.y="state")
View(storms6)
head(storms6)

# Plot
storm_plot <-ggplot(storms6, aes(x=area,y=Freq)) + geom_point(aes(color=region))+
  labs(x="Land area (square miles)",
       y="# of storm events in 1997")
storm_plot


