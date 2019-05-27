rm(list=ls())
library(raster)
library(rgdal)
library(gdalUtils)
library(sp)
library(sf)
library(rgeos)
library(plyr)

# path definition
path0 = "/home/swertz/script"
path_in = paste0(path0,"/data_in")
path_adm = paste0(path_in, "/Niger-adm") 
path_roads = paste0(path_in, "/roads" )
path_srtm = paste0(path_in, "/srtm")
path_srtm = paste0(path_in, "/water")
path_grid = paste0(path0, "/grid" )

# output files
file_mask = paste0(path_grid,"/mask0.tif")

# EPSG
EPSG0 <- crs31370 <-CRS("+init=epsg:32631")

# Admin layer
adm0 <- getData('GADM' , country="NER", level=0)
adm0_UTM <- spTransform(adm0,EPSG0)

# Extent definition
#To correctly spatially reference a raster not already georeferenced,
#you need to identify

#1.The lower left hand corner coordinates of the raster.
#2.The number of columns and rows that the raster dataset contains
ext0<-extent(adm0_UTM)
res0<-900

ext0[1]<-(round(ext0[1]/res0))*res0
ext0[2]<-(round(ext0[2]/res0)+1)*res0
ext0[3]<-(round(ext0[3]/res0))*res0
ext0[4]<-(round(ext0[4]/res0)+1)*res0

nbcol0<-(ext0[2]-ext0[1])/res0
nbrow0<-(ext0[4]-ext0[3])/res0
ext_txt<-as.character(ext0)


# Admin mask
r<-raster(ncols=nbcol0,nrows=nbrow0)
extent(r) <- ext0
crs(r)<- EPSG0
mask0 <- rasterize(adm0_UTM, r, field=1,filename="C:/Users/WERTZS/Desktop/script/grid/mask0.tif")

write.csv(cars,file = "C:/Users/WERTZS/Desktop/script/grid/hello.csv")

files_adm <- list.files(path=path_adm, pattern="*.shp", full.names=T, recursive=FALSE)
gdalbuildvrt(gdalfile=files_dens,separate=F,output.vrt="./density/density.vrt",verbose=TRUE)
gdal_translate("./density/density.vrt","./density/density2.vrt",of="VRT",projwin=bbox_ullr)

getwd()

