# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# +000 OUTPUTS
# +++1 SHAPEFILES TO RASTERS
# +++2 ALIGN RASTERS TO MASK
# +++3 DISTANCES TO FEATURES
# +++4 SCORES TO FEATURES
# +++5 MASK UNSUITABLE
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
mask <- raster(paste0(griddir,"mask.tif"))
mask_path <- paste0(griddir,"mask.tif")

# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# +++1 SHAPEFILES TO RASTERS

boundaries_path     <- paste0(griddir,"boundaries_level0.shp")
boundaries_tif      <- paste0(data0dir, "boundaries_level0.tif")

water_pois_osm_path <- paste0(data0dir, "water_pois_osm.shp")
water_pois_osm_tif  <- paste0(data0dir, "water_pois_osm.tif")

water_osm_path      <- paste0(data0dir,"water_osm.shp")
water_osm_tif       <-  paste0(data0dir, "water_osm.tif")

waterways_osm_path  <- paste0(data0dir,"waterways_osm.shp")
waterways_osm_tif   <- paste0(data0dir, "waterways_osm.tif")

water_natural_osm_path  <- paste0(data0dir,"water_natural_osm.shp")
water_natural_osm_tif   <- paste0(data0dir, "water_natural_osm.tif")

surf_water_tif       <- paste0(data0dir,"surf_water.tif")
under_water_tif      <-paste0(data0dir,"under_water.tif")

electricity_path     <-paste0(data0dir,"electricity.shp")
electricity_tif      <-paste0(data0dir, "electricity.tif")

roads_path     <- paste0(data0dir,"roads_osm.shp")
roads_tif      <- paste0(data0dir, "roads.tif")

religion_path       <- paste0(data0dir, "religion_osm.shp")
religion_tif        <- paste0(data0dir, "religion.tif")

towns_path        <- paste0(data0dir,"towns_osm.shp")
towns_tif         <- paste0(data0dir, "towns.tif")

health_path        <- paste0(data0dir,"health_osm.shp")
health_tif         <- paste0(data0dir, "health.tif")

education_path        <- paste0(data0dir,"education_osm.shp")
education_tif         <- paste0(data0dir,"education.tif")

unsuit_land_path        <- paste0(data0dir,"unsuit_land_osm.shp")
unsuit_land_tif         <- paste0(data0dir, "unsuit_land.tif")

unsuit_wetland_path        <- paste0(data0dir,"unsuit_wetland_osm.shp")
unsuit_wetland_tif         <- paste0(data0dir, "unsuit_wetland.tif")

unsuit_tif         <- paste0(data0dir,"unsuitable.tif")

# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# +++2 ALIGN RASTERS TO MASK

# srtm, elevation, slope, aspect
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
tmp_srtm_path         <- paste0(data0dir, "tmp_srtm.tif")
tmp_srtm_comp_path    <-paste0(data0dir,"tmp_comp_srtm.tif")

srtm_path             <- paste0(data0dir,"srtm.tif")
elevation_path        <- paste0(data0dir,"elevation.tif")

slope_path            <- paste0(data0dir,"slope.tif")
aspect_path           <- paste0(data0dir,"aspect.tif")

# BIOMASS - GEOSAHEL - VALUES 2018
# http://sigsahel.info/ -> http://geosahel.info/Viewer.aspx?map=Analyse-Biomasse-Finale#
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
biomass_path          <- paste0(biomassdir,"BiomassValue2018_geosahel.tif")
tmp_biomass_comp      <- paste0(data0dir,"tmp_comp_biomass_geosahel2018.tif")

biomass_tif           <- paste0(data0dir,"biomass_geosahel2018.tif")

# PRECIPITATIONS - WAPOR
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
preci_path          <- paste0(waterdir,"L1_PCP_18_clipped.tif") 
tmp_preci_comp      <- paste0(data0dir,"tmp_comp_L1_PCP_18_clipped.tif")

preci_tif           <- paste0(data0dir,"preci_wapor2018.tif")

# LAND COVER - WAPOR
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
lc_path          <- paste0(lulcdir,"L1_LCC_15_clipped.tif")
tmp_lc_comp      <- paste0(data0dir,"tmp_comp_L1_LCC_15_clipped.tif")

lc_tif           <- paste0(data0dir,"lc_wapor_2015.tif")

# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# +++3 DISTANCES TO FEATURES

tmp_mask_boundaries  <- paste0(data0dir,"tmp_mask_boundaries.tif")
tmp_mask_dist2boundaries <- paste0(data0dir,"tmp_mask_dist2boundaries.tif")
dist2boundaries  <- paste0(data0dir,"dist2boundaries.tif")


tmp_mask_surf_water  <- paste0(data0dir,"tmp_mask_surf_water.tif")
tmp_mask_dist2surf_water <- paste0(data0dir,"tmp_mask_dist2surf_water.tif")
dist2surf_water  <- paste0(data0dir,"dist2surf_water.tif")

tmp_mask_under_water  <- paste0(data0dir,"tmp_mask_under_water.tif")
tmp_mask_dist2under_water <- paste0(data0dir,"tmp_mask_dist2under_water.tif")
dist2under_water <- paste0(data0dir,"dist2under_water.tif")

dist2water       <- paste0(data0dir,"dist2water.tif")

tmp_mask_electricity  <- paste0(data0dir,"tmp_mask_electricity.tif")
tmp_mask_dist2electricity <- paste0(data0dir,"tmp_mask_dist2electricity.tif")
dist2electricity <- paste0(data0dir,"dist2electricity.tif")


tmp_mask_roads  <- paste0(data0dir,"tmp_mask_roads.tif")
tmp_mask_dist2roads <- paste0(data0dir,"tmp_mask_dist2roads.tif")
dist2roads      <- paste0(data0dir,"dist2roads.tif")

tmp_mask_towns  <- paste0(data0dir,"tmp_mask_towns.tif")
tmp_mask_dist2towns  <- paste0(data0dir,"tmp_mask_dist2towns.tif")
dist2towns      <-paste0(data0dir,"dist2towns.tif")

tmp_mask_health  <- paste0(data0dir,"tmp_mask_health.tif")
tmp_mask_dist2health <- paste0(data0dir,"tmp_mask_dist2health.tif")
dist2health <- paste0(data0dir,"dist2health.tif")


tmp_mask_education <- paste0(data0dir,"tmp_mask_education.tif")
tmp_mask_dist2education <- paste0(data0dir,"tmp_mask_dist2education.tif")
dist2education <- paste0(data0dir,"dist2education.tif")

tmp_mask_biomass  <- paste0(data0dir,"tmp_mask_biomass_geosahel2018.tif")
tmp_mask_dist2biomass  <- paste0(data0dir,"tmp_mask_dist2biomass_geosahel2018.tif")
dist2biomass <- paste0(data0dir,"dist2biomass_geosahel2018.tif")

# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# +++4 SCORES TO FEATURES

score_surf_water <- paste0(data0dir,"score_surf_water.tif")
score_under_water <- paste0(data0dir,"score_under_water.tif")
#?score_water <- paste0(data0dir,"score_water.tif")
score_preci <- paste0(data0dir,"score_preci.tif")
score_slope <- paste0(data0dir,"score_slope.tif")
score_boundaries <- paste0(data0dir,"score_boundaries.tif")
score_biomass <- paste0(data0dir,"score_biomass.tif")
score_electricity <- paste0(data0dir,"score_electricity.tif")
score_roads <- paste0(data0dir,"score_roads.tif")
score_towns <- paste0(data0dir,"score_towns.tif")
score_health <- paste0(data0dir,"score_health.tif")
score_education <- paste0(data0dir,"score_education.tif")

# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# +++5 MASK UNSUITABLE
tmp_mask_exclusion <- paste0(data0dir, "tmp_mask_exclusion.tif")

# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# +++6 RESULT - SUITABILITY MAP
tmp_suitability_map <- paste0(data0dir, "tmp_suitability_map.tif")
color_table_txt <- paste0(data0dir,'color_table.txt')
tmp_suitability_map_byte <- paste0(data0dir, "tmp_suitability_map_byte.tif")
#pct: pseudo color table
tmp_suitability_map_pct <- paste0(data0dir, "tmp_suitability_map_pct.tif")

suitability_map  <- paste0(data0dir, "suitability_map.tif")
