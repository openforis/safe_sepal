# NERGE ZONAL STATS INTO DBF

paste0(data0dir,"dist2surf_water.tif")
paste0(data0dir,"score_surf_water.tif")


system(sprintf("gdal_calc.py -A %s --co=\"COMPRESS=LZW\" --outfile=%s --calc=\"%s\" --overwrite",
               paste0(data0dir,"dist2surf_water.tif") ,
               paste0(data0dir,"tmp_score_surf_water.tif"),
               "(A>500/30)*1+(A<=500/30)*(A>1030)*2+(A<100/30)*3"
))
