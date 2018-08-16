require(rgdal)
require(raster)
require(maptools)
require(dismo)
library(sp)
library(caTools)
#specify folder for the precense point data and covariate data files
result_folder = "Data/Cumberland/"
data_folder = "/Volumes/TOSHIBA EXT/WSSSP Modelling/SDM/Data/Covariates/modelling/"


cumberland =  readOGR("Data/IBRA_cumberland/Cumberland_IBRA_subregion.shp")

#get names of all the raster files in the data folder
files=list.files(data_folder , pattern = "*.tif$", full.names=TRUE)

count = 0
for (i in files) {
	# read a raster
	r = raster(i)
	result_name = paste(result_folder, names(r), "_c.tif", sep = "")

	#print a message
	count = count + 1
	print(paste("file", names(r), ". #", count, "out of" , length(files)))

	# crop and save file if it doesn't exist
	if (!file.exists(result_name)) {
		r2 <- crop(r, extent(cumberland))
		c = mask(r2, cumberland, filename = result_name)
	} else {
		print(paste(names(r), "already exists"))
	}

}

