
interpolationRfGrid = function(model, gridCoordinates, config){
  if (length(gridCoordinates) >= config$minimum_size_interpolation_sample &&
            length(gridCoordinates) <= config$maximum_size_interpolation_sample){
    valueInterpolation =  predict(model, gridCoordinates)
    listValues = data.frame(latitude = gridCoordinates$y,
                          longitude = gridCoordinates$x,
                          Value = valueInterpolation)
    # print(listValues)
    return(listValues)
  }else{
    return("Tamanho de amostra de dados nao eh valida.")
  }
}