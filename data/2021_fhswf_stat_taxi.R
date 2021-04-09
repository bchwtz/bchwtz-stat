library(geodist)
library(osrm)

# load raw data
coursepath <- "~/sciebo/courses/bchwtz-stat"
filepath <- "nongit/data/2021-taxi/nyctaxi.csv"
savepath <- "data"
d <- read.csv(file.path(coursepath, filepath))

# select a subset of the data
n <- 10000
set.seed(20210408)
d <- d[sample(nrow(d), size = n), ]

# Function to make points dataframe
make_pts <- function(x){
  pts <- data.frame(long = c(x["pickup_longitude"], x["dropoff_longitude"]), 
                    lat = c(x["pickup_latitude"], x["dropoff_latitude"]),
                    row.names = NULL)
  return(pts)
}

# Function to request route information from openstreetmap
make_dist_duration <- function(x, type=c("car","bike","foot")[1]){
  pts <- make_pts(x)
  route <- osrm::osrmRoute(loc=pts, returnclass = "sf", osrm.profile = type)
  return(c(osrm_distance=route$dist, osrm_duration=route$duration))
}

# Funtion to calculate geodesic_distance
make_geodesic_distance <- function(x){
  pickup_loc <- c(longitude=x["pickup_longitude"],
                  latitude=x["pickup_latitude"])
  dropoff_loc <- c(longitude=x["dropoff_longitude"],
                   latitude=x["dropoff_latitude"])
  geodesic_distance <- geodist::geodist(x=pickup_loc,
                                        y=dropoff_loc, 
                                        measure = "geodesic")
  return(geodesic_distance)
}


# Getting route information involves an external server and needs to be batched
# so that it does not time out

mb <- 15 # microbatch size
f <- rep((1:ceiling(nrow(d)/mb)), each=mb)[1:nrow(d)] # splitkey
dlist <- split(d, f)


for (idx in 1:length(dlist)){
  
  batch <- dlist[[idx]]
  # Generate route information and add to dataset
  try({
  res <- apply(batch, MARGIN=1, make_dist_duration)
  df <- cbind(batch, t(res))
  
  # Add day of the week to dataset
  df$weekday <- weekdays(as.Date(df$pickup_datetime))
  
  # Add geodesic distance to dataset
  df$geodesic_distance <- apply(df, MARGIN=1, make_geodesic_distance)
  
  # caching: export to csv
  filename <- paste0("cache_",idx,"-2021_fhswf_stat_taxi.csv")
  write.csv(df,
            file = file.path(coursepath,savepath,filename),
            row.names = FALSE)
  })
  
  Sys.sleep(runif(1,1,mb))
  message(idx)
}

files <- list.files(file.path(coursepath,savepath), 
                    pattern = "^cache*", full.names = T)
length(files)
flist <- lapply(files, read.csv)
df <- do.call("rbind", flist)

# write final csv
write.csv(df,
          file = file.path(coursepath,savepath,"2021_fhswf_stat_taxi.csv"),
          row.names = FALSE)

# delete cache files
unlink(files)
