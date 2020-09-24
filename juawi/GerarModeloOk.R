
makeModelOk <- function(dataSorted, config){
  
  # Calculo do modelo utilizando o algoritmo de Krigagem Ordinária
  # print(dataSorted)
  variogramSample <- gstat::variogram(Value ~ 1, dataSorted)
  # print(variogramSample)
  modelVariogramSample <- gstat::fit.variogram(variogramSample, model= gstat::vgm("Exp"))
  modelOK <- gstat::gstat(id="tec", formula = Value ~ 1, data = dataSorted, model = modelVariogramSample)
  # print(modelOK)
  
  #Gerar nome o modelo (id) com milésimo de segundos
  op <- options(digits.secs = config$amount_decimal_name_model)
  nameModel = paste(tolower(config$ok), Sys.time())
  
  #salvar o modelo
  saveRDS(modelOK, 
          file = paste0(config$folder_model,
                        paste0(tolower(nameModel),
                               config$type_file_model)), 
          compress = TRUE)
  
  # Encapsular o nome do modelo
  hashNameModel <- RCurl::base64(nameModel)
  print(hashNameModel)
  return(as.character(hashNameModel))
}