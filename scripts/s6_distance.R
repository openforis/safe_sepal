# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# DISTANCES TO FEATURES 
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
##  BORDERS
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# FOCUS ON YOUR AOI : * mask
system(sprintf("gdal_calc.py -A %s -B %s --co=\"COMPRESS=LZW\" --outfile=%s --calc=\"%s\" --overwrite",
               paste0(data0dir,"border.tif") ,
               paste0(griddir,"mask.tif") ,
               paste0(data0dir,"tmp_mask_border.tif"),
               "A*(B>0)"
))
# COMPUTE DISTANCES TO FEATURES
system(sprintf("gdal_proximity.py -co COMPRESS=LZW -ot Int16 -distunits PIXEL %s %s -co BIGTIFF=YES",
               paste0(data0dir,"tmp_mask_border.tif"),
               paste0(data0dir,"tmp_mask_dist2border.tif")
))
# COMPRESS
system(sprintf("gdal_translate -co COMPRESS=LZW %s %s -co BIGTIFF=YES",
               paste0(data0dir,"tmp_mask_dist2border.tif"),
               paste0(data0dir,"dist2border.tif")
))
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
##  WATER RESOURCES 
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# SURFACE WATER  
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
system(sprintf("gdal_calc.py -A %s -B %s --co=\"COMPRESS=LZW\" --outfile=%s --calc=\"%s\" --overwrite",
               paste0(data0dir,"surf_water.tif") ,
               paste0(griddir,"mask.tif") ,
               paste0(data0dir,"tmp_mask_surf_water.tif"),
               "A*(B>0)"
))
system(sprintf("gdal_proximity.py -co COMPRESS=LZW -ot Int16 -distunits PIXEL %s %s -co BIGTIFF=YES",
               paste0(data0dir,"tmp_mask_surf_water.tif"),#source file
               paste0(data0dir,"mask_dist2surf_water.tif") #destination file
))
# COMPRESS
# 5.3 GB -> 4.4 GB
system(sprintf("gdal_translate -co COMPRESS=LZW %s %s -co BIGTIFF=YES",
               paste0(data0dir,"mask_dist2surf_water.tif"),
               paste0(data0dir,"dist2surf_water.tif")
))

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# UNDERGROUND WATER  
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
system(sprintf("gdal_calc.py -A %s -B %s --co=\"COMPRESS=LZW\" --outfile=%s --calc=\"%s\" --overwrite",
               paste0(data0dir,"under_water.tif") ,
               paste0(griddir,"mask.tif") ,
               paste0(data0dir,"tmp_mask_under_water.tif"),
               "A*(B>0)"
))
system(sprintf("gdal_proximity.py -co COMPRESS=LZW -ot Int16 -distunits PIXEL %s %s -co BIGTIFF=YES",
               paste0(data0dir,"tmp_mask_under_water.tif"),
               paste0(data0dir,"tmp_mask_dist2under_water.tif")
))
system(sprintf("gdal_translate -co COMPRESS=LZW %s %s -co BIGTIFF=YES",
               paste0(data0dir,"tmp_mask_dist2under_water.tif"),
               paste0(data0dir,"dist2under_water.tif")
))
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# WATER RESOURCES COMPILATION 
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
system(sprintf("gdal_calc.py -A %s -B %s --co=\"COMPRESS=LZW\" --outfile=%s --calc=\"%s\" --overwrite",
               paste0(data0dir,"dist2surf_water.tif"),
               paste0(data0dir,"dist2under_water.tif"),
               paste0(data0dir,"dist2water.tif"),
               "A*B"
))

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
##  ELECTRIC LINES 
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
system(sprintf("gdal_calc.py -A %s -B %s --co=\"COMPRESS=LZW\" --outfile=%s --calc=\"%s\" --overwrite",
               paste0(data0dir,"electricity.tif") ,
               paste0(griddir,"mask.tif") ,
               paste0(data0dir,"tmp_mask_electricity.tif"),
               "A*(B>0)"
))
system(sprintf("gdal_proximity.py -co COMPRESS=LZW -ot Int16 -distunits PIXEL %s %s -co BIGTIFF=YES",
               paste0(data0dir,"tmp_mask_electricity.tif"),
               paste0(data0dir,"tmp_mask_dist2electricity.tif")
))
system(sprintf("gdal_translate -co COMPRESS=LZW %s %s -co BIGTIFF=YES",
               paste0(data0dir,"tmp_mask_dist2electricity.tif"),
               paste0(data0dir,"dist2electricity.tif")
))

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
##  ROADS 
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
system(sprintf("gdal_calc.py -A %s -B %s --co=\"COMPRESS=LZW\" --outfile=%s --calc=\"%s\" --overwrite",
               paste0(data0dir,"roads.tif") ,
               paste0(griddir,"mask.tif") ,
               paste0(data0dir,"tmp_mask_roads.tif"),
               "A*(B>0)"
))
system(sprintf("gdal_proximity.py -co COMPRESS=LZW -ot Int16 -distunits PIXEL %s %s -co BIGTIFF=YES",
               paste0(data0dir,"tmp_mask_roads.tif"),
               paste0(data0dir,"tmp_mask_dist2roads.tif")
))
system(sprintf("gdal_translate -co COMPRESS=LZW %s %s -co BIGTIFF=YES",
               paste0(data0dir,"tmp_mask_dist2roads.tif"),
               paste0(data0dir,"dist2roads.tif")
))

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
##  SETTLEMENTS 
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
system(sprintf("gdal_calc.py -A %s -B %s --co=\"COMPRESS=LZW\" --outfile=%s --calc=\"%s\" --overwrite",
               paste0(data0dir,"towns.tif") ,
               paste0(griddir,"mask.tif") ,
               paste0(data0dir,"tmp_mask_towns.tif"),
               "A*(B>0)"
))
system(sprintf("gdal_proximity.py -co COMPRESS=LZW -ot Int16 -distunits PIXEL %s %s -co BIGTIFF=YES",
               paste0(data0dir,"tmp_mask_towns.tif"),
               paste0(data0dir,"tmp_mask_dist2towns.tif")
))
system(sprintf("gdal_translate -co COMPRESS=LZW %s %s -co BIGTIFF=YES",
               paste0(data0dir,"tmp_mask_dist2towns.tif"),
               paste0(data0dir,"dist2towns.tif")
))
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
##  HEALTH 
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
system(sprintf("gdal_calc.py -A %s -B %s --co=\"COMPRESS=LZW\" --outfile=%s --calc=\"%s\" --overwrite",
               paste0(data0dir,"health.tif") ,
               paste0(griddir,"mask.tif") ,
               paste0(data0dir,"tmp_mask_health.tif"),
               "A*(B>0)"
))
system(sprintf("gdal_proximity.py -co COMPRESS=LZW -ot Int16 -distunits PIXEL %s %s -co BIGTIFF=YES",
               paste0(data0dir,"tmp_mask_health.tif"),
               paste0(data0dir,"tmp_mask_dist2health.tif")
))
system(sprintf("gdal_translate -co COMPRESS=LZW %s %s -co BIGTIFF=YES",
               paste0(data0dir,"tmp_mask_dist2health.tif"),
               paste0(data0dir,"dist2health.tif")
))
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
##  EDUCATION 
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
system(sprintf("gdal_calc.py -A %s -B %s --co=\"COMPRESS=LZW\" --outfile=%s --calc=\"%s\" --overwrite",
               paste0(data0dir,"education.tif") ,
               paste0(griddir,"mask.tif") ,
               paste0(data0dir,"tmp_mask_education.tif"),
               "A*(B>0)"
))
system(sprintf("gdal_proximity.py -co COMPRESS=LZW -ot Int16 -distunits PIXEL %s %s -co BIGTIFF=YES",
               paste0(data0dir,"tmp_mask_education.tif"),
               paste0(data0dir,"tmp_mask_dist2education.tif")
))
system(sprintf("gdal_translate -co COMPRESS=LZW %s %s -co BIGTIFF=YES",
               paste0(data0dir,"tmp_mask_dist2education.tif"),
               paste0(data0dir,"dist2education.tif")
))

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
##  BIOMASS 
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
system(sprintf("gdal_calc.py -A %s -B %s --co=\"COMPRESS=LZW\" --outfile=%s --calc=\"%s\" --overwrite",
               paste0(data0dir,"biomass_geosahel2018.tif"),
               paste0(griddir,"mask.tif"),
               paste0(data0dir,"tmp_mask_biomass_geosahel2018.tif"),
               "A*(B>0)"
))
system(sprintf("gdal_proximity.py -co COMPRESS=LZW -ot Int16 -distunits PIXEL %s %s -co BIGTIFF=YES",
               paste0(data0dir,"tmp_mask_biomass_geosahel2018.tif"),
               paste0(data0dir,"tmp_mask_dist2biomass_geosahel2018.tif")
))
system(sprintf("gdal_translate -co COMPRESS=LZW %s %s -co BIGTIFF=YES",
               paste0(data0dir,"tmp_mask_dist2biomass_geosahel2018.tif"),
               paste0(data0dir,"dist2biomass_geosahel2018.tif")
))
plot(raster(paste0(data0dir,"dist2biomass_geosahel2018.tif")))
