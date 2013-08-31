source("header.r")
source("model-count.r")

# Load data from disk
set_folders("count")
count <- load_rdata()

# Run, save and sumarise jagganaut analysis
analysis <- jags_analysis(models, data = count, niter = 10^5)   

save_analysis(analysis)
print(summary(analysis))

save_tables(analysis)
save_plots(analysis)