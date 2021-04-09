# Suppression of B-cell development genes is key to glucocorticoid efficacy in treatment of acute lymphoblastic leukemia

## Reference

Karina A. Kruth, Mimi Fang, Dawne N. Shelton, Ossama Abu-Halawa, Ryan Mahling, Hongxing Yang, Jonathan S. Weissman, Mignon L. Loh, Markus Müschen, Sarah K. Tasian, Michael C. Bassik, Martin Kampmann, Miles A. Pufall; Suppression of B-cell development genes is key to glucocorticoid efficacy in treatment of acute lymphoblastic leukemia. Blood 2017; 129 (22): 3000–3008. doi: https://doi.org/10.1182/blood-2017-02-766204

## Introduction

B-cell acute lymphoblastic leukemia (B-ALL) is the most common childhood cancer, and glucocorticoids are a key component of chemotherapy regimens for B-ALL. Patients with B-ALL who have a poor response to glucocorticoids have poorer outcomes. Additionally, glucocorticoids are used at high doses which lead to many off target toxicities. Glucocorticoids work through the glucocorticoid receptor, which is a ligand activated transcription factor that regulates genes leading to B-ALL cell death. The specific genes and pathways which lead to glucocorticoid resistance are not entirely known. A systematic, genome-wide short hairpin RNA (shRNA) screen was performed by Kruth et al, which knocked down one gene per cell and allowed quantification of the effect of each gene on glucocorticoid sensitivity. This process identified hundreds of genes which contribute to glucocorticoid-induced cell death. Many of the genes which increase glucocorticoid-induced cell death fall in the B-cell receptor pathway, including PIK3CD. 

## Figure to Reproduce

I plan to reproduce figure 2B from the Kruth et al. paper: 

![Kruth et al. Figure 2B shows volcano plot of the effect of shRNA gene knockdown on dex sensitivity. Each point is a gene with the log significance on the y-axis, with relative effect (phenotype) on dex-induced cell death on the x-axis. GR is the most protective when knocked down, and knockdown of PIK3CD makes NALM-6 cell more sensitive. Top hits (Mann-Whitney, P <= .05) are green for sensitizing, purple for protective, and gray for P greater than 0.05.](./figure2.jpeg)

In this figure, the x-axis represents the phenotype of gene knock down on dexamethasone sensitivity (aka Rho phenotype). A Rho phenotype of 0 would indicate that the gene knock down has no effect on dexamethasone sensitivity. More negative Rho phenotypes (to the left on the figure) indicate increasing sensitivity to dexamethasone with gene knock down, and more positive Rho phenotypes (to the right on the figure) indicate increasing resistance to dexamethasone with gene knock down.

## Materials and Methods
### Data Source
The data for this figure was produced after infecting B-ALL cells with shRNAs against genes associated with cancer, apoptosis, gene expression, and kinases, with one gene knocked down per cell. Infected cells were then subjected to dexamethasone treatment or vehicle control treatment. At the end of treatment, the shRNAs are sequenced and the frequency of each individual shRNA is compared between cell types. First, the shRNA frequencies in the growth control cells are compared to the shRNA frequencies in infected cells which were cryopreserved at the beginning of the treatment period to determine the growth phenotype. Then the shRNA frequencies in the dexamethasone treated cells are compared to the shRNA frequencies in the growth control cells, with the growth phenotype removed to determine the dexamethasone sensitivity (Rho phenotype). P values for the Rho phenotype are calculated by both the Mann-Whitney U test and K-S test, but the P values in figure 2B are the Mann-Whitney P values. The P values were previously computed using Python scripts available from <https://kampmannlab.ucsf.edu/resources> (GImap in the Bioinformatics section). These phenotypes and P values are available from the electronic version of the article in xslx format (Document 3 of supplemental data) at <https://ashpublications.org/blood/article/129/22/3000/36066/Suppression-of-B-cell-development-genes-is-key-to?searchresult=1>. 

### RStudio Set Up
I am using RStudio on the FastX environment for easy connection to my GitHub repository. Before starting to re-create the figure, I installed `tidyverse`, which includes the `ggplot2` package, along with the `readxl` and `knitr` packages. 

I uploaded the xslx file into the RStudio environment after downloading to my project data folder (downloaded on 2/23/2021 as described above) and viewed the table to ensure that the correct data was populated, specifically Rho phenotype (the effect on dexamethasone sensitivity) and Rho P value (the previously calculated p values for the phenotype for each gene knock down using Mann-Whitney U test). 

### Modifying the Data Prior to Plotting
In order to plot the data as it appears in the figure, I used the `mutate` function to change the Rho p-values to the -log10(p-value). I then created a new dataframe with this new variable added. The Rho phenotypes do not require modification prior to plotting.

## Results
### Initial Draft of the Volcano Plot
Using the `ggplot2` package, I created a scatterplot using `geom_point` with the Rho phenotype on the x-axis and the -log10(p-value) on the y-axis. I modified the y-axis limits and the y-axis label to match the original figure. I also created a temporary x-axis label of "Dexamethasone sensitivity", which I will modify later to match the original figure. The first draft of this plot is shown below.

![Initial Draft Volcano Plot](./output/initial_volcano.png)

### Next Steps in Figure Modification
Now that the initial plot is made, I will next set thresholds for significant phenotypes, which would be equivalent to p value <=0.05. I will then change the colors of the points to indicate genes which significantly increase dexamethasone sensitivity when knocked down (green, Rho phenotype <0) and genes which significantly increase dexamethasone resistance when knocked down (purple, Rho phenotype >0). I can then attempt to label the same significant genes as shown in the figure with names (GR, BRD4, PIK3CD, and MBNL1) and add the key to the figure.   
 
## Discussion
Since going through the RStudio workshops in the past couple of weeks, I have made good progress in recreating the figure. I now have an initial draft of a plot which appears consistent with the orginal figure but in black and white. I also have a better understanding of aesthetics in R, so it will likely be easier for me moving forward in the further modifications which are needed to fully reproduce the figure. I continue to refer to webinars and the RStudio cheatsheets available at <https://rstudio.com> for additional help, along with using Google to help find answers to remaining questions about syntax. 

In terms of the reproducibility of this figure, it does appear to be fairly straightforward to use the provided phenotypes and p-values to re-create the volcano plot. However, if I had wanted to start with the original shRNA reads and calculate the p-values myself, I would not have been able to do so with the data available. I am currently performing a similar shRNA screen of my own, so in the future I will be able to perform this part of the analysis on my own data using the python scripts from the Kampmann lab. 
