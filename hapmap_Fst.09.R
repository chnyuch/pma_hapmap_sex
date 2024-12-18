### Hapmap Fst plot
### hapmap_Fst.09.R
### v9 2024/12/10
### Female and male comparison from all focal populations
### v8 2024/12/10
### improved v6
### v7 2024/12/10
### improved v4
### v6 2024/11/25
### Hapmap plot: female vs male, different ratio for 2 pops (from v4)
### v5 2024/11/22
### Hapmap plot: female vs male, different ratio (from v4)
### v4 2024/11/20
### Hapmap plot: female vs whole group Fst, remove recombination rate parts (from v3)
### v3 2024/11/19
### Hapmap plot: female vs whole group Fst (from v1)
### v2 2024/07/02
### Hapmap plot: gender comparison
### v1 2024/07/02
### Hapmap plot: sliding window of Fst
### @author:Chen Yu Chi
### https://github.com/lgs85/SpurginBosse_Hapmap/blob/main/Scripts/Genomic_scripts/FST_Turkey.R

library(ggplot2)
library(gridExtra)
library(patchwork)
library(dplyr)
library(grid)

# dir
dir_work <- 'C:/Users/myucchen/Dropbox/VHF274/ParusMA_hapmap/hapmap/hm.01.10/fst1/' 
setwd(dir_work)

pops <- list.files(paste0(dir_work, '/'), pattern = '*.windowed.weir.fst')
pops <- gsub(".windowed.weir.fst", "",pops)

temp <- read.table(paste0(pops,".windowed.weir.fst"), header = T, stringsAsFactors = F)
temp$x <- seq_len(nrow(temp))
temp$color <- ifelse(temp$MEAN_FST > 0.2, "high", ifelse(temp$CHROM%%2 == 1,"1","2"))
dataColor <- unique(temp$color)
temp$color <- factor(temp$color, levels = dataColor)

# chromosome labeling
chr <- read.table("PLINK_Chromosome_numbering.txt", header = T, sep = '\t')

temp.1 <- merge(temp, chr, by.x = 'CHROM', by.y = 'Plink_Chr', all.x=TRUE) # with Z chr
temp.1<- temp.1 %>%
  mutate(serialID = as.integer(factor(CHROM)))

temp.2 <- temp.1[!temp.1$CHROM == "36", ] # without Z chr


plot <- ggplot(temp.1, aes(x = x, y = MEAN_FST, group = 1)) +
  geom_line(aes(color = color), linewidth = 0.3) +
  scale_color_manual(values = c("1" = "steelblue4", "2" = "steelblue2", "high" = "red")[dataColor]) +
  scale_y_continuous(limits = c(-0.1, 0.3)) +
  geom_text(#data = temp.1 %>% group_by(Chr_name) %>% summarise(x = mean(x)), 
            data = temp.1 %>% group_by(Chr_name) %>% reframe(x = mean(x), y = ifelse(serialID%%2 == 1, -0.05, -0.09), .groups = "drop"), 
            aes(x = x, y = y, label = Chr_name), 
            vjust = 1.5, 
            size = 1.1) +
  theme(# plot.title = element_text(hjust = 0.5, size = 10, margin = margin(1, 0, 0, 0), face = "bold"),
    plot.title = element_blank(),
    panel.grid.major = element_blank(), 
    panel.grid.minor = element_blank(),
    panel.background = element_blank(),
    strip.background = element_blank(),
    axis.line.x.top = element_blank(),
    axis.line.x.bottom = element_blank(),
    axis.text.x = element_blank(),
    axis.title.x = element_text(size = 8),
    axis.ticks.x.bottom = element_blank(),
    axis.line.y.right = element_blank(),
    axis.line.y.left = element_line(linewidth = 0.5, colour = "black", linetype = "solid"),
    axis.text.y.left = element_text(size = 6),
    axis.text.y.right = element_blank(),
    axis.title.y = element_text(size = 8, angle=90),
    axis.ticks.y.left = element_line(colour = "black", linewidth = 0.5),
    axis.ticks.length = unit(0.1, "cm"),
    plot.margin = margin(5, 0, 5, 5),
    legend.position = "none"
    # legend.margin = margin(0.5, 0.5, 0.5, 0.5),
    # legend.key.size = unit(1, "cm"),
    # legend.key = element_blank(),
    # legend.title = element_text(size = 10, hjust = 0.5), 
    # legend.text = element_text(size = 13)
  ) +
  xlab("Positions") +
  ylab(expression(italic(F)[ST])) +
  ggtitle("Male vs Female") 


ggsave(paste0(gsub('.{5}$', '', dir_work), "Male_female1.png"), 
       plot = plot, 
       height = 60, 
       width = 240, 
       units = "mm", 
       dpi = 600)

