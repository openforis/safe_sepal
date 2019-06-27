# +000 EXTRACT LAYERS
# +++1 ELECTRIC LINES -> Electricity Transmission Network
# +++2 GET OSM DATA
# ++++ 1-WATER RESOURCES
# ++++ 1-1-WATER "POIS" - Points of interest
# ++++ 1-2-WATER "OSM" - OpenStreetMap
# ++++ 1-3-WATERWAYS "OSM" - OpenStreetMap
# ++++ 1-4-WATER "NATURAL OSM" - OpenStreetMap
# ++++ 2-ROADS  "roads OSM" - OpenStreetMap
# ++++ 3-RELIGION "POFW OSM" - Places of worship OpenStreetMap
# ++++ 4-SETTLEMENTS - "places OSM" OpenStreetMap
# ++++ 5-HEALTH  - "Points of interestOSM" OpenStreetMap
# ++++ 6-EDUCATION - "Points of interestOSM" OpenStreetMap
# ++++ 7-UNSUITABLE AREAS Points of interestOSM" OpenStreetMap
# ++++ 7-1-UNSUITABLE-LAND - "Land Use OSM" OpenStreetMap
# ++++ 7-2-UNSUITABLE-WATER - "OSM" - OpenStreetMap

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# +000 EXTRACT LAYERS
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## 1/ ELECTRIC LINES 
# Electricity Transmission Network
# https://energydata.info/dataset/niger-electricity-transmission-network-2015
# See details on : http://africagrid.energydata.info/#
# Distribution grid in Niger with neighbouring countries:
# http://www.ecowrex.org/mapView/?mclayers=layerDistributionGrid&lat=1763532.7726153&lon=567395.7928025&zoom=7
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
url_elec          
file_elec          

download.file(url = url_elec,
              destfile = paste0(elecdir,file_elec))

system(sprintf("unzip -o %s -d %s",
               paste0(elecdir,file_elec),
               elecdir))

electricity    <- readOGR(paste0(elecdir,"330_132_66_33_20_kV_lines_NIGER.shp"))
head(electricity)

#0 is "Planned"
electricity$status_code                                             <-0
#1 is "Existing"
electricity$status_code[which(grepl("Existing",electricity$status))]<-1

table(electricity$status_code)

## REPROJECT
electricity_existing_ea<-spTransform(electricity, crs(mask))
writeOGR(electricity_existing_ea, paste0(data0dir, "electricity.shp"), layer= "electricity.shp", driver='ESRI Shapefile', overwrite=T)

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## 2/ GET OSM DATA
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
url_osm         
file_osm

download.file(url = url_osm,
              destfile = paste0(tmpdir,file_osm))

system(sprintf("unzip -o %s -d %s",
               paste0(tmpdir,file_osm),
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
water_pois$water_code                                                  <-0
#1 is drinkig water
water_pois$water_code[which(grepl("drinking_water",water_pois$fclass))]<-1
#2 is water_tower
water_pois$water_code[which(grepl("water_tower",water_pois$fclass))]  <-2
#3 is water_well
water_pois$water_code[which(grepl("water_well",water_pois$fclass))]   <-3
#4 is water_works
water_pois$water_code[which(grepl("water_works",water_pois$fclass))]  <-4

table(water_pois$water_code)

## REPROJECT
water_pois_ea<-spTransform(water_pois, crs(mask))
writeOGR(water_pois_ea, paste0(data0dir, "water_pois_osm.shp"), layer= "water_pois_osm.shp", driver='ESRI Shapefile', overwrite=T)

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

table(water_osm$water_code)

## REPROJECT
water_osm_ea        <-spTransform(water_osm, crs(mask))
writeOGR(water_osm_ea, paste0(data0dir, "water_osm.shp"),layer="water_osm.shp",driver='ESRI Shapefile', overwrite=T)

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

table(waterways_osm$waterways_code)

## REPROJECT
waterways_osm_ea<-spTransform(waterways_osm, crs(mask))
plot(waterways_osm_ea)
plot(aoi_ea,add=T)
writeOGR(waterways_osm_ea, paste0(data0dir, "waterways_osm.shp"), layer="waterways_osm.shp", driver='ESRI Shapefile', overwrite=T)

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

table(water_natural$water_code)

## REPROJECT
water_natural_ea<-spTransform(water_natural, crs(mask))
writeOGR(water_natural_ea, paste0(data0dir,"water_natural_osm.shp"), layer = "water_natural_osm.shp", driver='ESRI Shapefile', overwrite=T)

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## 2/ ROADS  "roads OSM" - OpenStreetMap
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

table(roads$roads_code)

## REPROJECT
roads_ea <-spTransform(roads, crs(mask))
writeOGR(roads_ea, paste0(data0dir,"roads_osm.shp"), layer="roads_osm.shp", driver='ESRI Shapefile', overwrite=T)

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## 3/ RELIGION "POFW OSM" - Places of worship OpenStreetMap
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

table(pofw$religion_code)

## REPROJECT
pofw_ea    <-spTransform(pofw, crs(mask))
writeOGR(pofw_ea, paste0(data0dir, layer="religion_osm.shp"), layer="religion_osm.shp",driver='ESRI Shapefile', overwrite=TRUE)

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## 4/ SETTLEMENTS - "places OSM" OpenStreetMap
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

table(towns$towns_code)

## REPROJECT 
towns_ea            <-spTransform(towns, crs(mask))
writeOGR(towns_ea, paste0(data0dir,"towns_osm.shp"), layer= "towns_osm.shp",driver='ESRI Shapefile', overwrite=T)

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## 5/ HEALTH  - "Points of interestOSM" OpenStreetMap
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

table(health$health_code)

## REPROJECT
health_ea<-spTransform(health, crs(mask))
writeOGR(health_ea, paste0(data0dir,"health_osm.shp"), layer= "health_osm.shp",driver='ESRI Shapefile', overwrite=T)

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## 6/ EDUCATION - "Points of interestOSM" OpenStreetMap
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

table(edu$education_code)

## REPROJECT
edu_ea <-spTransform(edu, crs(mask))
writeOGR(edu_ea, paste0(data0dir, "education_osm.shp"), layer="education_osm.shp", driver='ESRI Shapefile', overwrite=T)

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## 7/ UNSUITABLE AREAS 
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ 
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## 7-1/ UNSUITABLE-LAND - "Land Use OSM" OpenStreetMap
# MORE INFO page 17 : http://download.geofabrik.de/osm-data-in-gis-formats-free.pdf
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
unsuitable       <- readOGR(paste0(tmpdir,"gis_osm_landuse_a_free_1.shp"))
levels(as.factor(unsuitable$fclass))

#0 is NODATA
unsuitable$unsuit_code                                                  <-0
#1 is nature_reserve
unsuitable$unsuit_code[which(grepl("nature_reserve",unsuitable$fclass))]<-1
#2 is military
unsuitable$unsuit_code[which(grepl("military",unsuitable$fclass))]      <-2
#3 is national_park
unsuitable$unsuit_code[which(grepl("national_park",unsuitable$fclass))] <-3

table(unsuitable$unsuit_code)

## REPROJECT
unsuitable_ea        <- spTransform(unsuitable, crs(mask))
writeOGR(unsuitable_ea, paste0(data0dir,"unsuit_land_osm.shp"), layer= "unsuit_land_osm.shp",driver='ESRI Shapefile', overwrite=T, encoding= "UTF-8")

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## 7-2/ UNSUITABLE-WATER - "OSM" - OpenStreetMap
# MORE INFO page 17 : http://download.geofabrik.de/osm-data-in-gis-formats-free.pdf
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
wetland_osm      <- readOGR(paste0(tmpdir,"gis_osm_water_a_free_1.shp"))
levels(as.factor(wetland_osm$fclass))

#0 is NODATA
wetland_osm$water_code                                                  <-0
#1 is wetland
wetland_osm$water_code[which(grepl("wetland",wetland_osm$fclass))]      <-1

table(wetland_osm$water_code)

## REPROJECT
wetland_osm_ea        <-spTransform(wetland_osm, crs(mask))
writeOGR(wetland_osm_ea, paste0(data0dir, "unsuit_wetland_osm.shp"),layer="unsuit_wetland_osm.shp",driver='ESRI Shapefile', overwrite=T)

