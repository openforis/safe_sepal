# +000 RASTERIZE LAYERS
# +++1 FROM SHAEPFILES TO RASTERS
# +++2 ALIGN RASTERS TO MASK

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## BORDERS 
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
border  <- readOGR(paste0(griddir,"boundaries_level0.shp"))
head(border)

## RASTERIZE 
system(sprintf("python %s/oft-rasterize_attr.py -v %s -i %s -o %s  -a %s",
               scriptdir,
               paste0(griddir,"boundaries_level0.shp"),
               paste0(griddir,"mask.tif"),
               paste0(data0dir, "border.tif"),
               "code"
))
plot(raster(paste0(data0dir, "border.tif")))
gdalinfo(paste0(data0dir,"border.tif"))

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## WATER RESOURCES 
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## -1/ WATER "POIS" - Points of interest, OpenStreetMap 
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
water_pois_osm  <- readOGR(paste0(data0dir,"water_pois_osm.shp"))
head(water_pois_osm)

## RASTERIZE 
system(sprintf("python %s/oft-rasterize_attr.py -v %s -i %s -o %s  -a %s",
               scriptdir,
               paste0(data0dir,"water_pois_osm.shp"),
               paste0(griddir,"mask.tif"),
               paste0(data0dir, "water_pois.tif"),
               "water_code"
))
plot(raster(paste0(data0dir, "water_pois.tif")))
gdalinfo(paste0(data0dir,"water_pois.tif"))

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## -2/ WATER "OSM" - OpenStreetMap  
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
water_osm             <- readOGR(paste0(data0dir,"water_osm.shp"))
head(water_osm)

## RASTERIZE 
system(sprintf("python %s/oft-rasterize_attr.py -v %s -i %s -o %s  -a %s",
               scriptdir,
               paste0(data0dir,"water_osm.shp"),
               paste0(griddir,"mask.tif"),
               paste0(data0dir, "water.tif"),
               "water_code"
))
plot(raster(paste0(data0dir, "water.tif")))
gdalinfo(paste0(data0dir,"water.tif"))

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## -3/ WATERWAYS "OSM" - OpenStreetMap
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
waterways_osm    <- readOGR(paste0(data0dir, "waterways_osm.shp"))
head(waterways_osm)

## RASTERIZE 
system(sprintf("python %s/oft-rasterize_attr.py -v %s -i %s -o %s  -a %s",
               scriptdir,
               paste0(data0dir,"waterways_osm.shp"),
               paste0(griddir,"mask.tif"),
               paste0(data0dir, "waterways.tif"),
               "wtrwys_"
))
plot(raster(paste0(data0dir, "waterways.tif")))
gdalinfo(paste0(data0dir,"waterways.tif"))

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## -4/ WATER "NATURAL OSM" - OpenStreetMap
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
water_natural_osm             <- readOGR(paste0(data0dir,"water_natural_osm.shp"))
head(water_natural_osm)

## RASTERIZE 
system(sprintf("python %s/oft-rasterize_attr.py -v %s -i %s -o %s  -a %s",
               scriptdir,
               paste0(data0dir,"water_natural_osm.shp"),
               paste0(griddir,"mask.tif"),
               paste0(data0dir, "water_natural.tif"),
               "water_code"
))
plot(raster(paste0(data0dir, "water_natural.tif")))
gdalinfo(paste0(data0dir,"water_natural.tif"))

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## WATER RESSOURCES - COMPILATION 
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

# SURFACE WATER = 1, other =0 
system(sprintf("gdal_calc.py -A %s -B %s -C %s --co=\"COMPRESS=LZW\" --outfile=%s --calc=\"%s\" --overwrite",
               paste0(data0dir,"water_pois.tif"),
               paste0(data0dir,"water.tif"),
               paste0(data0dir,"waterways.tif"),
               paste0(data0dir,"surf_water.tif"),
               "((A==1)+(A==2)+(A==4)+(B>0)+(C>0))*1"
))
GDALinfo(paste0(data0dir,"surf_water.tif"))
plot(raster(paste0(data0dir, "surf_water.tif")))

# UNDERGROUND WATER = 1, other =0
system(sprintf("gdal_calc.py -A %s -B %s --co=\"COMPRESS=LZW\" --outfile=%s --calc=\"%s\" --overwrite",
               paste0(data0dir,"water_pois.tif"),
               paste0(data0dir,"water_natural.tif"),
               paste0(data0dir,"under_water.tif"),
               "((A==3)+(B==1))*1"
))
GDALinfo(paste0(data0dir,"under_water.tif"))
plot(raster(paste0(data0dir, "under_water.tif")))

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## ELECTRIC LINES 
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
electricity             <- readOGR(paste0(data0dir,"electricity.shp"))
head(electricity)

system(sprintf("python %s/oft-rasterize_attr.py -v %s -i %s -o %s  -a %s",
               scriptdir,
               paste0(data0dir,"electricity.shp"),
               paste0(griddir,"mask.tif"),
               paste0(data0dir, "electricity.tif"),
               "stts_cd "
))
plot(raster(paste0(data0dir, "electricity.tif")))
gdalinfo(paste0(data0dir,"electricity.tif"))

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## ROADS  "roads OSM" - OpenStreetMap
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
roads_osm      <- readOGR(paste0(data0dir, "roads_osm.shp"))
head(roads_osm)

## RASTERIZE 
system(sprintf("python %s/oft-rasterize_attr.py -v %s -i %s -o %s  -a %s",
               scriptdir,
               paste0(data0dir,"roads_osm.shp"),
               paste0(griddir,"mask.tif"),
               paste0(data0dir, "roads.tif"),
               "roads_code"
))
plot(raster(paste0(data0dir, "roads.tif")))
gdalinfo(paste0(data0dir,"roads.tif"))

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## RELIGION "POFW OSM" - Places of worship OpenStreetMap
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
pofw    <- readOGR(paste0(data0dir, "religion_osm.shp"))
head(pofw)

## RASTERIZE 
system(sprintf("python %s/oft-rasterize_attr.py -v %s -i %s -o %s  -a %s",
               scriptdir,
               paste0(data0dir, "religion_osm.shp"),
               paste0(griddir, "mask.tif"),
               paste0(data0dir, "religion.tif"),
               "rlgn_cd"
))
plot(raster(paste0(data0dir, "religion.tif")))
gdalinfo(paste0(data0dir, "religion.tif"))

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## SETTLEMENTS - "places OSM" OpenStreetMap
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ 
towns_osm        <- readOGR(paste0(data0dir, "towns_osm.shp"))
head(towns_osm)

## RASTERIZE 
system(sprintf("python %s/oft-rasterize_attr.py -v %s -i %s -o %s  -a %s",
               scriptdir,
               paste0(data0dir,"towns_osm.shp"),
               paste0(griddir,"mask.tif"),
               paste0(data0dir, "towns.tif"),
               "towns_code"
))
plot(raster(paste0(data0dir, "towns.tif")))

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## HEALTH  - "Points of interest OSM" OpenStreetMap
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ 
health_osm     <- readOGR(paste0(data0dir,"health_osm.shp"))
head(health_osm)

## RASTERIZE 
system(sprintf("python %s/oft-rasterize_attr.py -v %s -i %s -o %s  -a %s",
               scriptdir,
               paste0(data0dir,"health_osm.shp"),
               paste0(griddir,"mask.tif"),
               paste0(data0dir, "health.tif"),
               "hlth_cd"
))
plot(raster(paste0(data0dir, "health.tif")))
gdalinfo(paste0(data0dir,"health.tif"))

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## EDUCATION - "Points of interestOSM" OpenStreetMap
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++  
edu_osm        <- readOGR(paste0(data0dir,"education_osm.shp"))
head(edu_osm)

## RASTERIZE 
system(sprintf("python %s/oft-rasterize_attr.py -v %s -i %s -o %s  -a %s",
               scriptdir,
               paste0(data0dir,"education_osm.shp"),
               paste0(griddir,"mask.tif"),
               paste0(data0dir,"education.tif"),
               "edctn_c"
))
plot(raster(paste0(data0dir, "education.tif")))
gdalinfo(paste0(data0dir,"education.tif"))

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## OPEN HABITAT  - "Land Use OSM" OpenStreetMap
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ 
openareas_osm      <- readOGR(paste0(data0dir,"openareas_osm.shp"))
head(openareas_osm)

## RASTERIZE 
system(sprintf("python %s/oft-rasterize_attr.py -v %s -i %s -o %s  -a %s",
               scriptdir,
               paste0(data0dir,"openareas_osm.shp"),
               paste0(griddir,"mask.tif"),
               paste0(data0dir, "openareas.tif"),
               "open_code"
))
plot(raster(paste0(data0dir, "openareas.tif")))
gdalinfo(paste0(data0dir,"openareas.tif"))

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## UNSUITABLE AREAS 
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ 
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## -1/ UNSUITABLE LAND - "Land Use OSM" OpenStreetMap
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
unsuit_land_osm           <- readOGR(paste0(data0dir,"unsuit_land_osm.shp"))
head(unsuit_land_osm)

## RASTERIZE 
system(sprintf("python %s/oft-rasterize_attr.py -v %s -i %s -o %s  -a %s",
               scriptdir,
               paste0(data0dir,"unsuit_land_osm.shp"),
               paste0(griddir,"mask.tif"),
               paste0(data0dir, "unsuit_land.tif"),
               "unst_cd"
))
plot(raster(paste0(data0dir, "unsuit_land.tif")))
gdalinfo(paste0(data0dir,"unsuit_land.tif"))
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## -2/ UNSUITABLE-WATER - "OSM" - OpenStreetMap
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
wetland_osm             <- readOGR(paste0(data0dir,"unsuit_wetland_osm.shp"))
head(wetland_osm)

## RASTERIZE 
system(sprintf("python %s/oft-rasterize_attr.py -v %s -i %s -o %s  -a %s",
               scriptdir,
               paste0(data0dir,"unsuit_wetland_osm.shp"),
               paste0(griddir,"mask.tif"),
               paste0(data0dir, "unsuit_wetland.tif"),
               "water_code"
))
plot(raster(paste0(data0dir, "unsuit_wetland.tif")))
gdalinfo(paste0(data0dir,"unsuit_wetland.tif"))

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## UNSUITABLE - COMPILATION
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

# RASTER : unsuitable = 1, other =0 
system(sprintf("gdal_calc.py -A %s -B %s --co=\"COMPRESS=LZW\" --outfile=%s --calc=\"%s\" --overwrite",
               paste0(data0dir,"unsuit_land.tif"),
               paste0(data0dir,"unsuit_wetland.tif"),
               paste0(data0dir,"unsuitable.tif"),
               "((A>0)+(B>0))*1"
))

GDALinfo(paste0(data0dir,"unsuitable.tif"))
plot(raster(paste0(data0dir, "unsuitable.tif")))

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

srtm   <- list.files(
                     path=srtmdir,
                     pattern=glob2rx("srtm*.tif"),
                     full.names=T,
                     recursive=FALSE)
file <- srtm
file
# MERGE INTO .tif
system(sprintf("gdal_merge.py -o %s -v  %s",
               paste0(srtmdir, "tmp_srtm.tif"),
               paste0(file,collapse= " ")
))
# COMPRESS
system(sprintf("gdal_translate -co COMPRESS=LZW %s %s",
               paste0(srtmdir,"tmp_srtm.tif"),
               paste0(srtmdir,"tmp_comp_srtm.tif")
))
plot(raster(paste0(srtmdir,"tmp_comp_srtm.tif")))
plot(aoi,add=T)

# DEFINE MASK TO ALIGN ON
mask   <- raster(paste0(griddir,"mask.tif"))
proj   <- proj4string(raster(mask))
extent <- extent(raster(mask))
res    <- res(raster(mask))[1]

# DEFINE INPUT AND OUTPUT
input  <- paste0(srtmdir,"tmp_comp_srtm.tif")
ouput  <- paste0(data0dir,"srtm.tif")

system(sprintf("gdalwarp -co COMPRESS=LZW -t_srs \"%s\" -te %s %s %s %s -tr %s %s %s %s -overwrite",
               proj4string(raster(mask)),
               extent(raster(mask))@xmin,
               extent(raster(mask))@ymin,
               extent(raster(mask))@xmax,
               extent(raster(mask))@ymax,
               res(raster(mask))[1],
               res(raster(mask))[2],
               input,
               ouput
))
# COMPUTE ELEVATION
system(sprintf("gdaldem hillshade -co COMPRESS=LZW %s %s",
               paste0(data0dir,"srtm.tif"),
               paste0(data0dir,"elevation.tif")
))

# COMPUTE SLOPE
system(sprintf("gdaldem slope -co COMPRESS=LZW -p %s %s",
               paste0(data0dir,"srtm.tif"),
               paste0(data0dir,"slope.tif")
))

# COMPUTE ASPECT
system(sprintf("gdaldem aspect -co COMPRESS=LZW %s %s",
               paste0(data0dir,"srtm.tif"),
               paste0(data0dir,"aspect.tif")
))
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## BIOMASS - GEOSAHEL - VALUES 2018
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# http://sigsahel.info/ -> http://geosahel.info/Viewer.aspx?map=Analyse-Biomasse-Finale#

biomass         <- paste0(biomassdir,"BiomassValue2018_geosahel.tif") 

# COMPRESS
system(sprintf("gdal_translate -co COMPRESS=LZW %s %s",
               biomass,
               paste0(biomassdir,"tmp_comp_biomass_geosahel2018.tif")
))

# DEFINE MASK TO ALIGN ON
mask   <- raster(paste0(griddir,"mask.tif"))
proj   <- proj4string(raster(mask))
extent <- extent(raster(mask))
res    <- res(raster(mask))[1]

# DEFINE INPUT AND OUTPUT
input  <- paste0(biomassdir,"tmp_comp_biomass_geosahel2018.tif")
ouput  <- paste0(data0dir,"biomass_geosahel2018.tif")

system(sprintf("gdalwarp -co COMPRESS=LZW -t_srs \"%s\" -te %s %s %s %s -tr %s %s %s %s -overwrite",
               proj4string(raster(mask)),
               extent(raster(mask))@xmin,
               extent(raster(mask))@ymin,
               extent(raster(mask))@xmax,
               extent(raster(mask))@ymax,
               res(raster(mask))[1],
               res(raster(mask))[2],
               input,
               ouput
))
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## PRECIPITATIONS - WAPOR
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
preci         <- paste0(waterdir,"L1_PCP_18_clipped.tif") 

system(sprintf("gdal_translate -co COMPRESS=LZW %s %s",
               preci,
               paste0(waterdir,"tmp_comp_L1_PCP_18_clipped.tif")
))

# DEFINE MASK TO ALIGN ON
mask   <- raster(paste0(griddir,"mask.tif"))
proj   <- proj4string(raster(mask))
extent <- extent(raster(mask))
res    <- res(raster(mask))[1]

# DEFINE INPUT AND OUTPUT
input  <- paste0(waterdir,"tmp_comp_L1_PCP_18_clipped.tif")
ouput  <- paste0(data0dir,"preci_wapor_2018.tif")

system(sprintf("gdalwarp -co COMPRESS=LZW -t_srs \"%s\" -te %s %s %s %s -tr %s %s %s %s -overwrite",
               proj4string(raster(mask)),
               extent(raster(mask))@xmin,
               extent(raster(mask))@ymin,
               extent(raster(mask))@xmax,
               extent(raster(mask))@ymax,
               res(raster(mask))[1],
               res(raster(mask))[2],
               input,
               ouput
))
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## LANDCOVER - WAPOR
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
lc         <- paste0(lulcdir,"L1_LCC_15_clipped.tif") 

system(sprintf("gdal_translate -co COMPRESS=LZW %s %s",
               lc,
               paste0(lulcdir,"tmp_comp_L1_LCC_15_clipped.tif")
))

# DEFINE MASK TO ALIGN ON
mask   <- raster(paste0(griddir,"mask.tif"))
proj   <- proj4string(raster(mask))
extent <- extent(raster(mask))
res    <- res(raster(mask))[1]

# DEFINE INPUT AND OUTPUT
input  <- paste0(lulcdir,"tmp_comp_L1_LCC_15_clipped.tif")
ouput  <- paste0(data0dir,"lc_wapor_2015.tif")

system(sprintf("gdalwarp -co COMPRESS=LZW -t_srs \"%s\" -te %s %s %s %s -tr %s %s %s %s -overwrite",
               proj4string(raster(mask)),
               extent(raster(mask))@xmin,
               extent(raster(mask))@ymin,
               extent(raster(mask))@xmax,
               extent(raster(mask))@ymax,
               res(raster(mask))[1],
               res(raster(mask))[2],
               input,
               ouput
))