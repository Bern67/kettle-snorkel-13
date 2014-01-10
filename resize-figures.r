source("header.r")

if (.Platform$OS.type != "windows") {
    stop("resize-figures must be run on windows")
} else {
    resave_plots()
} 
