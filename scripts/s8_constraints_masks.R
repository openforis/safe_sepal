#Constraints features


system(sprintf("gdal_calc.py -A %s -B %s -C %s -D %s -E %s -F %s -G %s -H %s -I %s -J %s --co=\"COMPRESS=LZW\" --outfile=%s --calc=\"%s\" --overwrite",
               tmp_dist2water,
               tmp_mask_biomass,
               tmp_slope_path,
               tmp_dist2unsuit_land_reserves,
               tmp_dist2unsuit_wetland,
               preci_tif,
               unsuit_land_military_tif,
               unsuit_land_reserves_tif,
               unsuit_wetland_tif,
               lc_tif,
               
               tmp_mask_exclusion,
               "((A>2000/90)+(B<1000)+(C>20)+(D<15000/90)+(E<1000/90)+(F<100*10)+(G==1)+(H==1)+(I==1)+(J==41)+(J==42)+(J==50)+(J==80))>0"
))


