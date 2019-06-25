# +001 INSTALLATION OF THE PACKAGES
# +002 SET WORKING ENVIRONMENT 
# +003 CREATING OBJECTS ON R
# +004 CREATING FOLDERS ON THE COMPUTER
rm(list=ls())
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# +001 INSTALLATION OF THE PACKAGES
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
packages <- function(x){
  x <- as.character(match.call()[[2]])
  if (!require(x,character.only=TRUE)){
    install.packages(pkgs=x,repos="http://cran.r-project.org")
    require(x,character.only=TRUE)
  }
}
##################### LOAD/INSTALL PACKAGES - FIRST RUN MAY TAKE TIME
options(stringsAsFactors = F)
packages(raster)
packages(rgdal)
packages(gdalUtils)
packages(sp)
packages(sf)
packages(rgeos)
packages(plyr)

packages(foreign)
packages(ggplot2)
packages(devtools)
packages(maptools)

#packages(rJava)
#packages(xlsx)

install_github('yfinegold/gfcanalysis')
packages(gfcanalysis)

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# +002 SET WORKING ENVIRONMENT (GENERAL)
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
rootdir <- ("~/safe_sepal")
setwd(rootdir)
rootdir <- paste0(getwd(),"/")

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++s
# +003 CREATING OBJECTS ON SEPAL
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
scriptdir <- paste0(rootdir,"scripts/")
griddir   <- paste0(rootdir,"grid/")
dataindir   <- paste0(rootdir,"data_in/")
data0dir  <- paste0(rootdir,"data0/")
tmpdir    <- paste0(rootdir,"tmp/")
admdir    <- paste0(rootdir,"data_in/adm/")
lulcdir   <- paste0(rootdir,"data_in/lu-lc/")
biomassdir<- paste0(rootdir,"data_in/biomass/")
gfcdir    <- paste0(biomassdir,"gfc/")
waterdir  <- paste0(rootdir,"data_in/water/")
denspopdir<- paste0(rootdir,"data_in/denspop/")
roadsdir  <- paste0(rootdir, "data_in/roads/Roads/")
twnsdir   <- paste0(rootdir, "data_in/towns/")
srtmdir   <- paste0(rootdir,"data_in/srtm/") 
elecdir   <- paste0(rootdir,"data_in/electricity/")

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# +004 CREATING FOLDERS ON THE COMPUTER
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
dir.create(scriptdir,showWarnings = F)
dir.create(griddir,showWarnings = F)
dir.create(dataindir,showWarnings = F)
dir.create(data0dir,showWarnings = F)
dir.create(tmpdir,showWarnings = F)
dir.create(admdir,showWarnings = F)
dir.create(lulcdir,showWarnings = F)
dir.create(biomassdir,showWarnings = F)
dir.create(gfcdir,showWarnings = F)
dir.create(waterdir,showWarnings = F)
dir.create(denspopdir,showWarnings = F)
dir.create(roadsdir, showWarnings = F)
dir.create(twnsdir, showWarnings = F)
dir.create(srtmdir,showWarnings = F)
dir.create(elecdir,showWarnings = F)

setwd(dataindir)
