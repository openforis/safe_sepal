####################################################################################
####### Object:  Traitement donnees PISTE FORESTIERE MAYOTTE           
####### Author:  remi.dannunzio@fao.org                               
####### Update:  2019/02/11                                  
####################################################################################
options(stringsAsFactors = F)

library(foreign)
library(plyr)
library(rgeos)
library(rgdal)
library(raster)
library(ggplot2)
library(gfcanalysis)

rootdir <- ("/home/dannunzio/mayotte_ONFi/")
scriptdir <- paste0(rootdir,"scripts/")
datadir   <- paste0(rootdir,"data/")
gfcdir    <- paste0(rootdir,"data/gfc/")
rdsdir    <- paste0(rootdir,"data/roads/")
fordir    <- paste0(rootdir,"data/forets/")
resdir    <- paste0(rootdir,"data/results/")

dir.create(datadir,showWarnings = F)
dir.create(gfcdir,showWarnings = F)
dir.create(rdsdir,showWarnings = F)
dir.create(fordir,showWarnings = F)
dir.create(resdir,showWarnings = F)
setwd(datadir)

aoi             <- getData('GADM',
                           path=datadir, 
                           country= "MYT", 
                           level=1)

tiles           <- calc_gfc_tiles(aoi)

plot(tiles)
plot(aoi)

download_tiles(tiles,output_folder = gfcdir,images = c("treecover2000","lossyear","gain","datamask") )

for(file in list.files(gfcdir,glob2rx("Hansen*.tif"))){
  input <- paste0(gfcdir,file)
  
  system(sprintf("gdal_translate -co COMPRESS=LZW  -projwin %s %s %s %s %s %s",
                 extent(aoi)@xmin,
                 extent(aoi)@ymax,
                 extent(aoi)@xmax,
                 extent(aoi)@ymin,
                 input,
                 paste0(gfcdir,"crop_",file)
  ))
  
  system(sprintf("gdalwarp -co COMPRESS=LZW  -t_srs \"%s\" %s %s",
                 "+proj=utm +zone=38 +south +ellps=GRS80 +units=m +no_defs",
                 paste0(gfcdir,"crop_",file),
                 paste0(gfcdir,"utm_crop_",file)
  ))
}

list.files(gfcdir,"utm_crop_Hansen")

plot(aoi)

foret <- readOGR(paste0(fordir,"L_FORET_DEP_DOM_S_976.shp"))

head(foret@data)
foret$num_id <- row(foret)[,1]
writeOGR(foret,paste0(fordir,"foret_utm.shp"),"foret_utm","ESRI Shapefile",overwrite_layer = T)
plot(foret,add=T,col="green")

system(sprintf("python %s/oft-rasterize_attr.py -v %s -i %s -o %s  -a %s",
               scriptdir,
               paste0(fordir,"foret_utm.shp"),
               paste0(gfcdir,"utm_crop_Hansen_GFC-2017-v1.5_datamask_10S_040E.tif"),
               paste0(fordir,"forets_utm.tif"),
               "num_id"
))

system(sprintf("gdal_proximity.py -co COMPRESS=LZW -ot Int16 -distunits PIXEL %s %s",
               paste0(fordir,"forets_utm.tif"),
               paste0(fordir,"dist_to_forets.tif")
))

roads <- readOGR(paste0(rdsdir,"ROUTE.SHP"))

head(roads@data)
roads$num_id <- row(roads)[,1]
writeOGR(roads,paste0(rdsdir,"roads_utm.shp"),"roads_utm","ESRI Shapefile",overwrite_layer = T)
plot(roads,add=T,col="red")

system(sprintf("python %s/oft-rasterize_attr.py -v %s -i %s -o %s  -a %s",
               scriptdir,
               paste0(rdsdir,"roads_utm.shp"),
               paste0(gfcdir,"utm_crop_Hansen_GFC-2017-v1.5_datamask_10S_040E.tif"),
               paste0(rdsdir,"roads_utm.tif"),
               "num_id"
))

system(sprintf("gdal_proximity.py -co COMPRESS=LZW -ot Int16 -distunits PIXEL %s %s",
               paste0(rdsdir,"roads_utm.tif"),
               paste0(rdsdir,"dist_to_roads.tif")
))


##################### SOLUTION BY CLUMP
system(sprintf("oft-clump -i %s -um %s -o %s",
               paste0(gfcdir,"utm_crop_Hansen_GFC-2017-v1.5_lossyear_10S_040E.tif"),
               paste0(gfcdir,"utm_crop_Hansen_GFC-2017-v1.5_lossyear_10S_040E.tif"),
               paste0(resdir,"clump.tif")
))

##################### CLUMP ID
system(sprintf("oft-stat -i %s -um %s -o %s",
               paste0(resdir,"clump.tif"),
               paste0(resdir,"clump.tif"),
               paste0(resdir,"id_clump.txt")
))

##################### TREE COVER
system(sprintf("oft-stat -i %s -um %s -o %s",
               paste0(gfcdir,"utm_crop_Hansen_GFC-2017-v1.5_treecover2000_10S_040E.tif"),
               paste0(resdir,"clump.tif"),
               paste0(resdir,"tc_clump.txt")
))

##################### LOSSYEAR
system(sprintf("oft-stat -i %s -um %s -o %s",
               paste0(gfcdir,"utm_crop_Hansen_GFC-2017-v1.5_lossyear_10S_040E.tif"),
               paste0(resdir,"clump.tif"),
               paste0(resdir,"ly_clump.txt")
))

##################### DISTANCE TO ROADS
system(sprintf("oft-stat -i %s -um %s -o %s",
               paste0(rdsdir,"dist_to_roads.tif"),
               paste0(resdir,"clump.tif"),
               paste0(resdir,"dr_clump.txt")
))

##################### FOREST BLOCK
system(sprintf("oft-stat -i %s -um %s -o %s",
               paste0(fordir,"forets_utm.tif"),
               paste0(resdir,"clump.tif"),
               paste0(resdir,"fo_clump.txt")
))

##################### DISTANCE TO ROADS
system(sprintf("oft-stat -i %s -um %s -o %s",
               paste0(fordir,"dist_to_forets.tif"),
               paste0(resdir,"clump.tif"),
               paste0(resdir,"df_clump.txt")
))



pix <- res(raster(paste0(resdir,"clump.tif")))[1]

df0 <- read.table(paste0(resdir,"id_clump.txt"))[,1:2]
tc <- read.table(paste0(resdir,"tc_clump.txt"))
ly <- read.table(paste0(resdir,"ly_clump.txt"))
dsr <- read.table(paste0(resdir,"dr_clump.txt"))
dsf <- read.table(paste0(resdir,"df_clump.txt"))
fo <- read.table(paste0(resdir,"fo_clump.txt"))

names(df0) <- c("id","size")
names(tc) <- c("id","size","tree_cover","sd_tc")
names(ly) <- c("id","size","loss_year","sd_ly")
names(dsr) <- c("id","size","dist_road","sd_dr")
names(dsf) <- c("id","size","dist_forets","sd_df")
names(fo) <- c("id","size","forest","sd_fo")


df <- cbind(df0,tc[,3:4],ly[,3:4],dsr[,3:4]*pix,dsf[,3:4]*pix,fo[,3:4])
summary(df)

table(df$fo)
plot(df$dist_forets,df$dist_road)


r1 <- raster(paste0(gfcdir,"utm_crop_Hansen_GFC-2017-v1.5_lossyear_10S_040E.tif"))
r2 <- raster(paste0(gfcdir,"utm_crop_Hansen_GFC-2017-v1.5_treecover2000_10S_040E.tif"))
r3 <- raster(paste0(rdsdir,"dist_to_roads.tif"))
r4 <- raster(paste0(fordir,"dist_to_forets.tif"))
r5 <- raster(paste0(fordir,"forets_utm.tif"))
r6 <- raster(paste0(gfcdir,"utm_crop_Hansen_GFC-2017-v1.5_datamask_10S_040E.tif"))

c1 <- rasterToPoints(r1)
c2 <- rasterToPoints(r2)
c3 <- rasterToPoints(r3)
c4 <- rasterToPoints(r4)
c5 <- rasterToPoints(r5)
c6 <- rasterToPoints(r6)

d1 <- data.frame(c1)
d2 <- data.frame(c2)
d3 <- data.frame(c3)
d4 <- data.frame(c4)
d5 <- data.frame(c5)
d6 <- data.frame(c6)

df <- cbind(d1,
            d2$utm_crop_Hansen_GFC.2017.v1.5_treecover2000_10S_040E,
            d3$dist_to_roads,
            d4$dist_to_forets,
            d5$forets_utm,
            d6$utm_crop_Hansen_GFC.2017.v1.5_datamask_10S_040E)

names(df) <- c("x","y","loss_year","tree_cover","dist_to_roads","dist_to_forets","forest_block","data_mask")

summary(df)
nrow(df[df$tree_cover ==0,])
df1 <- df[df$data_mask == 1,]

hist(df1$tree_cover)

write.csv(df1,paste0(resdir,"resultats_20190212.csv"),row.names = F)
df1 <- read.csv(paste0(resdir,"resultats_20190212.csv"))
df1$loss <- 0
df1[df1$loss_year > 0 & df1$tree_cover > 30,]$loss <- 1

dfl <- df1[df1$loss_year > 0 & df1$tree_cover > 30,]
dff <- df1[df1$tree_cover > 30,]

df1$pa <- 0 
df1[df1$dist_to_forets == 0,]$pa <- 1

df1$forest <- 0
df1[df1$tree_cover > 30,]$forest <- 1



head(dfl)
hist(dfl$dist_to_roads)
hist(dfl$dist_to_forets,breaks=c(0,10,15,20,50,100))
table(df$dist_to_forets)
nrow(dfl[dfl$dist_to_forets == 0,])
head(dfl)

test <- df1[df1$x > 512000 & df1$x < 519000 & df1$y > 8588000 & df1$y < 8600000,
            c("x","y","forest","pa","loss","dist_to_roads","dist_to_forets")]
names(test)[7] <- "dist_to_pa"
#head(test)
plot(test$dist_to_pa,test$pa)
table(test$dist_to_pa,test$pa)
write.csv(test,paste0(resdir,"test_mayotte.csv"),row.names = F)
head(test)
table(test$loss_year)
