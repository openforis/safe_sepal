# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# +000 CONSTRAINTS CRITERIA DEFINITION
# +++1 PRECIPITATION
# +++2 DISTANCE TO WATER RESOURCES
# +++3 SLOPE
# +++4 ABOVE GROUND BIOMASS PRODUCTION 
# +++5 DISTANCE TO WETLANDS
# +++6 DISTANCE TO NATURE RESERVE OR NATIONAL PARK
# +++7 WETLANDS MASK
# +++8 WATER BODY MASK 
# +++9 CROPLAND MASK
# +++10 ALTITUDE
# +++11 MILITARY BASE MASK
# +++12 NATURE RESERVE OR NATIONAL PARK MASK
# +++13 RELIGION
# +++14 ETHNICITY
# +++15 CONFLICT
# +++16 LAND TENURE
# +++17 POPULATION DENSITY
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

# +++1 PRECIPITATION
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
system(sprintf("gdal_calc.py -A %s --co=\"COMPRESS=LZW\" --type=Byte --outfile=%s --calc=\"%s\" --overwrite",
               preci_factmult,
               tmp_preci_constraint_mask,
               "(A<200)>0"
))

# +++2 DISTANCE TO WATER RESOURCES
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
system(sprintf("gdal_calc.py -A %s --co=\"COMPRESS=LZW\" --type=Byte --outfile=%s --calc=\"%s\" --overwrite",
               tmp_dist2water,
               tmp_dist2water_constraint_mask,
               "(A>2000)>0"
))
# +++3 SLOPE
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
system(sprintf("gdal_calc.py -A %s --co=\"COMPRESS=LZW\" --type=Byte --outfile=%s --calc=\"%s\" --overwrite",
               tmp_slope_path,
               tmp_slope_constraint_mask,
               "(A>20)>0"
))
# +++4 ABOVE GROUND BIOMASS PRODUCTION 
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
system(sprintf("gdal_calc.py -A %s --co=\"COMPRESS=LZW\" --type=Byte --outfile=%s --calc=\"%s\" --overwrite",
               tmp_mask_biomass,
               tmp_biomass_prod_constraint_mask,
               "(A<1000)>0"
))
# +++5 DISTANCE TO WETLANDS
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
system(sprintf("gdal_calc.py -A %s --co=\"COMPRESS=LZW\" --type=Byte --outfile=%s --calc=\"%s\" --overwrite",
               tmp_dist2_unsuit_wetland,
               tmp_dist2wetland_constraint_mask,
               "(A<1000)>0"
))
# +++6 DISTANCE TO NATURE RESERVE OR NATIONAL PARK
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
# +++7 WETLANDS MASK -> unsuit_mask_wetland_tif
# +++8 WATER BODY MASK
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
system(sprintf("gdal_calc.py -A %s --co=\"COMPRESS=LZW\" --type=Byte --outfile=%s --calc=\"%s\" --overwrite",
               lc_tif,
               tmp_lc_water_constraint_mask,
               "(A==80)>0"
))
# +++9 CROPLAND MASK
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
system(sprintf("gdal_calc.py -A %s --co=\"COMPRESS=LZW\" --type=Byte --outfile=%s --calc=\"%s\" --overwrite",
               lc_tif,
               tmp_lc_cropland_constraint_mask,
               "((A==41)+(A==42))>0"
))
# +++10 ALTITUDE
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
system(sprintf("gdal_calc.py -A %s --co=\"COMPRESS=LZW\" --type=Byte --outfile=%s --calc=\"%s\" --overwrite",
               lc_tif,
               tmp_lc_cropland_constraint_mask,
               "((A==41)+(A==42))>0"
))
# +++11 MILITARY BASE MASK                   -> unsuit_land_military_tif
# +++12 NATURE RESERVE OR NATIONAL PARK MASK -> unsuit_mask_land_reserves_tif
# +++13 RELIGION
# +++14 ETHNICITY
# +++15 CONFLICT
# +++16 LAND TENURE

# +++17 POPULATION DENSITY
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++