library(plumber)

pr = plumber::plumb("Main.R")
pr$run(host='0.0.0.0', port=8001)

