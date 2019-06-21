####################################################################################
####### Object:  Suitability map - Site locations selection for displacement settings           
####### Author:  sarah.wertz@fao.org                        
####### Update:  2019/06/19                                  
####################################################################################
rm(list=ls())

# +005 DEFINE AOI WITH THE BOUNDARIES OF THE COUNTRY : CREATE A MASK LAYER 
#      COUNTRY'S BOUNDARIES 
# +006 EXTRACT AND PREPARE LAYERS 
# #    I/ SHAPEFILES 
#      GET OSM DATA -> tmpdir
# #    #            1/   WATER RESOURCES
# #    #            1-1/ WATER POIS OSM - drinking_water/water_tower/water_well/water_works
# #    #            1-2/ WATER OSM - reservoir/river/water
# #    #            1-3/ WATERWAYS OSM  - canal/drain/river/stream
# #    #            1-4/ WATER NATURAL OSM - spring
# #    #            2/   ELECTRIC LINES 
# #    #            3/   ROADS 
# #    #            4/   RELIGION 
# #    #            5/   BIOMASS
# #    #            6/   SETTLEMENTS 
# #    #            7/   HEALTH 
# #    #            8/   EDUCATION 
# #    #            9/   OPEN AREAS - meadow/grass/heath=uncultivated land
# #    #            10/  UNSUITABLE AREAS - agricultural land/nature reserve/military/national park/wetlands
# #    II/ RASTERS 
# #    #            11/  SRTM 
# #    #            12/  GLOBAL FOREST CHANGE 
# #    #            13/  LAND USE / LAND COVER 
# #    #            14/  POPULATION DENSITY 
# #    #            15/  PRECIPITATIONS 
# #    III/ DATA TABLE
# #    #            16/  CONFLICTS 

# +007 ANALYSIS
# #    I/ DISTANCES TO FEATURES 
# #    #            1/   WATER RESOURCES
# #    #            1-1/   UNDERGROUND WATER 
# #    #            1-2/   SURFACE WATER 
# #    #            2/   ELECTRIC LINES 
# #    #            3/   ROADS
# #    #            4/   BIOMASS
# #    #            5/   SETTLEMENTS 
# #    #            6/   HEALTH 
# #    #            7/   EDUCATION 

# #    II/ EXCLUDING FEATURES 
# #    #            8/  SRTM 
# #    #            9/  LAND USE / LAND COVER 
# #    #            9-1/   OPEN AREAS - meadow/grass/heath=uncultivated land
# #    #            9-2/   UNSUITABLE AREAS - agricultural land/nature reserve/military/national park/wetlands
# #    #            10/  POPULATION DENSITY 

# #    RELIGION? CONFLICTS? PRECIPITATIONS?


# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
##################### 12/ BIOMASS
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
##################### 12-1/ ABOVE GROUND BIOMASS PRODUCTION
# https://wapor.apps.fao.org/catalog/1/L1_AGBP_A

##################### 12-3/ GFC - Global Forest Change

packages(Hmisc)
packages(faraway)
packages(mgcv)
packages(sjPlot)
packages(sjmisc)

options(stringsAsFactors = F)

##################### CHECK WHICH GFC TILES FALL ON IT
#Calculate the GFC product tiles needed for a given AOI
#https://cran.r-project.org/web/packages/gfcanalysis/gfcanalysis.pdf
tiles           <- calc_gfc_tiles(aoi_utm)

plot(tiles)
plot(aoi_utm,add=T)
plot(aoi, add=T)

##################### DOWNLOAD IF NECESSARY
#https://cran.r-project.org/web/packages/gfcanalysis/gfcanalysis.pdf
download_tiles(tiles,output_folder = gfcdir,images = c("treecover2000","lossyear","gain","datamask") )


##################### REPROJECT IN THE CORRECT SYSTEM -> use mask0

for(file in list.files(gfcdir,glob2rx("Hansen*.tif"))){
  input <- paste0(gfcdir,file)
  
  system(sprintf("gdal_translate -co COMPRESS=LZW  -projwin %s %s %s %s %s %s",
                 extent(mask0)@xmin,
                 extent(mask0)@ymax,
                 extent(mask0)@xmax,
                 extent(mask0)@ymin,
                 input,
                 paste0(gfcdir,"crop_",file)
  ))
  
  system(sprintf("gdalwarp -co COMPRESS=LZW  -t_srs \"%s\" %s %s",
                 "+proj=utm +zone=31 +datum=WGS84 +units=m +no_defs +ellps=WGS84 +towgs84=0,0,0",
                 paste0(gfcdir,"crop_",file),
                 paste0(gfcdir,"utm_crop_",file)
  ))
}


# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
##################### 13/ LU-LC - Land Use - Land Cover 
# Land rights and Development in Niger : http://www.focusonland.com/countries/niger/
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
##################### 13.1/ LAND COVER


# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
##################### 14/ POPULATION DENSITY  
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
##################### 14.1/ FROM ENERGYDATA.INFO   
# https://energydata.info/dataset/niger-republic-population-density-2015

# DOWNLOAD THE FILE - UNZIP IT
url            <- "https://energydata.info/dataset/fb16aa42-d0bc-4a2e-bb1a-7720be13b056/resource/da74fbc7-54b2-424d-ac02-9a9228c3ee39/download/ner-popner15adjv4.zip"
file           <- "ner-popner15adjv4.zip"

download.file(url = url,
              destfile = paste0(denspopdir,file))

system(sprintf("unzip -o %s -d %s",
               paste0(denspopdir,file),
               denspopdir))

# READ THE RASTER FILE AND VISUALIZE IT
file2             <- "NER15adjv4.tif" 
denspop           <- raster(paste0(denspopdir,file2))

plot(denspop)
denspop

# TRANSFORM THE COORDINATE SYSTEM -- USING EPSG0: +proj=utm
proj4string(denspop)
denspop_utm       <- projectRaster(denspop, crs = EPSG0) 
denspop_utm
#saved in the setwd --- "~/safe_sepal/data_in/"
writeRaster(denspop_utm,"denspop_utm.tif",format='GTiff',overwrite=TRUE)

# TRANSFORM THE EXTENT -- USING THE EXTENT OF MASK0
mask0
denspop_utm       <- raster(paste0(datadir,"denspop_utm.tif"))
bb                <- extent(194610, 1865340, 1293120,2630580)
extent(denspop)   <- bb
denspop_utm_extent<- setExtent(denspop_utm, bb,keepres=F)
denspop_utm_extent
#saved in the setwd --- "~/safe_sepal/data_in/"
writeRaster(denspop_utm_extent,"denspop_utm_extent.tif",format='GTiff',overwrite=TRUE)

denspop_utm_extent<- raster(paste0(datadir,"denspop_utm_extent.tif"))

# TRANSFORM THE RESOLUTION -- USING THE RESOLUTION OF MASK0

res(mask0)
res(denspop_utm_extent)
#disaggregate from 88.7 x 92.5 resolution to 30x30 (factor = 3)
denspop_utm_extent_res <- disaggregate(denspop_utm_extent, fact=3)
res(denspop_utm_extent_res)
writeRaster(denspop_utm_extent_res,"denspop_utm_extent_res.tif",format='GTiff',overwrite=TRUE)

# ?? Use gdal warp to transform the raster 1 to raster 2 to direclty use mask0 ??

##################### 14.2/ FROM HUMDATA 
# https://data.humdata.org/organization/ocha-niger
url            <- "ftp://ftp.worldpop.org.uk/GIS/Population/Global_2000_2020/2018/NER/ner_ppp_2018.tif"
file           <- "ner_ppp_2018.tif"

download.file(url = url,
              destfile = paste0(denspopdir,file))

# READ THE RASTER FILE AND VISUALIZE IT
denspop2       <- raster(paste0(denspopdir,file))

plot(denspop2)
denspop2

# TRANSFORM THE COORDINATE SYSTEM -- USING EPSG0: +proj=utm
proj4string(denspop2)
EPSG0
denspop2_utm   <- projectRaster(denspop2, crs = EPSG0) 
denspop2_utm
#saved in the setwd --- "~/safe_sepal/data_in/"
writeRaster(denspop2_utm,"denspop2_utm.tif",format='GTiff',overwrite=TRUE)

# TRANSFORM THE EXTENT -- USING THE EXTENT OF MASK0
mask0
denspop2_utm        <- raster(paste0(datadir,"denspop2_utm.tif"))
bb                  <- extent(194610, 1865340, 1293120,2630580)
denspop2_utm_extent <- setExtent(denspop2_utm, bb,keepres=F)
denspop2_utm_extent
#saved in the setwd --- "~/safe_sepal/data_in/"
writeRaster(denspop2_utm_extent,"denspop2_utm_extent.tif",format='GTiff',overwrite=TRUE)

denspop2_utm_extent <- raster(paste0(datadir,"denspop2_utm_extent.tif"))

# TRANSFORM THE RESOLUTION -- USING THE RESOLUTION OF MASK0

res(mask0)
res(denspop2_utm_extent)
#disaggregate from 85.3 x 90.3 resolution to 30x30 (factor = 3)
denspop2_utm_extent_res <- disaggregate(denspop2_utm_extent, fact=3)
res(denspop2_utm_extent_res)
writeRaster(denspop2_utm_extent_res,"denspop2_utm_extent_res.tif",format='GTiff',overwrite=TRUE)

# ?? Use gdal warp to transform the raster 1 to raster 2 to direclty use mask0 ??

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
##################### 15/ PRECIPITATIONS
# FROM WAPOR : https://wapor.apps.fao.org/
# https://wapor.apps.fao.org/catalog/2
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Lire un fichier csv avec des champs de type caract?re
# /!\ if we don't put stringsAsFactors = F, les champs caractère sont des facteurs (parfois g?nant)
precip_2018<-read.csv(paste0(waterdir,"WAPOR_prec_NER_2018.csv"), sep = ";",stringsAsFactors=FALSE)
precip_2018
head(precip_2018)
class(precip_2018$Nom)


#####################   CHECK YOUR DATA0 FILE : YOU SHOULD HAVE ALL THE FILES IN .tif AND UTM
?ls
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# III/ DATA TABLE 
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# 
url         <- "https://www.acleddata.com/download/2909/"
file        <- "Africa_1997-2019_Jun08.xlsx"

download.file(url = url,
              destfile = paste0(tmpdir,file))

# transform the .xls to a .csv ---> how?

packages(xlsx)
library("rio")
xls <- dir(pattern = "xlsx")
created <- mapply(convert, xls, gsub("xlsx", "csv", xls))
unlink(xls) # delete xlsx files

# read the .csv
# pr?ciser le type de s?parateur d?cimal et le s?parateur de colonne
stat <- read.csv("stat.csv", dec = ".", sep = ";",stringsAsFactors=FALSE)

# Lire un fichier csv avec des champs de type caract?re
# Attention, si on ne pr?cise pas stringsAsFactors = F, les champs caract?re sont des facteurs (parfois g?nant)
loc_rdc<-read.csv("localite_rdc.csv", sep = ";")
class(loc_rdc$Nom)
loc_rdc<-read.csv("localite_rdc.csv", sep = ";",stringsAsFactors=FALSE)
class(loc_rdc$Nom)

