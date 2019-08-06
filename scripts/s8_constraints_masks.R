# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# +000 CONSTRAINTS CRITERIA DEFINITION
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#general
system(sprintf("gdal_calc.py -A %s -B %s -C %s -D %s -E %s -F %s -G %s -H %s -I %s -J %s --co=\"COMPRESS=LZW\" --type=Byte --outfile=%s --calc=\"%s\" --overwrite",
               preci_factmult,
               tmp_dist2water,
               tmp_slope_path,
               tmp_mask_biomass,
               tmp_dist2_unsuit_wetland,
               tmp_dist2_unsuit_land_reserves,
               unsuit_land_military_tif,
               unsuit_mask_land_reserves_tif,
               unsuit_mask_wetland_tif,
               lc_tif,
               
               tmp_mask_exclusion,
               "((A<200)+(B>2000)+(C>20)+(D<1000)+(E<1000)+(F<24000)+(G==1)+(H==1)+(I==1)+(J==41)+(J==42)+(J==50)+(J==80))>0"
))
# precipitation criterion less strict
system(sprintf("gdal_calc.py -A %s -B %s -C %s -D %s -E %s -F %s -G %s -H %s -I %s -J %s --co=\"COMPRESS=LZW\" --type=Byte --outfile=%s --calc=\"%s\" --overwrite",
               preci_factmult,
               tmp_dist2water,
               tmp_slope_path,
               tmp_mask_biomass,
               tmp_dist2_unsuit_wetland,
               tmp_dist2_unsuit_land_reserves,
               unsuit_land_military_tif,
               unsuit_mask_land_reserves_tif,
               unsuit_mask_wetland_tif,
               lc_tif,
               
               tmp_mask_exclusion2,
               "((A<100)+(B>2000)+(C>20)+(D<1000)+(E<1000)+(F<24000)+(G==1)+(H==1)+(I==1)+(J==41)+(J==42)+(J==50)+(J==80))>0"
))
#without precipitation
system(sprintf("gdal_calc.py -A %s -B %s -C %s -D %s -E %s -F %s -G %s -H %s -I %s --co=\"COMPRESS=LZW\" --type=Byte --outfile=%s --calc=\"%s\" --overwrite",
               tmp_dist2water,
               tmp_slope_path,
               tmp_mask_biomass,
               tmp_dist2_unsuit_wetland,
               tmp_dist2_unsuit_land_reserves,
               unsuit_land_military_tif,
               unsuit_mask_land_reserves_tif,
               unsuit_mask_wetland_tif,
               lc_tif,
               
               tmp_mask_exclusion3,
               "((A>2000)+(B>20)+(C<1000)+(D<1000)+(E<24000)+(F==1)+(G==1)+(H==1)+(I==41)+(I==42)+(I==50)+(I==80))>0"
))
#without croplands
system(sprintf("gdal_calc.py -A %s -B %s -C %s -D %s -E %s -F %s -G %s -H %s -I %s -J %s --co=\"COMPRESS=LZW\" --type=Byte --outfile=%s --calc=\"%s\" --overwrite",
               preci_factmult,
               tmp_dist2water,
               tmp_slope_path,
               tmp_mask_biomass,
               tmp_dist2_unsuit_wetland,
               tmp_dist2_unsuit_land_reserves,
               unsuit_land_military_tif,
               unsuit_mask_land_reserves_tif,
               unsuit_mask_wetland_tif,
               lc_tif,
               
               tmp_mask_exclusion4,
               "((A<200)+(B>2000)+(C>20)+(D<1000)+(E<1000)+(F<24000)+(G==1)+(H==1)+(I==1)+(J==50)+(J==80))>0"
))
#without dist2water
system(sprintf("gdal_calc.py -A %s -B %s -C %s -D %s -E %s -F %s -G %s -H %s -I %s --co=\"COMPRESS=LZW\" --type=Byte --outfile=%s --calc=\"%s\" --overwrite",
               preci_factmult,
               tmp_slope_path,
               tmp_mask_biomass,
               tmp_dist2_unsuit_wetland,
               tmp_dist2_unsuit_land_reserves,
               unsuit_land_military_tif,
               unsuit_mask_land_reserves_tif,
               unsuit_mask_wetland_tif,
               lc_tif,
               
               tmp_mask_exclusion5,
               "((A<200)+(B>20)+(C<1000)+(D<1000)+(E<24000)+(F==1)+(G==1)+(H==1)+(I==41)+(I==42)+(I==50)+(I==80))>0"
))
#without AGBP
system(sprintf("gdal_calc.py -A %s -B %s -C %s -D %s -E %s -F %s -G %s -H %s -I %s --co=\"COMPRESS=LZW\" --type=Byte --outfile=%s --calc=\"%s\" --overwrite",
               preci_factmult,
               tmp_dist2water,
               tmp_slope_path,
               tmp_dist2_unsuit_wetland,
               tmp_dist2_unsuit_land_reserves,
               unsuit_land_military_tif,
               unsuit_mask_land_reserves_tif,
               unsuit_mask_wetland_tif,
               lc_tif,
               
               tmp_mask_exclusion6,
               "((A<200)+(B>2000)+(C>20)+(D<1000)+(E<24000)+(F==1)+(G==1)+(H==1)+(I==41)+(I==42)+(I==50)+(I==80))>0"
))
#without slope
system(sprintf("gdal_calc.py -A %s -B %s -C %s -D %s -E %s -F %s -G %s -H %s -I %s --co=\"COMPRESS=LZW\" --type=Byte --outfile=%s --calc=\"%s\" --overwrite",
               preci_factmult,
               tmp_dist2water,
               tmp_mask_biomass,
               tmp_dist2_unsuit_wetland,
               tmp_dist2_unsuit_land_reserves,
               unsuit_land_military_tif,
               unsuit_mask_land_reserves_tif,
               unsuit_mask_wetland_tif,
               lc_tif,
               
               tmp_mask_exclusion7,
               "((A<200)+(B>2000)+(C<1000)+(D<1000)+(E<24000)+(F==1)+(G==1)+(H==1)+(I==41)+(I==42)+(I==50)+(I==80))>0"
))
#without built-up
system(sprintf("gdal_calc.py -A %s -B %s -C %s -D %s -E %s -F %s -G %s -H %s -I %s -J %s --co=\"COMPRESS=LZW\" --type=Byte --outfile=%s --calc=\"%s\" --overwrite",
               preci_factmult,
               tmp_dist2water,
               tmp_slope_path,
               tmp_mask_biomass,
               tmp_dist2_unsuit_wetland,
               tmp_dist2_unsuit_land_reserves,
               unsuit_land_military_tif,
               unsuit_mask_land_reserves_tif,
               unsuit_mask_wetland_tif,
               lc_tif,
               
               tmp_mask_exclusion8,
               "((A<200)+(B>2000)+(C>20)+(D<1000)+(E<1000)+(F<24000)+(G==1)+(H==1)+(I==1)+(J==41)+(J==42)+(J==80))>0"
))
#Combinaison of all the constraints criteria

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
