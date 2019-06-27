# +000 PARAMETERS FOR YOUR AOI
# +++1 DEFINE COUNTRY OF INTEREST
# +++2 DEFINE PROJECTION
# +++3 DEFINE RESOLUTION
# +++4 GET OSM DATA

rm(list=ls())
#Do you need 8bits, 16bits, 32bits?
#(extent(aoi_ea)@xmax - extent(aoi_ea)@xmin)/30
#(extent(aoi_ea)@ymax - extent(aoi_ea)@ymin)/30
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
#s4_data_in.R, line 39, you need to ask R to read the shapefile and head() to see what's inside the shapefile so not automatic
url_elec            <- "https://development-data-hub-s3-public.s3.amazonaws.com/ddhfiles/145469/330132663320kvlinesniger.zip"
file_elec           <- "330132663320kvlinesniger.zip"

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## SRTM
# Get more info on Niger: https://eros.usgs.gov/westafrica/ecoregions-and-topography/ecoregions-and-topography-niger
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# SRTM 90m 
srtm01 <- getData('SRTM',lon=0,lat=15, path = srtmdir)
srtm11 <- getData('SRTM',lon=5,lat=15, path = srtmdir)
srtm21 <- getData('SRTM',lon=10,lat=15, path = srtmdir)
srtm02 <- getData('SRTM',lon=0,lat=20, path = srtmdir)
srtm12 <- getData('SRTM',lon=5,lat=20, path = srtmdir)
srtm22 <- getData('SRTM',lon=10,lat=20, path = srtmdir)
srtm32 <- getData('SRTM',lon=15,lat=20, path = srtmdir)
srtm13 <- getData('SRTM',lon=5,lat=25, path = srtmdir)
srtm23 <- getData('SRTM',lon=10,lat=25, path = srtmdir)
srtm33 <- getData('SRTM',lon=15,lat=25, path = srtmdir)
