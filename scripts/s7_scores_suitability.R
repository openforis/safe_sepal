# GIVE SCORES TO PARAMETERS
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# DISTANCE TO WATER SOURCES : SURFACE + UNDERGROUND WATER  
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
system(sprintf("gdal_calc.py -A %s --co=\"COMPRESS=LZW\" --type=Byte --outfile=%s --calc=\"%s\" --overwrite",
               tmp_dist2water,
               score_dist2water,
               "(A<=500/90)*100+(A>1000/90)*0+(A>500/90)*(A<=1000/90)*(100+((A-500/90)/(1000/90-500/90))*(0-100))"
))

plot(raster(score_dist2water))

hist(raster(score_dist2water),
     main = "Distribution of suitability index values",
     xlab = "suitability index", ylab = "Frequency",
     col = "springgreen")


# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
##  DISTANCE TO BOUNDARIES
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

system(sprintf("gdal_calc.py -A %s --co=\"COMPRESS=LZW\" --type=Byte --outfile=%s --calc=\"%s\" --overwrite",
               tmp_dist2boundaries,
               score_dist2boundaries,
               "(A>=50000/90)*100+(A<25000/90)*0+(A>=25000/90)*(A<50000/90)*(100+((A-25000/90)/(50000/90-25000/90))*(0-100))"
))
plot(raster(score_dist2boundaries))


# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
##  DISTANCE TO ELECTRIC LINES 
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
system(sprintf("gdal_calc.py -A %s --co=\"COMPRESS=LZW\" --type=Byte --outfile=%s --calc=\"%s\" --overwrite",
               tmp_dist2electricity,
               score_dist2electricity,
               "(A<=5000/90)*100+(A>=10000/90)*0+(A>5000/90)*(A<=10000/90)*(100+((A-5000/90)/(10000/90-5000/90))*(0-100))"
))
plot(raster(score_dist2electricity))

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
##  DISTANCE TO ROADS 
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
system(sprintf("gdal_calc.py -A %s --co=\"COMPRESS=LZW\" --type=Byte --outfile=%s --calc=\"%s\" --overwrite",
               tmp_dist2roads,
               score_dist2roads,
               "(A<=1000/90)*100+(A>5000/90)*0+(A>1000/90)*(A<=5000/90)*(100+((A-1000/90)/(5000/90-1000/90))*(0-100))"
))
plot(raster(score_dist2roads))

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
##  DISTANCE TO TOWNS 
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

system(sprintf("gdal_calc.py -A %s --co=\"COMPRESS=LZW\" --type=Byte --outfile=%s --calc=\"%s\" --overwrite",
               tmp_dist2towns,
               score_dist2towns,
               "(A<=5000/90)*100+(A>10000/90)*0+(A>5000/90)*(A<=10000/90)*(100+((A-5000/90)/(10000/90-5000/90))*(0-100))"
))
plot(raster(score_dist2towns))

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
##  DISTANCE TO HEALTH INFRASTRUCTURES
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

system(sprintf("gdal_calc.py -A %s --co=\"COMPRESS=LZW\" --type=Byte --outfile=%s --calc=\"%s\" --overwrite",
               tmp_dist2health,
               score_dist2health,
               "(A<=5000/90)*100+(A>=10000/90)*0+(A>5000/90)*(A<=10000/90)*(100+((A-5000/90)/(10000/90-5000/90))*(0-100))"
))
plot(raster(score_dist2towns))

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
##  DISTANCE TO EDUCATION INFRASTRUCTURES
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
system(sprintf("gdal_calc.py -A %s --co=\"COMPRESS=LZW\" --type=Byte --outfile=%s --calc=\"%s\" --overwrite",
               tmp_dist2education,
               score_dist2education,
               "(A<=5000/90)*100+(A>10000/90)*0+(A>5000/90)*(A<=10000/90)*(100+((A-5000/90)/(10000/90-5000/90))*(0-100))"
))
plot(raster(score_dist2towns))

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## SLOPE
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
system(sprintf("gdal_calc.py -A %s --co=\"COMPRESS=LZW\" --type=Byte --outfile=%s --calc=\"%s\" --overwrite",
               tmp_slope_path,
               score_slope,
               "(A>=2)*(A<=4)*100+(A>10)*(A<2)*0+(A>4)*(A<=10)*(100+((A-4)/(10-4))*(0-100))"
))

plot(raster(score_slope))
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## PRECIPITATIONS - WAPOR
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
system(sprintf("gdal_calc.py -A %s --co=\"COMPRESS=LZW\" --type=Byte --outfile=%s --calc=\"%s\" --overwrite",
               preci_tif,
               score_preci,
               "(A>=300)*100+(A<100)*0+(A>=100)*(A<300)*(100+((A-100)/(300-100))*(0-100))"
               
))
## Conversion factor : the pixel value in the downloaded data must be multiplied by 0.1 (or divided by 10)
# So here, we will multiply the value that we want by ten since the values in the tif are 10 times higher than their real value
system(sprintf("gdal_calc.py -A %s --co=\"COMPRESS=LZW\" --type=Byte --outfile=%s --calc=\"%s\" --overwrite",
               preci_tif,
               score_preci_factmult,
               "(A>=300*10)*100+(A<100*10)*0+(A>=100*10)*(A<300*10)*(100+((A-100)/(300-100))*(0-100))"
               
))

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## ABOVE GROUND BIOMASS PRODUCTION -> CHECK RESULTS WITH GEOSAHEL - VALUES 2018 
#  Also available on WAPOR
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
##  BIOMASS 
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
               "(A>3000)*100+(A<1500)*0+(A>=1500)*(A<=3000)*(100+((A-1500)/(3000-1500))*(0-100))"
))

plot(raster(score_biomass_prod))

hist(raster(score_biomass_prod),
     main = "Distribution of suitability index values",
     xlab = "suitability index", ylab = "Frequency",
     col = "springgreen")



