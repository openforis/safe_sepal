scriptdir  <- paste0(path.expand("~"),"/safe_sepal/scripts/")

setwd(scriptdir)

source(paste0(scriptdir,"s0_parameters.R"))
source(paste0(scriptdir,"s1_setworking.R"))
source(paste0(scriptdir,"s2_mask.R"))
source(paste0(scriptdir,"s3_output.R"))
source(paste0(scriptdir,"s4_data_in.R"))
source(paste0(scriptdir,"s5_rasters.R"))
source(paste0(scriptdir,"s6_distance.R"))
source(paste0(scriptdir,"s7_unsuit_mask.R"))
source(paste0(scriptdir,"s8_codes_layers.R"))
source(paste0(scriptdir,"s9_decision.R"))


