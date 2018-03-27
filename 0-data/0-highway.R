# NOAA Interstate Highways of the US:
# valid update 2003-10-15
# http://www.nws.noaa.gov/geodata/catalog/transportation/html/interst.htm


# ---- Start --------------------------------------------------------------

print(paste0("Started 0-highway at ", Sys.time()))

library(tidyverse)
library(sf)

# Create a directory for the data
local_dir    <- "0-data/highway"
data_source <- paste0(local_dir, "/raw")
if (!file.exists(local_dir)) dir.create(local_dir)
if (!file.exists(data_source)) dir.create(data_source)

hwy_url <- paste0("http://www2.census.gov/geo/tiger/TIGER2016/PRIMARYROADS/",
                  "tl_2016_us_primaryroads.zip")
hwy_file <- paste0(data_source, "/", basename(hwy_url))

if (!(file.exists(hwy_file))) download.file(hwy_url, hwy_file)

temp_dir <- tempdir()

unzip(hwy_file, exdir = temp_dir)

hwy_sf <- st_read(paste0(temp_dir, "/tl_2016_us_primaryroads.shp"))

ggplot(data = hwy_sf, aes(color = RTTYP)) +
  geom_sf() +
  coord_sf(xlim = c(-130, -60), ylim = c(24, 50)) 

map(urls, function(x){
  Sys.sleep(runif(1, 2, 3))
  file_x <- paste0(data_source, "/", basename(x))
  if (!file.exists(file_x)) download.file(x, file_x)
})

print(paste0("Finished 0-highway at ", Sys.time()))
