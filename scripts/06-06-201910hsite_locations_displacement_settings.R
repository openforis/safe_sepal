####################################################################################
####### Object:  Suitability map - Site locations selection for displacement settings           
####### Author:  sarah.wertz@fao.org                        
####### Update:  2019/06/06                                  
####################################################################################
rm(list=ls())

# +001 INSTALLATION OF THE PACKAGES
# +002 SET WORKING ENVIRONMENT 
# +003 CREATING OBJECTS ON R
# +004 CREATING FOLDERS ON THE COMPUTER
# +005 DEFINE AOI WITH THE BOUNDARIES OF THE COUNTRY : CREATE A MASK LAYER 
#      COUNTRY'S BOUNDARIES 
# +006 EXTRACT AND PREPARE LAYERS 
# #    I/ SHAPEFILES 
#      GET OSM DATA -> tmpdir
# #    #            1/ CULTURE-RELIGION 
# #    #            2/ EDUCATION 
# #    #            3/ HEALTH  
# #    #            4/ BIOMASS
# #    #            5/ UNSUITABLE AREAS
# #    #            6/ OPEN AREAS  
# #    #            7/ ROADS 
# #    #            8/ TOWNS 
# #    #            9/ WATER POIS
# #    #            10/WATER OSM  
# #    #            11/WATERWAYS OSM  
# #    #            12/WATER NATURAL OSM 
# #    #            13/ELECTRIC LINES -> need to find
# #    II/ RASTERS 
# #    #            1/ POPULATION DENSITY 
# #    #            2/ PRECIPITATION 
# #    #            3/ ALTITUDE 
# #    #            4/ SRTM 
# #    #            
# +008 LU-LC
# +009 GFC

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# +001 INSTALLATION OF THE PACKAGES
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
##################### INSTALLATION OF THE PACKAGE FUNCTION - FOR R TO GO FIND THE PACKAGES ON THE CRAN.R PROJECT
packages <- function(x){
  x <- as.character(match.call()[[2]])
  if (!require(x,character.only=TRUE)){
    install.packages(pkgs=x,repos="http://cran.r-project.org")
    require(x,character.only=TRUE)
  }
}

##################### LOAD/INSTALL PACKAGES - FIRST RUN MAY TAKE TIME
options(stringsAsFactors = F)
packages(raster)
packages(rgdal)
packages(gdalUtils)
packages(sp)
packages(sf)
packages(rgeos)
packages(plyr)

packages(foreign)
packages(ggplot2)
packages(devtools)
packages(maptools)

install_github('yfinegold/gfcanalysis')
packages(gfcanalysis)

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# +002 SET WORKING ENVIRONMENT (GENERAL)
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
rootdir <- ("~/safe_sepal")
setwd(rootdir)
rootdir <- paste0(getwd(),"/")

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# +003 CREATING OBJECTS ON SEPAL
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
scriptdir <- paste0(rootdir,"scripts/")
datadir   <- paste0(rootdir,"data_in/")
griddir   <- paste0(rootdir,"grid/")
data0dir  <- paste0(rootdir,"data0/")
tmpdir    <- paste0(rootdir,"tmp/")
admdir    <- paste0(rootdir,"data_in/adm/")
lulcdir   <- paste0(rootdir,"data_in/lu-lc/")
gfcdir    <- paste0(rootdir,"data_in/gfc/")
waterdir  <- paste0(rootdir,"data_in/water/")
denspopdir<- paste0(rootdir,"data_in/denspop/")
srtmdir   <- paste0(rootdir,"data_in/srtm/") 
elecdir   <- paste0(rootdir,"data_in/electricity/")

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# +004 CREATING FOLDERS ON THE COMPUTER
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
dir.create(scriptdir,showWarnings = F)
dir.create(datadir,showWarnings = F)
dir.create(griddir,showWarnings = F)
dir.create(data0dir,showWarnings = F)
dir.create(tmpdir,showWarnings = F)
dir.create(admdir,showWarnings = F)
dir.create(lulcdir,showWarnings = F)
dir.create(gfcdir,showWarnings = F)
dir.create(waterdir,showWarnings = F)
dir.create(denspopdir,showWarnings = F)
dir.create(srtmdir,showWarnings = F)
dir.create(elecdir,showWarnings = F)

setwd(datadir)

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# +005 DEFINE AOI WITH THE BOUNDARIES OF THE COUNTRY : CREATE A MASK LAYER
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## SEE COUNTRY CODE ON http://kirste.userpage.fu-berlin.de/diverse/doc/ISO_3166.html
aoi        <- getData('GADM',
                      path=admdir,
                      country= "NER",
                      level=0)
plot(aoi)
aoi
## REPROJECT - SEARCH FOR YOUR COUNTRY'S COORDINATES ON https://epsg.io/
EPSG0 <- CRS("+init=epsg:32631")
aoi_utm<-spTransform(aoi, EPSG0)
aoi_utm

## CREATE A RASTER LAYER BOX WITH INTEGER COLUMNS AND LINES / DEFINITION OF THE RESOLUTION, EXTENT AND CS
res0      <- 30
ext0      <- extent(aoi_utm)
ext0[1]   <- (floor(ext0[1]/res0)+1)*res0
ext0[2]   <- (floor(ext0[2]/res0)+1)*res0
ext0[3]   <- (floor(ext0[3]/res0)+1)*res0
ext0[4]   <- (floor(ext0[4]/res0)+1)*res0
nbcol0    <- (ext0[2]-ext0[1])/res0
nbrow0    <- (ext0[4]-ext0[3])/res0

extent(aoi_utm)
ext0

r         <- raster(ncols=nbcol0,nrows=nbrow0)
extent(r) <- ext0
crs(r)    <- EPSG0
# r is an empty object at this point
plot(r)
# Function : ask R to add "1" in each cell for the extent and resolution of r -- RUN MAY TAKE TIME
# Saved in your setwd(datadir)
set1f     <- function(x){rep(1, x)}
rbox      <- init(r, fun=set1f, filename='rbox.tif', overwrite=TRUE)
rbox
plot(rbox)
plot(aoi_utm,add=TRUE)

# Rasterize the polygon (.rds) object using rbox : S4 method for SpatialPolygons,Raster
aoi_utm_rbox <- rasterize(aoi_utm, rbox, field=1, fun='last', background=NA,
                          mask=FALSE, update=FALSE, updateValue='all', filename="")
# Write the .tif file
file_mask = paste0(griddir,"mask0.tif")
mask0 <- writeRaster(aoi_utm_rbox, filename= file_mask, overwrite=TRUE) 
mask0
plot(mask0)

#mask0 has values=1 within Niger and nodata values outside -> comes from the rasterize function where background=NA(?)
plot(aoi_utm_rbox)

# /!\ Compress mask0
system(sprintf("gdal_translate -ot Byte -co COMPRESS=LZW %s %s " ,
               paste0(griddir, "mask0.tif"),
               paste0(griddir, "mask0_comp.tif")
))

mask0 <- raster(paste0(griddir,"mask0.tif"))
mask0
#Look at the difference between mask0 and mask0_comp -> values are different : 1,1 (mask0) and 0,255 (mask0_comp) for (min,max) (why?)
mask0_comp <- raster(paste0(griddir,"mask0_comp.tif"))
mask0_comp


# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
##################### COUNTRY'S BOUNDARIES 
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

aoi_utm 
writeOGR(aoi_utm,paste0(data0dir,"boundaries.shp"),"boundaries","ESRI Shapefile",overwrite_layer = T)

aoi_utm    <- readOGR(paste0(data0dir,"boundaries.shp"))
plot(aoi_utm)
aoi_utm


# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# +006 EXTRACT AND PREPARE LAYERS  
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# I/ SHAPEFILES 
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

 ##################### GET OSM DATA 
#See details on : http://download.geofabrik.de/osm-data-in-gis-formats-free.pdf
url <- "http://download.geofabrik.de/africa/niger-latest-free.shp.zip"
file <- "niger-latest-free.shp.zip"

download.file(url = url,
              destfile = paste0(tmpdir,file))

system(sprintf("unzip -o %s -d %s",
               paste0(tmpdir,file),
               tmpdir))

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
##################### 1/ CULTURE-RELIGION 
# Which religions you have in your country and plot them
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## Places of worship -> fclass -> "muslim_" and "christian_" (using the function grepl)
pofw       <- readOGR(paste0(tmpdir,"gis_osm_pofw_free_1.shp"))
str(pofw)
levels(as.factor(pofw$fclass))

#0 is NODATA
pofw$religion_code <- 0
#1 is muslims
pofw$religion_code[which(grepl("muslim",pofw$fclass))]<-1
#2 is christians
pofw$religion_code[which(grepl("christian",pofw$fclass))]<-2
pofw
head(pofw)

## To see which lines have a muslim in it: "which(grepl("muslim",pow$fclass))"
## REPROJECT
pofw<-spTransform(pofw, crs(mask0))
writeOGR(pofw, paste0(data0dir, layer="religioncode.shp"), layer="religioncode.shp",driver='ESRI Shapefile', overwrite=TRUE)

## Get R to read the shapefile that we have created to use it afterwards if needed
pofw_shp    <- readOGR(paste0(data0dir, "religioncode.shp"))
head(pofw_shp)
plot(pofw_shp)

## RASTERIZE by the column we created -> "religion_code" abbreviated by "rlgn_cd"
# More info: https://gdal.org/programs/gdal_rasterize.html
#            http://www.openforis.org/fileadmin/user_upload/Geospatial_Toolkit/OFGT_usermanual.pdf 

#-v %s -> vector 
#-i %s -> infile
#-o %s -> outfile
#-a %s -> attr
#RASTERIZE USING MASKO_COMP?
system(sprintf("python %s/oft-rasterize_attr.py -v %s -i %s -o %s  -a %s",
               scriptdir,
               paste0(data0dir, "religioncode.shp"),
               paste0(griddir, "mask0.tif"),
               paste0(data0dir, "religion_mask0.tif"),
               "rlgn_cd"
))
gdalinfo(paste0(data0dir, "religion_mask0.tif"),hist=T)
plot(raster(paste0(data0dir, "religion_mask0.tif")))

system(sprintf("python %s/oft-rasterize_attr.py -v %s -i %s -o %s  -a %s",
               scriptdir,
               paste0(data0dir, "religioncode.shp"),
               paste0(griddir, "mask0_comp.tif"),
               paste0(data0dir, "religion_mask0_comp.tif"),
               "rlgn_cd"
))

## Verify what you created
plot(raster(paste0(data0dir, "religion_mask0.tif")))
gdalinfo(paste0(data0dir, "religion_mask0.tif"),hist=T)
gdalinfo(paste0(data0dir, "religion_mask0.tif"),mm=T)

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
##################### 2/ EDUCATION  
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++  
## Points of interest -> fclass -> "university", "school", "kindergarten" and "college"   
edu       <- readOGR(paste0(tmpdir,"gis_osm_pois_free_1.shp"))
str(edu)
levels(as.factor(edu$fclass))

#0 is NODATA
edu$education_code <- 0
#1 is university
edu$education_code[which(grepl("university",edu$fclass))]<-1
#2 is school
edu$education_code[which(grepl("school",edu$fclass))]<-2
#3 is kindergarten 
edu$education_code[which(grepl("kindergarten",edu$fclass))]<-3
#4 is college
edu$education_code[which(grepl("college",edu$fclass))]<-4
edu
head(edu)
plot(edu)

#Use a filter function to only take into account the points related to education facilities
edu_only <- edu[edu$education_code !=0,]
str(edu_only@data)
levels(as.factor(edu_only$education_code))

## REPROJECT
edu_only_mask0 <-spTransform(edu_only, crs(mask0))
writeOGR(edu_only_mask0, paste0(data0dir, "educationcode.shp"), layer="educationcode.shp", driver='ESRI Shapefile', overwrite=T)

## Get R to read the shapefile that we have created 
edu_shp    <- readOGR(paste0(data0dir,"educationcode.shp"))
head(edu_shp)
str(edu_shp@data)
plot(edu_shp)

## RASTERIZE 
system(sprintf("python %s/oft-rasterize_attr.py -v %s -i %s -o %s  -a %s",
               scriptdir,
               paste0(data0dir,"educationcode.shp"),
               paste0(griddir,"mask0.tif"),
               paste0(data0dir,"education.tif"),
               "edctn_c"
))
plot(raster(paste0(educdir, "education.tif")))
gdalinfo(paste0(data0dir,"education.tif"),mm=T)

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
##################### 3/ HEALTH  
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ 
## Points of interest -> fclass -> "pharmacy", "hospital", "doctors" and "dentist"   
health    <- readOGR(paste0(tmpdir,"gis_osm_pois_free_1.shp"))
str(health)
levels(as.factor(health$fclass))

#0 is NODATA
health$health_code <- 0
#1 is pharmacy
health$health_code[which(grepl("pharmacy",health$fclass))]<-1
#2 is hospital
health$health_code[which(grepl("hospital",health$fclass))]<-2
#3 is doctors
health$health_code[which(grepl("doctors",health$fclass))]<-3
#4 is dentist
health$health_code[which(grepl("dentist",health$fclass))]<-4

health
head(health)
#Use a filter function to only take into account the points related to health facilities
health_only <- health[health$health_code !=0,]
str(health_only@data)
levels(as.factor(health_only$health_code))

## REPROJECT
health_only_utm<-spTransform(health_only, crs(mask0))
writeOGR(health_only_utm, paste0(data0dir,"healthcode.shp"), layer= "healthcode.shp",driver='ESRI Shapefile', overwrite=T)

## Get R to read the shapefile that we have created to use it afterwards if needed
health_shp    <- readOGR(paste0(data0dir,"healthcode.shp"))
head(health_shp)
plot(health_shp)

## RASTERIZE 
system(sprintf("python %s/oft-rasterize_attr.py -v %s -i %s -o %s  -a %s",
               scriptdir,
               paste0(data0dir,"healthcode.shp"),
               paste0(griddir,"mask0_comp.tif"),
               paste0(data0dir, "health.tif"),
               "hlth_cd"
))
plot(raster(paste0(data0dir, "health.tif")))
gdalinfo(paste0(data0dir,"health.tif"),mm=T)

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
##################### 4/ BIOMASS  
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ 
## fclass -> "forest" and "scrub"
biomass   <- readOGR(paste0(tmpdir,"gis_osm_landuse_a_free_1.shp"))
str(biomass)
levels(as.factor(biomass$fclass))

#0 is NODATA
biomass$biom_code <- 0
#1 is forest
biomass$biom_code[which(grepl("forest",biomass$fclass))]<-1
#2 is scrub
biomass$biom_code[which(grepl("scrub",biomass$fclass))]<-2
biomass
head(biomass)

#Use a filter function to only take into account the points related to health facilities
biomass_only <- biomass[biomass$biom_code !=0,]
str(biomass_only@data)
levels(as.factor(biomass_only$lu_code))

## REPROJECT
biomass_only_utm <- spTransform(biomass_only, crs(mask0))
writeOGR(biomass_only_utm, paste0(data0dir,"biomcode.shp"), layer= "biomcode.shp",driver='ESRI Shapefile', overwrite=T)

## Get R to read the shapefile that we have created to use it afterwards if needed
biomass_shp    <- readOGR(paste0(data0dir,"biomcode.shp"))
head(biomass_shp)
plot(biomass_shp)

## RASTERIZE 
system(sprintf("python %s/oft-rasterize_attr.py -v %s -i %s -o %s  -a %s",
               scriptdir,
               paste0(data0dir,"biomcode.shp"),
               paste0(griddir,"mask0_comp.tif"),
               paste0(data0dir, "biomass.tif"),
               "lu_code"
))
plot(raster(paste0(data0dir, "biomass.tif")))
gdalinfo(paste0(data0dir,"biomass.tif",mm=T))

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
##################### 5/ UNSUITABLE AREAS 
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ 
## fclass -> "nature_reserve", "military" and "national_park"
unsuitable   <- readOGR(paste0(tmpdir,"gis_osm_landuse_a_free_1.shp"))
str(unsuitable)
levels(as.factor(unsuitable$fclass))

#0 is NODATA
unsuitable$unsuit_code <- 0
#1 is nature_reserve
unsuitable$unsuit_code[which(grepl("nature_reserve",unsuitable$fclass))]<-1
#2 is military
unsuitable$unsuit_code[which(grepl("military",unsuitable$fclass))]<-2
#3 is national_park
unsuitable$unsuit_code[which(grepl("national_park",unsuitable$fclass))]<-3
unsuitable
head(unsuitable)

#Use a filter function to only take into account the points related to health facilities
unsuitable_only <- unsuitable[unsuitable$unsuit_code !=0,]
str(unsuitable_only@data)
levels(as.factor(unsuitable_only$fclass))
#there is no national park recorded in Niger with this dataset

## REPROJECT
unsuitable_only_utm <- spTransform(unsuitable_only, crs(mask0))
#/!\focusing on Niger
unsuitable_only_utm_extent <- crop(unsuitable_only_utm,(aoi_utm))

plot(unsuitable_only_utm)
plot(unsuitable_only_utm_extent)
plot(aoi_utm, add=TRUE)

str(unsuitable_only_utm_extent)
writeOGR(unsuitable_only_utm_extent, paste0(data0dir,"unsuitcode.shp"), layer= "unsuitcode.shp",driver='ESRI Shapefile', overwrite=T)

unsuit_shp    <- readOGR(paste0(data0dir,"unsuitcode.shp"))
plot(unsuit_shp)

## RASTERIZE 
system(sprintf("python %s/oft-rasterize_attr.py -v %s -i %s -o %s  -a %s",
               scriptdir,
               paste0(data0dir,"unsuitcode.shp"),
               paste0(griddir,"mask0_comp.tif"),
               paste0(data0dir, "unsuit.tif"),
               "unst_cd"
))
plot(raster(paste0(data0dir, "unsuit.tif")))
gdalinfo(paste0(data0dir,"unsuit.tif",mm=T))

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
##################### 6/ OPEN AREAS  
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ 
## fclass -> "meadow", "grass" and "heath"
openareas  <- readOGR(paste0(tmpdir,"gis_osm_landuse_a_free_1.shp"))
str(openareas)
levels(as.factor(openareas$fclass))

#0 is NODATA
openareas$open_code <- 0
#1 is meadow
openareas$open_code[which(grepl("meadow",openareas$fclass))]<-1
#2 is grass
openareas$open_code[which(grepl("grass",openareas$fclass))]<-2
#3 is heath
openareas$open_code[which(grepl("heath",openareas$fclass))]<-3
openareas
head(openareas)

#Use a filter function to only take into account the points related to health facilities
openareas_only <- openareas[openareas$open_code !=0,]
str(openareas_only@data)
levels(as.factor(openareas_only$fclass))

## REPROJECT
openareas_only_utm <- spTransform(openareas_only, crs(mask0))
openareas_only_utm_extent <- crop(openareas_only_utm,(aoi_utm))
writeOGR(openareas_only_utm_extent, paste0(data0dir,"openareascode.shp"), layer= "openareascode.shp",driver='ESRI Shapefile', overwrite=T)

openareas_shp    <- readOGR(paste0(data0dir,"openareascode.shp"))
head(openareas_shp)
plot(openareas_shp)

## RASTERIZE 
system(sprintf("python %s/oft-rasterize_attr.py -v %s -i %s -o %s  -a %s",
               scriptdir,
               paste0(data0dir,"openareascode.shp"),
               paste0(griddir,"mask0_comp.tif"),
               paste0(data0dir, "openareascode.tif"),
               "open_code"
))
plot(raster(paste0(data0dir, "openareascode.tif")))
gdalinfo(paste0(data0dir,"openareascode.tif",mm=T))

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
##################### 7/ ROADS  
# OR SEE : https://data.humdata.org/dataset/niger-roads (need to check)
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ 
# fclass -> Major roads -> "motorway", "trunk", "primary", "secondary" and "tertiary"
roads     <- readOGR(paste0(tmpdir,"gis_osm_roads_free_1.shp"))
head(roads)
levels(as.factor(roads$fclass))

#0 is NODATA
roads$roads_code <- 0
#1 is motorway
roads$roads_code[which(grepl("motorway",roads$fclass))]<-1
#2 is trunk
roads$roads_code[which(grepl("trunk",roads$fclass))]<-2
#3 is primary roads
roads$roads_code[which(grepl("primary",roads$fclass))]<-3
#2 is secondary roads
roads$roads_code[which(grepl("secondary",roads$fclass))]<-4
#3 is tertiary roads
roads$roads_code[which(grepl("tertiary",roads$fclass))]<-5
roads
head(roads)

#Use a filter function to only take into account the points related to health facilities
roads_only <- roads[roads$roads_code !=0,]
str(roads_only@data)
levels(as.factor(roads_only$fclass))

## REPROJECT
roads_only_utm<-spTransform(roads_only, crs(mask0))
roads_only_utm
roads_only_utm_extent <- crop(roads_only_utm,(aoi_utm))
writeOGR(roads_only_utm_extent, paste0(data0dir,"roadscode.shp"), layer="roadscode.shp", driver='ESRI Shapefile', overwrite=T)

roads_shp    <- readOGR(paste0(data0dir, "roadscode.shp"))
head(roads_shp)
plot(roads_shp)

## RASTERIZE 
system(sprintf("python %s/oft-rasterize_attr.py -v %s -i %s -o %s  -a %s",
               scriptdir,
               paste0(data0dir,"roadscode.shp"),
               paste0(griddir,"mask0_comp.tif"),
               paste0(data0dir, "roadscode.tif"),
               "roads_code"
))
plot(raster(paste0(data0dir, "roadscode.tif")))
gdalinfo(paste0(data0dir,"roadscode.tif",mm=T))

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
##################### 8/ TOWNS  -> /!\ HEAVY /!\-> NEED TO COMPRESS THE SHAPEFILE?
# OR CHECK : https://data.humdata.org/dataset/niger-settlements
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ 
## fclass -> "building"
buildings    <- readOGR(paste0(tmpdir,"gis_osm_buildings_a_free_1.shp"))
levels(as.factor(buildings$fclass))

#1 is buildings
buildings$buildings_code[which(grepl("building",buildings$fclass))]<-1
buildings
head(buildings)

## REPROJECT -- MAY TAKE TIME
buildings<-spTransform(buildings, crs(mask0))
buildings
buildings_utm_extent <- crop(buildings,aoi_utm)
plot(buildings_utm_extent)
writeOGR(buildings, paste0(data0dir,"buildingscode.shp"), layer= "buildingscode.shp",driver='ESRI Shapefile', overwrite=T)

buildings_shp    <- readOGR(paste0(data0dir, "buildingscode.shp"))
plot(buildings_shp)

## RASTERIZE 
system(sprintf("python %s/oft-rasterize_attr.py -v %s -i %s -o %s  -a %s",
               scriptdir,
               paste0(data0dir,"buildingscode.shp"),
               paste0(griddir,"mask0_comp.tif"),
               paste0(data0dir, "buildingscode.tif"),
               "bldngs_"
))
plot(raster(paste0(data0dir, "buildingscode.tif")))
gdalinfo(paste0(data0dir,"buildingscode.tif",mm=T))

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
##################### 9/ WATER POIS 
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## Points of interest -> fclass -> "drinkig water", "fountain", "water_tower", "water_well" and "water_works"
water_pois    <- readOGR(paste0(tmpdir,"gis_osm_pois_free_1.shp"))
levels(as.factor(water_pois$fclass))

#0 is NODATA
water_pois$water_code <- 0
#1 is drinkig water
water_pois$water_code[which(grepl("drinkig water",water_pois$fclass))]<-1
#2 is fountain
water_pois$water_code[which(grepl("fountain",water_pois$fclass))]<-2
#3 is water_tower
water_pois$water_code[which(grepl("water_tower",water_pois$fclass))]<-3
#4 is water_well
water_pois$water_code[which(grepl("water_well",water_pois$fclass))]<-4
#5 is water_works
water_pois$water_code[which(grepl("water_works",water_pois$fclass))]<-5
water_pois
head(water_pois)

#Use a filter function to only take into account the points related to water in the layer "points of interest" 
water_pois_only <- water_pois[water_pois$water_code !=0,]
str(water_pois_only@data)
levels(as.factor(water_pois_only$fclass))

## REPROJECT
water_pois<-spTransform(water_pois_only, crs(mask0))
writeOGR(water_pois_only, paste0(data0dir, "water_pois_code.shp"), layer= "water_pois_code.shp", driver='ESRI Shapefile', overwrite=T)

water_pois_shp    <- readOGR(paste0(data0dir,"water_pois_code.shp"))
head(water_pois_shp)

## RASTERIZE 
system(sprintf("python %s/oft-rasterize_attr.py -v %s -i %s -o %s  -a %s",
               scriptdir,
               paste0(data0dir,"water_pois_code.shp"),
               paste0(griddir,"mask0_comp.tif"),
               paste0(data0dir, "water_pois_code.tif"),
               "water_code"
))
plot(raster(paste0(data0dir, "water_pois_code.tif")))
gdalinfo(paste0(data0dir,"water_pois_code.tif",mm=T))

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
##################### 10/ WATER OSM  
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## fclass -> "reservoir", "river", "water" and "wetland" 
water_osm<- readOGR(paste0(tmpdir,"gis_osm_water_a_free_1.shp"))
levels(as.factor(water_osm$fclass))

#0 is NODATA
water_osm$water_code <- 0
#1 is reservoir
water_osm$water_code[which(grepl("reservoir",water_osm$fclass))]<-1
#2 is river
water_osm$water_code[which(grepl("river",water_osm$fclass))]<-2
#3 is water
water_osm$water_code[which(grepl("water",water_osm$fclass))]<-3
#4 is wetland
water_osm$water_code[which(grepl("waterland",water_osm$fclass))]<-4

head(water_osm)

#Use a filter function to only take into account the points related to water 
water_osm_only <- water_osm[water_osm$water_code !=0,]
str(water_osm_only@data)
levels(as.factor(water_osm_only$fclass))

## REPROJECT
water_osm_only_utm <-spTransform(water_osm_only, crs(mask0))
writeOGR(water_osm_only_utm, paste0(data0dir, "water_osmcode.shp"),layer="water_osmcode.shp",driver='ESRI Shapefile', overwrite=T)

water_osm_shp    <- readOGR(paste0(data0dir,"water_osmcode.shp"))
head(water_osm_shp)

## RASTERIZE 
system(sprintf("python %s/oft-rasterize_attr.py -v %s -i %s -o %s  -a %s",
               scriptdir,
               paste0(data0dir,"water_osmcode.shp"),
               paste0(griddir,"mask0_comp.tif"),
               paste0(data0dir, "water_osmcode.tif"),
               "water_code"
))
plot(raster(paste0(data0dir, "water_osmcode.tif")))
gdalinfo(paste0(data0dir,"water_osmcode.tif",mm=T))

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
##################### 11/ WATERWAYS OSM  
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## fclass -> "canal", "drain", "river" and "stream"
waterways_osm<- readOGR(paste0(tmpdir,"gis_osm_waterways_free_1.shp"))
levels(as.factor(waterways_osm$fclass))

#0 is NODATA
waterways_osm$waterways_code <- 0
#1 is canal
waterways_osm$waterways_code[which(grepl("canal",waterways_osm$fclass))]<-1
#2 is drain
waterways_osm$waterways_code[which(grepl("drain",waterways_osm$fclass))]<-2
#3 is river
waterways_osm$waterways_code[which(grepl("river",waterways_osm$fclass))]<-3
#4 is stream
waterways_osm$waterways_code[which(grepl("stream",waterways_osm$fclass))]<-4
waterways_osm
head(waterways_osm)

#Use a filter function to only take into account the points related to water 
waterways_osm_only <- waterways_osm[waterways_osm$waterways_code !=0,]
str(waterways_osm_only@data)
levels(as.factor(waterways_osm_only$fclass))

## REPROJECT
waterways_osm_only_utm<-spTransform(waterways_osm_only, crs(mask0))
writeOGR(waterways_osm_only_utm, paste0(data0dir, "waterways_osm_code.shp"), layer="waterways_osm_code.shp", driver='ESRI Shapefile', overwrite=T)

waterways_osm_shp    <- readOGR(paste0(data0dir, "waterways_osm_code.shp"))
head(waterways_osm_shp)

## RASTERIZE 
system(sprintf("python %s/oft-rasterize_attr.py -v %s -i %s -o %s  -a %s",
               scriptdir,
               paste0(data0dir,"waterways_osm_code.shp"),
               paste0(griddir,"mask0_comp.tif"),
               paste0(data0dir, "waterways_osm_code.tif"),
               "wtrwys_"
))
plot(raster(paste0(data0dir, "waterways_osm_code.tif")))
gdalinfo(paste0(data0dir,"waterways_osm_code.tif",mm=T))
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
##################### 12/ WATER NATURAL OSM  
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## fclass -> "spring"
water_natural<- readOGR(paste0(waterdir,"gis_osm_natural_free_1.shp"))
levels(as.factor(water_natural$fclass))

#0 is NODATA
water_natural$water_code <- 0
#1 is spring
water_natural$water_code[which(grepl("spring",water_natural$fclass))]<-1
water_natural
head(water_natural)

#Use a filter function to only take into account the points related to water 
water_natural_only <- water_natural[water_natural$water_code !=0,]
str(water_natural_only@data)
levels(as.factor(water_natural_only$fclass))

## REPROJECT
water_natural_only_utm<-spTransform(water_natural_only, crs(mask0))
writeOGR(water_natural_only_utm, paste0(data0dir,"water_naturalcode.shp"), layer = "water_naturalcode.shp", driver='ESRI Shapefile', overwrite=T)

water_natural_shp    <- readOGR(paste0(data0dir,"water_naturalcode.shp"))
plot(water_natural_shp)

## RASTERIZE 
system(sprintf("python %s/oft-rasterize_attr.py -v %s -i %s -o %s  -a %s",
               scriptdir,
               paste0(data0dir,"water_naturalcode.shp"),
               paste0(griddir,"mask0_comp.tif"),
               paste0(data0dir, "water_naturalcode.tif"),
               "water_code"
))
plot(raster(paste0(data0dir, "water_naturalcode.tif")))
gdalinfo(paste0(data0dir,"water_naturalcode.tif",mm=T))

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
##################### 13/ELECTRIC LINES -> need to find data
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# II/ RASTERS ----> WORK TO BE CONTINUED<-----
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
##################### 1/ POPULATION DENSITY 
# OR CHECK https://data.humdata.org/dataset/niger-other
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#You can download the file for your country and the year of interest manually from: https://data.humdata.org/organization/ocha-niger
#Save it in the denspopdir folder and follow the 2 next steps
#dens <- raster(paste0(denspopdir,"ocha_ner_ppp_2018.tif"))
#dens
#crs(dens)
#plot(dens)
#If not, follow the command lines below
url <- "ftp://ftp.worldpop.org.uk/GIS/Population/Global_2000_2020/2018/NER/ner_ppp_2018.tif"
file <- "ner_ppp_2018.tif"

download.file(url = url,
              destfile = paste0(denspopdir,file))
plot(file)

denspop <- raster(paste0(denspopdir,file))
denspop

#Use gdal warp to transform the raster 1 to raster 2
system(sprintf("gdalwarp -co COMPRESS=LZW  -t_srs \"%s\" %s %s",
               "+proj=utm +zone=31 +datum=WGS84 +units=m +no_defs +ellps=WGS84 +towgs84=0,0,0",
               paste0(denspopdir,"file",file),
               paste0(griddir,"mask0.tif",file),
               paste0(data0dir,"denspop.tif",file)
))


## PROJECT IN THE CS : WGS84 -> UTM : RASTER -> RASTER
#EPSG0     <- crs31370 <-CRS("+init=epsg:32631")
projection(aoi_utm)
projection(dens)
#To know the projection attribute of mask0
proj4string(mask0)

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
##################### 2/ PRECIPITATION
# ------> Find other data : raster for the country
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#long=? Lat? and Res of aoi?
#Getting the Data from: https://biogeo.ucdavis.edu/data/climate/worldclim/1_4/tiles/cur/prec_26.zip
#??getData

prec        <- getData('worldclim',
                       download = TRUE,
                       path = '/home/swertz/safe_sepal/data_in/water/',
                       var='prec', 
                       res=0.5, 
                       lon=8,
                       lat=16
                      )
hist(prec, plot=TRUE)

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
##################### 3/ ALTITUDE
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#??getData

alt            <- getData('alt', 
                          download = TRUE,
                          path = 'srtmdir',
                          country='NER', 
                          mask=TRUE)
hist(alt, plot=TRUE)

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
##################### 4/ SRTM
# OR CHECK : https://data.humdata.org/dataset/niger-elevation-model
# but 90m resolution
#OR CHECK : https://dwtkns.com/srtm30m/
#OR CHECK : http://glcf.umd.edu/data/srtm/
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#??getData

slope         <- getData('SRTM', 
                          lon=8, 
                          lat=16)
hist(slope, plot=TRUE)

#####################   CHECK YOUR DATA0 FILE : YOU SHOULD HAVE ALL THE FILES IN .tif AND UTM
?ls
