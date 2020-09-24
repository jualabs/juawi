
source("Funcoes.R")
source("TratamentoEValidacao.R")
source("GerarModeloIdw.R")
source("GerarModeloOk.R")
source("GerarModeloRf.R")
source("InterpolacaoOk.R")
source("InterpolacaoRf.R")
source("InterpolacaoIdw.R")

config = config::get()

#* Retorna o modelo baseado nos dados repassados
#' @author Wellington Luiz Antonio
#' @param data são os dados passados via post em formato json
#' @param choice escolha do modelo, Ex: OK, IDW, RF
#' @examples curl --data '{"data":[{"Latitude": -3.1211,"Longitude": -40.0873,"Value": 5.4241}], "choice":"idw"}' "http://localhost:8001/model"
#' @serializer json
#' @post /model
function(data, choice){
 
  # Tratamento dos dados recebidos do cliente
  if (validateDataInputModel(data, choice, config)){
    dataPosted = data.frame(data,choice)
    NAME_VALUE = toupper(names(dataPosted)[3])

    choice = choiceHandling(dataPosted$choice[1], config)
    
    if(validateDataframeLength(dataPosted, config)){
      if(toupper(config$name_value) == toupper(names(dataPosted)[1]) ||
      toupper(config$name_value) == toupper(names(dataPosted)[2]) ||
      toupper(config$name_value) == toupper(names(dataPosted)[3]) ){
      
        dataSorted  = DataHandling(dataPosted, config)
        modelMake = makeModel(dataSorted, choice, config)
        return(modelMake)
      }else{
        return("Este nome da medida nao foi implementado.")
      }
    }else{
      return("Essa quantidade de dados nao eh aceita pelo sistema.")
    }
  }else{
    return("Esta havendo algum erro na entrada, reveja se os parametros estao corretos.")
  }
}

#* Retorna a interpolacao dos dados repassados utilizando o modelo gerado no endpoint /model
#' @author Wellington Luiz Antonio
#' @param coordinates para calcular a interpolacao
#' @param hash id dado como retorno na criação do modelo de Interpolacao
#' @examples curl --data '{"coordinates":[{"Latitude": -3.1211,"Longitude": -40.0873}], "hash":"b2sgMjAxOS0wMS0yNCAwODoyNToxMi41ODc5ODQ="}' "http://localhost:8001/interpolation"
#' @serializer json
#' @post /interpolation
function(coordinates,  hash){
  
  # # Tratamento dos dados recebidos do cliente
  if (validateInterpolationDataInput(coordinates,  hash, config)){

    dataPosted = data.frame(coordinates, hash)

    hashNameModel = dataPosted$hash
  
    gridCoordinates = transformsSpatialCoordinates(dataPosted, config)
    model = loadModel(hashNameModel, config)

    if (model == config$file_not_exist){
      return(model)
    }else{

      ModelType = getModelType(hashNameModel, config)
      valuesInterpolation = makeInterpolation(model, gridCoordinates, ModelType, config)
      return(valuesInterpolation)
      
    }
  }else{
    return("Esta havendo algum erro na entrada, reveja se os parametros estao corretos.")
  }
}

#* Retorna o a mensagem de bem-vindo
#' @author Wellington Luiz Antonio
#' @serializer json
#' @get /test
function(){
  return("Welcome to the API - Service of Spatial Interpolation!")
}
