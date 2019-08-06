# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# +000 EXTRACT LAYERS
# +++1 electricity grid 
# +++2 OpenStreetMap
# ++++ 2.1. -WATER RESOURCES
# ++++ 2.1.1-WATER "POIS" - Points of interest
# ++++ 2.1.2-WATER "OSM" - OpenStreetMap
# ++++ 2.1.3-WATERWAYS "OSM" - OpenStreetMap
# ++++ 2.1.4-WATER "NATURAL OSM" - OpenStreetMap
# ++++ 2.2. -ROADS  "roads OSM" - OpenStreetMap
# ++++ 2.3. -RELIGION "POFW OSM" - Places of worship OpenStreetMap
# ++++ 2.4. -TOWNS - "places OSM" OpenStreetMap
# ++++ 2.5. -HEALTH  - "Points of interestOSM" OpenStreetMap
# ++++ 2.6. -EDUCATION - "Points of interestOSM" OpenStreetMap
# ++++ 2.7. -UNSUITABLE AREAS Points of interestOSM" OpenStreetMap
# ++++ 2.7.1-UNSUITABLE-LAND-NATURE RESERVE/PARC - "Land Use OSM" OpenStreetMap
# ++++ 2.7.2-UNSUITABLE-LAND-MILITARY AREAS- "Land Use OSM" OpenStreetMap
# ++++ 2.7.3-UNSUITABLE-WATER - "OSM" - OpenStreetMap
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# +++1 electricity grid  
# Electricity Transmission Network, https://energydata.info/dataset/niger-electricity-transmission-network-2015

download.file(url = url_elec,
              destfile = paste0(elecdir,file_elec))

system(sprintf("unzip -o %s -d %s",
               paste0(elecdir,file_elec),
               elecdir))

electricity    <- readOGR(elec_shp)
head(electricity)

#0 is "Planned"
electricity$status_code                                             <-0
#1 is "Existing"
electricity$status_code[which(grepl("Existing",electricity$status))]<-1

table(electricity$status_code)

## REPROJECT
electricity_existing_ea <- spTransform(electricity, proj4string(mask))
writeOGR(electricity_existing_ea, electricity_path, layer= electricity_shp, driver=format_shp, overwrite=T)

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# +++2 OpenStreetMap

download.file(url = url_osm,
              destfile = paste0(tmpdir,file_osm))

system(sprintf("unzip -o %s -d %s",
               paste0(tmpdir,file_osm),
               tmpdir))

# ++++ 2.1. -WATER RESOURCES
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

# ++++ 2.1.1-WATER "POIS" - Points of interest
# MORE INFO page 10-11 : http://download.geofabrik.de/osm-data-in-gis-formats-free.pdf
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
water_pois     <- readOGR(pts_of_interest_path_in)
levels(as.factor(water_pois$fclass))

#0 is NODATA
water_pois$water_code                                                  <-0
#1 is drinkig water
water_pois$water_code[which(grepl("drinking_water",water_pois$fclass))]<-1
#2 is water_tower
water_pois$water_code[which(grepl("water_tower",water_pois$fclass))]   <-2
#3 is water_well
water_pois$water_code[which(grepl("water_well",water_pois$fclass))]    <-3
#4 is water_works 
water_pois$water_code[which(grepl("water_works",water_pois$fclass))]   <-4

table(water_pois$water_code)

## REPROJECT
water_pois_ea<-spTransform(water_pois, proj4string(mask))
writeOGR(water_pois_ea, water_pois_path, layer= water_pois_shp, driver=format_shp, overwrite=T)

# ++++ 2.1.2-WATER "OSM" - OpenStreetMap
# MORE INFO page 17 : http://download.geofabrik.de/osm-data-in-gis-formats-free.pdf
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
water_osm      <- readOGR(water_path_in)
levels(as.factor(water_osm$fclass))

#0 is NODATA
water_osm$water_code                                            <-0
#1 is water
water_osm$water_code[which(grepl("water",water_osm$fclass))]    <-1
#2 is reservoir
water_osm$water_code[which(grepl("reservoir",water_osm$fclass))]<-2
#3 is river
water_osm$water_code[which(grepl("river",water_osm$fclass))]    <-3

table(water_osm$water_code)

## REPROJECT
water_osm_ea        <-spTransform(water_osm, proj4string(mask))
water_osm_ea@data   <- water_osm_ea@data[,c("osm_id","water_code","fclass")]
writeOGR(water_osm_ea, water_path,layer=water_shp,driver=format_shp, overwrite=T)
head(water_osm_ea)

# ++++ 2.1.3-WATERWAYS "OSM" - OpenStreetMap
# MORE INFO page 16 : http://download.geofabrik.de/osm-data-in-gis-formats-free.pdf
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
waterways_osm  <- readOGR(waterways_path_in)
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
waterways_osm_ea<-spTransform(waterways_osm, proj4string(mask))
writeOGR(waterways_osm_ea, waterways_path, layer=waterways_shp, driver=format_shp, overwrite=T)

# ++++ 2.1.4-WATER "NATURAL OSM" - OpenStreetMap
# MORE INFO page 11 : http://download.geofabrik.de/osm-data-in-gis-formats-free.pdf
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
water_natural  <- readOGR(natural_path_in)
levels(as.factor(water_natural$fclass))

#0 is NODATA
water_natural$water_code                                             <-0
#1 is spring
water_natural$water_code[which(grepl("spring",water_natural$fclass))]<-1

table(water_natural$water_code)

## REPROJECT
water_natural_ea<-spTransform(water_natural, proj4string(mask))
writeOGR(water_natural_ea, water_natural_path, layer = water_natural_shp, driver=format_shp, overwrite=T)

# ++++ 2.2. -ROADS  "roads OSM" - OpenStreetMap
# MORE INFO page 14 : http://download.geofabrik.de/osm-data-in-gis-formats-free.pdf
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ 
roads          <- readOGR(roads_path_in)
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
roads_ea <-spTransform(roads, proj4string(mask))
writeOGR(roads_ea, roads_path, layer=roads_shp, driver=format_shp, overwrite=T)

# ++++ 2.3. -RELIGION "POFW OSM" - Places of worship OpenStreetMap
# MORE INFO page 11 : http://download.geofabrik.de/osm-data-in-gis-formats-free.pdf
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
pofw        <- readOGR(places_of_worship_path_in)
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
pofw_ea    <-spTransform(pofw, proj4string(mask))
writeOGR(pofw_ea, religion_path, layer=religion_shp,driver=format_shp, overwrite=TRUE)

# ++++ 2.4. -TOWNS - "places OSM" OpenStreetMap
# MORE INFO page 5 and 6 : http://download.geofabrik.de/osm-data-in-gis-formats-free.pdf
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ 
towns      <- readOGR(towns_path_in)
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
#6 is suburb
towns$towns_code[which(grepl("suburb",towns$fclass))]               <-6

table(towns$towns_code)

## REPROJECT 
towns_ea            <-spTransform(towns, proj4string(mask))
writeOGR(towns_ea, towns_path, layer= towns_shp,driver=format_shp, overwrite=T)

# ++++ 2.5. -HEALTH  - "Points of interestOSM" OpenStreetMap
# MORE INFO page 6-7 : http://download.geofabrik.de/osm-data-in-gis-formats-free.pdf
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ 
health      <- readOGR(pts_of_interest_path_in)
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
health_ea<-spTransform(health, proj4string(mask))
writeOGR(health_ea, health_path, layer= health_shp,driver=format_shp, overwrite=T)

# ++++ 2.6. -EDUCATION - "Points of interestOSM" OpenStreetMap
# MORE INFO page 6-7 : http://download.geofabrik.de/osm-data-in-gis-formats-free.pdf
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++  
edu         <- readOGR(pts_of_interest_path_in)
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
edu_ea <-spTransform(edu, proj4string(mask))
writeOGR(edu_ea, education_path, layer=education_shp, driver=format_shp, overwrite=T)

# ++++ 2.7. -UNSUITABLE AREAS Points of interestOSM" OpenStreetMap
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ 

# ++++ 2.7.1-UNSUITABLE-LAND-NATURE RESERVE/PARC - "Land Use OSM" OpenStreetMap
# MORE INFO page 17 : http://download.geofabrik.de/osm-data-in-gis-formats-free.pdf
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
unsuitable_reserves      <- readOGR(landuse_path_in)
levels(as.factor(unsuitable_reserves$fclass))
head(unsuitable_reserves)

#0 is NODATA
unsuitable_reserves$unsuit_code                                                           <-0
#1 is nature_reserve
unsuitable_reserves$unsuit_code[which(grepl("nature_reserve",unsuitable_reserves$fclass))]<-1
#2 is national_park
unsuitable_reserves$unsuit_code[which(grepl("national_park",unsuitable_reserves$fclass))] <-2

table(unsuitable_reserves$unsuit_code)

## REPROJECT
unsuitable_reserves_ea        <- spTransform(unsuitable_reserves, proj4string(mask))
unsuitable_reserves_ea@data   <- unsuitable_reserves_ea@data[,c("osm_id","unsuit_code","fclass")]
writeOGR(unsuitable_reserves_ea, unsuit_land_reserves_path, layer= unsuit_land_reserves_shp,driver=format_shp, overwrite=T)

head(unsuitable_reserves_ea)

# ++++ 2.7.2-UNSUITABLE-LAND-MILITARY AREAS- "Land Use OSM" OpenStreetMap
# MORE INFO page 17 : http://download.geofabrik.de/osm-data-in-gis-formats-free.pdf
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
unsuitable_military       <- readOGR(landuse_path_in)
levels(as.factor(unsuitable_military$fclass))

#0 is NODATA
unsuitable_military$unsuit_code                                                           <-0
#1 is military
unsuitable_military$unsuit_code[which(grepl("military",unsuitable_military$fclass))]      <-1
table(unsuitable_military$unsuit_code)

## REPROJECT
unsuitable_military_ea        <- spTransform(unsuitable_military, proj4string(mask))
unsuitable_military_ea@data   <- unsuitable_military_ea@data[,c("osm_id","unsuit_code","fclass")]
writeOGR(unsuitable_military_ea, unsuit_land_military_path, layer= unsuit_land_military_shp,driver=format_shp, overwrite=T)

head(unsuitable_military_ea)

# ++++ 2.7.3-UNSUITABLE-WATER - "OSM" - OpenStreetMap
# MORE INFO page 17 : http://download.geofabrik.de/osm-data-in-gis-formats-free.pdf
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
wetland_osm      <- readOGR(water_path_in)
levels(as.factor(wetland_osm$fclass))
head(wetland_osm)
#0 is NODATA
wetland_osm$water_code                                                  <-0
#1 is wetland
wetland_osm$water_code[which(grepl("wetland",wetland_osm$fclass))]      <-1
table(wetland_osm$water_code)
head(wetland_osm)

## REPROJECT
wetland_osm_ea        <-spTransform(wetland_osm,proj4string(mask))
wetland_osm_ea@data   <- wetland_osm_ea@data[,c("osm_id","water_code","fclass")]
head(wetland_osm_ea)
writeOGR(wetland_osm_ea, unsuit_wetland_path,layer=unsuit_wetland_shp,driver=format_shp, overwrite=T)
