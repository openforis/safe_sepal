# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# DISTANCES TO FEATURES 
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
##  BORDERS
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# COMPUTE DISTANCES TO FEATURES
system(sprintf("gdal_proximity.py -co COMPRESS=LZW -ot Int32 -distunits GEO %s %s -co BIGTIFF=YES -co overwrite",
               boundaries_line_tif,
               tmp_dist2boundaries
))
#system(sprintf("gdal_translate -ot Int32 -co COMPRESS=LZW %s %s -co overwrite",
#               tmp_dist2boundaries,
#               tmp_comp_dist2boundaries
#))
# FOCUS ON YOUR AOI : * mask
system(sprintf("gdal_calc.py -A %s -B %s --co=\"COMPRESS=LZW\" --outfile=%s --calc=\"%s\" --overwrite",
               tmp_dist2boundaries,
               mask_path,
               tmp_mask_dist2boundaries,
               "A*(B>0)"
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
system(sprintf("gdal_proximity.py -co COMPRESS=LZW -ot Int32 -distunits GEO %s %s -co BIGTIFF=YES -co overwrite",
               tmp_mask_surf_water,
               tmp_mask_dist2surf_water 
))
system(sprintf("gdal_proximity.py -co COMPRESS=LZW -ot Int32 -distunits GEO %s %s -co BIGTIFF=YES -co overwrite",
               tmp_mask_surf_water,
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
system(sprintf("gdal_proximity.py -co COMPRESS=LZW -ot Int32 -distunits GEO %s %s -co BIGTIFF=YES -co overwrite",
               tmp_mask_under_water,
               tmp_dist2under_water
))
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# WATER RESOURCES COMPILATION 
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
system(sprintf("gdal_calc.py -A %s -B %s --type Int32 --co=\"COMPRESS=LZW\" --outfile=%s --calc=\"%s\" --overwrite",
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
system(sprintf("gdal_proximity.py -co COMPRESS=LZW -ot Int32 -distunits GEO %s %s -co BIGTIFF=YES -co overwrite",
               tmp_mask_electricity,
               tmp_dist2elec
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
system(sprintf("gdal_proximity.py -co COMPRESS=LZW -ot Int32 -distunits GEO %s %s -co BIGTIFF=YES -co overwrite",
               tmp_mask_roads,
               tmp_dist2_roads
))
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
##  TOWNS 
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
system(sprintf("gdal_calc.py -A %s -B %s --co=\"COMPRESS=LZW\" --outfile=%s --calc=\"%s\" --overwrite",
               towns_tif,
               mask_path,
               tmp_mask_towns,
               "A*(B>0)"
))
system(sprintf("gdal_proximity.py -co COMPRESS=LZW -ot Int32 -distunits GEO %s %s -co BIGTIFF=YES -co overwrite",
               tmp_mask_towns,
               tmp_dist2_towns
))
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
##  HEALTH INFRASTRUCTURES
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
system(sprintf("gdal_calc.py -A %s -B %s --co=\"COMPRESS=LZW\" --outfile=%s --calc=\"%s\" --overwrite",
               health_tif,
               mask_path,
               tmp_mask_health,
               "A*(B>0)"
))
system(sprintf("gdal_proximity.py -co COMPRESS=LZW -ot Int32 -distunits GEO %s %s -co BIGTIFF=YES -co overwrite",
               tmp_mask_health,
               tmp_dist2_health
))
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
##  EDUCATION INFRASTRUCTURES
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
system(sprintf("gdal_calc.py -A %s -B %s --co=\"COMPRESS=LZW\" --outfile=%s --calc=\"%s\" --overwrite",
               education_tif,
               mask_path,
               tmp_mask_education,
               "A*(B>0)"
))
system(sprintf("gdal_proximity.py -co COMPRESS=LZW -ot Int32 -distunits GEO %s %s -co BIGTIFF=YES -co overwrite",
               tmp_mask_education,
               tmp_dist2_edu
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
system(sprintf("gdal_proximity.py -co COMPRESS=LZW -ot Int32 -distunits GEO %s %s -co BIGTIFF=YES -co overwrite",
               tmp_mask_unsuit_land_reserves,
               tmp_dist2_unsuit_land_reserves
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
system(sprintf("gdal_proximity.py -co COMPRESS=LZW -ot Int32 -distunits GEO %s %s -co BIGTIFF=YES",
               tmp_mask_unsuit_wetland,
               tmp_dist2_unsuit_wetland
))