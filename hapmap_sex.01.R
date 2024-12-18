### Hapmap gender distribution
### hapmap_sex.01.R
### v1 2024/11/15
### Plotting the snpsxe per populatoin on one plot and heterozygosity plot
### @author:Chen Yu Chi


library(ggplot2)
library(tidyr)
library(dplyr)
library(stringr)
library(forcats)

dir_work <- 'C:/Users/myucchen/Dropbox/VHF274/ParusMA_hapmap/hapmap/hm.01.02/'
setwd(dir_work)

sex <- read.table('z.sexcheck', header = T, stringsAsFactors = F)
colnames(sex)[6] <- "F_het"
sex <- sex %>%
  mutate(RevSex = case_when(
    SNPSEX == 0 ~ 0, # unknown
    SNPSEX == 1 ~ 2, # male to female
    SNPSEX == 2 ~ 1, # female to male
    TRUE ~ NA_real_  # Default case for unexpected values
  ))

table(sex$RevSex)

sex$FID <- as.factor(sex$FID)
sex$RevSex <- as.factor(sex$RevSex)
sex$Location <- str_replace(sex$FID, "_[^_]+$", "") %>%
  str_replace_all("_", " ")

# location ranks by the total number of individuals
sex$Location <- factor(sex$Location, levels = names(sort(table(sex$Location))))

# sex counts
sex_counts <- sex %>%
  group_by(Location, RevSex) %>%
  summarise(Count = n(), .groups = "drop") %>%
  pivot_wider(names_from = RevSex, values_from = Count, values_fill = 0)

# Add a column for the male-to-female ratio
sex_counts <- sex_counts %>%
  mutate(Male_Female_Ratio = `1` / `2`)

sex <- sex %>%
  mutate(Location = factor(Location, levels = sex_counts$Location[order(-sex_counts$Male_Female_Ratio)]))


# gender
plot_1 <- ggplot(sex, aes(x=Location, fill=RevSex)) + 
  geom_bar(stat= "count", position = position_dodge(preserve = "single")) +
  geom_line(aes(group = "FID", y = ..count.., color = "FID"), stat = "count", size = 1) +
  labs(x = "Location", y = "Number of individuals") +
  guides(
    fill = guide_legend(title = 'Sex',
                        override.aes = list(size = 3),
                        order = 1),
    color = guide_legend(title = NULL,
                         order = 2)
         ) +
  scale_fill_manual(labels=c("0" = "Unknown", "1" = "Male", "2" = "Female"),
                    values = c("0" = "seagreen3", "1" = "steelblue3", "2" = "palevioletred2")) +
  scale_color_manual(labels=c("FID" = "Total number of\nindividuals"),
                     values = c("FID" = "black")) + 
  # ggtitle("Gender in each population") +
  theme(plot.title = element_blank(), 
        #plot.title = element_text(hjust = 0.5, size = 20, margin = margin(1, 0, 0, 0), face = "bold"),
        panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(),
        panel.background = element_blank(),
        axis.line.x.top = element_line(linewidth = 1, colour = "black", linetype = "solid"),
        axis.line.x.bottom = element_line(linewidth = 1, colour = "black", linetype = "solid"),
        axis.line.y.right = element_line(linewidth = 1, colour = "black", linetype = "solid"),
        axis.line.y.left = element_line(linewidth = 1, colour = "black", linetype = "solid"),
        axis.text.x = element_text(size = 12, angle = 45, vjust = 1, hjust = 1),
        axis.title.x = element_text(size = 18),
        axis.text.y = element_text(size = 12),
        axis.title.y = element_text(size = 18, angle=90),
        axis.ticks = element_line(colour = "black", linewidth = 0.5),
        axis.ticks.length = unit(0.05, "cm"),
        plot.margin = margin(10, 10, 10, 10),
        legend.margin = margin(0.5, 0.5, 0.5, 0.5),
        legend.key.size = unit(1, "cm"),
        legend.key = element_blank(),
        legend.title = element_text(size = 18, hjust = 0.5), 
        legend.text = element_text(size = 12)) +
  scale_x_discrete(drop = FALSE)

ggsave("sex1.png", 
       plot = plot_1,
       height = 150, 
       width = 300,
       units = c("mm"), 
       dpi = 600)


# heterozygosity
plot_2 <- ggplot(sex, 
               aes(x = F_het)) + 
  geom_histogram(binwidth = 0.1,
                 position = "stack") +
  labs(x = "Heteroyzgosity index (F)", y = "Number of individuals") +
  # ggtitle("Heteroyzgosity of Z chromosome") +
  coord_cartesian(ylim = c(0, 400)) +
  guides(fill = guide_legend(title = 'Count',
                             override.aes = list(size = 3))) +
  theme(#plot.title = element_text(hjust = 0.5, size = 20, margin = margin(1, 0, 0, 0), face = "bold"),
        plot.title = element_blank(), 
        panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(),
        panel.background = element_blank(),
        axis.line.x.top = element_line(linewidth = 1, colour = "black", linetype = "solid"),
        axis.line.x.bottom = element_line(linewidth = 1, colour = "black", linetype = "solid"),
        axis.line.y.right = element_line(linewidth = 1, colour = "black", linetype = "solid"),
        axis.line.y.left = element_line(linewidth = 1, colour = "black", linetype = "solid"),
        axis.text.x = element_text(size = 12, angle = 45, vjust = 1, hjust = 1),
        axis.title.x = element_text(size = 18),
        axis.text.y = element_text(size = 12),
        axis.title.y = element_text(size = 18, angle=90),
        axis.ticks = element_line(colour = "black", linewidth = 0.5),
        axis.ticks.length = unit(0.05, "cm"),
        plot.margin = margin(10, 10, 10, 10),
        legend.margin = margin(0.5, 0.5, 0.5, 0.5),
        legend.key.size = unit(1, "cm"),
        legend.key = element_blank(),
        legend.title = element_text(size = 20, hjust = 0.5), 
        legend.text = element_text(size = 18))  
    

ggsave("z_het.png", 
       plot = plot_2,
       height = 150, 
       width = 200,
       units = c("mm"), 
       dpi = 600) 




