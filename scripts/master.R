scriptdir  <- paste0(path.expand("~"),"/safe_sepal/scripts/")

setwd(scriptdir)

source(paste0(scriptdir,"s0_parameters.R"))
source(paste0(scriptdir,"s1_def_output.R"))
source(paste0(scriptdir,"s2_parameters.R"))
source(paste0(scriptdir,"s3_mask.R"))
source(paste0(scriptdir,"s4_shp_in.R"))
source(paste0(scriptdir,"s5_rasters.R"))
source(paste0(scriptdir,"s6_distance.R"))
source(paste0(scriptdir,"s7_scores_suitability.R"))
source(paste0(scriptdir,"s8_constraints_masks.R"))
source(paste0(scriptdir,"s9_decision.R"))


