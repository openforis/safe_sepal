# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# +000 CONSTRAINTS CRITERIA DEFINITION
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

system(sprintf("gdal_calc.py -A %s -B %s -C %s -D %s -E %s -F %s -G %s -H %s -I %s -J %s --co=\"COMPRESS=LZW\" --type=Byte --outfile=%s --calc=\"%s\" --overwrite",
               preci_factmult,
               tmp_dist2water,
               tmp_slope_path,
               tmp_mask_biomass,
               tmp_dist2_unsuit_wetland,
               tmp_dist2_unsuit_land_reserves,
               unsuit_land_military_tif,
               unsuit_land_reserves_tif,
               unsuit_wetland_tif,
               lc_tif,
               
               tmp_mask_exclusion,
               "((A<200)+(B>2000)+(C>20)+(D<1000)+(E<1000)+(F<24000)+(G==1)+(H==1)+(I==1)+(J==41)+(J==42)+(J==50)+(J==80))>0"
))
