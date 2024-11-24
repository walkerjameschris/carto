#### Setup ####

library(sp)
library(yaml)
library(raster)
library(elevatr)
library(tidyverse)
library(rgeoboundaries)

source(here::here("src/functions.R"))

dials <-
  yaml::read_yaml(
    here::here("src/dials.yaml")
  )

#### Load Data ####

dials |>
  purrr::iwalk(function(spec, name) {
    
    file_name <- glue::glue("data/{name}.Rds")
    boundaries <- pull_bounds(spec)

    data <-
      elevatr::get_elev_raster(
        locations = boundaries,
        clip = "locations",
        z = spec$zoom
      ) |>
      raster::as.data.frame(
        xy = TRUE
      )
    
    data |>
      purrr::set_names(
        nm = c("x", "y", "elevation")
      ) |>
      tibble::as_tibble() |>
      dplyr::distinct(
        x = round(x, 2),
        y = round(y / spec$round) * spec$round,
        .keep_all = TRUE
      ) |>
      tidyr::drop_na() |>
      readr::write_rds(
        here::here(file_name),
        compress = "xz"
      )
  }, .progress = TRUE)
