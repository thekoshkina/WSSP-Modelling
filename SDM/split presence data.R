### Transform Bionet NSW data  - some species in the whole NSW ---------------------------------------------------
require(rgdal)


folder = "Data/presence records/"

cumberland = readOGR("Data/Data package 20180309/Cumberland_IBRA_subregion.shp")
sdm_nsw <- readOGR("Data/presence records/Bionet_records.shp")
proj4string(sdm_nsw)=cumberland@proj4string

sdm_nsw_table = sdm_nsw@data
sdm_nsw_names = unique(sdm_nsw_table$scientific)

write.csv(sdm_nsw_names, file= paste(folder, "all_species_names.csv", sep=""))
write.csv(sdm_nsw_table, file=paste(folder, "sdm_nsw.csv", sep=""))


nsw_inside_cumberland = !is.na(over(sdm_nsw, as(cumberland, "SpatialPolygons")))

sdm_cumberland <- sdm_nsw[nsw_inside_cumberland,]
sdm_cumberland_table = sdm_cumberland@data
sdm_cumberland_names = unique(sdm_cumberland_table$scientific)

write.csv(sdm_cumberland_table, file=paste(folder, "sdm_cumberland.csv", sep=""))

sdm_outside<-sdm_nsw[!nsw_inside_cumberland,]
sdm_outside_table=sdm_outside@data
sdm_outside_names = unique(sdm_outside_table$scientific)

write.csv(sdm_outside_table, file=paste(folder, "sdm_outside.csv", sep=""))



write("Code name, Sientific name, Common name, Order, Kingdom, Total number of records, No. in Cumberland, No. out Cumberland",file= paste(folder, "species_records_summary.csv", sep="") )





sdm_nsw_species=NULL
for (i in sdm_nsw_names)
{
	all=sdm_nsw_table[sdm_nsw_table$scientific==i,]
	inside = sdm_cumberland_table[sdm_cumberland_table$scientific==i,]
	outside = sdm_outside_table[sdm_outside_table$scientific==i,]

	common_name =  unique(sdm_nsw_table[sdm_nsw_table$scientific==i,'vernacular'])
	common_name  = gsub(",",";" , common_name ,ignore.case = TRUE)

	family =  unique(sdm_nsw_table[sdm_nsw_table$scientific==i,'order_'])
	kingdom =  unique(sdm_nsw_table[sdm_nsw_table$scientific==i,'kingdom'])

	name=i
	# remove special characters, spaces, douple underscores and trailing unserscores
	name  = gsub("[^0-9A-Za-z]","_" , name ,ignore.case = TRUE)
	name  = gsub("__","_" , name ,ignore.case = TRUE)
	name  = gsub("_$","" , name ,ignore.case = TRUE)
	name  = gsub("^_","" , name ,ignore.case = TRUE)

	sdm_nsw_species=c(sdm_nsw_species, name)

	do.call('=',list(name,all))


	write.csv(all, file=paste( folder, "all_csv/",name,".csv", sep=""))
	write.csv(inside, file=paste( folder, "inside_csv/",name,".csv", sep=""))
	write.csv(outside, file=paste(folder, "outside_csv/",name,".csv", sep=""))


	# write.csv(eval(parse(text = name)), file="Data/precence records/species_records_summary.csv")

	str = paste(name, i, common_name, family, kingdom, dim(all)[1], dim(inside)[1], dim(outside)[1], sep="," )
	write(str ,file=paste(folder, "species_records_summary.csv", sep =""), append=TRUE)
}













# write( paste ("sdm_cumberland.csv","Bionet records that are inside of the Cumberland plane IBRA subregion from the layer All_Bionet_Records_for_SDM_NSW", length(sdm_cumberland_names), dim(sdm_cumberland_table)[1],  dim(sdm_cumberland_table)[2], min(as.Date(sdm_cumberland_table$Bionet_A39)),max(as.Date(sdm_cumberland_table$Bionet_A40)),"Earliest and latest dates were calculated using columns Bionet_A39 and Bionet_A40", sep=","),file= "Data/data_summary.csv", append=TRUE)
# write("\n",file= "Data/precence records/data_summary.csv", append=TRUE )
#
# sdm_cumberland_species=NULL
# for (i in sdm_cumberland_names)
# {
# 	tmp=
# 	name=i
# 	# remove special characters, spaces, douple underscores and trailing unserscores
# 	name  = gsub("[^0-9A-Za-z]","_" , name ,ignore.case = TRUE)
# 	name  = gsub("__","_" , name ,ignore.case = TRUE)
# 	name  = gsub("_$","" , name ,ignore.case = TRUE)
# 	name  = gsub("^_","" , name ,ignore.case = TRUE)
#
# 	sdm_cumberland_species=c(sdm_cumberland_species, name)
#
# 	do.call('=',list(name,tmp))
#
#
#
# }
#
#
#
#
#
# sdm_outside<-sdm_nsw[!nsw_inside_cumberland,]
#
#
# write.csv(sdm_outside@data, file="Data/sdm_outside.csv")
#
# sdm_outside_table=read.csv(file="Data/sdm_outside.csv")
#
#
# sdm_outside_names = unique(sdm_outside_table$scientific)
#
# write( paste ("sdm_outside.csv","Bionet records that are outside of the Cumberland plane IBRA subregion but still are in the layer All_Bionet_Records_for_SDM_NSW", length(sdm_outside_names), dim(sdm_outside_table)[1],  dim(sdm_outside_table)[2], min(as.Date(sdm_outside_table$Bionet_A39)),max(as.Date(sdm_outside_table$Bionet_A40)),"Earliest and latest dates were calculated using columns Bionet_A39 and Bionet_A40", sep=","),file= "Data/data_summary.csv", append=TRUE)
# write("\n",file= "Data/data_summary.csv", append=TRUE )
#
# sdm_outside_species=NULL
# for (i in sdm_outside_names)
# {
# 	tmp=sdm_outside_table[sdm_outside_table$scientific==i,]
#
# 	name=i
# 	# remove special characters, spaces, douple underscores and trailing unserscores
# 	name  = gsub("[^0-9A-Za-z]","_" , name ,ignore.case = TRUE)
# 	name  = gsub("__","_" , name ,ignore.case = TRUE)
# 	name  = gsub("_$","" , name ,ignore.case = TRUE)
# 	name  = gsub("^_","" , name ,ignore.case = TRUE)
#
# 	sdm_outside_species=c(sdm_outside_species, name)
#
# 	do.call('=',list(name,tmp))
#
# 	write.csv(eval(parse(text = name)), file=paste("Data/precence records/outside_csv/",name,".csv", sep=""))
#
#
# }
#
# # Table of the all the species recornds inside and outside the the Cumberland plain--------------------
# proportion_summary = NULL
# for (i in sdm_cumberland_species)
# {
# 	inside = read.csv(file=paste("Data/precence records/inside_csv/", i, ".csv", sep=""))
#
# 	if(i%in%sdm_outside_species)
# 	{
# 		outside = read.csv(file=paste("Data/precence records/outside_csv/", i, ".csv", sep=""))
# 		proportion = (dim(inside)[1]/(dim(outside)[1]+dim(inside)[1]))
# 		tmp = c(i,dim(inside)[1], dim(outside)[1], proportion)
#
# 	}else
# 	{
# 		tmp =c(i,dim(inside)[1], 0, 100 )
# 	}
#
# 	proportion_summary = rbind(proportion_summary, tmp)
#
#
# }
#
# colnames(proportion_summary) = c("Species", "Records_inside_Cumberland", "Records_outside_Cumberland", "Percent inside (%)")
#
#
# write.csv(proportion_summary, file="Data/precence records/Species_records.csv")
#
# # ---
