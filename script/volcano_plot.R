# Set working directory

setwd("/mnt/nfs/clasnetappvm/homedirs/zimmermanjo/Documents/My_project/biol-4386-course-project-zimmermanjo/")

# Load libraries needed for the figure
library(readxl) 
library(tidyverse)
library(knitr)

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

