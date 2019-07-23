# COMBINE FEATURES

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
               
               suitability_map_no_mask,
               
               "((A+B+C)*0.5/3+
                (D+E+F)*0.3/3+
                (G+H+I+J)*0.2/4)"
))
system(sprintf("gdal_calc.py -A %s -B %s --co=\"COMPRESS=LZW\" --outfile=%s --calc=\"%s\" --overwrite",
               suitability_map_no_mask,
               tmp_mask_exclusion,
               suitability_map_mask,
               "A*(1-B)"
))

#On fait 1-L car dans L, on retrouve les éléments qui ne nous intéresse pas, donc qu'on veut masquer qui valent 1.
#Dès lors, ceux là représentent les "constraints criteria" où, quand ils valent 1, c'est ce qu'on ne veut pas prendre en compte et 0, ce qu'on veut prendre en compte.
#On va donc avoir, pour les éléments à masquer, (1-1=0) *(autres critères) -> ca donnera 0 -> ce qu'on veut 
#lorsque le pixel auquel on s'intéresse n'a pas de valeur =1, ce qu'on veut masquer, alors ce sera simplement (1-0=1) * (autres critères)

#% of Niger suitable 



## SURFACE MINIMALE /PERS
# calculer le nombre de pixels minimums à prendre en compte pour un nombre minimum de personne:
# 3.5m² / pers and 4.5m² / pers in cold climates

## REMOVE "tmp_" FILES
system(sprintf("rm -r -f %s",
               paste0(data0dir,"tmp*.tif")
))






