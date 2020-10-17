library(tercen)
library(dplyr)
library(tidyr)

options("tercen.workflowId" = "d330322c43363eb4f9b27738ef0042b9")
options("tercen.stepId"     = "e27988aa-702c-41db-8fc6-47f3fa246ae0")

ctx = tercenCtx()

if (!any(ctx$cnames == "documentId")) stop("Column factor documentId is required") 

filename = tempfile()
writeBin(ctx$client$fileService$download(ctx$cselect()[[1]]), filename)
on.exit(unlink(filename))

vcf <- readLines(filename)
vcf <- vcf[grep("#CHROM", vcf):length(vcf)]
vcf <- do.call(rbind, strsplit(vcf, "\t"))

colnames(vcf) <- vcf[1, ]
colnames(vcf)[1] <- "CHROM"
vcf <- vcf[-1, ] %>% as_tibble() 

df_out <- vcf %>%
  gather(sample, genotype, -CHROM, -POS, -ID, -REF, -ALT, -QUAL, -FILTER, -INFO, -FORMAT) %>%
  mutate(genotype = recode(genotype,
                           "0/1" = 1, "1/0" = 1, "0/0" = 0, "1/1" = 2,
                           "0|1" = 1, "1|0" = 1, "0|0" = 0, "1|1" = 2)) %>%
  mutate(.ci = rep_len(0, nrow(.)))

df_out %>% ctx$addNamespace() %>%
  ctx$save()
