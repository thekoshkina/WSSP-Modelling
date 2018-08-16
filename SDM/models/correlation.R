require(rgdal)
require(raster)
require(maptools)
require(dismo)
library(sp)
library(caTools)


data_folder = "Data/Cumberland/"



files=list.files(data_folder , pattern = "*.tif$", full.names=TRUE)
no_cov=length(files) #number of covariates

#### plot all the covariates
dir.create(paste("Data/Plots", sub("^[^/]*", "",data_folder), sep=''), showWarnings = FALSE)

for (i in names(predictors)) {
	plot_name = paste("Data/Plots", sub("^[^/]*", "", data_folder), i , ".png", sep = "")

	if (!file.exists(plot_name)) {
		png(filename = plot_name,	width = 2 * ppi, height = 2 * ppi)
		plot(predictors[[i]], main = i)
		dev.off()
	} else print(paste(i, "is already plotted"))
}



####check if all the files are at the same resolution and extent
resolution = NULL
for (i in files) {
	r = raster(i)


	s = c(names(r), as.vector(extent(r)), res(r))

	resolution = rbind(resolution,s)
}
names(resolution)=c('name','xmin','xmax','ymin','ymax','x_resolution','y_resolution')
write.csv(resolution, file=paste(data_folder,"raster files extent resolution.csv", sep=""))


# correlation matrix
	predictors <- stack(files)
	correlation = layerStats(predictors, 'pearson', na.rm=TRUE)
	write.csv(correlation, file=paste(data_folder,"predictor correlation.csv"))


	#
