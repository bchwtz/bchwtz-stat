library(tidyverse)
# load raw data
coursepath <- "~/sciebo/courses/bchwtz-stat"
filepath <- "nongit/data/2021-housing/germany_housing.csv"
savepath <- "data"
d <- read.csv(file.path(coursepath, filepath))
# rename columns and select relevant ones
d <- d %>%
  rename(
    id = X,
    price = Price,
    type = Type,
    living_space = Living_space,
    lot_size = Lot,
    additional_area = Usable_area,
    availability = Free_of_Relation,
    rooms = Rooms,
    bedrooms = Bedrooms,
    bathrooms = Bathrooms,
    floors = Floors,
    year_construction = Year_built,
    year_modernization = Year_renovated,
    condition = Condition,
    heating = Heating,
    facility_quality = Furnishing_quality,
    energy_source = Energy_source,
    energy_certificate = Energy_certificate,
    energy_certificate_type = Energy_certificate_type,
    energy_consumption = Energy_consumption,
    energy_efficiency_class = Energy_efficiency_class,
    state = State,
    district = City,
    city = Place,
    parking_lot = Garages,
    parking_lot_type = Garagetype
  ) %>%
  select(-availability)

# export to csv
write.csv(d,
          file = file.path(coursepath,savepath,"2021_fhswf_stat_housing.csv"),
          row.names = FALSE)