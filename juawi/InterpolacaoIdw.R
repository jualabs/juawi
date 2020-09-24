
interpolationIdwGrid = function(model, gridCoordinates, config){
  if (length(gridCoordinates) >= config$minimum_size_interpolation_sample && 
          length(gridCoordinates) <= config$maximum_size_interpolation_sample){
    
    interpolation = predict(model, gridCoordinates)
    # valueInterpolation = interpolation@data$var1.pred
    listValues = data.frame(latitude = gridCoordinates$y,
                          longitude = gridCoordinates$x, 
                          Value = interpolation@data$var1.pred)
    return(listValues)
    
  }else{
    return("Tamanho de amostra de dados nao eh valida.")
  }
}
