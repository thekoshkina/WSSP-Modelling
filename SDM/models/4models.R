# this file runs 4 models for each species 
# 1- no bias all cumberland. predictor secection is done for this model
# 2 - overall pres points bias layers. predictors are used from the selection process in 1
# 3 - individual species pres point bias layer
# 4 - vegetation only - no bias

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
ppi=300

species_list =c("Litoria_aurea","Grevillea_parviflora_subsp_parviflora", "Persoonia_nutans","Phascolarctos_cinereus"  )

data_folder = "Data/Cumberland"
presence_folder = "Data/Presence"
bias_folder = "Data/Bias"

dir.create("Outcomes", showWarnings = FALSE)

#read all the covariate tif files from covariate folder
cumberland <-  readOGR("Data/IBRA_cumberland/Cumberland_IBRA_subregion.shp")
bias = readOGR("Data/bias/presence_layer_buffer.shp")

files=list.files(data_folder , pattern = "*.tif$", full.names=TRUE)
no_cov=length(files) #number of covariates
predictors <- stack(files)




### add zeros instead of NA in the vegetation layer
predictors <- dropLayer(predictors, 'vegitation_pct_b_c')
vegetation=raster(paste(data_folder, '/', 'vegitation_pct_b_c.tif', sep=''))
vegetation[is.na(vegetation[])] <- 0
plot(vegetation)
predictors <- addLayer(predictors, vegetation)

background_sample_file = "Data/background_sample.rda"






for (species in species_list){
    
    # create a folder for output
    outcome_folder = paste('Outcomes/', species,"/", sep='')
    dir.create(outcome_folder, showWarnings = FALSE)
    
    model_folder = paste('Outcomes/ALL_MODELS/', species, sep='')
   
    
    pres_train_file = paste(outcome_folder, "pres_test_train_", species, ".rda" , sep="")
    backgr_train_file = paste("bias_backgr_test_train.rda")
    

    
    
    presence_table <- read.table(paste(presence_folder,"/", species, ".csv", sep="" ),  header=TRUE,  sep=",")
    presences_all = SpatialPoints( presence_table[, c("decimalLon","decimalLat")])
    proj4string(presences_all)=cumberland@proj4string
    
    
    
    background_sample = load_sample_file(background_sample_file, cumberland)
    backgr =  get_bkgr_train_test(backgr_train_file, background_sample)
    backgr_test = backgr[[1]]
    backgr_train = backgr[[2]]
    
    
    # only select points in the study area
    presences = presences_all[cumberland,]
    
    # check if training and testing points have already been selected
    if(!file.exists(pres_train_file)){
        ##### select 20% of the data for testing - randomly selecting points
        group <- kfold(presences, 5)
        pres_train <- presences[group != 1, ]
        pres_test <- presences[group == 1, ]
        
        save(pres_train, pres_test, file=pres_train_file)
        
        print(paste("Testing and training points for", species, "(", species, ") have been randomly selected and saved in the file: ", pres_train_file))
        
        
    }else{
        load(pres_train_file)
        print(paste("Testing and training points for", species, "(", species, ") have been loaded from the file: ", pres_train_file))
    }
    
    png(filename =paste(outcome_folder,'/', species, "_presence_background_points.png", sep=""), width = 6*ppi, height = 3*ppi)
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
    
    model_name = "select_variables"
    # outcome_folder = 'Outcomes_Cumberland/'
 
     #  
    model_all = run_maxent_reduce_variables (predictors, factors, species,  model_name, pres_train, pres_test, backgr_train, backgr_test, outcome_folder)
    
    save(model_all, file = paste(model_folder, "all.rda", sep=""))
    
    # # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # # RUN MAXENT - bias layers --------------------------------------------------
    # # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # 
    # species_bias = paste (bias_folder, species, sep="")
    # 
    # bias_list=c( common_bias, species_bias)
    # 
    # for (bias in bias_list){
    #     
    #     background_sample = load_sample_file(background_sample_file, bias)
    #     backgr =  get_bkgr_train_test(backgr_train_file, background_sample)
    #     backgr_test = backgr[[1]]
    #     backgr_train = backgr[[2]]
    # 
    # }
    # # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # # RUN MAXENT - vegetation --------------------------------------------------
    # # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # 
    
    }
    