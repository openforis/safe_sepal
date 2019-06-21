mask <- raster(paste0(griddir,"mask.tif"))
plot(mask)

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# EXTRACT LAYERS  
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

## GET OSM DATA 
# DATA FOR ALL COUNTRIES http://download.geofabrik.de/
# http://download.geofabrik.de/osm-data-in-gis-formats-free.pdf

url         <- "http://download.geofabrik.de/africa/niger-latest-free.shp.zip"
file        <- "niger-latest-free.shp.zip"

download.file(url = url,
              destfile = paste0(tmpdir,file))

system(sprintf("unzip -o %s -d %s",
               paste0(tmpdir,file),
               tmpdir))

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## 1/ WATER RESOURCES 
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## 1-1/ WATER "POIS" - Points of interest
# MORE INFO page 10-11 : http://download.geofabrik.de/osm-data-in-gis-formats-free.pdf
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
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

water_pois_only <- water_pois[water_pois$water_code !=0,]
head(water_pois_only)

## REPROJECT
water_pois_only_ea<-spTransform(water_pois_only, crs(mask))
plot(water_pois_only_ea)
plot(aoi_ea,add=T)
writeOGR(water_pois_only_ea, paste0(data0dir, "water_pois_osm.shp"), layer= "water_pois_osm.shp", driver='ESRI Shapefile', overwrite=T)

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## 1-2/ WATER "OSM" - OpenStreetMap
# MORE INFO page 17 : http://download.geofabrik.de/osm-data-in-gis-formats-free.pdf
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
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

water_osm_only <- water_osm[water_osm$water_code !=0,]
levels(as.factor(water_osm_only$fclass))

## REPROJECT
water_osm_only_ea        <-spTransform(water_osm_only, crs(mask))
plot(water_osm_only_ea)
plot(aoi_ea, add=T)
writeOGR(water_osm_only_ea, paste0(data0dir, "water_osm.shp"),layer="water_osm.shp",driver='ESRI Shapefile', overwrite=T)

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## 1-3/ WATERWAYS "OSM" - OpenStreetMap 
# MORE INFO page 16 : http://download.geofabrik.de/osm-data-in-gis-formats-free.pdf
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
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

waterways_osm_only <- waterways_osm[waterways_osm$waterways_code !=0,]

## REPROJECT
waterways_osm_only_ea<-spTransform(waterways_osm_only, crs(mask))
plot(waterways_osm_only_ea)
plot(aoi_ea,add=T)
writeOGR(waterways_osm_only_ea, paste0(data0dir, "waterways_osm.shp"), layer="waterways_osm.shp", driver='ESRI Shapefile', overwrite=T)

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## 1-4/ WATER "NATURAL OSM" - OpenStreetMap
# MORE INFO page 11 : http://download.geofabrik.de/osm-data-in-gis-formats-free.pdf
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
water_natural  <- readOGR(paste0(tmpdir,"gis_osm_natural_free_1.shp"))
levels(as.factor(water_natural$fclass))

#0 is NODATA
water_natural$water_code                                             <-0
#1 is spring
water_natural$water_code[which(grepl("spring",water_natural$fclass))]<-1

water_natural_only           <- water_natural[water_natural$water_code !=0,]

## REPROJECT
water_natural_only_ea<-spTransform(water_natural_only, crs(mask))
writeOGR(water_natural_only_ea, paste0(data0dir,"water_natural_osm.shp"), layer = "water_natural_osm.shp", driver='ESRI Shapefile', overwrite=T)

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## 2/ ELECTRIC LINES 
# Electricity Transmission Network
# https://energydata.info/dataset/niger-electricity-transmission-network-2015
# See details on : http://africagrid.energydata.info/#
# Distribution grid in Niger with neighbouring countries:
# http://www.ecowrex.org/mapView/?mclayers=layerDistributionGrid&lat=1763532.7726153&lon=567395.7928025&zoom=7
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
url            <- "https://development-data-hub-s3-public.s3.amazonaws.com/ddhfiles/145469/330132663320kvlinesniger.zip"
file           <- "330132663320kvlinesniger.zip"

download.file(url = url,
              destfile = paste0(elecdir,file))

system(sprintf("unzip -o %s -d %s",
               paste0(elecdir,file),
               elecdir))

electricity    <- readOGR(paste0(elecdir,"330_132_66_33_20_kV_lines_NIGER.shp"))
head(electricity)

#0 is "Planned"
electricity$status_code                                             <-0
#1 is "Existing"
electricity$status_code[which(grepl("Existing",electricity$status))]<-1

electricity_existing_only    <- electricity[electricity$status_code !=0,]

## REPROJECT
electricity_existing_only_ea<-spTransform(electricity_existing_only, crs(mask))
writeOGR(electricity_existing_only_ea, paste0(data0dir, "electricity.shp"), layer= "electricity.shp", driver='ESRI Shapefile', overwrite=T)

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## 3/ ROADS  "roads OSM" - OpenStreetMap
# MORE INFO page 14 : http://download.geofabrik.de/osm-data-in-gis-formats-free.pdf
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ 
roads          <- readOGR(paste0(tmpdir,"gis_osm_roads_free_1.shp"))
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

roads_only     <- roads[roads$roads_code !=0,]

## REPROJECT
roads_only_ea <-spTransform(roads_only, crs(mask))
writeOGR(roads_only_ea, paste0(data0dir,"roads_osm.shp"), layer="roads_osm.shp", driver='ESRI Shapefile', overwrite=T)

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## 4/ RELIGION "POFW OSM" - Places of worship OpenStreetMap
# MORE INFO page 11 : http://download.geofabrik.de/osm-data-in-gis-formats-free.pdf
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
pofw        <- readOGR(paste0(tmpdir,"gis_osm_pofw_free_1.shp"))
levels(as.factor(pofw$fclass))

#0 is NODATA
pofw$religion_code                                       <-0
#1 is christians
pofw$religion_code[which(grepl("christian",pofw$fclass))]<-1
#2 is jewish
pofw$religion_code[which(grepl("jewish",pofw$fclass))]   <-2
#3 is muslims
pofw$religion_code[which(grepl("muslim",pofw$fclass))]   <-3
#4 is buddhist
pofw$religion_code[which(grepl("buddhist",pofw$fclass))] <-4
#5 is hindu
pofw$religion_code[which(grepl("hindu",pofw$fclass))]    <-5
#6 is taoist
pofw$religion_code[which(grepl("taoist",pofw$fclass))]   <-6
#7 is shintoist
pofw$religion_code[which(grepl("shintoist",pofw$fclass))]<-7
#8 is sikh
pofw$religion_code[which(grepl("sikh",pofw$fclass))]     <-8
pofw
head(pofw)

## REPROJECT
pofw_ea    <-spTransform(pofw, crs(mask))
writeOGR(pofw_ea, paste0(data0dir, layer="religion_osm.shp"), layer="religion_osm.shp",driver='ESRI Shapefile', overwrite=TRUE)

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## 5/ SETTLEMENTS - "places OSM" OpenStreetMap
# MORE INFO page 5 and 6 : http://download.geofabrik.de/osm-data-in-gis-formats-free.pdf
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ 
towns      <- readOGR(paste0(tmpdir,"gis_osm_places_free_1.shp"))
levels(as.factor(towns$fclass))

#0 is NODATA
towns$towns_code                                                    <-0
#1 is city
towns$towns_code[which(grepl("city",towns$fclass))]                 <-1
#2 is town
towns$towns_code[which(grepl("town",towns$fclass))]                 <-2
#3 is village
towns$towns_code[which(grepl("village",towns$fclass))]              <-3
#4 is hamlet
towns$towns_code[which(grepl("hamlet",towns$fclass))]               <-4
#5 is national_capital
towns$towns_code[which(grepl("national_capital",towns$fclass))]     <-5
#5 is suburb
towns$towns_code[which(grepl("suburb",towns$fclass))]               <-6

towns_only     <- towns[towns$towns_code !=0,]

## REPROJECT 
towns_only_ea            <-spTransform(towns_only, crs(mask))
writeOGR(towns_only_ea, paste0(data0dir,"towns_osm.shp"), layer= "towns_osm.shp",driver='ESRI Shapefile', overwrite=T)

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## 6/ HEALTH  - "Points of interestOSM" OpenStreetMap
# MORE INFO page 6-7 : http://download.geofabrik.de/osm-data-in-gis-formats-free.pdf
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ 
health      <- readOGR(paste0(tmpdir,"gis_osm_pois_free_1.shp"))
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

health_only    <- health[health$health_code !=0,]

## REPROJECT
health_only_ea<-spTransform(health_only, crs(mask))
writeOGR(health_only_ea, paste0(data0dir,"health_osm.shp"), layer= "health_osm.shp",driver='ESRI Shapefile', overwrite=T)

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## 7/ EDUCATION - "Points of interestOSM" OpenStreetMap
# MORE INFO page 6-7 : http://download.geofabrik.de/osm-data-in-gis-formats-free.pdf
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++  
edu         <- readOGR(paste0(tmpdir,"gis_osm_pois_free_1.shp"))
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

edu_only    <- edu[edu$education_code !=0,]

## REPROJECT
edu_only_ea <-spTransform(edu_only, crs(mask))
writeOGR(edu_only_ea, paste0(data0dir, "education_osm.shp"), layer="education_osm.shp", driver='ESRI Shapefile', overwrite=T)

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## 8/ LANSCAPE TREE-COVER FREE  - "Land Use OSM" OpenStreetMap
# MORE INFO page 17 : http://download.geofabrik.de/osm-data-in-gis-formats-free.pdf
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ 
openareas  <- readOGR(paste0(tmpdir,"gis_osm_landuse_a_free_1.shp"))
levels(as.factor(openareas$fclass))

#0 is NODATA
openareas$open_code                                         <-0
#1 is meadow
openareas$open_code[which(grepl("meadow",openareas$fclass))]<-1
#2 is grass
openareas$open_code[which(grepl("grass",openareas$fclass))] <-2
#3 is heath=uncultivated land
openareas$open_code[which(grepl("heath",openareas$fclass))] <-3

openareas_only     <- openareas[openareas$open_code !=0,]

## REPROJECT
openareas_only_ea <- spTransform(openareas_only, crs(mask))
writeOGR(openareas_only_ea, paste0(data0dir,"openareas_osm.shp"), layer= "openareas_osm.shp",driver='ESRI Shapefile', overwrite=T)

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## 9/ OPEN HABITAT 
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ 
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## 9-1/ UNSUITABLE-LAND - "Land Use OSM" OpenStreetMap
# MORE INFO page 17 : http://download.geofabrik.de/osm-data-in-gis-formats-free.pdf
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
unsuitable       <- readOGR(paste0(tmpdir,"gis_osm_landuse_a_free_1.shp"))
levels(as.factor(unsuitable$fclass))

#0 is NODATA
unsuitable$unsuit_code                                                  <-0
#1 is agricultural land : farms and areas where crops are grown
unsuitable$unsuit_code[which(grepl("farm",unsuitable$fclass))]          <-1
#2 is nature_reserve
unsuitable$unsuit_code[which(grepl("nature_reserve",unsuitable$fclass))]<-2
#3 is military
unsuitable$unsuit_code[which(grepl("military",unsuitable$fclass))]      <-3
#4 is national_park
unsuitable$unsuit_code[which(grepl("national_park",unsuitable$fclass))] <-4

unsuitable_only  <- unsuitable[unsuitable$unsuit_code !=0,]

## REPROJECT
unsuitable_only_ea        <- spTransform(unsuitable_only, crs(mask))
writeOGR(unsuitable_only_ea, paste0(data0dir,"unsuit_land_osm.shp"), layer= "unsuit_land_osm.shp",driver='ESRI Shapefile', overwrite=T)

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## 9-2/ UNSUITABLE-WATER - "OSM" - OpenStreetMap
# MORE INFO page 17 : http://download.geofabrik.de/osm-data-in-gis-formats-free.pdf
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
wetland_osm      <- readOGR(paste0(tmpdir,"gis_osm_water_a_free_1.shp"))
levels(as.factor(wetland_osm$fclass))

#0 is NODATA
wetland_osm$water_code                                                  <-0
#1 is wetland
wetland_osm$water_code[which(grepl("wetland",wetland_osm$fclass))]      <-1

wetland_osm_only     <- wetland_osm[wetland_osm$water_code !=0,]

## REPROJECT
wetland_osm_only_ea        <-spTransform(wetland_osm_only, crs(mask))
writeOGR(wetland_osm_only_ea, paste0(data0dir, "unsuit_wetland_osm.shp"),layer="unsuit_wetland_osm.shp",driver='ESRI Shapefile', overwrite=T)

