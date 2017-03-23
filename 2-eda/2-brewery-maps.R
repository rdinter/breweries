
library(albersusa)
library(scales)
library(sp)
library(tidyverse)
library(viridis)

prec_86 <- read_rds("1-tidy/beer_prec.rds")

# Create a directory for the data
local_dir    <- "2-eda/maps"
if (!file.exists(local_dir)) dir.create(local_dir)

# ---- Explore ------------------------------------------------------------

cty <- counties_composite("aeqd")

states <- usa_composite("aeqd") %>% 
  fortify()

cty <- sp::merge(cty, prec_86, all.x = T)

gg_base <- fortify(cty, region = "fips") %>%
  mutate(fips = as.numeric(id))

# Add in aggregated data ...
gg_base <- right_join(prec_86, gg_base)

ggplot(gg_base, aes(long, lat, group = group)) +
  geom_polygon(aes(fill = prec_mean_86), color = NA) +
  geom_path(data = states) +
  labs(title = "Average Annual Precepitation", 
       subtitle = "from 1950 to 1986") +
  scale_fill_viridis(na.value = NA) +
  theme(panel.background = element_blank(), # remove various background facets
        panel.grid = element_blank(),
        axis.line = element_blank(),
        axis.title = element_blank(),
        axis.ticks = element_blank(),
        axis.text = element_blank(),
        legend.position = "bottom", # move the legend
        legend.title = element_blank(), #remove the legend's title
        legend.key.width = unit(2, "cm"),
        legend.text = element_text(size = 14),
        plot.title = element_text(size = 20),
        plot.subtitle = element_text(size = 14))
ggsave(paste0(local_dir, "/prec86.png"), width = 10, height = 7.5)

ggplot(gg_base, aes(long, lat, group = group)) +
  geom_polygon(aes(fill = est_1986), color = NA) +
  geom_path(data = states) +
  labs(title = "Breweries in 1986") +
  scale_fill_viridis(limits = c(0, 5), oob = squish, na.value = NA) +
  theme(panel.background = element_blank(), # remove various background facets
        panel.grid = element_blank(),
        axis.line = element_blank(),
        axis.title = element_blank(),
        axis.ticks = element_blank(),
        axis.text = element_blank(),
        legend.position = "bottom", # move the legend
        legend.title = element_blank(), #remove the legend's title
        legend.key.width = unit(2, "cm"),
        legend.text = element_text(size = 14),
        plot.title = element_text(size = 20),
        plot.subtitle = element_text(size = 14))
ggsave(paste0(local_dir, "/brew_86.png"), width = 10, height = 7.5)

ggplot(gg_base, aes(long, lat, group = group)) +
  geom_polygon(aes(fill = est_1995), color = NA) +
  geom_path(data = states) +
  labs(title = "Breweries in 1995") +
  scale_fill_viridis(limits = c(0, 5), oob = squish, na.value = NA) +
  theme(panel.background = element_blank(), # remove various background facets
        panel.grid = element_blank(),
        axis.line = element_blank(),
        axis.title = element_blank(),
        axis.ticks = element_blank(),
        axis.text = element_blank(),
        legend.position = "bottom", # move the legend
        legend.title = element_blank(), #remove the legend's title
        legend.key.width = unit(2, "cm"),
        legend.text = element_text(size = 14),
        plot.title = element_text(size = 20),
        plot.subtitle = element_text(size = 14))
ggsave(paste0(local_dir, "/brew_95.png"), width = 10, height = 7.5)

ggplot(gg_base, aes(long, lat, group = group)) +
  geom_polygon(aes(fill = est_2005), color = NA) +
  geom_path(data = states) +
  labs(title = "Breweries in 2005") +
  scale_fill_viridis(limits = c(0, 5), oob = squish, na.value = NA) +
  theme(panel.background = element_blank(), # remove various background facets
        panel.grid = element_blank(),
        axis.line = element_blank(),
        axis.title = element_blank(),
        axis.ticks = element_blank(),
        axis.text = element_blank(),
        legend.position = "bottom", # move the legend
        legend.title = element_blank(), #remove the legend's title
        legend.key.width = unit(2, "cm"),
        legend.text = element_text(size = 14),
        plot.title = element_text(size = 20),
        plot.subtitle = element_text(size = 14))
ggsave(paste0(local_dir, "/brew_05.png"), width = 10, height = 7.5)

ggplot(gg_base, aes(long, lat, group = group)) +
  geom_polygon(aes(fill = est_2014), color = NA) +
  geom_path(data = states) +
  labs(title = "Breweries in 2014") +
  scale_fill_viridis(limits = c(0, 5), oob = squish, na.value = NA) +
  theme(panel.background = element_blank(), # remove various background facets
        panel.grid = element_blank(),
        axis.line = element_blank(),
        axis.title = element_blank(),
        axis.ticks = element_blank(),
        axis.text = element_blank(),
        legend.position = "bottom", # move the legend
        legend.title = element_blank(), #remove the legend's title
        legend.key.width = unit(2, "cm"),
        legend.text = element_text(size = 14),
        plot.title = element_text(size = 20),
        plot.subtitle = element_text(size = 14))
ggsave(paste0(local_dir, "/brew_14.png"), width = 10, height = 7.5)

# ---- Growth Model -------------------------------------------------------

summary(goetz <- lm((est_2005 - est_1986)/(est_1986+0.01) ~ prec_mean_86, prec_86))
