# +000 CREATE A MASK LAYER
# +++1 GET COUNTRY ADM (OSM)
# +++2 REPROJECT
# +++3 CREATE SHAPEFILE
# +++4 CREATE RASTER LAYER BOX 
# +++5 RASTERIZE
 
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# CREATE A MASK LAYER
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## GET COUNTRY ADM 

aoi         <- getData('GADM',
                      path=admdir,
                      country= countrycode,
                      level=0)
plot(aoi)

## REPROJECT 
aoi_ea      <- spTransform(aoi, proj_ea)
plot(aoi_ea)
aoi_ea@bbox

## CREATE SHAPEFILE
aoi_ea$code <- row(aoi_ea)[,1]
writeOGR(aoi_ea,boundaries_level0_path,boundaries_level0_shp,format_shp,overwrite_layer = T)

## CREATE RASTER LAYER BOX
## INTEGER COLUMNS AND LINES; DEFINE RESOLUTION, EXTENT 
res0
ext0        <-  extent(aoi_ea)
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
rbox        <- init(r, fun=set1f, filename=rbox_path, overwrite=TRUE)
rbox
plot(rbox)
plot(aoi_ea,add=TRUE)

# RASTERIZE
system(sprintf("python %s/oft-rasterize_attr.py -v %s -i %s -o %s  -a %s",
               scriptdir,
               boundaries_level0_path,
               rbox_path,
               mask_path,
               "code"
))
plot(raster(mask_path))

# Compress mask
# COMPRESS NOT NECESSARY - ALREADY WITHIN "oft-rasterize"
#system(sprintf("gdal_translate -ot Byte -co COMPRESS=LZW %s %s " ,
#               paste0(griddir, "mask.tif"),
#               paste0(griddir, "mask0.tif")
#))
