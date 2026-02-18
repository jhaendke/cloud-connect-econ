# Clean workspace
rm(list = ls())

# ----------------------- #

# Make relative paths work in R

  # Get directory of current script
  current_file <- rstudioapi::getActiveDocumentContext()$path
  current_dir <- dirname(current_file)

  # Set working directory to the script's location
  setwd(current_dir)

  # Verify
  getwd()

# ----------------------- #

# Municipalities [Statistisches Bundesamt (2025)]

# Load data (2059 rows, 14 cols)
library(tidyverse)
library(readxl)

df_mun <- read_xlsx('../data/processed/municipalities.xlsx', col_names = TRUE) |>
  filter(!is.na(id), id != "") # exclude NAs in id

# Set data types
df_mun <- df_mun |>
  mutate(
    id = as.integer(id),
    mun_key = as.character(mun_key),
    mun_name = as.character(mun_name),
    mun_name_short = as.character(mun_name_short),
    mun_zip = as.character(mun_zip),
    mun_pop_cen22 = as.integer(mun_pop_cen22),
    mun_pop_cen22m = as.integer(mun_pop_cen22m),
    mun_pop_cen22f = as.integer(mun_pop_cen22f),
    mun_dens_cen22 = as.integer(mun_dens_cen22),
    mun_sizekm2 = as.numeric(mun_sizekm2),
    state = as.character(state),
    lat = as.numeric(lat),
    lon = as.numeric(lon),
    geo = as.character(geo)
  )

# Save to csv (utf-8)
write_csv(df_mun, '../data/processed/municipalities.csv')