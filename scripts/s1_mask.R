# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# CREATE A MASK LAYER
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

## GET COUNTRY ADM 
#COUNTRY CODE ON http://kirste.userpage.fu-berlin.de/diverse/doc/ISO_3166.html
aoi        <- getData('GADM',
                      path=admdir,
                      country= "NER",
                      level=0)
plot(aoi)
aoi

## REPROJECT 
#COUNTRY'S COORDINATES https://epsg.io/
#proj_ea   <- CRS("+init=epsg:32631")

proj_ea <- CRS("+proj=aea +lat_1=20 +lat_2=-23 +lat_0=0 +lon_0=25 +x_0=0 +y_0=0 +datum=WGS84 +units=m +no_defs")
aoi_ea   <-spTransform(aoi, proj_ea)
plot(aoi_ea)
aoi_ea@bbox
extent(aoi_ea)

## CREATE SHAPEFILE
aoi_ea$code <- row(aoi_ea)[,1]
writeOGR(aoi_ea,paste0(griddir,"boundaries_level0.shp"),"boundaries_level0","ESRI Shapefile",overwrite_layer = T)

## CREATE RASTER LAYER BOX : INTEGER COLUMNS AND LINES 
## RESOLUTION, EXTENT AND CRS

res0        <- 30
ext0        <- extent(aoi_ea)
ext0[1]     <- (floor(ext0[1]/res0)+1)*res0
ext0[2]     <- (floor(ext0[2]/res0)+1)*res0
ext0[3]     <- (floor(ext0[3]/res0)+1)*res0
ext0[4]     <- (floor(ext0[4]/res0)+1)*res0
nbcol0      <- (ext0[2]-ext0[1])/res0
nbrow0      <- (ext0[4]-ext0[3])/res0

extent(aoi_ea)
ext0

r           <- raster(ncols=nbcol0,nrows=nbrow0)
extent(r)   <- ext0
crs(r)      <- proj_ea
r

# Function : adds "1" in each cell -- RUN MAY TAKE TIME
set1f       <- function(x){rep(1, x)}
rbox        <- init(r, fun=set1f, filename='rbox.tif', overwrite=TRUE)
rbox        <- init(r, fun=set1f, filename=paste0(griddir,"rbox.tif"), overwrite=TRUE)
rbox
plot(rbox)
plot(aoi_ea,add=TRUE)

# RASTERIZE
system(sprintf("python %s/oft-rasterize_attr.py -v %s -i %s -o %s  -a %s",
               scriptdir,
               paste0(griddir,"boundaries_level0.shp"),
               paste0(griddir,"rbox.tif"),
               paste0(griddir, "mask.tif"),
               "code"
))
plot(raster(paste0(griddir, "mask.tif")))

# Compress mask
# COMPRESS NOT NECESSARY - ALREADY WITHIN "oft-rasterize"
#system(sprintf("gdal_translate -ot Byte -co COMPRESS=LZW %s %s " ,
#               paste0(griddir, "mask.tif"),
#               paste0(griddir, "mask0.tif")
#))
