#Robert Dinterman, NCSU Economics PhD Student

# Zip Code Shapefiles

require(rgdal, quietly = T)

localDir <- "0-data/Shapefiles"
if (!file.exists(localDir)) dir.create(localDir)

tempDir <- tempdir()

# ZCTA Points
# https://www.census.gov/geo/maps-data/data/gazetteer1990.html
url <- paste0("http://www2.census.gov/geo/docs/",
              "maps-data/data/gazetteer/zips.zip")
file <- paste(localDir, basename(url), sep = "/")
if (!file.exists(file)) download.file(url, file)#, method = "libcurl")

unzip(file, exdir = tempDir)
myfile  <- list.files(tempDir, full.names = T)[1]
#unlink(tempDir, recursive = T)
zctap90 <- read.csv(myfile, header = F, stringsAsFactors = F)
names(zctap90) <- c("STFIPS", "ZIP", "ST_Abbrv", "ZIP_Name", "long",
                    "lat", "pop90", "allocation")
zctap90$long <- - zctap90$long

# # https://www.census.gov/geo/maps-data/data/gazetteer2000.html
# url <- paste0("http://www2.census.gov/geo/docs/",
#               "maps-data/data/gazetteer/zcta5.zip")
# file <- paste(localDir, basename(url), sep = "/")
# if (!file.exists(file)) download.file(url, file, method = "libcurl")
# 
# unzip(file, exdir = tempDir)
# myfile  <- list.files(tempDir, full.names = T)[1]
# zctap00 <- read.csv(myfile, header = F, stringsAsFactors = F)
# unlink(tempDir, recursive = T)
# 
# 
# Columns 1-2  United States Postal Service State Abbreviation
# Columns 3-66	Name (e.g. 35004 5-Digit ZCTA - there are no post office names)
# Columns 67-75	Total Population (2000)
# Columns 76-84	Total Housing Units (2000)
# Columns 85-98	Land Area (square meters) - Created for statistical purposes only.
# Columns 99-112	Water Area (square meters) - Created for statistical purposes only.
# Columns 113-124	Land Area (square miles) - Created for statistical purposes only.
# Columns 125-136	Water Area (square miles) - Created for statistical purposes only.
# Columns 137-146	Latitude (decimal degrees) First character is blank or "-" denoting North or South latitude respectively
# Columns 147-157	Longitude (decimal degrees) First character is blank or "-" denoting East or West longitude respectively
# 
# names(zctap00) <- c("STFIPS", "ZIP", "ST_Abbrv", "ZIP_Name", "long",
#                     "lat", "pop90", "allocation")
# zctap00$long <- - zctap00$long



url <- paste0("http://www2.census.gov/geo/tiger/",
              "GENZ2014/shp/cb_2014_us_zcta510_500k.zip")
file <- paste(localDir, basename(url), sep = "/")
if (!file.exists(file)) download.file(url, file)#, method = "libcurl")

unzip(file, exdir = tempDir)
myfile  <- list.files(tempDir)[1]
zipcode <- substr(basename(myfile), 1, nchar(basename(myfile)) - 4)

zcta  <- readOGR(tempDir, layer = zipcode)

row.names(zcta) <- as.character(zcta$ZCTA5CE10)

# Clean-up Shapefile ------------------------------------------------------
# Used the following stackexchange for code:
# http://gis.stackexchange.com/questions/113964/fixing-orphaned-holes-in-r

require(devtools, quietly = T)
install_github("eblondel/cleangeo")
require(cleangeo, quietly = T)

# #get a report of geometry validity & issues for a sp spatial object
# sp            <- zcta
# report        <- clgeo_CollectionReport(sp)
# summary       <- clgeo_SummaryReport(report)
# issues        <- report[report$valid == FALSE,]
# #get suspicious features (indexes)
# nv            <- clgeo_SuspiciousFeatures(report)
# mysp          <- sp[nv,]
# #try to clean data
# mysp.clean    <- clgeo_Clean(mysp, print.log = TRUE)
# #check if they are still errors
# report.clean  <- clgeo_CollectionReport(mysp.clean)
# summary.clean <- clgeo_SummaryReport(report.clean)
# #Attempting a UnionSpatialPolygons based on the COUNTY field
# mysp.df       <- as(mysp, "data.frame")
# zipcol        <- mysp.df$ZIP
# mysp.diss     <- unionSpatialPolygons(mysp.clean, zipcol)

zcta      <- clgeo_Clean(zcta, print.log = T)

zcta$ZIP  <- as.numeric(as.character(zcta$ZCTA5CE10))

aea.proj  <- "+proj=longlat"

# aea.proj  <- "+proj=aea +lat_1=29.5 +lat_2=45.5 +lat_0=37.5 +lon_0=-100
#               +x_0=0 +y_0=0 +ellps=GRS80 +datum=NAD83 +units=m"
#  http://www.remotesensing.org/geotiff/proj_list/albers_equal_area_conic.html
#  +proj=aea   +lat_1=Latitude of first standard parallel
#              +lat_2=Latitude of second standard parallel
#              +lat_0=Latitude of false origin 
#              +lon_0=Longitude of false origin
#              +x_0=Easting of false origin
#              +y_0=Northing of false origin
zcta      <- spTransform(zcta,CRS(aea.proj))

save(zcta,  file = paste0(localDir, "/zcta2014.RData"))
# 
# load("~/Migration/0-data/ZBP/ZBP94-13_total.RData")
