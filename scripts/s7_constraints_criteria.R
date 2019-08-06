# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# +000 CONSTRAINTS CRITERIA DEFINITION
# +++1 CONSTRAINTS CRITERIA MAPS
# ++++ 1.1. -PRECIPITATION 
# ++++ 1.2. -DISTANCE TO WATER RESOURCES 
# ++++ 1.3. -SLOPE 
# ++++ 1.4. -ABOVE GROUND BIOMASS PRODUCTION 
# ++++ 1.5. -DISTANCE TO WETLANDS
# ++++ 1.6. -DISTANCE TO NATURE RESERVE OR NATIONAL PARK
# ++++ 1.7. -WETLANDS MASK
# ++++ 1.8. -WATER BODY MASK 
# ++++ 1.9. -CROPLAND MASK 
# ++++ 1.10.-MILITARY BASE MASK
# ++++ 1.11.-NATURE RESERVE OR NATIONAL PARK MASK
# ++++ 1.12.-ALTITUDE
# ++++ 1.13.-RELIGION
# ++++ 1.14.-ETHNICITY
# ++++ 1.15.-CONFLICT
# ++++ 1.16.-LAND TENURE
# ++++ 1.17.-POPULATION DENSITY
# +++2 CONSTRAINTS CRITERIA COMBINAISON MAP
# ++++ 2.1. -GENERAL MAP
# ++++ 2.2. -MAP WITHOUT PRECIPITATION
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# +++1 CONSTRAINTS CRITERIA MAPS

# ++++ 1.1. -PRECIPITATION 
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
system(sprintf("gdal_calc.py -A %s --co=\"COMPRESS=LZW\" --type=Byte --outfile=%s --calc=\"%s\" --overwrite",
               preci_factmult,
               tmp_preci_constraint_mask,
               "(A<200)>0"
))

# ++++ 1.2. -DISTANCE TO WATER RESOURCES 
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
system(sprintf("gdal_calc.py -A %s --co=\"COMPRESS=LZW\" --type=Byte --outfile=%s --calc=\"%s\" --overwrite",
               tmp_dist2water,
               tmp_dist2water_constraint_mask,
               "(A>2000)>0"
))
# ++++ 1.3. -SLOPE 
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
system(sprintf("gdal_calc.py -A %s --co=\"COMPRESS=LZW\" --type=Byte --outfile=%s --calc=\"%s\" --overwrite",
               tmp_slope_path,
               tmp_slope_constraint_mask,
               "(A>20)>0"
))
# ++++ 1.4. -ABOVE GROUND BIOMASS PRODUCTION 
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
system(sprintf("gdal_calc.py -A %s --co=\"COMPRESS=LZW\" --type=Byte --outfile=%s --calc=\"%s\" --overwrite",
               tmp_mask_biomass,
               tmp_biomass_prod_constraint_mask,
               "(A<1000)>0"
))
# ++++ 1.5. -DISTANCE TO WETLANDS
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
system(sprintf("gdal_calc.py -A %s --co=\"COMPRESS=LZW\" --type=Byte --outfile=%s --calc=\"%s\" --overwrite",
               tmp_dist2_unsuit_wetland,
               tmp_dist2wetland_constraint_mask,
               "(A<1000)>0"
))
# ++++ 1.6. -DISTANCE TO NATURE RESERVE OR NATIONAL PARK
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
system(sprintf("gdal_calc.py -A %s --co=\"COMPRESS=LZW\" --type=Byte --outfile=%s --calc=\"%s\" --overwrite",
               tmp_dist2_unsuit_land_reserves,
               tmp_dist2nat_reserv_constraint_mask,
               "(A<24000)>0"
))
system(sprintf("gdal_calc.py -A %s -B %s --co=\"COMPRESS=LZW\" --outfile=%s --calc=\"%s\" --overwrite",
               tmp_dist2nat_reserv_constraint_mask,
               mask_path,
               tmp_dist2nat_res_constr_mask_crop,
               "A*(B>0)"
))
# ++++ 1.7. -WETLANDS MASK
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
unsuit_mask_wetland_tif

# ++++ 1.8. -WATER BODY MASK
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
system(sprintf("gdal_calc.py -A %s --co=\"COMPRESS=LZW\" --type=Byte --outfile=%s --calc=\"%s\" --overwrite",
               lc_tif,
               tmp_lc_water_constraint_mask,
               "(A==80)>0"
))
# ++++ 1.9. -CROPLAND MASK 
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
system(sprintf("gdal_calc.py -A %s --co=\"COMPRESS=LZW\" --type=Byte --outfile=%s --calc=\"%s\" --overwrite",
               lc_tif,
               tmp_lc_cropland_constraint_mask,
               "((A==41)+(A==42))>0"
))
# ++++ 1.10.-MILITARY BASE MASK  
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
unsuit_land_military_tif

# ++++ 1.11.-NATURE RESERVE OR NATIONAL PARK MASK
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
unsuit_mask_land_reserves_tif

# ++++ 1.12.-ALTITUDE
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
system(sprintf("gdal_calc.py -A %s --co=\"COMPRESS=LZW\" --type=Byte --outfile=%s --calc=\"%s\" --overwrite",
               lc_tif,
               tmp_lc_cropland_constraint_mask,
               "((A==41)+(A==42))>0"
))
# ++++ 1.13.-RELIGION
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

# ++++ 1.14.-ETHNICITY
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

# ++++ 1.15.-CONFLICT
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

# ++++ 1.16.-LAND TENURE
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

# ++++ 1.17.-POPULATION DENSITY
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# +++2 CONSTRAINTS CRITERIA COMBINAISON MAP

# ++++ 2.1. -GENERAL MAP
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
system(sprintf("gdal_calc.py -A %s -B %s -C %s -D %s -E %s -F %s -G %s -H %s -I %s -J %s -K %s --co=\"COMPRESS=LZW\" --type=Byte --outfile=%s --calc=\"%s\" --overwrite",
               tmp_preci_constraint_mask,
               tmp_dist2water_constraint_mask,
               tmp_slope_constraint_mask,
               tmp_biomass_prod_constraint_mask,
               tmp_dist2wetland_constraint_mask,
               tmp_dist2nat_res_constr_mask_crop,
               unsuit_mask_wetland_tif,
               tmp_lc_water_constraint_mask,
               tmp_lc_cropland_constraint_mask,
               unsuit_land_military_tif,
               unsuit_mask_land_reserves_tif,
               
               tmp_mask_constraints_combi,
               "(A+B+C+D+E+F+G+H+I+J+K)>0"
))
# ++++ 2.2. -MAP WITHOUT PRECIPITATION
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
system(sprintf("gdal_calc.py -A %s -B %s -C %s -D %s -E %s -F %s -G %s -H %s -I %s -J %s --co=\"COMPRESS=LZW\" --type=Byte --outfile=%s --calc=\"%s\" --overwrite",
               tmp_dist2water_constraint_mask,
               tmp_slope_constraint_mask,
               tmp_biomass_prod_constraint_mask,
               tmp_dist2wetland_constraint_mask,
               tmp_dist2nat_res_constr_mask_crop,
               unsuit_mask_wetland_tif,
               tmp_lc_water_constraint_mask,
               tmp_lc_cropland_constraint_mask,
               unsuit_land_military_tif,
               unsuit_mask_land_reserves_tif,
               
               tmp_mask_constraints_combi_1,
               "(A+B+C+D+E+F+G+H+I+J)>0"
))