# Example Usage - Education Data Portal summary endpoints
# Leonardo Restrepo

library(educationdata)
library(tidyverse)
library(data.table)

# CCD Enrollment by fips (by year)
d1 = get_education_data_summary(
  level = "schools",
  source = "ccd",
  topic = "enrollment",
  stat = "sum",
  var = "enrollment",
  by = "fips"
)

# IPEDS Admissions by Institution (by year)
d2 = get_education_data_summary(
  level = "college-university",
  source = "ipeds",
  topic = "admissions-enrollment",
  stat = "avg",
  var = "number_applied",
  by = "unitid"
)
d2_a = d2 %>%
  group_by(year)%>%
  summarise(num_app =sum(number_applied, na.rm = T))

# IPEDS Admissions by Institution (by fips)
d3 = get_education_data_summary(
  level = "college-university",
  source = "ipeds",
  topic = "admissions-enrollment",
  stat = "avg",
  var = "number_applied",
  by = "fips",
  filters = list(fips=17)
)

plot = ggplot()+
  geom_point(data = d3, mapping = aes(x = year, y = number_applied) , color = "red")

# The hard way

d4 = get_education_data(level = "college-university",
                        source = "ipeds",
                        topic = "admissions-enrollment",
                        filters = list(fips = 17))%>%
  filter(!is.na(number_applied),
         sex == 99)%>%
  group_by(year, fips)%>%
  summarise(num_app = mean(number_applied))

# Red points use the summary endpoint and blue use classic collapse technique
plot+
  geom_point(data = d4, mapping = aes(x = year, y = num_app), color = "blue")

# How many observations are different (may be slightly different, accounted for 
            # by rounding to the 4th decimal)
sum(round(d4$num_app,4) != round(d3$number_applied,4), na.rm = T)

# No differences