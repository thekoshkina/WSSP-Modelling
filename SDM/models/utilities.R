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

	for (f in factors) {
		png(filename = paste(model_filename, "_", f , "_responce.png", sep = ""), width = 6 * ppi, height = 3 * ppi)
		r <- response(xm, var = f)
		dev.off()
		write.csv(unique(r), file = paste(model_filename, "_", f, "_response.csv", sep = ""))
	}



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


run_maxent_reduce_variables = function(predictors, factors, species,  model_name, pres_train, pres_test, backgr_train, backgr_test, outcome_folder)
{

	species_folder =  paste(outcome_folder, species, '/', sep = '')
	model_folder = paste(species_folder, model_name, '/', sep = '')
	model_filename = paste(model_folder, model_name, '_', species, "_", sep = '')

	dir.create(model_folder, showWarnings = FALSE)

	flag=TRUE
	auc_prev = 0
	count = 0


	write(paste("Species:", species, "\nModel:", model_name), file = paste(model_filename,"model_summary.txt", sep=''))

	while(flag)	{
		count = count + 1


		jar <-
			paste(system.file(package = "dismo"), "/java/maxent.jar", sep = '')
		xm <- maxent(predictors, pres_train, factors = factors)

		e <- evaluate(pres_test, backgr_test, xm, predictors)
		importance = var.importance(xm)


		write(
			paste(
				"\nModel_variation:",
				count,
				"\nAUC:",
				e@auc,
				"\n\nPredictors:"
			),
			file = paste(model_filename, "model_summary.txt", sep = ''),
			append = TRUE
		)

		write(
			names(predictors),
			file = paste(model_filename, "model_summary.txt", sep = ''),
			append = TRUE
		)

		if (e@auc - auc_prev > -0.05) {
			xm_prev = xm
			auc_prev = e@auc
			e_prev = e
			importance_prev = importance
			predictors_prev = predictors
			drop_list = as.character(importance[importance[, "percent.contribution"] <=
																						0.3, "variable"])
			if (length(drop_list) > 0) {
				predictors = dropLayer(predictors, drop_list)
			} else
				flag = !flag

		} else {
			flag = !flag
			xm = xm_prev
			e = e_prev
			importance = importance_prev
			predictors = predictors_prev

			write(
				paste("\nSelected model:", "\nAUC:", e@auc, "\n\nPredictors:"),
				file = paste(model_filename, "model_summary.txt", sep = ''),
				append = TRUE
			)

			write(
				names(predictors),
				file = paste(model_filename, "model_summary.txt", sep = ''),
				append = TRUE
			)

		}


	}


	write.csv(importance, file = paste(model_filename, "var_contribution.csv", sep=""))

	png(filename = paste(model_filename, "variable_contribution.png", sep=""), width = 6*ppi, height = 3*ppi)
	plot(xm)
	dev.off()

	png(filename=paste(model_filename, "variable_responce.png", sep=""), width = 6*ppi, height = 3*ppi)
	response(xm)
	dev.off()

	for (f in factors) {
		png(filename = paste(model_filename, "_", f , "_responce.png", sep = ""), width = 6 * ppi, height = 3 * ppi)
		r <- response(xm, var = f)
		dev.off()
		write.csv(unique(r), file = paste(model_filename, "_", f, "_response.csv", sep = ""))
	}





	png(filename=paste(model_filename, "roc.png", sep=""), width = 6*ppi, height = 3*ppi)
	plot(e, 'ROC')
	dev.off()



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

