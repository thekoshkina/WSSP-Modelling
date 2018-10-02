require(rgdal)
require(raster)
require(maptools)
require(dismo)
library(sp)
library(caTools)

#specify folder for the precense point data and covariate data files
result_folder = "Data/Veg_only_Cumberland/"
data_folder = "Data/Cumberland"


dir.create(result_folder, showWarnings = FALSE)

### read vegetation layer
vegetation=raster(paste(data_folder, '/', 'vegitation_pct_b_c.tif', sep=''))



	#get names of all the raster files in the data folder
	files=list.files(data_folder , pattern = "*.tif$", full.names=TRUE)

count = 0
for (i in files) {
	# read a raster
	r = raster(i)
	result_name = paste(result_folder, names(r), "_v0.tif", sep = "")

	#print a message
	count = count + 1
	print(paste("file", names(r), ". #", count, "out of" , length(files)))

	# crop and save file if it doesn't exist
	if (!file.exists(result_name)) {
		r[is.na(vegetation[])] <- NA
		writeRaster(r, result_name, format = "GTiff", overwrite=TRUE)
	} else {
		print(paste(names(r), "already exists"))
	}

}
