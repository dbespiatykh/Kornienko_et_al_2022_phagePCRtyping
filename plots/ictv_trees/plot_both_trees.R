# Load the required packages ========================================
library(cowplot)
library(ggplotify)
library(here)

set.seed(1984)

# Source Trees ======================================================
source("kb_tree.R")
source("st_tree.R")

# Extract legends ===================================================
kb_legend <- get_legend(
  kb_tree + theme(
    legend.position = "bottom",
    legend.justification = "center",
    legend.box = "vertical",
    legend.box.just = "left",
    legend.box.margin = margin(0, 0, 0, 0),
    legend.title = element_text(size = 6),
    legend.text = element_text(size = 6),
    legend.margin = margin()
  )
)

st_legend <- get_legend(
  st_tree + theme(
    legend.position = "bottom",
    legend.justification = "center",
    legend.box = "horizontal",
    # legend.box.just = "left",
    legend.box.margin = margin(0, 0, 0, 0),
    legend.title = element_text(size = 6),
    legend.text = element_text(size = 6),
    legend.margin = margin(),
  )
)

# Scale trees =======================================================
kb_scaled <- as.ggplot(kb_tree, scale = 1.1)
st_scaled <- as.ggplot(st_tree, scale = 1.1)

# Plot Trees In Grid ================================================
trees_grid <- plot_grid(
  st_scaled,
  kb_scaled,
  nrow = 1,
  labels = c('A', 'B'),
  label_size = 12,
  hjust = -1,
  vjust = 3,
  align = 'vh'
)

# Plot Legends In Grid ==============================================
legends_grid <-
  plot_grid(st_legend, kb_legend, align = 'h', axis = 't')

# Combine Trees and Legends =========================================
plot_grid(trees_grid,
          legends_grid,
          rel_heights = c(3, 2),
          nrow = 2)

# Save Figure =======================================================
ggsave(
  "trees.pdf",
  width = 183,
  height = 170,
  units = "mm",
  limitsize = FALSE,
  device = cairo_pdf
)

