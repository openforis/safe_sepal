# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# +000 ATTRIBUTE SCORES TO CRITERIA
# +++1 SCORE FOR THE PRECIPITATIONS - WAPOR
# +++2 SCORE FOR THE DISTANCE TO WATER RESOURCES
# +++3 SCORE FOR THE SLOPE
# +++4 SCORE FOR THE ABOVE GROUND BIOMASS PRODUCTION 
# +++5 SCORE FOR THE DISTANCE TO BOUNDARIES
# +++6 SCORE FOR THE DISTANCE TO ROADS
# +++7 SCORE FOR THE DISTANCE TO ELECTRICITY GRIDS
# +++8 SCORE FOR THE DISTANCE TO TOWNS 
# +++9 SCORE FOR THE DISTANCE TO HEALTH INFRASTRUCTURES 
# +++10 SCORE FOR THE DISTANCE TO EDUCATION INFRASTRUCTURES
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

# +++1 SCORE FOR THE PRECIPITATIONS - WAPOR
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
system(sprintf("gdal_calc.py -A %s --co=\"COMPRESS=LZW\" --type=Int32 --outfile=%s --calc=\"%s\" --overwrite",
               tmp_preci_tif,
               preci_factmult,
               "A*0.1"
))
system(sprintf("gdal_calc.py -A %s --co=\"COMPRESS=LZW\" --type=Byte --outfile=%s --calc=\"%s\" --overwrite",
               preci_factmult,
               score_preci_factmult,
               "(A>=350)*100+(A<250)*0+(A>=250)*(A<350)*(100*(A-100)/(300-100))"
))

# +++2 SCORE FOR THE DISTANCE TO WATER RESOURCES
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
system(sprintf("gdal_calc.py -A %s --co=\"COMPRESS=LZW\" --type=Byte --outfile=%s --calc=\"%s\" --overwrite",
               tmp_dist2water,
               score_dist2water,
               "(A<=500)*100+(A>1000)*0+(A>500)*(A<=1000)*(100+((A-500)*(0-100)/(1000-500)))"
))

# +++3 SCORE FOR THE SLOPE
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
system(sprintf("gdal_calc.py -A %s --co=\"COMPRESS=LZW\" --type=Byte --outfile=%s --calc=\"%s\" --overwrite",
               tmp_slope_path,
               score_slope,
               "(A>=2)*(A<=4)*100+(A>10)*(A<2)*0+(A>4)*(A<=10)*(100+((A-4)*(0-100)/(10-4)))"
))

# +++4 SCORE FOR THE ABOVE GROUND BIOMASS PRODUCTION 
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# FOCUS ON NIGER
system(sprintf("gdal_calc.py -A %s -B %s --co=\"COMPRESS=LZW\" --outfile=%s --calc=\"%s\" --overwrite",
               biomass_tif ,
               mask_path,
               tmp_mask_biomass,
               "A*(B>0)"
))
system(sprintf("gdal_calc.py -A %s --co=\"COMPRESS=LZW\" --type=Byte --outfile=%s --calc=\"%s\" --overwrite",
               tmp_mask_biomass,
               score_biomass_prod,
               "(A>=3000)*100+(A<1500)*0+(A>=1500)*(A<3000)*(100*(A-1500)/(3000-1500))"
))

# +++5 SCORE FOR THE DISTANCE TO BOUNDARIES
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
system(sprintf("gdal_calc.py -A %s --co=\"COMPRESS=LZW\" --type=Byte --outfile=%s --calc=\"%s\" --overwrite",
               tmp_mask_dist2boundaries,
               score_dist2boundaries,
               "(A>=50000)*100+(A<25000)*0+(A>=25000)*(A<50000)*(100*(A-25000)/(50000-25000))"
))

#lim_sup <-round(50000/90)
#lim_inf <-round(25000/90)

#system(sprintf("gdal_calc.py -A %s --co=\"COMPRESS=LZW\" --type=Byte --outfile=%s --calc=\"%s\" --overwrite",
#               tmp_mask_dist2boundaries_pixel,
#               score_dist2boundaries,
#               "(A>=lim_sup)*100+(A<lim_inf)*0+(A>=lim_inf)*(A<lim_sup)*(100*(A-lim_inf)/(lim_sup)-(lim_inf))"
#))

# +++6 SCORE FOR THE DISTANCE TO ROADS 
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
system(sprintf("gdal_calc.py -A %s --co=\"COMPRESS=LZW\" --type=Byte --outfile=%s --calc=\"%s\" --overwrite",
               tmp_dist2_roads,
               score_dist2roads,
               "(A<=1000)*100+(A>5000)*0+(A>1000)*(A<=5000)*(100+((A-1000)*(0-100)/(5000-1000)))"
))

# +++7 SCORE FOR THE DISTANCE TO ELECTRICITY GRIDS 
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
system(sprintf("gdal_calc.py -A %s --co=\"COMPRESS=LZW\" --type=Byte --outfile=%s --calc=\"%s\" --overwrite",
               tmp_dist2elec,
               score_dist2electricity,
               "(A<=5000)*100+(A>10000)*0+(A>5000)*(A<=10000)*(100+((A-5000)*(0-100)/(10000-5000)))"
))

# +++8 SCORE FOR THE DISTANCE TO TOWNS 
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
system(sprintf("gdal_calc.py -A %s --co=\"COMPRESS=LZW\" --type=Byte --outfile=%s --calc=\"%s\" --overwrite",
               tmp_dist2_towns,
               score_dist2towns,
               "(A<=5000)*100+(A>10000)*0+(A>5000)*(A<=10000)*(100+((A-5000)*(0-100)/(10000-5000)))"
))

# +++9 SCORE FOR THE DISTANCE TO HEALTH INFRASTRUCTURES 
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
system(sprintf("gdal_calc.py -A %s --co=\"COMPRESS=LZW\" --type=Byte --outfile=%s --calc=\"%s\" --overwrite",
               tmp_dist2_health,
               score_dist2health,
               "(A<=5000)*100+(A>10000)*0+(A>5000)*(A<=10000)*(100+((A-5000)*(0-100)/(10000-5000)))"
))

# +++10 SCORE FOR THE DISTANCE TO EDUCATION INFRASTRUCTURES
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
system(sprintf("gdal_calc.py -A %s --co=\"COMPRESS=LZW\" --type=Byte --outfile=%s --calc=\"%s\" --overwrite",
               tmp_dist2_edu,
               score_dist2education,
               "(A<=5000)*100+(A>10000)*0+(A>5000)*(A<=10000)*(100+((A-5000)*(0-100)/(10000-5000)))"
))