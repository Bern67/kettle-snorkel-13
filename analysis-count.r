source("header.r")
source("model-count.r")

count <- readRDS("count.rds")

analysis <- janalysis(
  model = model, data = count, n.iter=10^5
)

summary(analysis)

saveRDS(analysis,"analysis.rds")

write.csv(calc_estimates(analysis),"estimates.csv")

pdf("trace.pdf",width=8.5,height=11)
plot(analysis)
dev.off()
