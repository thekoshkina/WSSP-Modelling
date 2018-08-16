# utilities
run_maxent = function(predictors, factors, species, code_name, model_name, pres_train, pres_test, backgr_train, backgr_test)
{
	jar <- paste(system.file(package="dismo"), "/java/maxent.jar", sep='')
	xm <- maxent(predictors, pres_train, factors=factors)

	dir.create(paste('Outcomes/', code_name, '/', model_name, sep=''), showWarnings = FALSE)


	importance = var.importance(xm)
	write.csv(importance, file = paste('Outcomes/', code_name, '/', model_name, "/", code_name, "_",model_name, "var_contribution.csv", sep=""))

	png(filename = paste('Outcomes/', code_name, '/', model_name, "/", code_name, "_variable_contribution.png", sep=""), width = 6*ppi, height = 3*ppi)
	plot(xm)
	dev.off()

	png(filename=paste('Outcomes/', code_name, '/', model_name, "/", code_name, "_variable_responce.png", sep=""), width = 6*ppi, height = 3*ppi)
	response(xm)
	dev.off()



	e <- evaluate(pres_test, backgr_test, xm, predictors)

	png(filename=paste('Outcomes/', code_name, '/', model_name, "/", code_name, "_roc.png", sep=""), width = 6*ppi, height = 3*ppi)
	plot(e, 'ROC')
	dev.off()

	write(paste("Species:", species, " - ", code_name,  "\nModel:", model_name, "\nAUC:", e@auc,"\n\nPredictors"), file = paste('Outcomes/', code_name, '/', model_name, "/model_summary.txt", sep=''))
	write(names(predictors), file = paste('Outcomes/', code_name, '/', model_name, "/model_summary.txt", sep=''), append= TRUE)


	px <- predict(predictors, xm, progress='')

	writeRaster(px, paste('Outcomes/', code_name, '/', model_name, "/", code_name, "_maxent_output.tif", sep=""), format = "GTiff", overwrite=TRUE)

	png(filename=paste('Outcomes/', code_name, '/', model_name, "/", code_name, "_maxent_results.png", sep=""), width = 6*ppi, height = 3*ppi)
	par(mfrow=c(1,2))
	plot(px, main='Maxent, raw values')


	tr <- threshold(e, 'spec_sens')
	plot(px > tr, main='presence/absence')
	dev.off()

return(list( e, xm, px, importance))
}

