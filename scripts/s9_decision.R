# COMBINE FEATURES

output  <- paste0(data0dir, "suitability_map.tif")

system(sprintf("gdal_calc.py -A %s -B %s -C %s --co=\"COMPRESS=LZW\" --outfile=%s --calc=\"%s\" --overwrite",
               paste0(data0dir,"unsuit_land.tif"),
               paste0(data0dir,"unsuit_wetland.tif"),
               paste0(data0dir,"slope.tif"),
               
               paste0(data0dir, "tmp_mask_exclusion.tif"),
               "((A==1)+(B==1)+(C>20))>0"
))

system(sprintf("gdal_calc.py -A %s -B %s -C %s -D %s -E %s -F %s -G %s -H %s -I %s -J %s -K %s -L %s  --co=\"COMPRESS=LZW\" --outfile=%s --calc=\"%s\" --overwrite",
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
               
               paste0(data0dir, "tmp_mask_exclusion.tif"),
               
               paste0(data0dir, "tmp_suitability_map.tif"),
               
               "(1-L)*((A+B+C)*1+
                (D+E+F+G)*2+
                (H+I+J+K)*3)"
))

####################  CREATE A PSEUDO COLOR TABLE

colfunc <- colorRampPalette(c("green", "red"))
cols    <- col2rgb(c("black",colfunc(47)))

# cols <- col2rgb(c("black","beige","yellow","orange","red","darkred","palegreen","green2","forestgreen",'darkgreen'))
pct <- data.frame(cbind(c(0,23:69),
                        cols[1,],
                        cols[2,],
                        cols[3,]
))

write.table(pct,paste0(data0dir,'color_table.txt'),row.names = F,col.names = F,quote = F)

## Compress final result
system(sprintf("gdal_translate -ot Byte -co COMPRESS=LZW %s %s",
               paste0(data0dir, "tmp_suitability_map.tif"),
               paste0(data0dir, "tmp_suitability_map_byte.tif")
))


################################################################################
## Add pseudo color table to result
system(sprintf("(echo %s) | oft-addpct.py %s %s",
               paste0(data0dir,'color_table.txt'),
               paste0(data0dir, "tmp_suitability_map_byte.tif"),
               paste0(data0dir, "tmp_suitability_map_pct.tif")
))

## Compress final result
system(sprintf("gdal_translate -ot Byte -co COMPRESS=LZW %s %s",
               paste0(data0dir, "tmp_suitability_map_pct.tif"),
               output
))



## SURFACE MINIMALE /PERS
# calculer le nombre de pixels minimums à prendre en compte pour un nombre minimum de personne:
# 3.5m² / pers and 4.5m² / pers in cold climates

## REMOVE "tmp_" FILES
system(sprintf("rm -r -f %s",
               paste0(data0dir,"tmp*.tif")
))

