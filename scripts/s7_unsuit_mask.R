# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## UNSUITABLE AREAS - agricultural land/nature reserve/military/national park/wetlands
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
land_mask      <- paste0(data0dir, "unsuit_land.tif")
wetland_mask   <- paste0(data0dir,"unsuit_wetland.tif")



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
output <- paste0(data0dir,"mask_slope.tif")

system(sprintf("gdal_calc.py -A %s --co=\"COMPRESS=LZW\" --outfile=%s --calc=\"%s\" --overwrite",
               input,
               output,
               "(A>20)*1"
))