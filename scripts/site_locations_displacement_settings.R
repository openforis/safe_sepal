####################################################################################
####### Object:  Suitability map - Site locations selection for displacement settings           
####### Author:  sarah.wertz@fao.org                        
####### Update:  2019/06/12                                  
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
# #    #            9/ WATER POIS - drinking_water/fountain/water_tower/water_well/water_works
# #    #            10/WATER OSM - reservoir/river/water
# #    #            11/WATERWAYS OSM  - canal/drain/river/stream
# #    #            12/WATER NATURAL OSM - spring
# #    #            13/ELECTRIC LINES 
# #    II/ RASTERS 
# #    #            1/ POPULATION DENSITY 
# #    #            2/ SRTM 
# #    #            3/ PRECIPITATION 
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

#packages(rJava)
#packages(xlsx)

install_github('yfinegold/gfcanalysis')
packages(gfcanalysis)

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# +002 SET WORKING ENVIRONMENT (GENERAL)
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
rootdir <- ("~/safe_sepal")
setwd(rootdir)
rootdir <- paste0(getwd(),"/")

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++s
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
roadsdir  <- paste0(rootdir, "data_in/roads/Roads/")
twnsdir   <- paste0(rootdir, "data_in/towns/")
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
dir.create(roadsdir, showWarnings = F)
dir.create(twnsdir, showWarnings = F)
dir.create(srtmdir,showWarnings = F)
dir.create(elecdir,showWarnings = F)

setwd(datadir)

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# +005 DEFINE AOI WITH THE BOUNDARIES OF THE COUNTRY : CREATE A MASK LAYER
#For Niger https://en.wikipedia.org/wiki/Administrative_divisions_of_Niger: 
#Level 0 : national boundaries
#Level 1 : region boundaries
#Level 2 : county/department boundaries
#Level 3 : commune boundaries
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## SEE COUNTRY CODE ON http://kirste.userpage.fu-berlin.de/diverse/doc/ISO_3166.html
aoi        <- getData('GADM',
                      path=admdir,
                      country= "NER",
                      level=0)
plot(aoi)
aoi

aoi2        <- getData('GADM',
                       path=admdir,
                       country= "NER",
                       level=3)
plot(aoi2)
aoi2_utm<-spTransform(aoi2, EPSG0)
writeOGR(aoi2_utm,paste0(data0dir,"boundaries_level3.shp"),"boundaries_level3","ESRI Shapefile",overwrite_layer = T)

## REPROJECT - SEARCH FOR YOUR COUNTRY'S COORDINATES ON https://epsg.io/
EPSG0 <- CRS("+init=epsg:32631")
aoi_utm<-spTransform(aoi, EPSG0)
aoi_utm
aoi_utm@bbox

## CREATE A RASTER LAYER BOX WITH INTEGER COLUMNS AND LINES / DEFINITION OF THE RESOLUTION, EXTENT AND CS

res0        <- 30
ext0        <- extent(aoi_utm)
ext0[1]     <- (floor(ext0[1]/res0)+1)*res0
ext0[2]     <- (floor(ext0[2]/res0)+1)*res0
ext0[3]     <- (floor(ext0[3]/res0)+1)*res0
ext0[4]     <- (floor(ext0[4]/res0)+1)*res0
nbcol0      <- (ext0[2]-ext0[1])/res0
nbrow0      <- (ext0[4]-ext0[3])/res0

extent(aoi_utm)
ext0

r           <- raster(ncols=nbcol0,nrows=nbrow0)
extent(r)   <- ext0
crs(r)      <- EPSG0
# r is an empty object at this point
plot(r)
# Function : ask R to add "1" in each cell for the extent and resolution of r -- RUN MAY TAKE TIME
# Saved in your setwd(datadir)

set1f       <- function(x){rep(1, x)}
rbox        <- init(r, fun=set1f, filename='rbox.tif', overwrite=TRUE)
rbox
plot(rbox)
plot(aoi_utm,add=TRUE)

# Rasterize the polygon (.rds) object using rbox : S4 method for SpatialPolygons,Raster

aoi_utm_rbox<- rasterize(aoi_utm, 
                         rbox,
                         field=1,
                         fun='last',
                         background=NA,
                         mask=FALSE,
                         update=FALSE,
                         updateValue='all',
                         filename="")
# Write the .tif file
file_mask = paste0(griddir,"mask0.tif")

mask0       <- writeRaster(aoi_utm_rbox, filename= file_mask, overwrite=TRUE) 
mask0
plot(mask0)

#mask0 has values=1 within Niger and nodata values outside -> comes from the rasterize function where background=NA(?)
plot(aoi_utm_rbox)

# /!\ Compress mask0
system(sprintf("gdal_translate -ot Byte -co COMPRESS=LZW %s %s " ,
               paste0(griddir, "mask0.tif"),
               paste0(griddir, "mask0_comp.tif")
))

mask0       <- raster(paste0(griddir,"mask0.tif"))
mask0
#Look at the difference between mask0 and mask0_comp -> values are different : 1,1 (mask0) and 0,255 (mask0_comp) for (min,max) (why?)
mask0_comp  <- raster(paste0(griddir,"mask0_comp.tif"))
mask0_comp

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
##################### COUNTRY'S BOUNDARIES ---> How to change the extent of the shapefile to the same as "mask0" (?) 
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

aoi_utm
writeOGR(aoi_utm,paste0(data0dir,"boundaries.shp"),"boundaries","ESRI Shapefile",overwrite_layer = T)

aoi_utm     <- readOGR(paste0(data0dir,"boundaries.shp"))
plot(mask0)
plot(aoi_utm, add=T)


# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# +006 EXTRACT AND PREPARE LAYERS  
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# I/ SHAPEFILES 
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

##################### GET OSM DATA 
#See details on : http://download.geofabrik.de/osm-data-in-gis-formats-free.pdf

url         <- "http://download.geofabrik.de/africa/niger-latest-free.shp.zip"
file        <- "niger-latest-free.shp.zip"

download.file(url = url,
              destfile = paste0(tmpdir,file))

system(sprintf("unzip -o %s -d %s",
               paste0(tmpdir,file),
               tmpdir))

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
##################### 1/ CULTURE-RELIGION 
# MORE INFO page 11 : http://download.geofabrik.de/osm-data-in-gis-formats-free.pdf
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## Places of worship -> fclass -> "muslim_" and "christian_" (using the function grepl)
pofw        <- readOGR(paste0(tmpdir,"gis_osm_pofw_free_1.shp"))
str(pofw)
# Which religions do you have in your country ?
levels(as.factor(pofw$fclass))

#0 is NODATA
pofw$religion_code                                       <-0
#1 is muslims
pofw$religion_code[which(grepl("christian",pofw$fclass))]<-1
#2 is christians
pofw$religion_code[which(grepl("muslim",pofw$fclass))]   <-2
pofw
head(pofw)

## To see which lines have a muslim in it: "which(grepl("muslim",pow$fclass))"
## REPROJECT
pofw_utm    <-spTransform(pofw, crs(mask0))

#/!\focusing on Niger
pofw_utm_extent <- crop(pofw_utm,(aoi_utm))
#Error in x@coords[i, , drop = FALSE] : subscript out of bounds -> all the points are already in Niger ?

writeOGR(pofw_utm, paste0(data0dir, layer="religioncode.shp"), layer="religioncode.shp",driver='ESRI Shapefile', overwrite=TRUE)

## Get R to read the shapefile that we have created
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
               paste0(data0dir, "religions.tif"),
               "rlgn_cd"
))
gdalinfo(paste0(data0dir, "religions.tif"),hist=T)
plot(raster(paste0(data0dir, "religions.tif")))

system(sprintf("python %s/oft-rasterize_attr.py -v %s -i %s -o %s  -a %s",
               scriptdir,
               paste0(data0dir, "religioncode.shp"),
               paste0(griddir, "mask0_comp.tif"),
               paste0(data0dir, "religion_mask0_comp.tif"),
               "rlgn_cd"
))

## Verify what you created
plot(raster(paste0(data0dir, "religions.tif")))
gdalinfo(paste0(data0dir, "religions.tif"),hist=T)
gdalinfo(paste0(data0dir, "religions.tif"),mm=T)

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
##################### 2/ EDUCATION  
# MORE INFO page 6-7 : http://download.geofabrik.de/osm-data-in-gis-formats-free.pdf
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++  
## Points of interest -> fclass -> "university", "school", "kindergarten" and "college"
edu         <- readOGR(paste0(tmpdir,"gis_osm_pois_free_1.shp"))
str(edu)
levels(as.factor(edu$fclass))

#0 is NODATA
edu$education_code                                         <-0
#1 is university
edu$education_code[which(grepl("university",edu$fclass))]  <-1
#2 is school
edu$education_code[which(grepl("school",edu$fclass))]      <-2
#3 is kindergarten 
edu$education_code[which(grepl("kindergarten",edu$fclass))]<-3
#4 is college
edu$education_code[which(grepl("college",edu$fclass))]     <-4
edu
head(edu)
plot(edu)

#Use a filter function to only take into account the points related to education facilities
edu_only    <- edu[edu$education_code !=0,]
str(edu_only@data)
levels(as.factor(edu_only$education_code))

## REPROJECT
edu_only_utm <-spTransform(edu_only, crs(mask0))

# /!\focusing on Niger
edu_only_utm_extent <- crop(edu_only_utm,(aoi_utm))
# Error in x@coords[i, , drop = FALSE] : subscript out of bounds

# Compare the extent of the 
edu_only_utm
aoi_utm
# xmin and ymin have to be cropped
# xmax and ymax have to be extended
# how should I proceed?

writeOGR(edu_only_mask0, paste0(data0dir, "educationcode.shp"), layer="educationcode.shp", driver='ESRI Shapefile', overwrite=T)

## Get R to read the shapefile that we have created 
edu_shp        <- readOGR(paste0(data0dir,"educationcode.shp"))
head(edu_shp)
str(edu_shp@data)
plot(edu_shp)

## RASTERIZE 
system(sprintf("python %s/oft-rasterize_attr.py -v %s -i %s -o %s  -a %s",
               scriptdir,
               paste0(data0dir,"educationcode.shp"),
               paste0(griddir,"mask0_comp.tif"),
               paste0(data0dir,"education_comp.tif"),
               "edctn_c"
))
plot(raster(paste0(data0dir, "education_comp.tif")))
gdalinfo(paste0(data0dir,"education_comp.tif"),mm=T)

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
##################### 3/ HEALTH  
# MORE INFO page 6-7 : http://download.geofabrik.de/osm-data-in-gis-formats-free.pdf
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ 
## Points of interest -> fclass -> "pharmacy", "hospital", "doctors" and "dentist"
health      <- readOGR(paste0(tmpdir,"gis_osm_pois_free_1.shp"))
str(health)
levels(as.factor(health$fclass))

#0 is NODATA
health$health_code                                         <-0
#1 is pharmacy
health$health_code[which(grepl("pharmacy",health$fclass))] <-1
#2 is hospital
health$health_code[which(grepl("hospital",health$fclass))] <-2
#3 is doctors
health$health_code[which(grepl("doctors",health$fclass))]  <-3
#4 is dentist
health$health_code[which(grepl("dentist",health$fclass))]  <-4

health
head(health)
#Use a filter function to only take into account the points related to health facilities
health_only    <- health[health$health_code !=0,]
str(health_only@data)
levels(as.factor(health_only$health_code))

## REPROJECT
health_only_utm<-spTransform(health_only, crs(mask0))
writeOGR(health_only_utm, paste0(data0dir,"healthcode.shp"), layer= "healthcode.shp",driver='ESRI Shapefile', overwrite=T)

# /!\focusing on Niger
health_only_utm_extent <- crop(health_only_utm,(aoi_utm))
# Error in x@coords[i, , drop = FALSE] : subscript out of bounds

## Get R to read the shapefile that we have created to use it afterwards if needed
health_shp     <- readOGR(paste0(data0dir,"healthcode.shp"))
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
# "forest", "scrub" and "tree"
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ 
##################### 4.1./ 
# MORE INFO page 17 : http://download.geofabrik.de/osm-data-in-gis-formats-free.pdf
## fclass -> "forest" and "scrub"
biomass     <- readOGR(paste0(tmpdir,"gis_osm_landuse_a_free_1.shp"))
str(biomass)
levels(as.factor(biomass$fclass))

#0 is NODATA
biomass$biom_code                                          <-0
#1 is forest
biomass$biom_code[which(grepl("forest",biomass$fclass))]   <-1
#2 is scrub
biomass$biom_code[which(grepl("scrub",biomass$fclass))]    <-2
biomass
head(biomass)

#Use a filter function to only take into account the points related to health facilities
biomass_only     <- biomass[biomass$biom_code !=0,]
str(biomass_only@data)
levels(as.factor(biomass_only$biom_code))

## REPROJECT
biomass_only_utm <- spTransform(biomass_only, crs(mask0))

# /!\focusing on Niger
biomass_only_utm_extent <- crop(biomass_only_utm,(aoi_utm))
#Cropping worked

writeOGR(biomass_only_utm_extent, paste0(data0dir,"biomcode.shp"), layer= "biomcode.shp",driver='ESRI Shapefile', overwrite=T)

## Get R to read the shapefile that we have created to use it afterwards if needed
biomass_shp      <- readOGR(paste0(data0dir,"biomcode.shp"))
head(biomass_shp)
plot(biomass_shp)

## RASTERIZE 
system(sprintf("python %s/oft-rasterize_attr.py -v %s -i %s -o %s  -a %s",
               scriptdir,
               paste0(data0dir,"biomcode.shp"),
               paste0(griddir,"mask0_comp.tif"),
               paste0(data0dir, "biomass.tif"),
               "biom_code"
))
plot(raster(paste0(data0dir, "biomass.tif")))
gdalinfo(paste0(data0dir,"biomass.tif",mm=T))


##################### 4.2./ 
# MORE INFO page 11-12 : http://download.geofabrik.de/osm-data-in-gis-formats-free.pdf
## fclass -> "tree"
tree_natural     <- readOGR(paste0(tmpdir,"gis_osm_natural_free_1.shp"))
levels(as.factor(tree_natural$fclass))

#0 is NODATA
tree_natural$natural_code                                          <-0
#1 is tree
tree_natural$natural_code[which(grepl("tree",tree_natural$fclass))]<-1
tree_natural
head(tree_natural)

#Use a filter function to only take into account the points related to trees
tree_natural_only<- tree_natural[tree_natural$natural_code !=0,]
str(tree_natural_only@data)
levels(as.factor(tree_natural_only$natural_code))

## REPROJECT
tree_natural_only_utm<-spTransform(tree_natural_only, crs(mask0))

# /!\focusing on Niger
tree_natural_only_utm_extent <- crop(tree_natural_only_utm,(aoi_utm))
#Error in x@coords[i, , drop = FALSE] : subscript out of bounds

writeOGR(tree_natural_only_utm, paste0(data0dir,"tree_naturalcode.shp"), layer = "tree_naturalcode.shp", driver='ESRI Shapefile', overwrite=T)

tree_natural_shp     <- readOGR(paste0(data0dir,"tree_naturalcode.shp"))
plot(tree_natural_shp)
head(tree_natural_shp)
## RASTERIZE 
system(sprintf("python %s/oft-rasterize_attr.py -v %s -i %s -o %s  -a %s",
               scriptdir,
               paste0(data0dir,"tree_naturalcode.shp"),
               paste0(griddir,"mask0_comp.tif"),
               paste0(data0dir, "tree_naturalcode.tif"),
               "ntrl_cd"
))
plot(raster(paste0(data0dir, "tree_naturalcode.tif")))

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
##################### 5/ UNSUITABLE AREAS 
# "nature_reserve", "military", "national_park" and "wetlands"
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ 
##################### 5.1./ 
# MORE INFO page 17 : http://download.geofabrik.de/osm-data-in-gis-formats-free.pdf
## fclass -> "nature_reserve", "military" and "national_park"
unsuitable       <- readOGR(paste0(tmpdir,"gis_osm_landuse_a_free_1.shp"))
str(unsuitable)
levels(as.factor(unsuitable$fclass))

#0 is NODATA
unsuitable$unsuit_code                                                  <-0
#1 is nature_reserve
unsuitable$unsuit_code[which(grepl("nature_reserve",unsuitable$fclass))]<-1
#2 is military
unsuitable$unsuit_code[which(grepl("military",unsuitable$fclass))]      <-2
#3 is national_park
unsuitable$unsuit_code[which(grepl("national_park",unsuitable$fclass))] <-3
unsuitable
head(unsuitable)

#Use a filter function to only take into account the points related to health facilities
unsuitable_only  <- unsuitable[unsuitable$unsuit_code !=0,]
str(unsuitable_only@data)
levels(as.factor(unsuitable_only$unsuit_code))
#there is no national park recorded in Niger with this dataset

## REPROJECT
unsuitable_only_utm        <- spTransform(unsuitable_only, crs(mask0))
#/!\focusing on Niger
unsuitable_only_utm_extent <- crop(unsuitable_only_utm,(aoi_utm))
#Cropping worked

plot(unsuitable_only_utm)
plot(unsuitable_only_utm_extent)
plot(aoi_utm, add=TRUE)

str(unsuitable_only_utm_extent)
writeOGR(unsuitable_only_utm_extent, paste0(data0dir,"unsuitcode.shp"), layer= "unsuitcode.shp",driver='ESRI Shapefile', overwrite=T)

unsuit_shp           <- readOGR(paste0(data0dir,"unsuitcode.shp"))
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

##################### 5.2./ 
# MORE INFO page 17 : http://download.geofabrik.de/osm-data-in-gis-formats-free.pdf
## fclass -> "wetland" 
wetland_osm      <- readOGR(paste0(tmpdir,"gis_osm_water_a_free_1.shp"))
levels(as.factor(wetland_osm$fclass))

#0 is NODATA
wetland_osm$water_code                                                  <-0
#1 is wetland
wetland_osm$water_code[which(grepl("wetland",wetland_osm$fclass))]      <-1

head(wetland_osm)

#Use a filter function to only take into account the points related to water 
wetland_osm_only     <- wetland_osm[wetland_osm$water_code !=0,]
levels(as.factor(wetland_osm_only$fclass))

## REPROJECT
wetland_osm_only_utm        <-spTransform(wetland_osm_only, crs(mask0))
#/!\focusing on Niger
wetland_osm_only_utm_extent <- crop(wetland_osm_only_utm,(aoi_utm))
wetland_osm_only_utm_extent
plot(wetland_osm_only_utm)
plot(wetland_osm_only_utm_extent)
plot(aoi_utm, add=T)
#Cropping worked
writeOGR(wetland_osm_only_utm_extent, paste0(data0dir, "wetland_osmcode.shp"),layer="wetland_osmcode.shp",driver='ESRI Shapefile', overwrite=T)

wetland_osm_shp             <- readOGR(paste0(data0dir,"wetland_osmcode.shp"))
head(wetland_osm_shp)
plot(wetland_osm_shp)
## RASTERIZE 
system(sprintf("python %s/oft-rasterize_attr.py -v %s -i %s -o %s  -a %s",
               scriptdir,
               paste0(data0dir,"wetland_osmcode.shp"),
               paste0(griddir,"mask0_comp.tif"),
               paste0(data0dir, "wetland_osmcode.tif"),
               "water_code"
))
plot(raster(paste0(data0dir, "wetland_osmcode.tif")))
gdalinfo(paste0(data0dir,"wetland_osmcode.tif",mm=T))
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
##################### 6/ OPEN SITES  
# MORE INFO page 17 : http://download.geofabrik.de/osm-data-in-gis-formats-free.pdf
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ 
## fclass -> "meadow", "grass" and "heath"
openareas  <- readOGR(paste0(tmpdir,"gis_osm_landuse_a_free_1.shp"))
str(openareas)
levels(as.factor(openareas$fclass))

#0 is NODATA
openareas$open_code                                         <-0
#1 is meadow
openareas$open_code[which(grepl("meadow",openareas$fclass))]<-1
#2 is grass
openareas$open_code[which(grepl("grass",openareas$fclass))] <-2
#3 is heath
openareas$open_code[which(grepl("heath",openareas$fclass))] <-3
openareas
head(openareas)

#Use a filter function to only take into account the points related to health facilities
openareas_only     <- openareas[openareas$open_code !=0,]
str(openareas_only@data)
levels(as.factor(openareas_only$fclass))

## REPROJECT
openareas_only_utm <- spTransform(openareas_only, crs(mask0))
#/!\focusing on Niger
openareas_only_utm_extent <- crop(openareas_only_utm,(aoi_utm))
#Cropping worked
writeOGR(openareas_only_utm_extent, paste0(data0dir,"openareascode.shp"), layer= "openareascode.shp",driver='ESRI Shapefile', overwrite=T)

openareas_shp      <- readOGR(paste0(data0dir,"openareascode.shp"))
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
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ 
##################### FROM HUMDATA 
# MORE INFO : https://data.humdata.org/dataset/niger-roads
url            <- "https://data.humdata.org/dataset/a388fd5d-0dbd-4d05-b047-7f5db50838dc/resource/06eb9b57-b170-4fd7-82f4-0c34ae52f4a7/download/roads.zip"
file           <- "roads.zip"

download.file(url = url,
              destfile = paste0(roadsdir,file))

system(sprintf("unzip -o %s -d %s",
               paste0(roadsdir,file),
               roadsdir))

roads_humdata  <- readOGR(paste0(roadsdir,"NER_Road.shp"))
head(roads_humdata)
plot(roads_humdata)
levels(as.factor(roads_humdata$NAME))
levels(as.factor(roads_humdata$ETYPE))
levels(as.factor(roads_humdata$CAcorridor))
levels(as.factor(roads_humdata$Corridors))

#0 in "NAME" ---> Correspond to unspecified roads 
roads_humdata$roads_code                                      <-1
#1 is Autoroutes roads
roads_humdata$roads_code[which(grepl("A",roads_humdata$NAME))]<-2
#2 is National roads
roads_humdata$roads_code[which(grepl("N",roads_humdata$NAME))]<-3
#3 is Regional roads
roads_humdata$roads_code[which(grepl("R",roads_humdata$NAME))]<-4

roads_humdata
head(roads_humdata)
plot(roads_humdata)

## REPROJECT
roads_humdata_utm <- spTransform(roads_humdata, crs(mask0))
#/!\focusing on Niger
roads_humdata_utm_extent <- crop(roads_humdata_utm,(aoi_utm))
#Cropping worked
writeOGR(roads_humdata_utm_extent, paste0(data0dir,"roads_humdata.shp"), layer= "roads_humdata.shp",driver='ESRI Shapefile', overwrite=T)
levels(as.factor(roads_humdata$roads_code))

roads_humdata     <- readOGR(paste0(data0dir,"roads_humdata.shp"))
head(roads_humdata)
plot(roads_humdata)

## RASTERIZE 
system(sprintf("python %s/oft-rasterize_attr.py -v %s -i %s -o %s  -a %s",
               scriptdir,
               paste0(data0dir,"roads_humdata.shp"),
               paste0(griddir,"mask0_comp.tif"),
               paste0(data0dir, "roads_humdata.tif"),
               "roads_code"
))
plot(raster(paste0(data0dir, "roads_humdata.tif")))
gdalinfo(paste0(data0dir,"roads_humdata.tif",mm=T))

##################### FROM OSM DATA 
# fclass -> Major roads -> "motorway", "trunk", "primary", "secondary" and "tertiary"
roads          <- readOGR(paste0(tmpdir,"gis_osm_roads_free_1.shp"))
head(roads)
levels(as.factor(roads$fclass))

#0 is NODATA
roads$roads_code                                        <-0
#1 is motorway
roads$roads_code[which(grepl("motorway",roads$fclass))] <-1


#2 is trunk
roads$roads_code[which(grepl("trunk",roads$fclass))]    <-2
#3 is primary roads
roads$roads_code[which(grepl("primary",roads$fclass))]  <-3
#4 is secondary roads
roads$roads_code[which(grepl("secondary",roads$fclass))]<-4
#5 is tertiary roads
roads$roads_code[which(grepl("tertiary",roads$fclass))] <-5
roads
head(roads)

#Use a filter function to only take into account the points related to health facilities
roads_only     <- roads[roads$roads_code !=0,]
str(roads_only@data)
levels(as.factor(roads_only$fclass))

## REPROJECT
roads_only_utm <-spTransform(roads_only, crs(mask0))
roads_only_utm
#/!\focusing on Niger
roads_only_utm_extent <- crop(roads_only_utm,(aoi_utm))
#Cropping worked
writeOGR(roads_only_utm_extent, paste0(data0dir,"roadscode.shp"), layer="roadscode.shp", driver='ESRI Shapefile', overwrite=T)

roads_shp      <- readOGR(paste0(data0dir, "roadscode.shp"))
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
##################### 8/ TOWNS  -> /!\ HEAVY WHEN USING OSM DATA /!\-> NEED TO COMPRESS THE SHAPEFILE?
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ 
##################### FROM HUMDATA 
# MORE INFO : https://data.humdata.org/dataset/niger-settlements
url            <- "https://data.humdata.org/dataset/5d17ed45-74a6-4417-9801-6935dcdc9c86/resource/3970d02a-00b5-4e15-a8fb-6227aef45cc7/download/niger_pplp_ocha_itos.zip"
file           <- "Niger_pplp_ocha_itos.zip"

download.file(url = url,
              destfile = paste0(twnsdir,file))

system(sprintf("unzip -o %s -d %s",
               paste0(twnsdir,file),
               twnsdir))

settlements_humdata     <- readOGR(paste0(twnsdir,"ner_pplp_ocha_itos.shp"))
head(settlements_humdata)

levels(as.factor(settlements_humdata$admin2Name))
levels(as.factor(settlements_humdata$admin2RefN))
levels(as.factor(settlements_humdata$NAME))

# Create a numeric ID column (used after to rasterize)
settlements_humdata$id_code <- seq.int(nrow(settlements_humdata))
head(settlements_humdata)

## REPROJECT
settlements_humdata_utm <- spTransform(settlements_humdata, crs(mask0))
plot(settlements_humdata_utm)
plot(aoi2,add=T)

#/!\focusing on Niger
settlements_humdata_utm_extent <- crop(settlements_humdata_utm,(aoi_utm))
#Error in x@coords[i, , drop = FALSE] : subscript out of bounds

writeOGR(settlements_humdata_utm, paste0(data0dir,"settlements_humdata.shp"), layer= "settlements_humdata.shp",driver='ESRI Shapefile', overwrite=T)

settlements_humdata_shp        <- readOGR(paste0(data0dir, "settlements_humdata.shp"))
head(settlements_humdata_shp)
plot(settlements_humdata_shp)

## RASTERIZE BY THE ID
system(sprintf("python %s/oft-rasterize_attr.py -v %s -i %s -o %s  -a %s",
               scriptdir,
               paste0(data0dir,"settlements_humdata.shp"),
               paste0(griddir,"mask0_comp.tif"),
               paste0(data0dir, "settlements_humdata.tif"),
               "id_code"
))
plot(raster(paste0(data0dir, "settlements_humdata.tif")))
gdalinfo(paste0(data0dir,"settlements_humdata.tif",mm=T))

##################### FROM OSM DATA -> /!\ HEAVY WHEN USING OSM DATA /!\-> NEED TO COMPRESS THE SHAPEFILE?
## fclass -> "building"
buildings      <- readOGR(paste0(tmpdir,"gis_osm_buildings_a_free_1.shp"))
levels(as.factor(buildings$fclass))

#1 is buildings
buildings$buildings_code[which(grepl("building",buildings$fclass))]<-1
buildings
head(buildings)

## REPROJECT -- MAY TAKE TIME
buildings            <-spTransform(buildings, crs(mask0))
buildings

#/!\focusing on Niger
buildings_utm_extent <- crop(buildings,aoi_utm)
plot(buildings_utm_extent)
#Cropping? 
writeOGR(buildings, paste0(data0dir,"buildingscode.shp"), layer= "buildingscode.shp",driver='ESRI Shapefile', overwrite=T)

buildings_shp        <- readOGR(paste0(data0dir, "buildingscode.shp"))
plot(buildings_shp)
plot(aoi_utm, add=T)

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
# MORE INFO page 10-11 : http://download.geofabrik.de/osm-data-in-gis-formats-free.pdf
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## Points of interest -> fclass -> "drinking water", "fountain", "water_tower", "water_well" and "water_works"
water_pois     <- readOGR(paste0(tmpdir,"gis_osm_pois_free_1.shp"))
levels(as.factor(water_pois$fclass))

#0 is NODATA
water_pois$water_code                                                 <-0
#1 is drinkig water
water_pois$water_code[which(grepl("drinkig water",water_pois$fclass))]<-1
#2 is water_tower
water_pois$water_code[which(grepl("water_tower",water_pois$fclass))]  <-2
#3 is water_well
water_pois$water_code[which(grepl("water_well",water_pois$fclass))]   <-3
#4 is water_works
water_pois$water_code[which(grepl("water_works",water_pois$fclass))]  <-4
water_pois
head(water_pois)

water_pois_only <- water_pois[water_pois$water_code !=0,]
str(water_pois_only@data)
levels(as.factor(water_pois_only$fclass))

## REPROJECT
water_pois_only_utm<-spTransform(water_pois_only, crs(mask0))
plot(water_pois_only_utm)
plot(aoi_utm,add=T)
#/!\focusing on Niger 
water_pois_only_utm_extent <- crop(water_pois_only_utm,(aoi_utm))
#Error in x@coords[i, , drop = FALSE] : subscript out of bounds

writeOGR(water_pois_only_utm, paste0(data0dir, "water_pois_code.shp"), layer= "water_pois_code.shp", driver='ESRI Shapefile', overwrite=T)

water_pois_shp  <- readOGR(paste0(data0dir,"water_pois_code.shp"))
plot(water_pois_shp)
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
# MORE INFO page 17 : http://download.geofabrik.de/osm-data-in-gis-formats-free.pdf
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## fclass -> "reservoir", "river", "water" 
water_osm      <- readOGR(paste0(tmpdir,"gis_osm_water_a_free_1.shp"))
levels(as.factor(water_osm$fclass))

#0 is NODATA
water_osm$water_code                                            <-0
#1 is water
water_osm$water_code[which(grepl("water",water_osm$fclass))]    <-1
#1 is reservoir
water_osm$water_code[which(grepl("reservoir",water_osm$fclass))]<-2
#2 is river
water_osm$water_code[which(grepl("river",water_osm$fclass))]    <-3


head(water_osm)

#Use a filter function to only take into account the points related to water 
water_osm_only <- water_osm[water_osm$water_code !=0,]
str(water_osm_only@data)
levels(as.factor(water_osm_only$fclass))

## REPROJECT
water_osm_only_utm        <-spTransform(water_osm_only, crs(mask0))

#/!\focusing on Niger 
water_osm_only_utm_extent <- crop(water_osm_only_utm,(aoi_utm))
plot(water_osm_only_utm)
plot(water_osm_only_utm_extent)
plot(aoi_utm,add=T)

writeOGR(water_osm_only_utm_extent, paste0(data0dir, "water_osmcode.shp"),layer="water_osmcode.shp",driver='ESRI Shapefile', overwrite=T)

water_osm_shp             <- readOGR(paste0(data0dir,"water_osmcode.shp"))
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
# MORE INFO page 16 : http://download.geofabrik.de/osm-data-in-gis-formats-free.pdf
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## fclass -> "canal", "drain", "river" and "stream"
waterways_osm  <- readOGR(paste0(tmpdir,"gis_osm_waterways_free_1.shp"))
levels(as.factor(waterways_osm$fclass))

#0 is NODATA
waterways_osm$waterways_code                                             <-0
#1 is river
waterways_osm$waterways_code[which(grepl("river",waterways_osm$fclass))] <-1
#2 is stream
waterways_osm$waterways_code[which(grepl("stream",waterways_osm$fclass))]<-2
#3 is canal
waterways_osm$waterways_code[which(grepl("canal",waterways_osm$fclass))] <-3
#4 is drain
waterways_osm$waterways_code[which(grepl("drain",waterways_osm$fclass))] <-4


waterways_osm
head(waterways_osm)

#Use a filter function to only take into account the points related to water 
waterways_osm_only <- waterways_osm[waterways_osm$waterways_code !=0,]
str(waterways_osm_only@data)
levels(as.factor(waterways_osm_only$fclass))

## REPROJECT
waterways_osm_only_utm<-spTransform(waterways_osm_only, crs(mask0))

#/!\focusing on Niger 
waterways_osm_only_utm_extent <- crop(waterways_osm_only_utm,(aoi_utm))
#Cropping worked
plot(waterways_osm_only_utm_extent)
plot(aoi_utm,add=T)

writeOGR(waterways_osm_only_utm_extent, paste0(data0dir, "waterways_osm_code.shp"), layer="waterways_osm_code.shp", driver='ESRI Shapefile', overwrite=T)

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
# MORE INFO page 11 : http://download.geofabrik.de/osm-data-in-gis-formats-free.pdf
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## fclass -> "spring"
water_natural  <- readOGR(paste0(tmpdir,"gis_osm_natural_free_1.shp"))
levels(as.factor(water_natural$fclass))

#0 is NODATA
water_natural$water_code                                             <-0
#1 is spring
water_natural$water_code[which(grepl("spring",water_natural$fclass))]<-1
water_natural
head(water_natural)

#Use a filter function to only take into account the points related to water 
water_natural_only           <- water_natural[water_natural$water_code !=0,]
str(water_natural_only@data)
levels(as.factor(water_natural_only$water_code))

## REPROJECT
water_natural_only_utm<-spTransform(water_natural_only, crs(mask0))

#/!\focusing on Niger 
water_natural_only_utm_extent <- crop(water_natural_only_utm,(aoi_utm))
#Error in x@coords[i, , drop = FALSE] : subscript out of bounds

writeOGR(water_natural_only_utm, paste0(data0dir,"water_naturalcode.shp"), layer = "water_naturalcode.shp", driver='ESRI Shapefile', overwrite=T)

water_natural_shp             <- readOGR(paste0(data0dir,"water_naturalcode.shp"))
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
##################### 13/ELECTRIC LINES 
# Electricity Transmission Network
# https://energydata.info/dataset/niger-electricity-transmission-network-2015
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#See details on : http://africagrid.energydata.info/#
url            <- "https://development-data-hub-s3-public.s3.amazonaws.com/ddhfiles/145469/330132663320kvlinesniger.zip"
file           <- "330132663320kvlinesniger.zip"

download.file(url = url,
              destfile = paste0(elecdir,file))

system(sprintf("unzip -o %s -d %s",
               paste0(elecdir,file),
               elecdir))

electricity    <- readOGR(paste0(elecdir,"330_132_66_33_20_kV_lines_NIGER.shp"))
head(electricity)
levels(as.factor(electricity$voltage_kV))
levels(as.factor(electricity$status))
levels(as.factor(electricity$source))
levels(as.factor(electricity$year))

#0 is "Planned"
electricity$status_code                                             <-0
#1 is "Existing"
electricity$status_code[which(grepl("Existing",electricity$status))]<-1
electricity
head(electricity)

#Use a filter function to only take into account the points related to the electricity transmission network that exists already
electricity_existing_only    <- electricity[electricity$status_code !=0,]
str(electricity_existing_only@data)
levels(as.factor(electricity_existing_only$status_code))

plot(electricity_existing_only)
plot(aoi, add=T)

## REPROJECT
electricity_existing_only_utm<-spTransform(electricity_existing_only, crs(mask0))
electricity_existing_only_utm
#/!\focusing on Niger ---->>>> DOES THE NEXT LINE (CROPPING) ACTUALLY DO SOMETHING? 
electricity_existing_only_utm_extent <- crop(electricity_existing_only_utm,(aoi_utm))
electricity_existing_only_utm_extent
electricity_existing_only_utm
plot(electricity_existing_only_utm_extent)
plot(aoi_utm,add=T) 
writeOGR(electricity_existing_only_utm_extent, paste0(data0dir, "electricity_code.shp"), layer= "electricity_code.shp", driver='ESRI Shapefile', overwrite=T)

electricity_code            <- readOGR(paste0(data0dir,"electricity_code.shp"))
head(electricity_code)
electricity_code

## RASTERIZE 
system(sprintf("python %s/oft-rasterize_attr.py -v %s -i %s -o %s  -a %s",
               scriptdir,
               paste0(data0dir,"electricity_code.shp"),
               paste0(griddir,"mask0_comp.tif"),
               paste0(data0dir, "electricity_code.tif"),
               "stts_cd "
))
plot(raster(paste0(data0dir, "electricity_code.tif")))
gdalinfo(paste0(data0dir,"electricity_code.tif",mm=T))
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# II/ RASTERS 
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
##################### 1/ POPULATION DENSITY  
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
##################### 1.1/ FROM ENERGYDATA.INFO   
# https://energydata.info/dataset/niger-republic-population-density-2015

# DOWNLOAD THE FILE - UNZIP IT
url            <- "https://energydata.info/dataset/fb16aa42-d0bc-4a2e-bb1a-7720be13b056/resource/da74fbc7-54b2-424d-ac02-9a9228c3ee39/download/ner-popner15adjv4.zip"
file           <- "ner-popner15adjv4.zip"

download.file(url = url,
              destfile = paste0(denspopdir,file))

system(sprintf("unzip -o %s -d %s",
               paste0(denspopdir,file),
               denspopdir))

# READ THE RASTER FILE AND VISUALIZE IT
file2             <- "NER15adjv4.tif" 
denspop           <- raster(paste0(denspopdir,file2))

plot(denspop)
denspop

# TRANSFORM THE COORDINATE SYSTEM -- USING EPSG0: +proj=utm
proj4string(denspop)
denspop_utm       <- projectRaster(denspop, crs = EPSG0) 
denspop_utm
#saved in the setwd --- "~/safe_sepal/data_in/"
writeRaster(denspop_utm,"denspop_utm.tif",format='GTiff',overwrite=TRUE)

# TRANSFORM THE EXTENT -- USING THE EXTENT OF MASK0
mask0
denspop_utm       <- raster(paste0(datadir,"denspop_utm.tif"))
bb                <- extent(194610, 1865340, 1293120,2630580)
extent(denspop)   <- bb
denspop_utm_extent<- setExtent(denspop_utm, bb,keepres=F)
denspop_utm_extent
#saved in the setwd --- "~/safe_sepal/data_in/"
writeRaster(denspop_utm_extent,"denspop_utm_extent.tif",format='GTiff',overwrite=TRUE)

denspop_utm_extent<- raster(paste0(datadir,"denspop_utm_extent.tif"))

# TRANSFORM THE RESOLUTION -- USING THE RESOLUTION OF MASK0

res(mask0)
res(denspop_utm_extent)
#disaggregate from 88.7 x 92.5 resolution to 30x30 (factor = 3)
denspop_utm_extent_res <- disaggregate(denspop_utm_extent, fact=3)
res(denspop_utm_extent_res)
writeRaster(denspop_utm_extent_res,"denspop_utm_extent_res.tif",format='GTiff',overwrite=TRUE)

# ?? Use gdal warp to transform the raster 1 to raster 2 to direclty use mask0 ??

##################### 1.2/ FROM HUMDATA 
# https://data.humdata.org/organization/ocha-niger
url            <- "ftp://ftp.worldpop.org.uk/GIS/Population/Global_2000_2020/2018/NER/ner_ppp_2018.tif"
file           <- "ner_ppp_2018.tif"

download.file(url = url,
              destfile = paste0(denspopdir,file))

# READ THE RASTER FILE AND VISUALIZE IT
denspop2       <- raster(paste0(denspopdir,file))

plot(denspop2)
denspop2

# TRANSFORM THE COORDINATE SYSTEM -- USING EPSG0: +proj=utm
proj4string(denspop2)
EPSG0
denspop2_utm   <- projectRaster(denspop2, crs = EPSG0) 
denspop2_utm
#saved in the setwd --- "~/safe_sepal/data_in/"
writeRaster(denspop2_utm,"denspop2_utm.tif",format='GTiff',overwrite=TRUE)

# TRANSFORM THE EXTENT -- USING THE EXTENT OF MASK0
mask0
denspop2_utm        <- raster(paste0(datadir,"denspop2_utm.tif"))
bb                  <- extent(194610, 1865340, 1293120,2630580)
denspop2_utm_extent <- setExtent(denspop2_utm, bb,keepres=F)
denspop2_utm_extent
#saved in the setwd --- "~/safe_sepal/data_in/"
writeRaster(denspop2_utm_extent,"denspop2_utm_extent.tif",format='GTiff',overwrite=TRUE)

denspop2_utm_extent <- raster(paste0(datadir,"denspop2_utm_extent.tif"))

# TRANSFORM THE RESOLUTION -- USING THE RESOLUTION OF MASK0

res(mask0)
res(denspop2_utm_extent)
#disaggregate from 85.3 x 90.3 resolution to 30x30 (factor = 3)
denspop2_utm_extent_res <- disaggregate(denspop2_utm_extent, fact=3)
res(denspop2_utm_extent_res)
writeRaster(denspop2_utm_extent_res,"denspop2_utm_extent_res.tif",format='GTiff',overwrite=TRUE)

# ?? Use gdal warp to transform the raster 1 to raster 2 to direclty use mask0 ??

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
##################### 2/ SRTM
# Spatial resolution approximately 30 meter on the line of the equator : http://srtm.csi.cgiar.org/srtmdata/ 
# DOWNLOAD MANUALLY THE TILES FALLING ON YOUR AOI
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

# READ THE RASTER FILES 
srtm           <- list.files(path=srtmdir, pattern="*.tif", full.names=T, recursive=FALSE)

# VISUALIZE THEM --> More efficient way?
# And how to see them next to each other ?
srtm_test37_09 <- raster(paste0(srtmdir, "srtm_37_09.tif"))
srtm_test37_10 <- raster(paste0(srtmdir, "srtm_37_10.tif"))
srtm_test38_08 <- raster(paste0(srtmdir, "srtm_38_08.tif"))
srtm_test38_09 <- raster(paste0(srtmdir, "srtm_38_09.tif"))
srtm_test38_10 <- raster(paste0(srtmdir, "srtm_38_10.tif"))
srtm_test39_08 <- raster(paste0(srtmdir, "srtm_39_08.tif"))
srtm_test39_09 <- raster(paste0(srtmdir, "srtm_39_09.tif"))
srtm_test39_10 <- raster(paste0(srtmdir, "srtm_39_10.tif"))
srtm_test40_08 <- raster(paste0(srtmdir, "srtm_40_08.tif"))
srtm_test40_09 <- raster(paste0(srtmdir, "srtm_40_09.tif"))

plot(srtm_test37_09)
plot(srtm_test37_10)
plot(srtm_test38_08)
plot(srtm_test38_09)
plot(srtm_test38_10)
plot(srtm_test39_08)
plot(srtm_test39_09)
plot(srtm_test39_10)
plot(srtm_test40_08)
plot(srtm_test40_09)

# Put all the .tif in one vrt (virtual raster) 
srtm_allfiles  <- list.files(path=srtmdir, pattern="*.tif", full.names=T, recursive=FALSE)
output_vrt     <- paste0(data0dir, "srtm.vrt")
output_tif     <- paste0(data0dir, "srtm.tif")

gdalbuildvrt(gdalfile = srtm_allfiles, # uses all tiffs in the folder srtmdir
             output.vrt = output_vrt,
             separate=F,
             verbose=TRUE
)
# Copy the virtual raster in an actual physical file
# /!\ does not work
gdal_translate(src_dataset = output_vrt, 
               dst_dataset = output_tif, 
               projwin=mask0,
               options = c("BIGTIFF=YES", "COMPRESSION=LZW")
)

# APPLY THE CHANGES (resolution, extent, coordinate system) TO ALL AT THE SAME TIME
# ----> to figure out

# TRANSFORM THE COORDINATE SYSTEM -- USING EPSG0: +proj=utm
# TEST FOR 1, how to do it for all the tiles at the same time ??
EPSG0
srtm_test37_09 <- raster(paste0(srtmdir, "srtm_37_09.tif"))
srtm_test37_09_utm <- projectRaster(srtm_test37_09,crs = EPSG0) 
srtm_test37_09_utm
# saved in the setwd --- "~/safe_sepal/data_in/"
writeRaster(srtm_test37_09_utm,"srtm_test37_09_utm.tif",format='GTiff',overwrite=TRUE)

#OR CHECK : https://dwtkns.com/srtm30m/
#OR CHECK : http://glcf.umd.edu/data/srtm/

# get a slope layer

slope_deg <- terrain(srtm_allfiles, opt='slope', unit='degrees')

##################### ----> WORK TO BE CONTINUED<----- #####################

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
##################### 3/ PRECIPITATION
# ------> Find other data : raster for the country
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

#Getting the Data from: https://biogeo.ucdavis.edu/data/climate/worldclim/1_4/tiles/cur/prec_26.zip




#####################   CHECK YOUR DATA0 FILE : YOU SHOULD HAVE ALL THE FILES IN .tif AND UTM
?ls

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# +008 LU-LC 
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# +009 GFC 
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

##################### CHECK WHICH GFC TILES FALL ON IT
#Calculate the GFC product tiles needed for a given AOI
#https://cran.r-project.org/web/packages/gfcanalysis/gfcanalysis.pdf
tiles           <- calc_gfc_tiles(aoi_utm)

plot(tiles)
plot(aoi)

##################### DOWNLOAD IF NECESSARY
#https://cran.r-project.org/web/packages/gfcanalysis/gfcanalysis.pdf
download_tiles(tiles,output_folder = gfcdir,images = c("treecover2000","lossyear","gain","datamask") )


##################### REPROJECT IN THE CORRECT SYSTEM -> use mask0

for(file in list.files(gfcdir,glob2rx("Hansen*.tif"))){
  input <- paste0(gfcdir,file)
  
  system(sprintf("gdal_translate -co COMPRESS=LZW  -projwin %s %s %s %s %s %s",
                 extent(mask0)@xmin,
                 extent(mask0)@ymax,
                 extent(mask0)@xmax,
                 extent(mask0)@ymin,
                 input,
                 paste0(gfcdir,"crop_",file)
  ))
  
  system(sprintf("gdalwarp -co COMPRESS=LZW  -t_srs \"%s\" %s %s",
                 "+proj=utm +zone=31 +datum=WGS84 +units=m +no_defs +ellps=WGS84 +towgs84=0,0,0",
                 paste0(gfcdir,"crop_",file),
                 paste0(gfcdir,"utm_crop_",file)
  ))
}


