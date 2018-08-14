require(rgdal)
library(maptools)

metropolitan <- readOGR("Data/Data package 20180309/SydneyMetroArea_v3_2016_E_4489.shp")


names(metropolitan)[15] = "PCT"

writeOGR(map, ".", "filename") #also you were missing the driver argument

writeOGR (metropolitan, ".", "Data/Veg_merge_Cumberland/renamed_SydneyMetroArea_v3_2016_E_4489.shp", driver="ESRI Shapefile")
