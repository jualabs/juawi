
makeModelRf <- function(dataSorted, config){
  
  # Calculo do modelo utilizando o algoritmo randomForest Aprendizagem de máquina
  modelRF <- randomForest::randomForest(Value ~ ., data=dataSorted, ntree=config::get()$amount_tree)
  
  #Gerar nome o modelo (id) com milésimo de segundos
  op <- options(digits.secs = config$amount_decimal_name_model)
  nameModel = paste(tolower(config$rf), Sys.time())
  
  #salvar o modelo
  saveRDS(modelRF, file = paste0(config$folder_model, paste0(tolower(nameModel), config$type_file_model)), 
          compress = TRUE)
  # print(nameModel)
  # Encapsular o nome do modelo
  hashNameModel <- RCurl::base64(nameModel)
  print(hashNameModel)
  return(as.character(hashNameModel))
}