################################################################################
## testing models of cumberland vs the whole nsw state
## only the species with a lot of records both inside and outside cumberland ibra subregion are selected for this test :
# Myotis_macropus
# Miniopterus_schreibersii_oceanensis
# Ninox_strenua
# Epacris_purpurascens_var_purpurascens
# Acacia_pubescens
################################################################################

require(rgdal)
require(raster)
require(maptools)
require(dismo)
dyn.load('/Library/Java/JavaVirtualMachines/jdk1.8.0_161.jdk/Contents/Home/jre/lib/server/libjvm.dylib')
library(rJava)


# cumberland <-  readOGR("Data/IBRA_cumberland/Cumberland_IBRA_subregion.shp")

species_list = c("Acacia_pubescens",	"Pimelea_spicata", "Anthochaera_phrygia")





#read all the covariate tif files from covariate folder
files=list.files(folder , pattern = "*.tif$", full.names=TRUE)
no_cov=length(files) #number of covariates
predictors <- stack(files)


for (species in species_list)
{

	# read presence data for all the species
	presences <- read.table(paste(folder,"/", species, ".csv", sep="" ),  header=TRUE,  sep=",")
	presences = SpatialPoints( presences[, c("Bionet_A31","Bionet_A30")])
	proj4string(presences)=cumberland@proj4string

	pres= extract(predictors[["vegetation_c"]],presences)

	pres_veg <- pres[!is.na(pres)]

print(paste(species,",", length(pres_veg),',', length(pres)) )


}

