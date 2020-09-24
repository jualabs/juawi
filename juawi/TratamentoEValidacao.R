
# Organização dos dados recebidos do cliente para gerar o modelo
DataHandling <- function(dataPosted, config){
  value = config$name_value
  latitudeTemp = match("Latitude", colnames(dataPosted))
  longitudeTemp = match("Longitude", colnames(dataPosted))
  valueTemp = match("Value", colnames(dataPosted))
  dataSorted = dataPosted[,c(longitudeTemp:latitudeTemp,valueTemp)]
  names(dataSorted) <- c("x", "y", value)
  sp::coordinates(dataSorted) <- ~ x + y
  return(dataSorted)

}

# Transformação dos dados recebidos do cliente em dados espaciais
transformsSpatialCoordinates = function(dataPosted, config){
  if (config$latitude == toupper(names(dataPosted)[1])){
    # print("É Latitude")
    gridCoordinates = dataPosted[,c(2:1)]
    names(gridCoordinates) <- c("x", "y")
    sp::coordinates(gridCoordinates) <- ~ x + y

    return(gridCoordinates)
    
  }
  else if(config$longitude == toupper(names(dataPosted)[1])){
    # print("É Longitude")
    gridCoordinates = dataPosted[,c(1,2)]
    names(gridCoordinates) <- c("x", "y")
    sp::coordinates(gridCoordinates) <- ~ x + y
    return(gridCoordinates)
  }
}

# Tratamento dos dados recebidos do cliente para gerar o modelo
validateDataInputModel = function(meteorologicalData, choice, config){
   # Valida a entrada da geração do modelo, por meio do
   # verficar de campos vazios do conteudo do dataframe
   # como um todo e depois verifica em cada item deste dataframe
  if(length(meteorologicalData) > config$amount_lines &&
     typeof(meteorologicalData) == config$is_list &&
     typeof(choice) == config$is_character &&
     choice != config$empty_option){
    
    if (nrow(meteorologicalData[1]) > config$amount_lines &&
        nrow(meteorologicalData[2]) > config$amount_lines &&
        nrow(meteorologicalData[3]) > config$amount_lines) {
      print("dataPosted validados")
      return(TRUE)
    }
    
  }else{
    # print("dataPosted não são válidos")
    return(FALSE)
  }
}

# Tratamento dos dados recebidos do cliente para interpolar
validateInterpolationDataInput = function(coordinates,  hash, config){

  # print(length(coordinates))
  # print(typeof(coordinates))
  # print(config$amount_lines)
  
  if(length(coordinates) > config$amount_lines &&
     typeof(coordinates) == config$is_list &&
     typeof(hash) == config$is_character &&
     hash != config$empty_option){
    
    if (nrow(coordinates[1]) > config$amount_lines &&
        nrow(coordinates[2]) > config$amount_lines) {
      # print("dataPosted validados")
      return(TRUE)
    }
  }
  else{
    return(FALSE)
  }
}

# Tratamento da opção recebida do cliente
choiceHandling <- function(choice,config){
  if (choice == tolower(config$idw) || choice == tolower(config$ok) || choice == tolower(config$rf)){
    return(choice)
  }
  else{
    return("Esta escolha nao esta disponível")
  }
}

# Validação dos dados recebidos do cliente para interpolação
validateDataframeLength = function(dataPosted, config){
  if(nrow(dataPosted)[1] <= config$modelMinimumSize || 
     nrow(dataPosted[2]) <= config$modelMinimumSize || 
     nrow(dataPosted[3]) <= config$modelMinimumSize){
    # print("tamanho dataPosted não validos")
    return(FALSE)
  }else{
    # print("Tamnho dataPosted validados")
    return(TRUE)
  }
}


