source("header.r")
source("models-count.r")

set_folders("count")

data <- load_rdata()

analysis <- jags_analysis(models, data = data, niters = 10^6)

save_analysis(analysis)

print(summary(analysis))

save_tables(analysis)

if (opts_jagr("mode") != "debug") {
    save_plots(analysis)
    plot_residuals(analysis)
} 
