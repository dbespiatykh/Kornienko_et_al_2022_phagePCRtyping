# Load the required packages =================================
suppressPackageStartupMessages({
  library(ggtree)
  library(ggtreeExtra)
  library(ggplot2)
  library(ggnewscale)
  library(ggsci)
  library(qualpalr)
  library(ggstar)
  library(here)
})

set.seed(1984)
options(ignore.negative.edge = TRUE)

# Load Tree and Annotations =========================================
tree <- read.tree("staphylococcus_tree.newick")

family <- read.table(
  "st_family.txt",
  sep = "\t",
  header = TRUE,
  check.names = FALSE
)

subfamily <- read.table(
  "st_subfamily.txt",
  sep = "\t",
  header = TRUE,
  check.names = FALSE
)

genus <- read.table(
  "st_genus.txt",
  sep = "\t",
  header = TRUE,
  check.names = FALSE
)

# Get Palette =======================================================
pal = qualpal(length(unique(genus$genus)), "pretty")

# Basic Tree ========================================================
st_tree <- ggtree(tree,
                  lwd = .1,
                  layout = "fan",
                  open.angle = 10) +
  ## Tip Labels -----------------------------------------------------
geom_tiplab(
  size = 1.1,
  align = TRUE,
  linesize = .05,
  line.color = "#d3d3d3",
  offset = .005,
  color = "#333333"
) +
  ## Tree axis limits -----------------------------------------------
xlim(-.1, NA) +
  ## Tree Root ------------------------------------------------------
geom_rootedge(.05, lwd = .1, color = "#333333") +
  ## Tree Scale -----------------------------------------------------
geom_treescale(
  x = .2,
  y = 0,
  fontsize = 2,
  linesize = .5,
  width = .1,
) +
  ## Annotations ----------------------------------------------------
### Family ----------------------------------------------------------
new_scale_fill() +
  geom_fruit(
    data = family,
    geom = geom_star,
    mapping = aes(y = taxa,
                  x = 1,
                  fill = family),
    size = 1.5,
    starstroke = .1,
    starshape = 13,
    pwidth = 0.3,
    inherit.aes = FALSE
  ) +
  scale_fill_jco(
    name = "(1) Family",
    guide = guide_legend(
      direction = "horizontal",
      title.position = "top",
      label.theme = element_text(size = 6,
                                 face = "italic"),
      keywidth = .5,
      keyheight = .5,
      order = 1,
      nrow = 3,
      byrow = TRUE,
      override.aes = list
      (
        starshape = 13,
        color = "black",
        size = 2
      )
    ),
    na.translate = FALSE
  ) +
  ### Subfamily -----------------------------------------------------
new_scale_fill() +
  geom_fruit(
    data = subfamily,
    geom = geom_star,
    mapping = aes(y = taxa,
                  x = 1,
                  fill = subfamily),
    size = 1.5,
    starstroke = .1,
    starshape = 21,
    pwidth = 0.05,
    inherit.aes = FALSE
  ) +
  scale_fill_nejm(
    name = "(2) Subfamily",
    guide = guide_legend(
      direction = "horizontal",
      title.position = "top",
      label.theme = element_text(size = 6,
                                 face = "italic"),
      keywidth = .5,
      keyheight = .5,
      order = 2,
      nrow = 6,
      byrow = TRUE,
      override.aes = list
      (
        starshape = 21,
        color = "black",
        size = 2
      )
    ),
    na.translate = FALSE
  ) +
  ### Genus ---------------------------------------------------------
new_scale_fill() +
  geom_fruit(
    data = genus,
    geom = geom_star,
    mapping = aes(y = taxa,
                  x = 1,
                  fill = genus),
    size = 1.5,
    starstroke = .1,
    starshape = 23,
    pwidth = 0.05,
    inherit.aes = FALSE
  ) +
  scale_fill_manual(
    values = pal$hex,
    name = "(3) Genus",
    guide = guide_legend(
      direction = "horizontal",
      title.position = "top",
      label.theme = element_text(size = 6,
                                 face = "italic"),
      keywidth = .5,
      keyheight = .5,
      order = 3,
      ncol = 2,
      byrow = FALSE,
      override.aes = list
      (
        starshape = 23,
        color = "black",
        size = 2
      )
    ),
    na.translate = FALSE
  ) +
  ## Theme ==========================================================
theme(legend.position = "none",
      plot.margin = unit(c(0, 0, 0, 0), "cm"))
