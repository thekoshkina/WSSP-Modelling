require(rgdal)
library(maptools)

metropolitan <- readOGR("Data/Data package 20180309/SydneyMetroArea_v3_2016_E_4489.shp")
west <- readOGR("Data/Data package 20180309/CumberlandPlainWest_2013_E_4207.shp")

names(metropolitan)
names (west)

names(metropolitan)[15] = "PCTNo"
names(west)[13]



# keer only PCTNo
metropolitan_veg= metropolitan[,c(15,1)]
west_veg = west[,c(10,13)]

writeOGR (metropolitan_veg, ".", "Data/Vegetation/metropolitan_veg.shp", driver="ESRI Shapefile")
writeOGR (west_veg, ".", "Data/Vegetation/west_veg.shp", driver="ESRI Shapefile")

#change id's of west_veg and metropolitan_veg for merging
new_names=paste0('m', 1:length(metropolitan_veg))
spChFIDs(metropolitan_veg) = new_names

new_names=paste0('w', 1:length(west_veg))
spChFIDs(west_veg) = new_names

combined <- spRbind(metropolitan_veg, west_veg)

writeOGR (combined, ".", "Data/Vegetation/vegitation_total.shp", driver="ESRI Shapefile")











