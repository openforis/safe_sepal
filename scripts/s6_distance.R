# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# DISTANCES TO FEATURES 
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
##  BORDERS
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# FOCUS ON YOUR AOI : * mask
system(sprintf("gdal_calc.py -A %s -B %s --co=\"COMPRESS=LZW\" --outfile=%s --calc=\"%s\" --overwrite",
               boundaries_tif,
               mask_path,
               tmp_mask_boundaries,
               "A*(B>0)"
))
# COMPUTE DISTANCES TO FEATURES
system(sprintf("gdal_proximity.py -co COMPRESS=LZW -ot Int16 -distunits PIXEL %s %s -co BIGTIFF=YES",
               tmp_mask_boundaries,
               tmp_mask_dist2boundaries
))
# COMPRESS
system(sprintf("gdal_translate -co COMPRESS=LZW %s %s -co BIGTIFF=YES",
               tmp_mask_dist2boundaries,
               tmp_dist2boundaries
))
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
##  WATER RESOURCES 
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# SURFACE WATER  
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
system(sprintf("gdal_calc.py -A %s -B %s --co=\"COMPRESS=LZW\" --outfile=%s --calc=\"%s\" --overwrite",
               surf_water_tif,
               mask_path,
               tmp_mask_surf_water,
               "A*(B>0)"
))
system(sprintf("gdal_proximity.py -co COMPRESS=LZW -ot Int16 -distunits PIXEL %s %s -co BIGTIFF=YES",
               tmp_mask_surf_water,
               tmp_mask_dist2surf_water 
))
# COMPRESS
system(sprintf("gdal_translate -co COMPRESS=LZW %s %s -co BIGTIFF=YES",
               tmp_mask_dist2surf_water,
               tmp_dist2surf_water
))

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# UNDERGROUND WATER  
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
system(sprintf("gdal_calc.py -A %s -B %s --co=\"COMPRESS=LZW\" --outfile=%s --calc=\"%s\" --overwrite",
               under_water_tif,
               mask_path,
               tmp_mask_under_water,
               "A*(B>0)"
))
system(sprintf("gdal_proximity.py -co COMPRESS=LZW -ot Int16 -distunits PIXEL %s %s -co BIGTIFF=YES",
               tmp_mask_under_water,
               tmp_mask_dist2under_water
))
system(sprintf("gdal_translate -co COMPRESS=LZW %s %s -co BIGTIFF=YES",
               tmp_mask_dist2under_water,
               tmp_dist2under_water
))
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# WATER RESOURCES COMPILATION 
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
system(sprintf("gdal_calc.py -A %s -B %s --co=\"COMPRESS=LZW\" --outfile=%s --calc=\"%s\" --overwrite",
               tmp_dist2surf_water,
               tmp_dist2under_water,
               tmp_dist2water,
               "minimum(A,B)"
))

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
##  ELECTRIC LINES 
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
system(sprintf("gdal_calc.py -A %s -B %s --co=\"COMPRESS=LZW\" --outfile=%s --calc=\"%s\" --overwrite",
               electricity_tif,
               mask_path,
               tmp_mask_electricity,
               "A*(B>0)"
))
system(sprintf("gdal_proximity.py -co COMPRESS=LZW -ot Int16 -distunits PIXEL %s %s -co BIGTIFF=YES",
               tmp_mask_electricity,
               tmp_mask_dist2electricity
))
system(sprintf("gdal_translate -co COMPRESS=LZW %s %s -co BIGTIFF=YES",
               tmp_mask_dist2electricity,
               tmp_dist2electricity
))

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
##  ROADS 
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
system(sprintf("gdal_calc.py -A %s -B %s --co=\"COMPRESS=LZW\" --outfile=%s --calc=\"%s\" --overwrite",
               roads_tif,
               mask_path,
               tmp_mask_roads,
               "A*(B>0)"
))
system(sprintf("gdal_proximity.py -co COMPRESS=LZW -ot Int16 -distunits PIXEL %s %s -co BIGTIFF=YES",
               tmp_mask_roads,
               tmp_mask_dist2roads
))
system(sprintf("gdal_translate -co COMPRESS=LZW %s %s -co BIGTIFF=YES",
               tmp_mask_dist2roads,
               tmp_dist2roads
))

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
##  SETTLEMENTS 
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
system(sprintf("gdal_calc.py -A %s -B %s --co=\"COMPRESS=LZW\" --outfile=%s --calc=\"%s\" --overwrite",
               towns_tif,
               mask_path,
               tmp_mask_towns,
               "A*(B>0)"
))
system(sprintf("gdal_proximity.py -co COMPRESS=LZW -ot Int16 -distunits PIXEL %s %s -co BIGTIFF=YES",
               tmp_mask_towns,
               tmp_mask_dist2towns
))
system(sprintf("gdal_translate -co COMPRESS=LZW %s %s -co BIGTIFF=YES",
               tmp_mask_dist2towns,
               tmp_dist2towns 
))
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
##  HEALTH 
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
system(sprintf("gdal_calc.py -A %s -B %s --co=\"COMPRESS=LZW\" --outfile=%s --calc=\"%s\" --overwrite",
               health_tif,
               mask_path,
               tmp_mask_health,
               "A*(B>0)"
))
system(sprintf("gdal_proximity.py -co COMPRESS=LZW -ot Int16 -distunits PIXEL %s %s -co BIGTIFF=YES",
               tmp_mask_health,
               tmp_mask_dist2health
))
system(sprintf("gdal_translate -co COMPRESS=LZW %s %s -co BIGTIFF=YES",
               tmp_mask_dist2health,
               tmp_dist2health
))
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
##  EDUCATION 
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
system(sprintf("gdal_calc.py -A %s -B %s --co=\"COMPRESS=LZW\" --outfile=%s --calc=\"%s\" --overwrite",
               education_tif,
               mask_path,
               tmp_mask_education,
               "A*(B>0)"
))
system(sprintf("gdal_proximity.py -co COMPRESS=LZW -ot Int16 -distunits PIXEL %s %s -co BIGTIFF=YES",
               tmp_mask_education,
               tmp_mask_dist2education
))
system(sprintf("gdal_translate -co COMPRESS=LZW %s %s -co BIGTIFF=YES",
               tmp_mask_dist2education,
               tmp_dist2education
))

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
##  UNSUITABLE LAND-NATURE RESERVE/PARC
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
system(sprintf("gdal_calc.py -A %s -B %s --co=\"COMPRESS=LZW\" --outfile=%s --calc=\"%s\" --overwrite",
               unsuit_land_reserves_tif,
               mask_path,
               tmp_mask_unsuit_land_reserves,
               "A*(B>0)"
))
system(sprintf("gdal_proximity.py -co COMPRESS=LZW -ot Int16 -distunits PIXEL %s %s -co BIGTIFF=YES",
               tmp_mask_unsuit_land_reserves,
               tmp_mask_dist2unsuit_land_reserves
))
system(sprintf("gdal_translate -co COMPRESS=LZW %s %s -co BIGTIFF=YES",
               tmp_mask_dist2unsuit_land_reserves,
               tmp_dist2unsuit_land_reserves
))

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
##  UNSUITABLE-WETLANDS
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
system(sprintf("gdal_calc.py -A %s -B %s --co=\"COMPRESS=LZW\" --outfile=%s --calc=\"%s\" --overwrite",
               unsuit_wetland_tif,
               mask_path,
               tmp_mask_unsuit_wetland,
               "A*(B>0)"
))
system(sprintf("gdal_proximity.py -co COMPRESS=LZW -ot Int16 -distunits PIXEL %s %s -co BIGTIFF=YES",
               tmp_mask_unsuit_wetland,
               tmp_mask_dist2unsuit_wetland
))
system(sprintf("gdal_translate -co COMPRESS=LZW %s %s -co BIGTIFF=YES",
               tmp_mask_dist2unsuit_wetland,
               tmp_dist2unsuit_wetland
))


