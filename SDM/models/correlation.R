require(rgdal)
require(raster)
require(maptools)
require(dismo)
library(sp)
library(caTools)


data_folder = "Data/Cumberland/"

files=list.files(data_folder , pattern = "*.tif$", full.names=TRUE)
no_cov=length(files) #number of covariates


files=list.files(data_folder , pattern = "*.tif$", full.names=TRUE)

####check if all the files are at the same resolution and extent
resolution = NULL
for (i in files) {
	r = raster(i)


	s = c(names(r), as.vector(extent(r)), res(r))

	resolution = rbind(resolution,s)
}
names(resolution)=c('name','xmin','xmax','ymin','ymax','x_resolution','y_resolution')
write.csv(resolution, file=paste(data_folder,"raster files extent resolution.csv", sep=""))



	predictors <- stack(files)
	correlation = layerStats(predictors, 'pearson')
	write.csv(correlation, file=paste(data_folder,"predictor correlation.csv"))


	#
