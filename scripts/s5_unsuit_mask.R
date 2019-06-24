# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## UNSUITABLE AREAS - agricultural land/nature reserve/military/national park/wetlands
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

unsuit         <- paste0(data0dir, "unsuitable.tif")

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## BUFFER OF 15 KM AROUND NATIONAL PARKS OR NATURE RESERVE
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
unsuitable <- paste0(data0dir,"unsuit_land_osm.shp")
# unsuitable$unsuit_code -> nature_reserve = 2
#            "              national_park = 4

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## SLOPE
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
input  <- paste0(data0dir,"slope.tif")
output <- paste0(data0dir,"score_slope.tif")

system(sprintf("gdal_calc.py -A %s --co=\"COMPRESS=LZW\" --outfile=%s --calc=\"%s\" --overwrite",
               input,
               output,
               "(A>20)*1"
))