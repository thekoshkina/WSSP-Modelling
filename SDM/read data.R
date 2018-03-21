## read the data files and standartise

require(rgdal)
require(raster)


setwd("Data")

# Creating a directory to save modyfied files
save.dir=paste(getwd(),'Modyfied',sep='/')
dir.create(save.dir, showWarnings=FALSE)



## read data drom data package folder
setwd("Data package 20180309")

# there are two types of data in this folders: tiff and shapefile
## read all the tif data files
tiffiles = list.files(pattern ='*.tif$', full.names=FALSE, include.dirs=FALSE, no..=TRUE )


filenames=substr(basename(tiffiles), 1,
								 nchar(basename(tiffiles)) - 4)

filenames=NULL

for (i in tiffiles) {
	#create RasterLayer objects with corresponding names of the files

	name = substr(basename(i), 1, nchar(basename(i)) - 4) #remove extension from the names

	do.call('=',list(name, raster(i)))

	filenames=c(filenames,name)
}
























raster.res=NULL
raster.ext=NULL
filenames=NULL


for (i in tiffiles) {
	#create RasterLayer objects with corresponding names of the files
	name = substr(basename(i), 1, nchar(basename(i)) - 4)
	do.call('=',list(name, raster(i)))

	#Saving objects resolutions and extents
	filenames=c(filenames,name)
	raster.res=c(raster.res, xres(get(i)))
	raster.ext=rbind(raster.ext, as.vector(extent(get(i))))
}

colnames(raster.ext)=c('xmin','xmax','ymin','ymax')

# Printing raster info
print(cbind(filenames, raster.res, raster.ext), quote=FALSE)


setwd("..")

