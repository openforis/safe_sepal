# +000 RASTERIZE LAYERS
# +++1 SHAPEFILES TO RASTERS
# +++2 ALIGN RASTERS TO MASK

# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# +++1 SHAPEFILES TO RASTERS

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## BORDERS 
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
system(sprintf("python %s/oft-rasterize_attr.py -v %s -i %s -o %s  -a %s",
               scriptdir,
               boundaries_path,
               mask_path,
               boundaries_tif,
               "code"
))
plot(raster(boundaries_tif))
gdalinfo(boundaries_tif)

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## WATER RESOURCES 
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## -1/ WATER "POIS" - Points of interest, OpenStreetMap 
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

system(sprintf("python %s/oft-rasterize_attr.py -v %s -i %s -o %s  -a %s",
               scriptdir,
               water_pois_osm_path,
               mask_path,
               water_pois_osm_tif,
               "water_code"
))
plot(raster(water_pois_osm_tif))
gdalinfo(water_pois_osm_tif)

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## -2/ WATER "OSM" - OpenStreetMap  
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

system(sprintf("python %s/oft-rasterize_attr.py -v %s -i %s -o %s  -a %s",
               scriptdir,
               water_osm_path,
               mask_path,
               water_osm_tif,
               "water_code"
))
plot(raster(water_osm_tif))
gdalinfo(water_osm_tif)

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## -3/ WATERWAYS "OSM" - OpenStreetMap
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

system(sprintf("python %s/oft-rasterize_attr.py -v %s -i %s -o %s  -a %s",
               scriptdir,
               waterways_osm_path,
               mask_path,
               waterways_osm_tif,
               "wtrwys_"
))
plot(raster(waterways_osm_tif))
gdalinfo(waterways_osm_tif)

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## -4/ WATER "NATURAL OSM" - OpenStreetMap
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

system(sprintf("python %s/oft-rasterize_attr.py -v %s -i %s -o %s  -a %s",
               scriptdir,
               water_natural_osm_path,
               mask_path,
               water_natural_osm_tif,
               "water_code"
))
plot(raster(water_natural_osm_tif))
gdalinfo(water_natural_osm_tif)

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## WATER RESSOURCES - COMPILATION 
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

# SURFACE WATER = 1, other =0 
system(sprintf("gdal_calc.py -A %s -B %s -C %s --co=\"COMPRESS=LZW\" --outfile=%s --calc=\"%s\" --overwrite",
               water_pois_osm_tif,
               water_osm_tif,
               waterways_osm_tif,
               surf_water_tif,
               "((A==1)+(A==2)+(A==4)+(B>0)+(C>0))*1"
))
plot(raster(GDALinfo(surf_water_tif)))
gdalinfo(surf_water_tif)

# UNDERGROUND WATER = 1, other =0
system(sprintf("gdal_calc.py -A %s -B %s --co=\"COMPRESS=LZW\" --outfile=%s --calc=\"%s\" --overwrite",
               water_pois_osm_tif,
               water_natural_osm_tif,
               under_water_tif,
               "((A==3)+(B==1))*1"
))
plot(raster(GDALinfo(under_water_tif)))
gdalinfo(under_water_tif)

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## ELECTRIC LINES 
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

system(sprintf("python %s/oft-rasterize_attr.py -v %s -i %s -o %s  -a %s",
               scriptdir,
               electricity_path,
               mask_path,
               electricity_tif,
               "stts_cd "
))
plot(raster(electricity_tif))
gdalinfo(electricity_tif)

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## ROADS  "roads OSM" - OpenStreetMap
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

system(sprintf("python %s/oft-rasterize_attr.py -v %s -i %s -o %s  -a %s",
               scriptdir,
               roads_path,
               mask_path,
               roads_tif,
               "roads_code"
))
plot(raster(roads_tif))
gdalinfo(roads_tif)

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## RELIGION "POFW OSM" - Places of worship OpenStreetMap
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

system(sprintf("python %s/oft-rasterize_attr.py -v %s -i %s -o %s  -a %s",
               scriptdir,
               religion_path,
               mask_path,
               religion_tif,
               "rlgn_cd"
))
plot(raster(religion_tif))
gdalinfo(religion_tif)

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## SETTLEMENTS - "places OSM" OpenStreetMap
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ 

system(sprintf("python %s/oft-rasterize_attr.py -v %s -i %s -o %s  -a %s",
               scriptdir,
               towns_path,
               mask_path,
               towns_tif,
               "towns_code"
))
plot(raster(towns_tif))
gdalinfo(towns_tif)
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## HEALTH  - "Points of interest OSM" OpenStreetMap
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ 

system(sprintf("python %s/oft-rasterize_attr.py -v %s -i %s -o %s  -a %s",
               scriptdir,
               health_path,
               mask_path,
               health_tif,
               "hlth_cd"
))
plot(raster(health_tif))
gdalinfo(health_tif)

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## EDUCATION - "Points of interestOSM" OpenStreetMap
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++  

system(sprintf("python %s/oft-rasterize_attr.py -v %s -i %s -o %s  -a %s",
               scriptdir,
               education_path,
               mask_path,
               education_tif,
               "edctn_c"
))
plot(raster(education_tif))
gdalinfo(education_tif)

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## UNSUITABLE AREAS 
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ 
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## -1/ UNSUITABLE LAND-NATURE RESERVE/PARC- "Land Use OSM" OpenStreetMap
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 system(sprintf("python %s/oft-rasterize_attr.py -v %s -i %s -o %s  -a %s",
               scriptdir,
               unsuit_land_reserves_path,
               mask_path,
               unsuit_land_reserves_tif,
               "unst_cd"
))
plot(raster(unsuit_land_reserves_tif))
gdalinfo(unsuit_land_reserves_tif)
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## -2/ UNSUITABLE LAND - MILITARY AREAS- "Land Use OSM" OpenStreetMap
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
system(sprintf("python %s/oft-rasterize_attr.py -v %s -i %s -o %s  -a %s",
               scriptdir,
               unsuit_land_military_path,
               mask_path,
               unsuit_land_military_tif,
               "unst_cd"
))
plot(raster(unsuit_land_military_tif))
gdalinfo(unsuit_land_military_tif)
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## -3/ UNSUITABLE-WETLANDS - "OSM" - OpenStreetMap
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 
system(sprintf("python %s/oft-rasterize_attr.py -v %s -i %s -o %s  -a %s",
               scriptdir,
               unsuit_wetland_path,
               mask_path,
               unsuit_wetland_tif,
               "water_code"
))
plot(raster(unsuit_wetland_tif))
gdalinfo(unsuit_wetland_tif)

# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# +++2 ALIGN RASTERS TO MASK

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## SRTM 90m
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
download.file(url = url_srtm_grid,
              destfile = paste0(srtmdir,file_srtm))

system(sprintf("unzip -o %s -d %s",
               paste0(srtmdir,file_srtm),
               srtmdir))

srtm_grid            <- shapefile(srtm_grid_path) 

#Get country geometry 
aoi         <- getData('GADM',
                       path=admdir,
                       country= countrycode,
                       level=0)

#Intersect country geometry and tile grid
intersects <- gIntersects(aoi, srtm_grid, byid=T)
tiles      <- srtm_grid[intersects[,1],]
plot(tiles)
plot(aoi,add=T)

#Download tiles
srtm_list  <- list()
for(i in 1:length(tiles)) {
  lon <- extent(tiles[i,])[1]  + (extent(tiles[i,])[2] - extent(tiles[i,])[1]) / 2
  lat <- extent(tiles[i,])[3]  + (extent(tiles[i,])[4] - extent(tiles[i,])[3]) / 2
  
  tile <- getData('SRTM', 
                  lon=lon, 
                  lat=lat,
                  path = srtmdir)
  
  srtm_list[[i]] <- tile
}

#Mosaic tiles
srtm_list$fun <- mean 
srtm_mosaic   <- do.call(mosaic, srtm_list)

#Crop tiles to country borders
srtm_crop     <- mask(srtm_mosaic, aoi)

#Plot
p <- levelplot(srtm_mosaic)
p + layer(sp.lines(aoi, 
                   lwd=0.8, 
                   col='darkgray'))

#Write raster
writeRaster(srtm_crop,tmp_srtm_path, overwrite=TRUE)

# COMPRESS
system(sprintf("gdal_translate -co COMPRESS=LZW %s %s",
               tmp_srtm_path,
               tmp_srtm_comp_path
))

# DEFINE MASK TO ALIGN ON
mask   
proj   <- proj4string(mask)
extent <- extent(mask)
res    <- res(mask)[1]

# DEFINE INPUT AND OUTPUT
input  <- tmp_srtm_comp_path
ouput  <- srtm_path 

system(sprintf("gdalwarp -co COMPRESS=LZW -t_srs \"%s\" -te %s %s %s %s -tr %s %s %s %s -overwrite",
               proj4string(mask),
               extent(mask)@xmin,
               extent(mask)@ymin,
               extent(mask)@xmax,
               extent(mask)@ymax,
               res(mask)[1],
               res(mask)[2],
               input,
               ouput
))
# COMPUTE ELEVATION
system(sprintf("gdaldem hillshade -co COMPRESS=LZW %s %s",
               srtm_path,
               elevation_path
))
# COMPUTE SLOPE
system(sprintf("gdaldem slope -co COMPRESS=LZW -p %s %s",
               srtm_path,
               tmp_slope_path
))
system(sprintf("gdal_translate -ot Byte -co COMPRESS=LZW %s %s",
               tmp_slope_path,
               slope_path
))

# COMPUTE ASPECT
system(sprintf("gdaldem aspect -co COMPRESS=LZW %s %s",
               srtm_path,
               aspect_path
))
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## BIOMASS 
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# COMPRESS
system(sprintf("gdal_translate -co COMPRESS=LZW %s %s",
               biomass_path,
               tmp_biomass_comp
))

# DEFINE MASK TO ALIGN ON
mask   
proj   <- proj4string(mask)
extent <- extent(mask)
res    <- res(mask)[1]

# DEFINE INPUT AND OUTPUT
input  <- tmp_biomass_comp
ouput  <- biomass_tif

system(sprintf("gdalwarp -co COMPRESS=LZW -t_srs \"%s\" -te %s %s %s %s -tr %s %s %s %s -overwrite",
               proj4string(mask),
               extent(mask)@xmin,
               extent(mask)@ymin,
               extent(mask)@xmax,
               extent(mask)@ymax,
               res(mask)[1],
               res(mask)[2],
               input,
               ouput
))
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## PRECIPITATIONS 
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# COMPRESS
system(sprintf("gdal_translate -co COMPRESS=LZW %s %s",
               preci_path,
               tmp_preci_comp
))
# DEFINE MASK TO ALIGN ON
mask   
proj   <- proj4string(mask)
extent <- extent(mask)
res    <- res(mask)[1]

# DEFINE INPUT AND OUTPUT
input  <- tmp_preci_comp
ouput  <- preci_tif

system(sprintf("gdalwarp -co COMPRESS=LZW -t_srs \"%s\" -te %s %s %s %s -tr %s %s %s %s -overwrite",
               proj4string(mask),
               extent(mask)@xmin,
               extent(mask)@ymin,
               extent(mask)@xmax,
               extent(mask)@ymax,
               res(mask)[1],
               res(mask)[2],
               input,
               ouput
))
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## LANDCOVER 
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# COMPRESS
system(sprintf("gdal_translate -co COMPRESS=LZW %s %s",
               lc_path,
               tmp_lc_comp
))

# DEFINE MASK TO ALIGN ON
mask   
proj   <- proj4string(mask)
extent <- extent(mask)
res    <- res(mask)[1]

# DEFINE INPUT AND OUTPUT
input  <- tmp_lc_comp
ouput  <- lc_tif

system(sprintf("gdalwarp -co COMPRESS=LZW -t_srs \"%s\" -te %s %s %s %s -tr %s %s %s %s -overwrite",
               proj4string(mask),
               extent(mask)@xmin,
               extent(mask)@ymin,
               extent(mask)@xmax,
               extent(mask)@ymax,
               res(mask)[1],
               res(mask)[2],
               input,
               ouput
))
