# +000 PARAMETERS FOR YOUR AOI
# +++1 DEFINE COUNTRY OF INTEREST
# +++2 DEFINE PROJECTION
# +++3 DEFINE RESOLUTION
# +++4 GET OSM DATA

rm(list=ls())
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# +000 PARAMETERS FOR YOUR AOI
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# DEFINE COUNTRY OF INTEREST
# Codes on : http://kirste.userpage.fu-berlin.de/diverse/doc/ISO_3166.html
countrycode <- "NER"

# DEFINE PROJECTION
# Countries' coordinates on: https://epsg.io/
# proj_ea   <- CRS("+init=epsg:32631")
proj_ea     <- CRS("+proj=aea +lat_1=20 +lat_2=-23 +lat_0=0 +lon_0=25 +x_0=0 +y_0=0 +datum=WGS84 +units=m +no_defs")

# DEFINE RESOLUTION
res0        <- 30

## GET OSM DATA 
# Countries' data on : http://download.geofabrik.de/
# Info on data on : http://download.geofabrik.de/osm-data-in-gis-formats-free.pdf

url_osm         <- "http://download.geofabrik.de/africa/niger-latest-free.shp.zip"
file_osm        <- "niger-latest-free.shp.zip"

## GET ELECTRICITY GRID DATA 
url_elec            <- "https://development-data-hub-s3-public.s3.amazonaws.com/ddhfiles/145469/330132663320kvlinesniger.zip"
file_elec           <- "330132663320kvlinesniger.zip"
