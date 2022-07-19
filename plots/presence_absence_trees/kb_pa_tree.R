# Load the required packages ========================================
suppressPackageStartupMessages({
  library(ggtree)
  library(ggtreeExtra)
  library(ggplot2)
  library(ggnewscale)
  library(ggsci)
  library(qualpalr)
  library(ggstar)
  library(here)
  library(ggplotify)
  library(cowplot)
  library(phylotools)
  library(phytools)
})

set.seed(1984)
options(ignore.negative.edge = TRUE)

# Load Tree  ========================================================
tree <- read.tree("kb_binary_presence_absence.nwk")

# Rename Tip Labels =================================================
names <- read.table(
  "kb_names.csv",
  sep = ",",
  header = FALSE,
  check.names = FALSE
)

tree <- sub.taxa.label(tree, names)
tree <- midpoint.root(tree)

# Load Annotations ==================================================
family <- read.table(
  "kb_family.txt",
  sep = "\t",
  header = TRUE,
  check.names = FALSE
)

subfamily <- read.table(
  "kb_subfamily.txt",
  sep = "\t",
  header = TRUE,
  check.names = FALSE
)

genus <- read.table(
  "kb_genus.txt",
  sep = "\t",
  header = TRUE,
  check.names = FALSE
)

ictv <- read.table(
  "kb_ictv.txt",
  sep = "\t",
  header = TRUE,
  check.names = FALSE
)

# Get Palette =======================================================
pal = qualpal(length(unique(genus$genus)), "pretty")

# Basic Tree ========================================================
kb_tree <- ggtree(tree,
                  lwd = .1,
                  layout = "fan",
                  open.angle = 10) +
  ## Tip Labels -----------------------------------------------------
geom_tiplab(
  size = .7,
  align = TRUE,
  linesize = .005,
  line.color = "#333333",
  offset = .005,
  color = "#333333"
) +
  ## Tree axis limits -----------------------------------------------
xlim(-.001, NA) +
  ## Tree Scale -----------------------------------------------------
geom_treescale(
  x = .001,
  y = 0,
  fontsize = 2,
  linesize = .5,
  width = .005,
) +
  ## Annotations ----------------------------------------------------
### ICTV ------------------------------------------------------------
new_scale_fill() +
  geom_fruit(
    data = ictv,
    geom = geom_star,
    mapping = aes(y = taxa,
                  fill = ictv),
    position = "identity",
    size = .4,
    starstroke = .1,
    starshape = 15,
    pwidth = 0.05,
    inherit.aes = FALSE
  ) +
  scale_fill_manual(
    values = c("#003680"),
    labels = c("ictv" = "ICTV"),
    name = "(1) Taxonomy source",
    guide = guide_legend(
      direction = "horizontal",
      title.position = "top",
      keywidth = .5,
      keyheight = .5,
      order = 1,
      ncol = 1,
      byrow = FALSE,
      override.aes = list
      (
        starshape = 15,
        color = "black",
        size = 3
      )
    ),
    na.translate = FALSE
  ) +
  ### Family --------------------------------------------------------
new_scale_fill() +
  geom_fruit(
    data = family,
    geom = geom_tile,
    mapping = aes(y = taxa,
                  x = 1,
                  fill = family),
    offset = 0.05,
    size = 0,
    pwidth = 0.08,
    width = 0.003
  ) +
  scale_fill_jco(
    name = "(2) Family",
    guide = guide_legend(
      direction = "horizontal",
      title.position = "top",
      label.theme = element_text(size = 6,
                                 face = "italic"),
      keywidth = .5,
      keyheight = .5,
      order = 2,
      ncol = 1,
      byrow = FALSE,
      override.aes = list
      (
        starshape = 13,
        color = "black",
        size = .1
      )
    ),
    na.translate = FALSE
  ) +
  ### Subfamily -----------------------------------------------------
new_scale_fill() +
  new_scale_fill() +
  geom_fruit(
    data = subfamily,
    geom = geom_tile,
    mapping = aes(y = taxa,
                  x = 1,
                  fill = subfamily),
    size = 0,
    pwidth = 0.005,
    width = 0.003
  ) +
  scale_fill_nejm(
    name = "(3) Subfamily",
    guide = guide_legend(
      direction = "horizontal",
      title.position = "top",
      label.theme = element_text(size = 6,
                                 face = "italic"),
      keywidth = .5,
      keyheight = .5,
      order = 3,
      ncol = 1,
      byrow = FALSE,
      override.aes = list
      (
        starshape = 21,
        color = "black",
        size = .1
      )
    ),
    na.translate = FALSE
  ) +
  ### Genus ---------------------------------------------------------
new_scale_fill() +
  geom_fruit(
    data = genus,
    geom = geom_tile,
    mapping = aes(y = taxa,
                  x = 1,
                  fill = genus),
    size = 0,
    pwidth = 0.005,
    width = 0.003
  ) +
  scale_fill_manual(
    values = pal$hex,
    name = "(4) Genus",
    guide = guide_legend(
      direction = "horizontal",
      title.position = "top",
      label.theme = element_text(size = 6,
                                 face = "italic"),
      keywidth = .5,
      keyheight = .5,
      order = 4,
      ncol = 1,
      byrow = FALSE,
      override.aes = list
      (
        starshape = 23,
        color = "black",
        size = .1
      )
    ),
    na.translate = FALSE
  ) +
  ## Theme ==========================================================
theme(legend.position = "none",
      plot.margin = unit(c(0, 0, 0, 0), "cm"))

# Extract legend ====================================================
legend <- get_legend(
  kb_tree + theme(
    legend.position = "left",
    legend.justification = "left",
    legend.box = "vertical",
    legend.box.just = "left",
    legend.box.margin = margin(0, 0, 0, 0),
    legend.title = element_text(size = 6),
    legend.text = element_text(size = 6),
    legend.margin = margin()
  )
)

# Scale tree ========================================================
kb_scaled <- as.ggplot(kb_tree, scale = 1.1)

# Plot Tree Into a Grid =============================================
plot_grid(legend,
          kb_scaled,
          nrow = 1,
          rel_widths = c(.2, 1.3))

# Save Figure =======================================================
ggsave(
  "kb_pa_tree.pdf",
  width = 183,
  height = 170,
  units = "mm",
  limitsize = FALSE,
  device = cairo_pdf
)

