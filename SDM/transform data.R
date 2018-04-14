require(rgdal)
require(raster)
require(maptools)

setwd("Data")
setwd("..")


roads=raster("/Volumes/Second/roads/Roads_100")
plot(roads)

## read data drom data package folder
setwd("Data package 20180309")

# there are two types of data in this folders: tiff and shapefile
## read all the tif data files
tiffiles = list.files(pattern ='*.tif$', full.names=FALSE, include.dirs=FALSE, no..=TRUE )



## read all the shapefiles from the folder
shapefiles = list.files(pattern ='*.shp$', full.names=FALSE, include.dirs=FALSE, no..=TRUE )
filenames=NULL
for (i in shapefiles) {

	# read the shape file
	name = substr(basename(i), 1, nchar(basename(i)) - 4) #remove extension from the names

	do.call('=',list(name, readShapeSpatial(i)))

	filenames=c(filenames,name)
}




Macarthur_Vegetation = readShapeSpatial("Data package 20180309/26276_Macarthur_Vegetation_DRAFT_20180223.shp")
Cadastre = readShapeSpatial("Data package 20180309/Cadastre.shp")
Study_area = readShapeSpatial("Data package 20180309/Cumberland_IBRA_subregion.shp")

Plain_west = readShapeSpatial("Data package 20180309/CumberlandPlainWest_2013_E_4207.shp")


Priority_Growth = readShapeSpatial("Data package 20180309/Priority_Growth_Areas.shp")
Threatened_Fauna = readShapeSpatial("Data package 20180309/Threatened_Fauna_records_bionet.shp")
Threatened_Flora = readShapeSpatial("Data package 20180309/Threatened_Flora_records_bionet.shp")
Western_Vegetation = readShapeSpatial("Data package 20180309/WesternSydneyVeg_prelimDRAFT20180309.shp")
Wilton_Vegetation = readShapeSpatial("Data package 20180309/Wilton_Vegetation_FINAL_20180226.shp", delete_null_obj=TRUE) # the coordinates of this layer don't match the coordinates of the other layers

plot(Study_area, add=TRUE)
plot(Wilton_Vegetation)


