# individual bias layers for all the species
# Run MODEL 1 for all the species in the precenses folder

require(rgdal)
require(raster)
require(maptools)
require(dismo)
require(sp)
require(ENMeval)
require(caTools)
# dyn.load('/Library/Java/JavaVirtualMachines/jdk1.8.0_181.jdk/Contents/Home/jre/lib/server/libjvm.dylib')
require(rJava)


source('utilities.R')

species_list =c("Litoria_aurea","Grevillea_parviflora_subsp_parviflora", "Persoonia_nutans","Phascolarctos_cinereus"  )
# species = "Litoria_aurea"

#specify folder for the precense point data and covariate data files
data_folder = "Data/Cumberland"
presence_folder = "Data/Presence"

#read all the covariate tif files from covariate folder
cumberland <-  readOGR("Data/IBRA_cumberland/Cumberland_IBRA_subregion.shp")
bias = readOGR("Data/bias/presence_layer_buffer.shp")

files=list.files(data_folder , pattern = "*.tif$", full.names=TRUE)
no_cov=length(files) #number of covariates
predictors <- stack(files)


for (species in species_list){
	presence_table <- read.table(paste(presence_folder,"/", species, ".csv", sep="" ),  header=TRUE,  sep=",")
	presences_all = SpatialPoints( presence_table[, c("decimalLon","decimalLat")])
	proj4string(presences_all)=cumberland@proj4string

	# only select points in the study area
	presences = presences_all[cumberland,]

	# cr <- crs(r)
	# crs(r) <- '+proj=utm +zone=10 +datum=WGS84'
	e <- extract(predictors, presences, buffer=0.5)
	# crs(r) <- cr
	plot(e)
}
