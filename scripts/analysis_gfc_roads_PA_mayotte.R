####################################################################################
####### Object:  Traitement donnees PISTE FORESTIERE MAYOTTE           
####### Author:  remi.dannunzio@fao.org & e.wiik@bangor.ac.uk                           
####### Update:  2019/03/11                                  
####################################################################################
packages <- function(x){
  x <- as.character(match.call()[[2]])
  if (!require(x,character.only=TRUE)){
    install.packages(pkgs=x,repos="http://cran.r-project.org")
    require(x,character.only=TRUE)
  }
}

##################### LOAD/INSTALL PACKAGES - FIRST RUN MAY TAKE TIME
packages(Hmisc)
packages(faraway)
packages(mgcv)
packages(sjPlot)
packages(sjmisc)

options(stringsAsFactors = F)

packages(foreign)
packages(plyr)
packages(rgeos)
packages(rgdal)
packages(raster)
packages(ggplot2)
packages(devtools)

install_github('yfinegold/gfcanalysis')
packages(gfcanalysis)

##################### SET WORKING ENVIRONMENT
rootdir <- ("~/mayotte_ONFi/")
setwd(rootdir)
rootdir <- paste0(getwd(),"/")

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

##################### READ BOUNDARIES OF THE COUNTRY
aoi             <- getData('GADM',
                           path=datadir, 
                           country= "MYT", 
                           level=1)

##################### CHECK WHICH GFC TILES FALL ON IT
tiles           <- calc_gfc_tiles(aoi)

plot(tiles)
plot(aoi)

##################### DOWNLOAD IF NECESSARY
download_tiles(tiles,output_folder = gfcdir,images = c("treecover2000","lossyear","gain","datamask") )


##################### REPROJECT IN THE CORRECT SYSTEM
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

plot(aoi)

##################### READ THE FOREST SHAPEFILE AND ADD A NUMERICAL num_id
foret <- readOGR(paste0(fordir,"L_FORET_DEP_DOM_S_976.shp"))

foret$num_id <- row(foret)[,1]
writeOGR(foret,paste0(fordir,"foret_utm.shp"),"foret_utm","ESRI Shapefile",overwrite_layer = T)
plot(foret,add=T,col="green")


##################### RASTERIZE BY THE ID
system(sprintf("python %s/oft-rasterize_attr.py -v %s -i %s -o %s  -a %s",
               scriptdir,
               paste0(fordir,"foret_utm.shp"),
               paste0(gfcdir,"utm_crop_Hansen_GFC-2017-v1.5_datamask_10S_040E.tif"),
               paste0(fordir,"forets_utm.tif"),
               "num_id"
))

##################### CREATE A DISTANCE TO FORESTS
system(sprintf("gdal_proximity.py -co COMPRESS=LZW -ot Int16 -distunits PIXEL %s %s",
               paste0(fordir,"forets_utm.tif"),
               paste0(fordir,"dist_to_forets.tif")
))

##################### READ THE ROAD SHAPEFILE AND ADD A NUMERICAL num_id
roads <- readOGR(paste0(rdsdir,"ROUTE.SHP"))

head(roads@data)
roads$num_id <- row(roads)[,1]
writeOGR(roads,paste0(rdsdir,"roads_utm.shp"),"roads_utm","ESRI Shapefile",overwrite_layer = T)
plot(roads,add=T,col="red")

##################### RASTERIZE BY THE ID
system(sprintf("python %s/oft-rasterize_attr.py -v %s -i %s -o %s  -a %s",
               scriptdir,
               paste0(rdsdir,"roads_utm.shp"),
               paste0(gfcdir,"utm_crop_Hansen_GFC-2017-v1.5_datamask_10S_040E.tif"),
               paste0(rdsdir,"roads_utm.tif"),
               "num_id"
))

##################### CREATE A DISTANCE TO ROADS
system(sprintf("gdal_proximity.py -co COMPRESS=LZW -ot Int16 -distunits PIXEL %s %s",
               paste0(rdsdir,"roads_utm.tif"),
               paste0(rdsdir,"dist_to_roads.tif")
))


##################### READ THE DIFFERENT LAYERS AND STORE AS ONE DATA TABLE
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

##################### SELECT IN LAND DATA ONLY AND EXPORT
summary(df)
df1 <- df[df$data_mask == 1,]
hist(df1$tree_cover)
write.csv(df1,paste0(resdir,"resultats_20190212.csv"),row.names = F)

##################### SIMPLIFY TABLE HEADERS
df1 <- read.csv(paste0(resdir,"resultats_20190212.csv"))
df1$loss <- 0
df1[df1$loss_year > 0 & df1$tree_cover > 30,]$loss <- 1

df1$pa <- 0 
df1[df1$dist_to_forets == 0,]$pa <- 1

df1$forest <- 0
df1[df1$tree_cover > 30,]$forest <- 1


##################### CREATE THEME
papertheme <- theme_bw(base_size=12, base_family = 'Arial') +
  theme(legend.position='top')

dat <- df1[,c("x","y","forest","pa","loss","dist_to_roads","dist_to_forets")]
names(dat) <- c("x","y","forest","pa","loss","dist_to_roads","dist_to_pa")

##################### REMOVE NON FOREST PIXELS
dat <- dat[-which(dat$forest==0),]

#####################  CONVERT TO FACTOR
dat$pa   <- as.factor(dat$pa)
dat$loss <- as.factor(dat$loss)

##################### RUN THE MODEL
modbin <- gam(loss ~ s(dist_to_roads, by=pa, k=3) + pa,
              data = dat, method='REML', family = binomial())

##################### PLOT RESULTS
plot_model(modbin, type = "pred", terms = c("dist_to_roads","pa"))

AIC(modbin)
summary(modbin)
