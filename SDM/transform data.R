require(rgdal)
require(raster)
require(maptools)


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
Macarthur_Vegetation = readOGR("Data/Data package 20180309/26276_Macarthur_Vegetation_DRAFT_20180223.shp")
Cadastre = readOGR("Data/Data package 20180309/Cadastre.shp")
Study_area = readOGR("Data/Data package 20180309/Cumberland_IBRA_subregion.shp")
Plain_west = readOGR("Data/Data package 20180309/CumberlandPlainWest_2013_E_4207.shp")
Priority_Growth = readOGR("Data/Data package 20180309/Priority_Growth_Areas.shp")
Western_Vegetation = readOGR("Data/Data package 20180309/WesternSydneyVeg_prelimDRAFT20180309.shp")
# Wilton_Vegetation = readOGR("Data/Data package 20180309/Wilton_Vegetation_FINAL_20180226.shp", delete_null_obj=TRUE) # the coordinates of this layer don't match the coordinates of the other layers




# #Read species data and convert it into csv format for further analysis
# Threatened_Fauna = readOGR("Data package 20180309/Threatened_Fauna_records_bionet.shp")
# Threatened_Flora = readOGR("Data package 20180309/Threatened_Flora_records_bionet.shp")
# write.csv( Threatened_Fauna@data, file="Threatened_Fauna.csv")
# write.csv( Threatened_Flora@data, file="Threatened_Flora.csv")




# Split the files into csv's for each of the species -----------------------------
fauna_table=read.csv(file="Data/Threatened_Fauna.csv")

fauna_names = unique(fauna_table$Scientific)

write( paste ("Threatened_Fauna.csv","Threated fauna records that were supplied in the Data package 20180309 file. All the points are inside the Cunmerland plain IBRA subregion excluding top left corner", length(fauna_names), dim(fauna_table)[1],  dim(fauna_table)[2], min(as.Date(fauna_table$DateFirst)), max(as.Date(fauna_table$DateLast)), "Earliest and latest dates were calculated using colums DateFirst and DateLast", "\n", sep=","),file= "Data/data_summary.csv", append=TRUE)

head(fauna_table[,8:12])

fauna_species=NULL
# fauna_names = unique(fauna_table$Scientific)

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

# rm(fauna_table)

flora_table=read.csv(file="Data/Threatened_Flora.csv")
head(flora_table[,8:13])

flora_species=NULL
flora_names = unique(flora_table$Scientific)

write( paste ("Threatened_Flora.csv","Threated flora records that were supplied in the Data package 20180309 file. All the points are inside the Cunmerland plain IBRA subregion excluding top left corner", length(flora_names), dim(flora_table)[1],  dim(flora_table)[2], min(as.Date(flora_table$DateFirst)), max(as.Date(flora_table$DateLast)), "Earliest and latest dates were calculated using colums DateFirst and DateLast", "\n", sep=","),file= "Data/data_summary.csv", append=TRUE)
write("\n",file= "Data/data_summary.csv", append=TRUE )

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

### Transform Bionet SURROUNDING data  - all species in the area ---------------------------------------------------
require(rgdal)

fc_list <- ogrListLayers("Data/BionetRecords/26276_Habitat_models.gdb")
print(fc_list)

bionet_surroundings <- readOGR(dsn = "Data/BionetRecords/26276_Habitat_models.gdb", layer = "All_Bionet_Records_CumberlandPlainIBRA_and_Surrounds")
proj4string(bionet_surroundings)=Study_area@proj4string

inside.cumberland <- !is.na(over(bionet_surroundings, as(Study_area, "SpatialPolygons")))

# # plot(bionet_surroundings)

#### select points from Cumberland IBRA
# proj4string(bionet_surroundings)=Study_area@proj4string
# bionet_cumberland = bionet_surroundings[Study_area, ]


# write.csv( bionet_cumberland@data, file="Data/bionet_cumberland.csv")
# add a record of this dataset in the dataset summary file
# bionet_cumberland_table=read.csv(file="Data/bionet_cumberland.csv")
# write( paste ("bionet_cumberland_table","Bionet records that are inside the Cumberland plane IBRA subregion", length(cumberland_names), dim(bionet_cumberland_table)[1],  dim(bionet_cumberland_table)[2], min(as.Date(bionet_cumberland_table$eventDate)),max(as.Date(bionet_cumberland_table$eventDate)), sep=","),file= "Data/data_summary.csv", append=TRUE)
# write("\n",file= "Data/data_summary.csv", append=TRUE )

bionet_cumberland_table=read.csv(file="Data/bionet_cumberland.csv")
# head(bionet_cumberland_table[,1:42])

cumberland_species=NULL
cumberland_names = unique(bionet_cumberland_table$scientificName)

# write.csv(cumberland_names, file="Data/cumberland_names.csv")


for (i in cumberland_names)
{
	tmp=bionet_cumberland_table[bionet_cumberland_table$scientificName==i,]

	name=i
	# remove special characters, spaces, douple underscores and trailing unserscores
	name  = gsub("[^0-9A-Za-z]","_" , name ,ignore.case = TRUE)
	name  = gsub("__","_" , name ,ignore.case = TRUE)
	name  = gsub("_$","" , name ,ignore.case = TRUE)
	name  = gsub("^_","" , name ,ignore.case = TRUE)

	cumberland_species=c(cumberland_species, name)

	do.call('=',list(name,tmp))

	write.csv(eval(parse(text = name)), file=paste("Data/Bionet_cumberland_species/",name,".csv", sep=""))

}


#select points that are in the geodatabase All_Bionet_Records_CumberlandPlainIBRA_and_Surrounds but not in the area of cubmerland plain IBRA subregion


bionet_outside<-bionet_surroundings[is.na(over(bionet_surroundings,Study_area)),]
write.csv( bionet_outside@data, file="Data/bionet_outside.csv")

bionet_outside_table=read.csv(file="Data/bionet_outside.csv")

outside_species=NULL
outside_names = unique(bionet_outside_table$scientificName)

write( paste ("bionet_outside.csv","Bionet records that are outside of the Cumberland plane IBRA subregion but still are in the layer All_Bionet_Records_CumberlandPlainIBRA_and_Surrounds", length(outside_names), dim(bionet_outside_table)[1],  dim(bionet_outside_table)[2], min(as.Date(bionet_outside_table$eventDate)),max(as.Date(bionet_outside_table$eventDate)), sep=","),file= "Data/data_summary.csv", append=TRUE)

for (i in outside_names)
{
	tmp=bionet_outside_table[bionet_outside_table$scientificName==i,]

	name=i
	# remove special characters, spaces, douple underscores and trailing unserscores
	name  = gsub("[^0-9A-Za-z]","_" , name ,ignore.case = TRUE)
	name  = gsub("__","_" , name ,ignore.case = TRUE)
	name  = gsub("_$","" , name ,ignore.case = TRUE)
	name  = gsub("^_","" , name ,ignore.case = TRUE)

	outside_species=c(outside_species, name)

	do.call('=',list(name,tmp))

	write.csv(eval(parse(text = name)), file=paste("Data/Bionet_outside_species/",name,".csv", sep=""))

}






# bionet_out_surrounding = bionet_surroundings[!Study_area, ]

plot(Study_area)
plot(bionet_cumberland, add=TRUE)


### Transform Bionet NSW data  - some species in the whole NSW ---------------------------------------------------

require(rgdal)

bionet_nsw <- readOGR("Data/BionetRecords/Bionet_Records_for_SDM_NSW.shp")

proj4string(bionet_nsw)=Study_area@proj4string

nsw_inside_cumberland = !is.na(over(bionet_nsw, as(Study_area, "SpatialPolygons")))


sdm_cumberland<-bionet_nsw[nsw_inside_cumberland,]



write.csv(sdm_cumberland@data, file="Data/sdm_cumberland.csv")

sdm_cumberland_table=read.csv(file="Data/sdm_cumberland.csv")


sdm_cumberland_names = unique(sdm_cumberland_table$Bionet_A36)

write( paste ("sdm_cumberland.csv","Bionet records that are inside of the Cumberland plane IBRA subregion from the layer All_Bionet_Records_for_SDM_NSW", length(sdm_cumberland_names), dim(sdm_cumberland_table)[1],  dim(sdm_cumberland_table)[2], min(as.Date(sdm_cumberland_table$Bionet_A39)),max(as.Date(sdm_cumberland_table$Bionet_A40)),"Earliest and latest dates were calculated using columns Bionet_A39 and Bionet_A40", sep=","),file= "Data/data_summary.csv", append=TRUE)
write("\n",file= "Data/data_summary.csv", append=TRUE )

sdm_cumberland_species=NULL
for (i in sdm_cumberland_names)
{
	tmp=sdm_cumberland_table[sdm_cumberland_table$Bionet_A36==i,]

	name=i
	# remove special characters, spaces, douple underscores and trailing unserscores
	name  = gsub("[^0-9A-Za-z]","_" , name ,ignore.case = TRUE)
	name  = gsub("__","_" , name ,ignore.case = TRUE)
	name  = gsub("_$","" , name ,ignore.case = TRUE)
	name  = gsub("^_","" , name ,ignore.case = TRUE)

	sdm_cumberland_species=c(sdm_cumberland_species, name)

	do.call('=',list(name,tmp))

	write.csv(eval(parse(text = name)), file=paste("Data/Bionet_sdm_cumberland_species/",name,".csv", sep=""))

}





sdm_outside<-bionet_nsw[!nsw_inside_cumberland,]


write.csv(sdm_outside@data, file="Data/sdm_outside.csv")

sdm_outside_table=read.csv(file="Data/sdm_outside.csv")


sdm_outside_names = unique(sdm_outside_table$Bionet_A36)

write( paste ("sdm_outside.csv","Bionet records that are outside of the Cumberland plane IBRA subregion but still are in the layer All_Bionet_Records_for_SDM_NSW", length(sdm_outside_names), dim(sdm_outside_table)[1],  dim(sdm_outside_table)[2], min(as.Date(sdm_outside_table$Bionet_A39)),max(as.Date(sdm_outside_table$Bionet_A40)),"Earliest and latest dates were calculated using columns Bionet_A39 and Bionet_A40", sep=","),file= "Data/data_summary.csv", append=TRUE)
write("\n",file= "Data/data_summary.csv", append=TRUE )

sdm_outside_species=NULL
for (i in sdm_outside_names)
{
	tmp=sdm_outside_table[sdm_outside_table$Bionet_A36==i,]

	name=i
	# remove special characters, spaces, douple underscores and trailing unserscores
	name  = gsub("[^0-9A-Za-z]","_" , name ,ignore.case = TRUE)
	name  = gsub("__","_" , name ,ignore.case = TRUE)
	name  = gsub("_$","" , name ,ignore.case = TRUE)
	name  = gsub("^_","" , name ,ignore.case = TRUE)

	sdm_outside_species=c(sdm_outside_species, name)

	do.call('=',list(name,tmp))

	write.csv(eval(parse(text = name)), file=paste("Data/Bionet_sdm_outside_species/",name,".csv", sep=""))


}

# Table of the all the species recornds inside and outside the the Cumberland plain--------------------
proportion_summary = NULL
for (i in sdm_cumberland_species)
{
	inside = read.csv(file=paste("Data/Bionet_sdm_cumberland_species/", i, ".csv", sep=""))

	if(i%in%sdm_outside_species)
		{
			outside = read.csv(file=paste("Data/Bionet_sdm_outside_species/", i, ".csv", sep=""))
			proportion = (dim(inside)[1]/(dim(outside)[1]+dim(inside)[1]))*100
			tmp = c(i,dim(inside)[1], dim(outside)[1], proportion)

			}else
			{
				tmp =c(i,dim(inside)[1], 0, 100 )
			}

	proportion_summary = rbind(proportion_summary, tmp)


}

colnames(proportion_summary) = c("Species", "Records_inside_Cumberland", "Records_outside_Cumberland", "Percent inside (%)")


write.csv(proportion_summary, file="Data/Species_records.csv")

# ------------------








