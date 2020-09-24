

interpolationOkGrid = function(model, gridCoordinates, config){
  if (length(gridCoordinates) >= config$minimum_size_interpolation_sample){
    interpolation = predict(model, gridCoordinates)
    # print(interpolation)
    valueInterpolation = interpolation$tec.pred
    listValues= data.frame(latitude = gridCoordinates$y,
                          longitude = gridCoordinates$x, 
                          Value = valueInterpolation)
    return(listValues)
    
    
  }else{
    return("Tamanho de amostra de dados nao eh valida.")
  }
}
