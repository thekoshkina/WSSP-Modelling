require(rgdal)
require(raster)
require(maptools)
require(dismo)
library(sp)
library(ENMeval)
library(caTools)
dyn.load('/Library/Java/JavaVirtualMachines/jdk1.8.0_161.jdk/Contents/Home/jre/lib/server/libjvm.dylib')
library(rJava)


source('utilities.R')

species = "Phascolarctos_cinereus"
code_name = "Koala"

#specify folder for the precense point data and covariate data files
data_folder = "Data/Cumberland"
presence_folder = "Data/Presence"


# create a folder for output
dir.create(paste('Outcomes/', code_name, sep=''), showWarnings = FALSE)


pres_train_file = paste('Outcomes/', code_name, '/',"pres_test_train", code_name, ".rda" , sep="")
backgr_train_file = paste("backgr_test_train.rda")

#read all the covariate tif files from covariate folder
cumberland <-  readOGR("Data/IBRA_cumberland/Cumberland_IBRA_subregion.shp")


files=list.files(data_folder , pattern = "*.tif$", full.names=TRUE)
no_cov=length(files) #number of covariates
predictors <- stack(files)




### add zeros instead of NA in the vegetation layer
predictors <- dropLayer(predictors, 'vegitation_pct_b_c')
vegetation=raster(paste(data_folder, '/', 'vegitation_pct_b_c.tif', sep=''))
vegetation[is.na(vegetation[])] <- 0
plot(vegetation)
predictors <- addLayer(predictors, vegetation)



ppi=300

if(!file.exists(backgr_train_file)){
	#### select beckground points - randomly selecting points and save them for later
	backgr <- randomPoints(predictors, 1000)
	group <- kfold(backgr, 5)
	backgr_train <- backgr[group != 1, ]
	backgr_test <- backgr[group == 1, ]
	#
	save(backgr_train, backgr_test, file=backgr_train_file)

	print(paste("Testing and training points for bakground have been randomly selected and saved in the file: ", backgr_train_file))

}else{
	load(backgr_train_file)
	print(paste("Testing and training points for background have been loaded from the file: ", backgr_train_file))
}


presence_table <- read.table(paste(presence_folder,"/", species, ".csv", sep="" ),  header=TRUE,  sep=",")
presences_all = SpatialPoints( presence_table[, c("decimalLon","decimalLat")])
proj4string(presences_all)=cumberland@proj4string

# only select points in the study area
presences = presences_all[cumberland,]


# check if training and testing points have already been selected
if(!file.exists(pres_train_file)){
	##### select 20% of the data for testing - randomly selecting points
	group <- kfold(presences, 5)
	pres_train <- presences[group != 1, ]
	pres_test <- presences[group == 1, ]

	save(pres_train, pres_test, file=pres_train_file)

	print(paste("Testing and training points for", code_name, "(", species, ") have been randomly selected and saved in the file: ", pres_train_file))


}else{
	load(pres_train_file)
	print(paste("Testing and training points for", code_name, "(", species, ") have been loaded from the file: ", pres_train_file))
}

png(filename =paste('Outcomes/', code_name, '/', code_name, "_presence_background_points.png", sep=""), width = 6*ppi, height = 3*ppi)
# plot presence and bacground points
plot(!is.na(predictors[[1]]), col=c('white', 'light grey'), legend=FALSE)
points(backgr_train, pch='-', cex=1.5, col='yellow')
points(backgr_test, pch='-',  cex=1.5, col='black')
points(pres_train, pch= '+',cex=1.5, col='green')
points(pres_test, pch='+',cex=1.5, col='blue')

legend("topright", legend=c("background - train","background - test","presence - train","presence - test"), pch=c('-','-','+','+'), col = c('yellow', 'black', 'green','blue'),cex=2.5)
dev.off()

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# RUN MAXENT - all covariates --------------------------------------------------
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
factors = c('vegitation_pct_b_c', 'soil_c')

model_name = "all_cov"
model1 = run_maxent(predictors, factors, species, code_name, model_name, pres_train, pres_test, backgr_train, backgr_test)

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Model2 - drop predictors with low contribution -------------------------------
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
model_name = "model2"
drop_list = as.character(model1[[4]][model1[[4]][,"percent.contribution"]<=0.2,"variable"])


predictors2 = dropLayer(predictors, drop_list)

model2 = run_maxent(predictors2, factors, species, code_name, model_name, pres_train, pres_test, backgr_train, backgr_test)





