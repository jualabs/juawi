
makeModelIdw <- function(dataSorted, config){
  
  # Calculo do modelo utilizando o algoritmo de Interpolação pela Ponderação do Inverso da Distância (IDW)
  modelIDW <- gstat::gstat(formula = Value ~ 1, data = dataSorted, nmax = config$nmax)
  
  #Gerar nome o modelo (id) com milésimo de segundos
  op <- options(digits.secs = config$amount_decimal_name_model)
  nameModel = paste(tolower(config$idw), Sys.time())
  
  #salvar o modelo
  saveRDS(modelIDW, 
          file = paste0(config$folder_model,
                        paste0(tolower(nameModel),
                               config$type_file_model)), 
          compress = TRUE)
  
  # Encapsular o nome do modelo em um hash base64
  hashNameModel <- RCurl::base64(nameModel)
  print(hashNameModel)
  return(as.character(hashNameModel))
}