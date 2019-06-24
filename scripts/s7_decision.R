# COMBINE FEATURES

output  <- paste0(data0dir, "suitability_map.tif")

system(sprintf("gdal_calc.py -A %s -B %s -C %s --co=\"COMPRESS=LZW\" --outfile=%s --calc=\"%s\" --overwrite",
               paste0(data0dir,"score_surf_water.tif"),
               paste0(data0dir,"score_under_water.tif"),
               paste0(data0dir,"score_preci.tif"),
               
               paste0(data0dir,"score_slope.tif"),
               paste0(data0dir,"score_biomass.tif"),
               paste0(data0dir,"score_roads.tif"),
               paste0(data0dir,"score_borders.tif"),
               
               
               paste0(data0dir,"score_electricity.tif"),
               paste0(data0dir,"score_towns.tif"),
               paste0(data0dir,"score_health.tif"),
               paste0(data0dir,"score_education.tif"),
               output,
               "(A==1)*(B==1)*(C==1)*1+
                (A==2)*(B==2)*(C==2)*2+
                (A==3)*(B==3)*(C==3)*3"
))

