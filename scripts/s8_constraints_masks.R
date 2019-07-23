#Constraints features


system(sprintf("gdal_calc.py -A %s -B %s -C %s -D %s -E %s -F %s -G %s -H %s -I %s -J %s --co=\"COMPRESS=LZW\" --type=Byte --outfile=%s --calc=\"%s\" --overwrite",
               tmp_dist2water,
               tmp_mask_biomass,
               tmp_slope_path,
               tmp_dist2_unsuit_land_reserves,
               tmp_dist2_unsuit_wetland,
               preci_factmult,
               unsuit_land_military_tif,
               unsuit_land_reserves_tif,
               unsuit_wetland_tif,
               lc_tif,
               
               tmp_mask_exclusion,
               "((A>2000)+(B<1000)+(C>20)+(D<15000)+(E<1000)+(F<100)+(G==1)+(H==1)+(I==1)+(J==41)+(J==42)+(J==50)+(J==80))>0"
))
