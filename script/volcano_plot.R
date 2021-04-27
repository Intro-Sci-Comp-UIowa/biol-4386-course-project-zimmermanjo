# Set working directory

setwd("/mnt/nfs/clasnetappvm/homedirs/zimmermanjo/Documents/My_project/biol-4386-course-project-zimmermanjo/")

# Load libraries needed for the figure
library(readxl) 
library(tidyverse)
library(knitr)
library(ggrepel)

## Not sure if I actually need these but they were used in a similar script example
library(rJava)
library(plot3Drgl)
library(cluster)
library(reshape2)
library(gplots)

# Upload xslx file into R and read first sheet (rhos)
# The file.choose option opens a window to allow you to select the desired file
cagek.rhos <- read_xlsx(file.choose(), 1)
View(cagek.rhos)

# Modify xslx file to include p-value as -log10(p-value)
cagek.rhos.log10 <- cagek.rhos %>% 
  mutate(log10.p = -1*log10(`Rho P value`))

# Making the basic volcano plot using ggplot2
initial_plot <- ggplot(data = cagek.rhos.log10) +
  geom_point(mapping = aes(x = `Rho Phenotype`, y = `log10.p`)) +
  ylim(0, 16) +
  labs(
    x = "Dexamethasone effect",
    y = "-log10(p-value)"
    )

# Export initial plot as output
ggsave(filename = "output/initial_volcano.png", plot = initial_plot, width = 6, height = 6, dpi = 300, units = "in")

# Make new column in data set to tell it what is sensitizing and what is not
cagek.rhos.log10$sigRho <- "p-value > 0.05"
cagek.rhos.log10$sigRho[cagek.rhos$`Rho P value` <0.05 & cagek.rhos$`Rho Phenotype` <0] <- "Sensitizing"
cagek.rhos.log10$sigRho[cagek.rhos$`Rho P value` <0.05 & cagek.rhos$`Rho Phenotype` >0] <- "Protective"

# Trying to add the colors to the points
color_plot <- ggplot(data = cagek.rhos.log10) +
  geom_point(mapping = aes(x = `Rho Phenotype`, y = `log10.p`, col=sigRho)) +
  ylim(0, 16) +
  labs(
    x = "Dexamethasone effect",
    y = "-log10(p-value)"
  )

# Saving the colored plot as output
ggsave(filename = "output/color_volcano.png", plot = color_plot, width = 4, height = 4, dpi = 300, units = "in")

# Change colors to the green/purple/gray
pt_color <- c("green", "purple", "gray")
names(pt_color) <- c("Sensitizing", "Protective", "p-value > 0.05")
color_plot_2 <- color_plot + scale_color_manual(values = pt_color)

# Save new colored plot as output
ggsave(filename = "output/color_volcano_2.png", plot = color_plot_2, width = 4, height = 4, dpi = 300, units = "in")


# Adding labels to genes - first create a new column in the data set to say which genes to name, then add names for these genes
cagek.rhos.log10$labeled <- NA
genes <- as.character(c("GR", "MBNL1", "BRD4", "PIK3CD"))
cagek.rhos.log10$labeled[cagek.rhos.log10$Symbol %in% c("NR3C1", "MBNL1", "PIK3CD", "BRD4")] <- genes

# First attempt to make plot with the gene labels
labeled_plot <- ggplot(data = cagek.rhos.log10, aes(x = `Rho Phenotype`, y = `log10.p`, col=sigRho, label=labeled)) +
  geom_point() +
  geom_text_repel() +
  ylim(0, 16) +
  labs(
    x = "Dexamethasone effect",
    y = "-log10(p-value)"
  ) + scale_color_manual(values = pt_color)

# Save new colored, labeled plot as output
ggsave(filename = "output/color_label_volcano.png", plot = labeled_plot, width = 6, height = 4, dpi = 300, units = "in")

# Changing the position of the legend to top middle and changing background color
plot_labeled_legend_bg <- ggplot(data = cagek.rhos.log10, aes(x = `Rho Phenotype`, y = `log10.p`, col=sigRho, label=labeled)) +
  geom_point() +
  geom_text_repel() +
  ylim(0, 16) +
  labs(
    x = "Dexamethasone effect",
    y = "-log10(p-value)",
    color = NULL
  ) + scale_color_manual(values = pt_color) +
  theme_bw() +
  theme(panel.grid.major = element_line(color = "white")) +
  theme(panel.grid.minor = element_line(color = "white")) +
  theme(legend.position = c(0.5, 0.85)) 

# Save new plot as output - only thing left is to fix label placement (and try to change size of those points if possible)
ggsave(filename = "output/plot_labeled_legend_bg.png", plot = plot_labeled_legend_bg, width = 6, height = 4, dpi = 300, units = "in")
