## analysis of remi's defor data from mayotte 
## note that since there are so few covariates (MANY more things can predict defor) the 
##    effect reported by the models may be an overestimate.

packages <- function(x){
  x <- as.character(match.call()[[2]])
  if (!require(x,character.only=TRUE)){
    install.packages(pkgs=x,repos="http://cran.r-project.org")
    require(x,character.only=TRUE)
  }
}
## Packages 
packages(Hmisc)
packages(faraway)
packages(mgcv)
packages(sjPlot)
packages(sjmisc)

## create default theme
papertheme <- theme_bw(base_size=12, base_family = 'Arial') +
  theme(legend.position='top')

## load data
#dat <- read.csv("test_mayotte.csv")

df1 <- read.csv(paste0(resdir,"resultats_20190212.csv"))
df1$loss <- 0
df1[df1$loss_year > 0 & df1$tree_cover > 30,]$loss <- 1

df1$pa <- 0 
df1[df1$dist_to_forets == 0,]$pa <- 1

df1$forest <- 0
df1[df1$tree_cover > 30,]$forest <- 1

dat <- df1[,c("x","y","forest","pa","loss","dist_to_roads","dist_to_forets")]
names(dat)[7] <- "dist_to_pa"

## look at the area
ggplot(dat, aes(x=x, y=y, alpha=factor(forest), col=factor(loss))) +
  geom_point(size=0.5) +
  scale_alpha_manual(values=c(0.5, 1)) 
# quite a few small loss areas rather than big lumps

## remove pixels that are not forest (as they cannot have loss)
dat <- dat[-which(dat$forest==0),]

## make pa and loss into a factor
dat$pa <- factor(dat$pa)
dat$loss <- factor(dat$loss)

## check if we can see boundaries of the PA
ggplot(dat, aes(x=x, y=y, col=pa)) +
  papertheme +
  geom_raster(aes(fill=dist_to_pa)) +
  geom_point(size=0.2, alpha=0.7)
  ggtitle("Map of distance to PA and PA status; \n white=non-forest")

## PA status is 'perfectly' correlated with distance to PA - they will confound each other
## but the model will probably cope with using both since distance has such a long gradient
## BUT! Worth noting that when in same model, 'pa' will reflect the difference between ALL
##    of protected area and the boundary just outside of the protected area.
##    If alone in a model, 'pa' would reflect the difference between ALL the area inside
##    the protected area and ALL the area outside the protected area.
table(dat$pa, dat$dist_to_pa>0, dnn=c('PA','dist>0'))

## check if major correlations with distances
plot(dat$dist_to_roads~ dat$dist_to_pa) # spatial but not linear pattern
with(dat[dat$pa==0,],plot(dist_to_roads~ dist_to_pa, col=loss)) # spatial but not linear pattern

## run models with gam; likely to be squiggly with omitted variable bias
## ===================================================================================
## can force simpler relationship by limiting k
modbin <- gam(loss ~ s(dist_to_roads, by=pa, k=3) + pa,
           data = dat, method='REML', family = binomial())
plot_model(modbin, type = "pred", terms = c("dist_to_roads","pa")) # deforestation is least likely
#   at the furthest point from roads. PA has less deforestation. NOTE the unimodal relationship 
#   outside PA though.....

modcont <- gam(loss ~ te(dist_to_roads, dist_to_pa, k=3),
           data = dat, method='REML', family = binomial(), select = TRUE)
plot_model(modcont, type='pred', terms=c('dist_to_roads', 'dist_to_pa [0,30,60,90]')) 
plot_model(modcont, type='pred', terms=c('dist_to_pa', 'dist_to_roads [0,10,20,30]')) # shows that unimodal road effect previously was actually reflecting
# shows that unimodal road effect previously was actually reflecting
#   a unimodal relationship with distance to PA (tho interestingly now there may be some increase
#   in defor as distance to roads increases..why may that be?)
# The unimodal PA effect could suggest that there is leakage of deforestation: deforestation
#   in the protected are could be displaced to outside the protected area.
# NOTE that here I didn't want to add 'dist_to_pa' and 'dist_to_roads, by=pa' separately, because
#   if I want to make distance to road vary by PA, I would HAVE to add PA in as a factor too
# ("As with any by factor smooth we are required to include a parametric term for the factor 
#   because the individual smooths are centered for identifiability reasons" -
#   https://www.fromthebottomoftheheap.net/2017/12/14/difference-splines-ii/
# Looking at a ti() model which separates the main effects from the inteaction effects,
#   the effect of roads alone practically disappears; biggest effect from distance to PA
#   and its interaction with roads

## the problem with this model is that since there is no logical dist to PA *by* PA, I can't
##    retain the interaction between roads and dist to PA in the model..
modboth <- gam(loss ~ s(dist_to_roads, by=pa, k=3) + s(dist_to_pa, k=3) +pa,
               data = dat, method='REML', family = binomial(), select = TRUE)
plot_model(modboth, type='pred', terms=c('dist_to_roads','pa')) 
plot_model(modboth, type='pred', terms='dist_to_pa') 

AIC(modbin, modcont, modboth) #modboth preferred
lapply(list(modbin, modboth), summary) # the effect of the binary inside or outside a PA
#   is not massively changed depending on whether or not one includes distance to PA - 
#   in both cases, the likelihood is reduced significantly.


