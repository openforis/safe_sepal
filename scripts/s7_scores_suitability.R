# GIVE SCORES TO PARAMETERS
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# DISTANCE TO SURFACE + UNDERGROUND WATER  
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
input  <- dist2water
output <- score_water

system(sprintf("gdal_calc.py -A %s --co=\"COMPRESS=LZW\" --type=Byte --outfile=%s --calc=\"%s\" --overwrite",
               input,
               output,
               "(A<500/30)*1+(A>=500/30)*(A<=1000/30)*2+(A>1000/30)*3"
))

#ALTERNATIVE !
dist_a <- 500
dist_b <- 1000
suitIndex_a <- 1
suitIndex_b <- 0
system(sprintf("gdal_calc.py -A %s --co=\"COMPRESS=LZW\" --type=Byte --outfile=%s --calc=\"%s\" --overwrite",
               dist2water,
               score_dist2water,
               "(A< dist_a/30)*1 +
                (A> dist_b/30)*0 +
                (A>= dist_a/30)*(A<= dist_b/30)* (suitIndex_a +((A - dist_a)/(dist_b - dist_a)*(suitIndex_b - suitIndex_a))
               "
))


# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## DISTANCE TO SURFACE WATER 
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
input  <- dist2surf_water
output <- score_surf_water

system(sprintf("gdal_calc.py -A %s --co=\"COMPRESS=LZW\" --type=Byte --outfile=%s --calc=\"%s\" --overwrite",
               input,
               output,
               "(A<500/30)*1+(A>=500/30)*(A<=1000/30)*2+(A>1000/30)*3"
))
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# DISTANCE TO UNDERGROUND WATER  
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
input  <- dist2under_water
output <- score_under_water

system(sprintf("gdal_calc.py -A %s --co=\"COMPRESS=LZW\" --type=Byte --outfile=%s --calc=\"%s\" --overwrite",
               input,
               output,
               "(A<500/30)*1+(A>=500/30)*(A<=1000/30)*2+(A>1000/30)*3"
))
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## PRECIPITATIONS - WAPOR
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
input  <- preci_tif
output <- score_preci

system(sprintf("gdal_calc.py -A %s --co=\"COMPRESS=LZW\" --type=Byte --outfile=%s --calc=\"%s\" --overwrite",
               input,
               output,
               "(A>300*0.1)*1+(A>=100*0.1)*(A<=300*0.1)*2+(A<100*0.1)*3"
))
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## SLOPE
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
input  <- slope_path
output <- score_slope

system(sprintf("gdal_calc.py -A %s --co=\"COMPRESS=LZW\" --type=Byte --outfile=%s --calc=\"%s\" --overwrite",
               input,
               output,
               "(A>=2)*(A<4)*1+(A>=4)*(A<=10)*2+(A>=0)*(A<=1)*(A>10)*3"
))

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
##  DISTANCE TO BORDERS
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
input  <- dist2boundaries
output <- score_boundaries

system(sprintf("gdal_calc.py -A %s --co=\"COMPRESS=LZW\" --type=Byte --outfile=%s --calc=\"%s\" --overwrite",
               input,
               output,
               "(A>50000/30)*1+(A>=25000/30)*(A<=50000/30)*2+(A<25000/30)*3"
))

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## ABOVE GROUND BIOMASS PRODUCTION -> CHECK RESULTS WITH GEOSAHEL - VALUES 2018 
#  Also available on WAPOR
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
input  <- biomass_tif
output <- score_biomass

system(sprintf("gdal_calc.py -A %s --co=\"COMPRESS=LZW\" --type=Byte --outfile=%s --calc=\"%s\" --overwrite",
               input,
               output,
               "(A>3000)*1+(A>=1500)*(A<=3000)*2+(A<1500)*3"
))
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
##  DISTANCE TO ELECTRIC LINES 
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
input  <- dist2electricity
output <- score_electricity

system(sprintf("gdal_calc.py -A %s --co=\"COMPRESS=LZW\" --type=Byte --outfile=%s --calc=\"%s\" --overwrite",
               input,
               output,
               "(A<5000/30)*1+(A>=5000/30)*(A<=10000/30)*2+(A>10000/30)*3"
))

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
##  DISTANCE TO ROADS 
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

input  <- dist2roads
output <- score_roads

system(sprintf("gdal_calc.py -A %s --co=\"COMPRESS=LZW\" --type=Byte --outfile=%s --calc=\"%s\" --overwrite",
               input,
               output,
               "(A<=1000/30)*1+(A>1000/30)*(A<=5000/30)*2+(A>5000/30)*3"
))

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
##  DISTANCE TO SETTLEMENTS 
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
input  <- dist2towns
output <- score_towns 

system(sprintf("gdal_calc.py -A %s --co=\"COMPRESS=LZW\" --type=Byte --outfile=%s --calc=\"%s\" --overwrite",
               input,
               output,
               "(A<5000/30)*1+(A>=5000/30)*(A<=10000/30)*2+(A>10000/30)*3"
))

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
##  DISTANCE TO HEALTH INFRASTRUCTURES
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

input  <- dist2health
output <- score_health

system(sprintf("gdal_calc.py -A %s --co=\"COMPRESS=LZW\" --type=Byte --outfile=%s --calc=\"%s\" --overwrite",
               input,
               output,
               "(A<5000/30)*1+(A>=5000/30)*(A<=10000/30)*2+(A>10000/30)*3"
))

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
##  DISTANCE TO EDUCATION INFRASTRUCTURES
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
input  <-  dist2education
output <- score_education

system(sprintf("gdal_calc.py -A %s --co=\"COMPRESS=LZW\" --type=Byte --outfile=%s --calc=\"%s\" --overwrite",
               input,
               output,
               "(A<5000/30)*1+(A>=5000/30)*(A<=10000/30)*2+(A>10000/30)*3"
))
