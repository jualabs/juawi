
# Seleciona o tipo de modelo a ser gerado
makeModel = function(dataSorted, choice, config) {
  print(choice)
  if(toupper(choice) == config$idw)
  { 
    # Gerar o modelo utilizando o algoritmo de IDW
    nameModelMake = makeModelIdw(dataSorted, config)
    return(nameModelMake)
  } 
  else if(toupper(choice) == config$ok){
    # Gerar o modelo utilizando o algoritmo de Krigagem Ordinaria
    nameModelMake = makeModelOk(dataSorted, config)
    return(nameModelMake)
  } 
  else if(toupper(choice) == config$rf)
  {
    # Gerar o modelo utilizando o algoritmo de randomForest (Aprendizagem de maquina)
    nameModelMake = makeModelRf(dataSorted, config)
    return(nameModelMake)
  } 
  else
  {
    return("Opcao de modelo indisponível no momento!")
  }
}

# Carrega o tipo de modelo gerado anteriormente
loadModel = function(hashNameModel, config){
  # Desencapsulando o nome do modelo (id)
  hashDecrypt = RCurl::base64Decode(hashNameModel)
  # Buscando e lendo o modelo pelo id 
  # print(hashNameModel)
  path =  paste0(config$folder_model,paste0(tolower(hashDecrypt),config$type_file_model))
  # print(path)
  model = tryCatch(base::readRDS(path), error =  function(e){return("Arquivo nao existe ou caminho nao eh valido.")})
  #print(model)
  return(model)
}

# Pegar o tipo de modelo gerado anteriormente 
getModelType = function(hashNameModel, config){
  hashDecrypt = RCurl::base64Decode(hashNameModel)
  path =  paste0(config$folder_model,paste0(tolower(hashDecrypt),config$model_file_type))
  
  if(stringr::str_detect(path, pattern = tolower(config$idw))){
    return(config$idw)
  }else if(stringr::str_detect(path, pattern = tolower(config$ok))){
    return(config$ok)
  }else{
    return(config$rf)
  }
  
  
  #Separando em partes o nome do modelo (id), para interpolar utilizando o algoritmo correto para cada modelo     
  # modelNameSeparatedBar <- do.call(rbind, strsplit(path, "/", fixed=TRUE))
  # 
  # # Pegando a segunda parte com nome do modelo (id) e nome do arquivo e seprando por espaço      
  # modelType <- data.frame(do.call(rbind, strsplit(modelNameSeparatedBar[,2], " ", fixed=TRUE)))
  # 
  # Pegando o nome do modelo, após o separar nas etapas anteriores
  # typeMakeModel = toupper(modelType$X1)
  # return(typeMakeModel)
  
}

# Gerar a interpolacao baseado no tipo de modelo gerado anteriormente
makeInterpolation = function(model, gridCoordinates, ModelType, config){
  
  if(ModelType == config$idw){
    # Calculo da interpolacao utilizando o algoritmo de IDW
    interpolationIdw =  interpolationIdwGrid(model, gridCoordinates, config)
    return(interpolationIdw)
    
  } else if(ModelType == config$ok){
    # Calculo da interpolacao utilizando o algoritmo de Krigagem Ordinaria
    interpolacaoOk =  interpolationOkGrid(model, gridCoordinates, config)
    return(interpolacaoOk)
    
  } else if(ModelType == config$rf){
    # Calculo da interpolacao utilizando o algoritmo de randomForest (Aprendizagem de maquina)
    interpolacaoRf =  interpolationRfGrid(model, gridCoordinates, config)
    return(interpolacaoRf)
    
  } else{
    return("Opcao de interpolação indisponível no momento!")
  }
}