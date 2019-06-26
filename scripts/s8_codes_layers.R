# GIVE CODES TO PARAMETERS
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## DISTANCE TO SURFACE WATER 
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
input  <- paste0(data0dir,"dist2surf_water.tif")
output <- paste0(data0dir,"score_surf_water.tif")

system(sprintf("gdal_calc.py -A %s --co=\"COMPRESS=LZW\" --type=Byte --outfile=%s --calc=\"%s\" --overwrite",
               input,
               output,
               "(A<500/30)*1+(A>=500/30)*(A<=1000/30)*2+(A>1000/30)*3"
))
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# DISTANCE TO UNDERGROUND WATER  
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
input  <- paste0(data0dir,"dist2under_water.tif")
output <- paste0(data0dir,"score_under_water.tif")

system(sprintf("gdal_calc.py -A %s --co=\"COMPRESS=LZW\" --outfile=%s --calc=\"%s\" --overwrite",
               input,
               output,
               "(A<500/30)*1+(A>=500/30)*(A<=1000/30)*2+(A>1000/30)*3"
))
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## PRECIPITATIONS - WAPOR
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
input  <- paste0(data0dir,"preci_wapor_2018.tif")
output <- paste0(data0dir,"score_preci.tif")

system(sprintf("gdal_calc.py -A %s --co=\"COMPRESS=LZW\" --outfile=%s --calc=\"%s\" --overwrite",
               input,
               output,
               "(A>300*0.1)*1+(A>=100*0.1)*(A<=300*0.1)*2+(A<100*0.1)*3"
))
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## SLOPE
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
input  <- paste0(data0dir,"slope.tif")
output <- paste0(data0dir,"score_slope.tif")

system(sprintf("gdal_calc.py -A %s --co=\"COMPRESS=LZW\" --outfile=%s --calc=\"%s\" --overwrite",
               input,
               output,
               "(A>=2)*(A<4)*1+(A>=4)*(A<=10)*2+(A>=0)*(A<=1)*(A>10)*3"
))

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
##  DISTANCE TO BORDERS
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
input  <- paste0(data0dir,"dist2border.tif")
output <- paste0(data0dir,"score_borders.tif")

system(sprintf("gdal_calc.py -A %s --co=\"COMPRESS=LZW\" --outfile=%s --calc=\"%s\" --overwrite",
               input,
               output,
               "(A>50000/30)*1+(A>=25000/30)*(A<=50000/30)*2+(A<25000/30)*3"
))

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## ABOVE GROUND BIOMASS PRODUCTION -> CHECK RESULTS WITH GEOSAHEL - VALUES 2018 
#  Also available on WAPOR
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
input  <- paste0(data0dir,"biomass_geosahel2018.tif")
output <- paste0(data0dir,"score_biomass.tif")

system(sprintf("gdal_calc.py -A %s --co=\"COMPRESS=LZW\" --outfile=%s --calc=\"%s\" --overwrite",
               input,
               output,
               "(A>3000)*1+(A>=1500)*(A<=3000)*2+(A<1500)*3"
))
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
##  DISTANCE TO ELECTRIC LINES 
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
input  <- paste0(data0dir,"dist2electricity.tif")
output <- paste0(data0dir,"score_electricity.tif")

system(sprintf("gdal_calc.py -A %s --co=\"COMPRESS=LZW\" --outfile=%s --calc=\"%s\" --overwrite",
               input,
               output,
               "(A<5000/30)*1+(A>=5000/30)*(A<=10000/30)*2+(A>10000/30)*3"
))

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
##  DISTANCE TO ROADS 
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

input  <- paste0(data0dir,"dist2roads.tif")
output <- paste0(data0dir,"score_roads.tif")

system(sprintf("gdal_calc.py -A %s --co=\"COMPRESS=LZW\" --outfile=%s --calc=\"%s\" --overwrite",
               input,
               output,
               "(A<=1000/30)*1+(A>1000/30)*(A<=5000/30)*2+(A>5000/30)*3"
))

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
##  DISTANCE TO SETTLEMENTS 
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
input  <- paste0(data0dir,"dist2towns.tif")
output <- paste0(data0dir,"score_towns.tif")

system(sprintf("gdal_calc.py -A %s --co=\"COMPRESS=LZW\" --outfile=%s --calc=\"%s\" --overwrite",
               input,
               output,
               "(A<5000/30)*1+(A>=5000/30)*(A<=10000/30)*2+(A>10000/30)*3"
))

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
##  DISTANCE TO HEALTH INFRASTRUCTURES
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

input  <- paste0(data0dir,"dist2health.tif")
output <- paste0(data0dir,"score_health.tif")

system(sprintf("gdal_calc.py -A %s --co=\"COMPRESS=LZW\" --outfile=%s --calc=\"%s\" --overwrite",
               input,
               output,
               "(A<5000/30)*1+(A>=5000/30)*(A<=10000/30)*2+(A>10000/30)*3"
))

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
##  DISTANCE TO EDUCATION INFRASTRUCTURES
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
input  <-  paste0(data0dir,"dist2education.tif")
output <- paste0(data0dir,"score_education.tif")

system(sprintf("gdal_calc.py -A %s --co=\"COMPRESS=LZW\" --outfile=%s --calc=\"%s\" --overwrite",
               input,
               output,
               "(A<5000/30)*1+(A>=5000/30)*(A<=10000/30)*2+(A>10000/30)*3"
))
