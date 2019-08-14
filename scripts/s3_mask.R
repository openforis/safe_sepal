# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# +000 CREATE A MASK LAYER
# +++1 COUNTRY ADM SHAPEFILE 
# +++2 CREATE RASTER LAYER BOX 
# +++3 RASTERIZE
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# +++1 COUNTRY ADM SHAPEFILE
# add column with numbers for rasterization later on  
aoi_ea$code <- row(aoi_ea)[,1]
#level0
writeOGR(aoi_ea,boundaries_path,boundaries_shp,format_shp,overwrite_layer = T)

# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# +++2 CREATE RASTER LAYER BOX
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

# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# +++3 RASTERIZATION
system(sprintf("python %s/oft-rasterize_attr.py -v %s -i %s -o %s  -a %s",
               scriptdir,
               boundaries_path,
               rbox_path,
               mask_path,
               "code"
))
plot(raster(mask_path))
mask                               <- raster(mask_path)
