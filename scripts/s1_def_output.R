# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# +000 OUTPUTS
# +++1 OBJECTS FOR MASK
# +++2 READ SHAPEFILES
# +++3 SHAPEFILES TO RASTERS
# +++4 ALIGN RASTERS TO MASK
#      srtm, elevation, slope, aspect
#      biomass
#      precipitation
#      land cover
# +++5 DISTANCES TO FEATURES
# +++6 SCORES TO FEATURES
# +++7 CONSTRAINTS FEATURES - MASK FOR UNSUITABLE
# +++8 RESULTS - SUITABILITY MAP
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# +++1 OBJECTS FOR MASK 
mask_path                          <- paste0(griddir,"mask.tif")
boundaries_shp                     <- "boundaries_level0.shp"
boundaries_path                    <- paste0(griddir,boundaries_shp)
rbox_path                          <- paste0(griddir,"rbox.tif")

# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# +++2 READ SHAPEFILES 
pts_of_interest_path_in            <- paste0(tmpdir,"gis_osm_pois_free_1.shp")
water_path_in                      <- paste0(tmpdir,"gis_osm_water_a_free_1.shp")
waterways_path_in                  <- paste0(tmpdir,"gis_osm_waterways_free_1.shp")
natural_path_in                    <- paste0(tmpdir,"gis_osm_natural_free_1.shp")
roads_path_in                      <- paste0(tmpdir,"gis_osm_roads_free_1.shp")
places_of_worship_path_in          <- paste0(tmpdir,"gis_osm_pofw_free_1.shp")
towns_path_in                      <- paste0(tmpdir,"gis_osm_places_free_1.shp")
landuse_path_in                    <- paste0(tmpdir,"gis_osm_landuse_a_free_1.shp")

# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# +++3 SHAPEFILES TO RASTERS

format_shp                         <- 'ESRI Shapefile'

#boundaries_shp and boundaries_path created in +++1
boundaries_tif                     <- paste0(data0dir, "boundaries_level0.tif")

water_pois_shp                     <- "water_pois_osm.shp"
water_pois_path                    <- paste0(data0dir, water_pois_shp)
water_pois_tif                     <- paste0(data0dir, "water_pois_osm.tif")

water_shp                          <- "water_osm.shp"
water_path                         <- paste0(data0dir, water_shp)
water_tif                          <- paste0(data0dir, "water_osm.tif")

waterways_shp                      <- "waterways_osm.shp"
waterways_path                     <- paste0(data0dir, waterways_shp)
waterways_tif                      <- paste0(data0dir, "waterways_osm.tif")

water_natural_shp                  <- "water_natural_osm.shp"
water_natural_path                 <- paste0(data0dir, water_natural_shp)
water_natural_tif                  <- paste0(data0dir, "water_natural_osm.tif")

surf_water_tif                     <- paste0(data0dir, "surf_water.tif")
under_water_tif                    <- paste0(data0dir, "under_water.tif")

electricity_shp                    <- "electricity.shp"
electricity_path                   <- paste0(data0dir, electricity_shp)
electricity_tif                    <- paste0(data0dir, "electricity.tif")

roads_shp                          <- "roads_osm.shp"
roads_path                         <- paste0(data0dir, roads_shp)
roads_tif                          <- paste0(data0dir, "roads.tif")

religion_shp                       <- "religion_osm.shp"
religion_path                      <- paste0(data0dir, religion_shp)
religion_tif                       <- paste0(data0dir, "religion.tif")

towns_shp                          <- "towns_osm.shp"
towns_path                         <- paste0(data0dir, towns_shp)
towns_tif                          <- paste0(data0dir, "towns.tif")

health_shp                         <- "health_osm.shp"
health_path                        <- paste0(data0dir, health_shp)
health_tif                         <- paste0(data0dir, "health.tif")

education_shp                      <- "education_osm.shp"
education_path                     <- paste0(data0dir, education_shp)
education_tif                      <- paste0(data0dir, "education.tif")

unsuit_land_reserves_shp           <- "unsuit_land_reserves_osm.shp"
unsuit_land_reserves_path          <- paste0(data0dir, unsuit_land_reserves_shp)
unsuit_land_reserves_tif           <- paste0(data0dir, "unsuit_land_reserves.tif")

unsuit_land_military_shp           <- "unsuit_land_military_osm.shp"
unsuit_land_military_path          <- paste0(data0dir, unsuit_land_military_shp)
unsuit_land_military_tif           <- paste0(data0dir, "unsuit_land_military.tif")

unsuit_wetland_shp                 <- "unsuit_wetland_osm.shp"
unsuit_wetland_path                <- paste0(data0dir, unsuit_wetland_shp)
unsuit_wetland_tif                 <- paste0(data0dir, "unsuit_wetland.tif")

# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# +++4 ALIGN RASTERS TO MASK

# srtm, elevation, slope, aspect
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Path to downloaded SRTM tiles
srtm_grid_path                     <- paste0(srtmdir, "srtm/tiles.shp")

tmp_srtm_path                      <- paste0(data0dir,  "tmp_srtm.tif")
tmp_srtm_comp_path                 <- paste0(data0dir,  "tmp_comp_srtm.tif")

srtm_path                          <- paste0(data0dir,  "srtm.tif")
elevation_path                     <- paste0(data0dir,  "elevation.tif")

tmp_slope_path                     <- paste0(data0dir,  "tmp_slope.tif")
slope_path                         <- paste0(data0dir,  "slope.tif")

aspect_path                        <- paste0(data0dir,  "aspect.tif")

# BIOMASS - GEOSAHEL - VALUES 2018
# http://sigsahel.info/ -> http://geosahel.info/Viewer.aspx?map=Analyse-Biomasse-Finale#
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
biomass_path                       <- paste0(biomassdir,"BiomassValue2018_geosahel.tif")

biomass_tif                        <- paste0(data0dir,"biomass_geosahel2018.tif")

# PRECIPITATIONS - WAPOR
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
preci_path                         <- paste0(waterdir,"L1_PCP_18_clipped.tif") 
tmp_preci_comp                     <- paste0(data0dir,"tmp_comp_L1_PCP_18_clipped.tif")

preci_tif                          <- paste0(data0dir,"preci_wapor2018.tif")

# LAND COVER - WAPOR
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
lc_path                            <- paste0(lulcdir,"L1_LCC_15_clipped.tif")
#tmp_lc_comp                        <- paste0(data0dir,"tmp_comp_L1_LCC_15_clipped.tif")

lc_tif                             <- paste0(data0dir,"lc_wapor_2015.tif")

# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# +++5 DISTANCES TO FEATURES

tmp_mask_boundaries                <- paste0(data0dir,"tmp_mask_boundaries.tif")
tmp_mask_dist2boundaries           <- paste0(data0dir,"tmp_mask_dist2boundaries.tif")
tmp_dist2boundaries                <- paste0(data0dir,"dist2boundaries.tif")

tmp_mask_surf_water                <- paste0(data0dir,"tmp_mask_surf_water.tif")
tmp_mask_dist2surf_water           <- paste0(data0dir,"tmp_mask_dist2surf_water.tif")
tmp_dist2surf_water                    <- paste0(data0dir,"dist2surf_water.tif")

tmp_mask_under_water               <- paste0(data0dir,"tmp_mask_under_water.tif")
tmp_mask_dist2under_water          <- paste0(data0dir,"tmp_mask_dist2under_water.tif")
tmp_dist2under_water               <- paste0(data0dir,"dist2under_water.tif")

tmp_dist2water                     <- paste0(data0dir,"dist2water.tif")

tmp_mask_electricity               <- paste0(data0dir,"tmp_mask_electricity.tif")
tmp_mask_dist2electricity          <- paste0(data0dir,"tmp_mask_dist2electricity.tif")
tmp_dist2electricity               <- paste0(data0dir,"dist2electricity.tif")

tmp_mask_roads                     <- paste0(data0dir,"tmp_mask_roads.tif")
tmp_mask_dist2roads                <- paste0(data0dir,"tmp_mask_dist2roads.tif")
tmp_dist2roads                     <- paste0(data0dir,"dist2roads.tif")

tmp_mask_towns                     <- paste0(data0dir,"tmp_mask_towns.tif")
tmp_mask_dist2towns                <- paste0(data0dir,"tmp_mask_dist2towns.tif")
tmp_dist2towns                     <- paste0(data0dir,"dist2towns.tif")

tmp_mask_health                    <- paste0(data0dir,"tmp_mask_health.tif")
tmp_mask_dist2health               <- paste0(data0dir,"tmp_mask_dist2health.tif")
tmp_dist2health                    <- paste0(data0dir,"dist2health.tif")

tmp_mask_education                 <- paste0(data0dir,"tmp_mask_education.tif")
tmp_mask_dist2education            <- paste0(data0dir,"tmp_mask_dist2education.tif")
tmp_dist2education                 <- paste0(data0dir,"dist2education.tif")

tmp_mask_unsuit_land_reserves      <- paste0(data0dir,"tmp_mask_unsuit_land_reserves.tif")
tmp_mask_dist2unsuit_land_reserves <- paste0(data0dir,"tmp_mask_dist2unsuit_land_reserves.tif")
tmp_dist2unsuit_land_reserves      <- paste0(data0dir,"dist2unsuit_land_reserves.tif")

tmp_mask_unsuit_wetland            <- paste0(data0dir,"tmp_mask_unsuit_wetland.tif")
tmp_mask_dist2unsuit_wetland       <- paste0(data0dir,"tmp_mask_dist2unsuit_wetland.tif")
tmp_dist2unsuit_wetland            <- paste0(data0dir,"dist2unsuit_wetland.tif")

# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# +++6 SCORES TO FEATURES

score_dist2water                   <- paste0(data0dir,"score_dist2water.tif")
score_dist2boundaries              <- paste0(data0dir,"score_dist2boundaries.tif")
score_dist2roads                   <- paste0(data0dir,"score_dist2roads.tif")
score_dist2electricity             <- paste0(data0dir,"score_dist2electricity.tif")
score_dist2towns                   <- paste0(data0dir,"score_dist2towns.tif")
score_dist2health                  <- paste0(data0dir,"score_dist2health.tif")
score_dist2education               <- paste0(data0dir,"score_dist2education.tif")

score_slope                        <- paste0(data0dir,"score_slope.tif")
score_preci                        <- paste0(data0dir,"score_preci.tif")
score_biomass_prod                 <- paste0(data0dir,"score_biomass_prod.tif")

# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# +++7 CONSTRAINTS FEATURES - MASK FOR UNSUITABLE

tmp_mask_exclusion                 <- paste0(data0dir, "tmp_mask_exclusion.tif")

# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# +++8 RESULTS - SUITABILITY MAP

tmp_suitability_map                <- paste0(data0dir,"tmp_suitability_map.tif")
color_table_txt                    <- paste0(data0dir,'color_table.txt')
tmp_suitability_map_byte           <- paste0(data0dir,"tmp_suitability_map_byte.tif")
#pct: pseudo color table
tmp_suitability_map_pct            <- paste0(data0dir,"tmp_suitability_map_pct.tif")

suitability_map                    <- paste0(data0dir,"suitability_map.tif")
