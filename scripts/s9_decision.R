# COMBINE FEATURES

system(sprintf("gdal_calc.py -A %s -B %s -C %s --co=\"COMPRESS=LZW\" --outfile=%s --calc=\"%s\" --overwrite",
               unsuit_land_tif,
               unsuit_wetland_tif,
               slope_path,
               
               tmp_mask_exclusion,
               "((A==1)+(B==1)+(C>20))>0"
))

system(sprintf("gdal_calc.py -A %s -B %s -C %s -D %s -E %s -F %s -G %s -H %s -I %s -J %s -K %s -L %s  --co=\"COMPRESS=LZW\" --outfile=%s --calc=\"%s\" --overwrite",
               score_surf_water,
               score_under_water,
               #??dist2water
               score_preci,
               
               score_slope,
               score_biomass,
               score_roads,
               score_boundaries,
               
               score_electricity,
               score_towns,
               score_health,
               score_education,
               
               tmp_mask_exclusion,
               
               tmp_suitability_map,
               
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

write.table(pct,color_table_txt,row.names = F,col.names = F,quote = F)

## Compress final result
system(sprintf("gdal_translate -ot Byte -co COMPRESS=LZW %s %s",
               tmp_suitability_map,
               tmp_suitability_map_byte
))


################################################################################
## Add pseudo color table to result
system(sprintf("(echo %s) | oft-addpct.py %s %s",
               color_table_txt,
               tmp_suitability_map_byte,
               tmp_suitability_map_pct
))

## Compress final result
system(sprintf("gdal_translate -ot Byte -co COMPRESS=LZW %s %s",
               tmp_suitability_map_pct,
               suitability_map
))



## SURFACE MINIMALE /PERS
# calculer le nombre de pixels minimums à prendre en compte pour un nombre minimum de personne:
# 3.5m² / pers and 4.5m² / pers in cold climates

## REMOVE "tmp_" FILES
system(sprintf("rm -r -f %s",
               paste0(data0dir,"tmp*.tif")
))

