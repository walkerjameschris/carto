#### Setup ####

library(yaml)
library(tidyverse)

source(here::here("src/functions.R"))

dials <-
  yaml::read_yaml(
    here::here("src/dials.yaml")
  )

#### Load Data ####

dials |>
  purrr::iwalk(function(spec, name) {

    file_name <- glue::glue("data/{name}.Rds")

    cli::cli_alert_success("Generating {spec$forma}")

    data <-
      readr::read_rds(
        here::here(file_name)
      ) |>
      transform_data(
        spec = spec
      )

    plot <-
      generate_map(
        data = data,
        spec = spec
      )
   
    save_map(
      plot = plot,
      spec = spec,
      country = name
    )
  })
