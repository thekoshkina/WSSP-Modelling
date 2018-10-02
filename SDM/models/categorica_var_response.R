require(rgdal)
require(raster)
require(maptools)
require(dismo)
library(sp)
library(ENMeval)
library(caTools)
dyn.load('/Library/Java/JavaVirtualMachines/jdk1.8.0_181.jdk/Contents/Home/jre/lib/server/libjvm.dylib')
library(rJava)


source('utilities.R')

code_name = "Litoria_aurea"

jar <- paste(system.file(package="dismo"), "/java/maxent.jar", sep='')
xm <- maxent(predictors, pres_train, factors=factors, additionalargs="writeplotdata=true")

xm@results

species_folder =  paste(outcome_folder, species, '/', sep = '')
model_folder = paste(species_folder, model_name, '/', sep = '')
model_filename = paste(model_folder, model_name, '_', species, "_", sep = '')

dir.create(model_folder, showWarnings = FALSE)


importance = var.importance(xm)
write.csv(importance, file = paste(model_filename, "var_contribution.csv", sep=""))

png(filename = paste(model_filename, "variable_contribution.png", sep=""), width = 6*ppi, height = 3*ppi)
plot(xm)
dev.off()

png(filename=paste(model_filename, "variable_responce.png", sep=""), width = 6*ppi, height = 3*ppi)
response(xm)
dev.off()

png(filename=paste(model_filename, "vegetation_responce.png", sep=""), width = 6*ppi, height = 3*ppi)
r <- response(xm, var="vegitation_pct_b_c_v0")
dev.off()
write.csv(unique(r), file = paste(model_filename, "vegetation_response.csv", sep=""))
