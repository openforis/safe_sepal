# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# +000 PARAMETERS FOR YOUR AOI
# +++1 DEFINE COUNTRY OF INTEREST
# +++2 DEFINE PROJECTION
# +++3 DEFINE RESOLUTION
# +++4 GET DATA
#      country boundaries
#      OpenStreetMap
#      electricity grid 
#      SRTM 
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# +++1 DEFINE COUNTRY OF INTEREST
# Codes on : http://kirste.userpage.fu-berlin.de/diverse/doc/ISO_3166.html

countrycode         <- "NER"

# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# +++2 DEFINE PROJECTION
# Countries' coordinates on: https://epsg.io/

# proj_ea           <- CRS("+init=epsg:32631")
proj_ea             <- CRS("+proj=aea +lat_1=20 +lat_2=-23 +lat_0=0 +lon_0=25 +x_0=0 +y_0=0 +datum=WGS84 +units=m +no_defs")

# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# +++3 DEFINE RESOLUTION
res0                <- 90

# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# +++4 GET DATA

# country boundaries
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#Level 0
aoi         <- getData('GADM',
                       path=admdir,
                       country= countrycode,
                       level=0)
plot(aoi)

## REPROJECT 
aoi_ea      <- spTransform(aoi, proj_ea)
plot(aoi_ea)
aoi_ea@bbox

#Level 1
aoi_1         <- getData('GADM',
                       path=admdir,
                       country= countrycode,
                       level=1)
plot(aoi_1)

## REPROJECT 
aoi_ea_1      <- spTransform(aoi_1, proj_ea)
plot(aoi_ea_1)
aoi_ea_1@bbox

# OpenStreetMap
# Countries' data on : http://download.geofabrik.de/
# Info on data on : http://download.geofabrik.de/osm-data-in-gis-formats-free.pdf, 
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
url_osm             <- "http://download.geofabrik.de/africa/niger-latest-free.shp.zip"
file_osm            <- "osm.zip"

## electricity grid
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

url_elec            <- "https://development-data-hub-s3-public.s3.amazonaws.com/ddhfiles/145469/330132663320kvlinesniger.zip"
file_elec           <- "electricity.zip"
elec_shp            <- paste0(elecdir,"330_132_66_33_20_kV_lines_NIGER.shp")


## SRTM 90m
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# download of the shapefile containing the srtm tile grid

url_srtm_grid       <- "http://www.gis-blog.com/wp-content/uploads/2017/01/srtm.zip"
file_srtm           <- "srtm.zip"
