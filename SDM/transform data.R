require(rgdal)
require(raster)
require(maptools)

setwd("Data")
# setwd("..")


# roads=raster("/Volumes/Second/roads/Roads_100")
# plot(roads)
#
#
# # there are two types of data in this folders: tiff and shapefile
# ## read all the tif data files
# tiffiles = list.files(pattern ='*.tif$', full.names=FALSE, include.dirs=FALSE, no..=TRUE )
#
#
#
# ## read all the shapefiles from the folder
# shapefiles = list.files(pattern ='*.shp$', full.names=FALSE, include.dirs=FALSE, no..=TRUE )
# filenames=NULL
# for (i in shapefiles) {
#
# 	# read the shape file
# 	name = substr(basename(i), 1, nchar(basename(i)) - 4) #remove extension from the names
#
# 	do.call('=',list(name, readShapeSpatial(i)))
#
# 	filenames=c(filenames,name)
# }



## Read files supplied with the project
Macarthur_Vegetation = readOGR("Data package 20180309/26276_Macarthur_Vegetation_DRAFT_20180223.shp")
Cadastre = readOGR("Data package 20180309/Cadastre.shp")
Study_area = readOGR("Data package 20180309/Cumberland_IBRA_subregion.shp")
Plain_west = readOGR("Data package 20180309/CumberlandPlainWest_2013_E_4207.shp")
Priority_Growth = readOGR("Data package 20180309/Priority_Growth_Areas.shp")
Western_Vegetation = readOGR("Data package 20180309/WesternSydneyVeg_prelimDRAFT20180309.shp")
Wilton_Vegetation = readOGR("Data package 20180309/Wilton_Vegetation_FINAL_20180226.shp", delete_null_obj=TRUE) # the coordinates of this layer don't match the coordinates of the other layers




# #Read species data and convert it into csv format for further analysis
# Threatened_Fauna = readOGR("Data package 20180309/Threatened_Fauna_records_bionet.shp")
# Threatened_Flora = readOGR("Data package 20180309/Threatened_Flora_records_bionet.shp")
# write.csv( Threatened_Fauna@data, file="Threatened_Fauna.csv")
# write.csv( Threatened_Flora@data, file="Threatened_Flora.csv")




# Split the files into csv's for each of the species
fauna_table=read.csv(file="Threatened_Fauna.csv")
head(fauna_table[,8:12])

fauna_species=NULL
fauna_names = unique(fauna_table$Scientific)

for (i in fauna_names)
{
	tmp=fauna_table[fauna_table$Scientific==i,]

	name=toString(tmp[1,'CommonName'])
	name=gsub(" ", "_",name, fixed = TRUE)
	name=gsub("-", "_",name, fixed = TRUE)
	name=gsub("(", "",name, fixed = TRUE)
	name=gsub(")", "",name, fixed = TRUE)
	name=gsub("'", "",name, fixed = TRUE)

	fauna_species=c(fauna_species, name)

	do.call('=',list(name,tmp))

	write.csv(eval(parse(text = name)), file=paste("Threatened_Fauna_csv/",name,".csv", sep=""))

}


flora_table=read.csv(file="Threatened_Flora.csv")
head(flora_table[,8:13])

flora_species=NULL
flora_names = unique(flora_table$Scientific)

for (i in flora_names)
{
	tmp=flora_table[flora_table$Scientific==i,]

	name=i
	name=gsub(" ", "_",name, fixed = TRUE)
	name=gsub("-", "_",name, fixed = TRUE)
	name=gsub("(", "",name, fixed = TRUE)
	name=gsub(")", "",name, fixed = TRUE)
	name=gsub("'", "",name, fixed = TRUE)

	flora_species=c(flora_species, name)

	do.call('=',list(name,tmp))

	write.csv(eval(parse(text = name)), file=paste("Threatened_Flora_csv/",name,".csv", sep=""))

}
