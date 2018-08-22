# utilities
run_maxent = function(predictors, factors, species,  model_name, pres_train, pres_test, backgr_train, backgr_test, outcome_folder)
{
	jar <- paste(system.file(package="dismo"), "/java/maxent.jar", sep='')
	xm <- maxent(predictors, pres_train, factors=factors)

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



	e <- evaluate(pres_test, backgr_test, xm, predictors)

	png(filename=paste(model_filename, "roc.png", sep=""), width = 6*ppi, height = 3*ppi)
	plot(e, 'ROC')
	dev.off()

	write(paste("Species:", species, "\nModel:", model_name, "\nAUC:", e@auc,"\n\nPredictors"), file = paste(model_filename,"model_summary.txt", sep=''))
	write(names(predictors), file = paste(model_filename,"model_summary.txt", sep=''), append= TRUE)


	px <- predict(predictors, xm, progress='')

	writeRaster(px, paste(model_filename, "maxent_output.tif", sep=""), format = "GTiff", overwrite=TRUE)

	png(filename=paste(model_filename, "maxent_results.png", sep=""), width = 6*ppi, height = 3*ppi)
	par(mfrow=c(1,2))
	plot(px, main='Maxent, raw values')


	tr <- threshold(e, 'spec_sens')
	bin = px > tr

	plot(bin, main='presence/absence')


	dev.off()

	writeRaster(bin, paste(model_filename, "maxent_output_binary.tif", sep=""), format = "GTiff", overwrite=TRUE)

return(list(e, xm, px, tr, importance))
}

