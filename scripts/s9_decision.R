# COMBINE FEATURES

system(sprintf("gdal_calc.py -A %s -B %s -C %s -D %s -E %s -F %s -G %s -H %s -I %s -J %s -K %s --co=\"COMPRESS=LZW\" --outfile=%s --calc=\"%s\" --overwrite",
               score_dist2water,
               score_slope,
               score_dist2roads,
               
               score_biomass_prod,
               score_preci_factmult,
               score_dist2boundaries,
               
               score_dist2electricity,
               score_dist2towns,
               score_dist2health,
               score_dist2education,
               
               tmp_mask_exclusion,
               
               tmp_suitability_map,
               
               "(1-K)*((A+B+C)*0.5/3+
                (D+E+F)*0.3/3+
                (G+H+I+J)*0.2/4)"
))


system(sprintf("gdal_calc.py -A %s -B %s -C %s -D %s -E %s -F %s -G %s -H %s -I %s -J %s --co=\"COMPRESS=LZW\" --outfile=%s --calc=\"%s\" --overwrite",
               score_dist2water,
               score_slope,
               score_dist2roads,
               
               score_biomass_prod,
               score_preci_factmult,
               score_dist2boundaries,
               
               score_dist2electricity,
               score_dist2towns,
               score_dist2health,
               score_dist2education,
               
               tmp_suitability_map_without_mask,
               
               "((A+B+C)*0.5/3+
                (D+E+F)*0.3/3+
                (G+H+I+J)*0.2/4)"
))

#On fait 1-L car dans L, on retrouve les éléments qui ne nous intéresse pas, donc qu'on veut masquer qui valent 1.
#Dès lors, ceux là représentent les "constraints criteria" où, quand ils valent 1, c'est ce qu'on ne veut pas prendre en compte et 0, ce qu'on veut prendre en compte.
#On va donc avoir, pour les éléments à masquer, (1-1=0) *(autres critères) -> ca donnera 0 -> ce qu'on veut 
#lorsque le pixel auquel on s'intéresse n'a pas de valeur =1, ce qu'on veut masquer, alors ce sera simplement (1-0=1) * (autres critères)

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







inputs = paste0(r_file, " ", ir_file) # noms de fichiers qui contiennent les bandes "rouge" et "ir"
output = ndvi_file # nom du fichier de sortie    
expr = '"im1b1==0?0:im2b1==0?0:((im2b1-im1b1)/(im2b1+im1b1)*1000)+1000"'
cmdline = paste0(path_otb, 
                 "otbcli_BandMathX -il ",
                  inputs," -out",  
                  output,
                  " uint16 -ram 1024 -exp ",
                  expr)
system(cmdline) 





