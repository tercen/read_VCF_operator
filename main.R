library(tercen)
library(dplyr)
library(tidyr)

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
