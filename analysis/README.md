# Analysis of Gene Knock Down on Dexamethasone Sensitivity using ggplot2

## Getting ready to create the figure

Before getting started on reproducing this figure, I will set my working directory:

```
setwd("/mnt/nfs/clasnetappvm/homedirs/zimmermanjo/Documents/My_project/biol-4386-course-project-zimmermanjo/")
```

Next, I will load the libraries needed for this figure, which have already been installed:

```
library(readxl) 
library(tidyverse)
library(ggrepel)
```

## Loading the data

To load the xslx file into R, I will use `read_xslx` along with `file.choose()`, which will allow me to select the file easily from the data directory. `read_xslx` also allows me to specify that I only want to load sheet 1 of this xslx file, which is the sheet that contains the Rho phenotypes (which are the effect on dexamethasone sensitivity). Sheet 2 contains Gamma phenotypes, which are the effect on overall cell growth. 

```
cagek.rhos <- read_xlsx(file.choose(), 1)
```

## Modifying the data prior to plotting

In order to create the plot as it appears in the figure, I will need to modify the p-values so that they are expressed as -log10 values. I can use `mutate()` to do this and create a new variable which I will call "log10.p" and add this to a modified dataframe called "cagek.rhos.log10".

```
cagek.rhos.log10 <- cagek.rhos %>% 
  mutate(log10.p = -1*log10(`Rho P value`))
```

Since the Rho phenotypes do not need modification prior to plotting, my data should now be ready to go. 

## Creating the initial volcano plot

I will use `ggplot2()` to create a scatterplot (using `geom_point()`) with the Rho phenotype on the x axis and the -log10(p-value) on the y axis. It appears that the y axis limits on the original figure go from 0 to about 16, so I will set my y axis limit accordingly. I will also modify the labels of my axes. For the y-axis, I can change this to match the actual y-axis in the figure. For the x-axis, I will put a temporary name of "Dexamethasone effect" and come back to this later to add the arrow as seen in the original figure. 

```
initial_plot <- ggplot(data = cagek.rhos.log10) +
  geom_point(mapping = aes(x = `Rho Phenotype`, y = `log10.p`)) +
  ylim(0, 16) +
  labs(
    x = "Dexamethasone effect",
    y = "-log10(p-value)"
    )
```

So far, this looks like the points are in the correct places compared to the original figure. I can save this initial volcano plot as my first output with `ggsave()` to create an initial png file. 

```
ggsave(filename = "output/initial_volcano.png", plot = initial_plot, width = 6, height = 6, dpi = 300, units = "in")
```

## Adding color to the volcano plot

The next step that I will address is adding color to the volcano plot based on which genes significantly sensitize and which genes significantly increase resistance to glucocorticoids. First, I create a new column of variables classifying each gene as "sensitive" (for genes which increase sensitivity to glucocorticoids), "resistant" (for genes which decrease sensitivity to glucocorticoids), and "no" (for genes with p >= 0.05). 

```
cagek.rhos.log10$sigRho <- "p-value > 0.05"
cagek.rhos.log10$sigRho[cagek.rhos$`Rho P value` <0.05 & cagek.rhos$`Rho Phenotype` <0] <- "Sensitizing"
cagek.rhos.log10$sigRho[cagek.rhos$`Rho P value` <0.05 & cagek.rhos$`Rho Phenotype` >0] <- "Protective"
```

Now, I can redo the volcano plot using the new variable "sigRho" as the color:

```
color_plot <- ggplot(data = cagek.rhos.log10) +
  geom_point(mapping = aes(x = `Rho Phenotype`, y = `log10.p`, col=sigRho)) +
  ylim(0, 16) +
  labs(
    x = "Dexamethasone effect",
    y = "-log10(p-value)"
  )
```

This appears to be coloring the genes correctly. I will save this interim plot to continue to track my progress:

```
ggsave(filename = "output/color_volcano.png", plot = color_plot, width = 4, height = 4, dpi = 300, units = "in")
```

Now I will change the colors from the default colors that R gave these groups to the desired colors of green, purple, and gray. This can be done by creating new vectors and assigning those to the sigRho values.

```
pt_color <- c("green", "purple", "gray")
names(pt_color) <- c("Sensitizing", "Protective", "p-value > 0.05")
```

Now I can make a new colored plot using these manually assigned colors to match the original figure:

```
color_plot_2 <- color_plot + scale_color_manual(values = pt_color)
```

And I will save a copy of this plot as well to track my progress:

```
ggsave(filename = "output/color_volcano_2.png", plot = color_plot_2, width = 4, height = 4, dpi = 300, units = "in")
```

## Adding key gene labels

Next, I will add labels for the 4 genes which are labeled in the original figure (MBNL1, PIK3CD, BRD4, and NR3C1, which is the same as GR). To do this, I first create a new column in the data frame called "labeled" which will include the name for only the genes that I want to be labeled in the final figure:

```
cagek.rhos.log10$labeled <- NA
genes <- as.character(c("GR", "MBNL1", "BRD4", "PIK3CD"))
cagek.rhos.log10$labeled[cagek.rhos.log10$Symbol %in% c("NR3C1", "MBNL1", "PIK3CD", "BRD4")] <- genes
```

Then I will use this label column to redo the plot with these labels applied:

```
labeled_plot <- ggplot(data = cagek.rhos.log10, aes(x = `Rho Phenotype`, y = `log10.p`, col=sigRho, label=labeled)) +
  geom_point() +
  geom_text_repel() +
  ylim(0, 16) +
  labs(
    x = "Dexamethasone effect",
    y = "-log10(p-value)"
  ) + scale_color_manual(values = pt_color)
```

The labels appear to be in the correct locations, but they don't appear as nicely as they are in the original figure. I will save this draft for now and work on adjusting these labels later:

```
ggsave(filename = "output/color_label_volcano.png", plot = labeled_plot, width = 6, height = 4, dpi = 300, units = "in")
```

## Changing background theme

In the next step, I will make two changes using themes. First, I will change the background to white with `theme_bw()`. To remove the grid marks, I will use two additional themes, `panel.grid.major` and `panel.grid.minor` and set these to white. Then, I will change the position of the legend to be at the top middle of the plot as in the original figure. I will also remove the title from the legend by changing the labs to include `color = NULL`. 

```
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
```

I will save this plot as well, with the only remaining step to see if I can adjust the labels of 4 key genes more (particularly PIK3CD) so that it doesn't overlap with other data points. 

```
ggsave(filename = "output/plot_labeled_legend_bg.png", plot = plot_labeled_legend_bg, width = 6, height = 4, dpi = 300, units = "in")
```

## Adjusting key gene label positioning

To adjust the overlap of the 4 key gene labels, I was mainly concerned about moving PIK3CD so that it was not on top of other data points. So, I used the `nudge_x` and `nudge_y` arguments along with two `ifelse` statements to only move the PIK3CD label differently and treating the other 3 labels the same.

I also added a final line to this script to make the points in the figure legend bigger (and get rid of the letter which was overlying the points) with the `guides` function. 

```{r move_PIK3CD_label}
ggplot(data = cagek.rhos.log10, aes(x = `Rho Phenotype`, y = `log10.p`, col=sigRho, label=labeled)) +
  geom_point() +
  geom_text_repel(nudge_x = ifelse(cagek.rhos.log10$labeled == "PIK3CD", -0.5, 0), nudge_y = ifelse(cagek.rhos.log10$labeled == "PIK3CD", 0.75, 0.6)) +
  ylim(0, 16) +
  labs(
    x = "Dexamethasone effect",
    y = "-log10(p-value)",
    color = NULL
  ) + scale_color_manual(values = pt_color) +
  theme_bw() +
  theme(panel.grid.major = element_line(color = "white")) +
  theme(panel.grid.minor = element_line(color = "white")) +
  theme(legend.position = c(0.5, 0.85)) +
  guides(color = guide_legend(override.aes = list(size = 3)))
```

## Changing key gene point size

The last step is to increase the size of the points for the 4 key genes. To do this, I used another `ifelse` statement inside `geom_point` to only increase the size of the genes I had defined earlier and leave all others the same size. 

```{r increase_key_gene_size}
final_plot <- ggplot(data = cagek.rhos.log10, aes(x = `Rho Phenotype`, y = `log10.p`, col=sigRho, label=labeled)) +
  geom_point(size = ifelse(cagek.rhos.log10$labeled %in% genes, 5, 1)) +
  geom_text_repel(nudge_x = ifelse(cagek.rhos.log10$labeled == "PIK3CD", -0.5, 0), nudge_y = ifelse(cagek.rhos.log10$labeled == "PIK3CD", 0.75, 0.6)) +
  ylim(0, 16) +
  labs(
    x = "Dexamethasone effect",
    y = "-log10(p-value)",
    color = NULL
  ) + scale_color_manual(values = pt_color) +
  theme_bw() +
  theme(panel.grid.major = element_line(color = "white")) +
  theme(panel.grid.minor = element_line(color = "white")) +
  theme(legend.position = c(0.5, 0.85)) +
  guides(color = guide_legend(override.aes = list(size = 3)))
```

I will save this as my final plot for the project:

```{r save_final_plot}
ggsave(filename = "output/final_plot.png", plot = final_plot, width = 6, height = 5, dpi = 300, units = "in")
```

## Remaining differences from the oritinal figure

There are only 2 differences from the original figure remaining. The x-axis label is just "Dexamethasone Sensitivity" and not an arrow, and some of the labels for the key genes are in slightly different locations relative to the points. These are both changes which could easily be made using Adobe Illustrator, so I did not attempt to do these using R. 
