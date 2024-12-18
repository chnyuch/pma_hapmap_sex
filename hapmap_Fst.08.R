### Hapmap Fst plot
### hapmap_Fst.08.R
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
dir_work <- 'C:/Users/myucchen/Dropbox/VHF274/ParusMA_hapmap/hapmap/hm.01.09/fst1/' 
setwd(dir_work)

# type1 and type2 populations
type2 <- list('Wytham_UK', 'Harjavalta_Finland')
sex_type <- list('00f12m', '03f09m', '06f06m', '09f03m', '12f00m')

# import data list
pops <- list.files(dir_work, pattern = '*.windowed.weir.fst')
pops <- gsub(".windowed.weir.fst", "",pops)
plots <- list()
cols <- list() # uk
rows <- list() # fn


for (pop in pops){
  # print(pop)
  # naming
  comp1 <- strsplit(pop, "-")[[1]][1]
  comp2 <- strsplit(pop, "-")[[1]][2]
  loc1 <- strsplit(comp1, "\\.")[[1]][1]
  loc2 <- strsplit(comp2, "\\.")[[1]][1]
  # ratio1 <- strsplit(comp1, "\\.")[[1]][2]
  # ratio2 <- strsplit(comp2, "\\.")[[1]][2]
  
  if (grepl("^W", comp1)) cols <- c(cols, comp1) else rows <- c(rows, comp1)
  if (grepl("^W", comp2)) cols <- c(cols, comp2) else rows <- c(rows, comp2)
  
  # import table  
  temp <- read.table(paste0(pop,".windowed.weir.fst"), header = T, stringsAsFactors = F)
  # print(temp)
  # temp$COMP <- pop
  # temp$COMP <- factor(temp$COMP, levels = unique(temp$COMP))
  # dd$MEAN_FST[dd$MEAN_FST < 0] <- 0
  temp$x <- seq_len(nrow(temp))
  plot <- ggplot(temp, aes(x = x, y = MEAN_FST, group = 1)) +
    annotate("rect", 
             xmin = (1031 - 100), 
             xmax = (1038 + 100), 
             ymin=-Inf, 
             ymax=Inf, 
             alpha=0.5, 
             fill="orange") +
    geom_line(color = "cyan4", linewidth = 0.3) +
    # geom_rect(
    #   inherit.aes=FALSE,
    #   aes(xmin = (1031 - 50), ymin = -Inf, 
    #               xmax = (1038 + 50), ymax = Inf),
    #           fill = 'orange',
    #           alpha = 0.8) +
    # geom_path(size = 0.8) +
    scale_y_continuous(limits = c(-0.5, 1.0)) +
    theme(plot.title = element_text(hjust = 0.5, size = 3, margin = margin(1, 0, 0, 0), face = "bold"),
          panel.grid.major = element_blank(), 
          panel.grid.minor = element_blank(),
          panel.background = element_blank(),
          strip.background = element_blank(),
          axis.line.x.top = element_blank(),
          axis.line.x.bottom = element_blank(),
          axis.text.x = element_blank(),
          axis.title.x = element_blank(), # element_text(size = 4),
          axis.ticks.x.bottom = element_blank(),
          axis.line.y.right = element_blank(),
          axis.line.y.left = element_line(linewidth = 0.5, colour = "black", linetype = "solid"),
          axis.text.y.left = element_text(size = 4),
          axis.text.y.right = element_blank(),
          axis.title.y =  element_blank(), # element_text(size = 4, angle=90),
          axis.ticks.y.left = element_line(colour = "black", linewidth = 0.5),
          axis.ticks.length = unit(0.1, "cm"),
          plot.margin = margin(1, 1, 1, 1),
          legend.position="none"
          # legend.margin = margin(0.5, 0.5, 0.5, 0.5),
          # legend.key.size = unit(1, "cm"),
          # legend.key = element_blank(),
          # legend.title = element_text(size = 10, hjust = 0.5), 
          # legend.text = element_text(size = 13)
    ) +
    # xlab("Windows") +
    # ylab(expression(italic(F)[ST])) +
    ggtitle(paste0(comp1, '\n', comp2)) 
  
  plots[[paste(pop)]] <- plot
  
}  

cols <- sort(unique(unlist(cols)))
rows <- sort(unique(unlist(rows)))

# order plots
ordered_plots <- list()   

# 5x5 plots
for (row in rows) {
  for (col in cols) {
    plot_name <- paste0(col, "-", row)  # Case 1: Row before Column
    if (plot_name %in% names(plots)) {
        ordered_plots[[length(ordered_plots) + 1]] <- plots[[plot_name]]
        } else {
        # Add a placeholder if no match
        ordered_plots[[length(ordered_plots) + 1]] <- ggplot() + theme_void() + ggtitle("Empty")
      }
    }
}

  
# Combine plots into a 3x3 grid
# final_plots <- wrap_plots(ordered_plots, ncol = 5)
final_plots <- grid.arrange(
  grobs = ordered_plots,  # Main plots,
  ncol = 5, 
  bottom = textGrob("Positions", gp = gpar(fontsize = 8)), 
  left = textGrob(expression(italic(F)[ST]), rot = 90, gp = gpar(fontsize = 8), just = "center") 
)
  
# Save the table of plots as a PNG file
ggsave(paste0(gsub('.{5}$', '', dir_work), 'uk_fn.png'), 
        plot = final_plots, 
        height = 120, 
        width = 120, 
        units = "mm", 
        dpi = 600)
  