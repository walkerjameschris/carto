
pull_bounds <- function(spec) {
  # Loads boundaries from service

  depth <- length(spec$formal) - 1

  boundaries <-
    rgeoboundaries::geoboundaries(
      country = head(spec$formal, 1),
      adm_lvl = glue::glue("adm{depth}")
    )

  if (depth == 0) {
    return(boundaries)
  }

  boundaries |>
    dplyr::filter(
      shapeName == tail(spec$formal, 1)
    )
}

transform_data <- function(
  data,
  spec,
  x = x,
  y = y,
  tolerance = 0.02,
  elevation = elevation
) {
  # Assigns groups based on stop tolerance for
  # contiguious terrain paths and shocks elevation

  data |>
    dplyr::reframe(
      x = {{ x }},
      y = {{ y }},
      elevation = {{ elevation }}
    ) |>
    dplyr::group_by(y) |>
    dplyr::arrange(x) |>
    dplyr::mutate(
      group = x - dplyr::coalesce(dplyr::lag(x), x),
      group = cumsum(group > .env$tolerance),
      group = glue::glue("{group}-{y}"),
      y = y + elevation / spec$shock
    ) |>
    dplyr::ungroup()
}

generate_map <- function(
  data,
  spec,
  x = x,
  y = y,
  group = group
) {
  # Workhorse mapping function to generate
  # asthentic terrain maps

  data |>
    ggplot2::ggplot(
      ggplot2::aes(
        x = {{ x }},
        y = {{ y }},
        group = {{ group }}
      )
    ) +
    ggplot2::geom_line(
      color = spec$terrain,
      linewidth = spec$linewidth
    ) +
    ggplot2::theme_minimal() +
    ggplot2::theme(
      plot.background = ggplot2::element_rect(fill = spec$background),
      panel.background = ggplot2::element_blank(),
      panel.grid = ggplot2::element_blank(),
      axis.title = ggplot2::element_blank(),
      axis.ticks = ggplot2::element_blank(),
      axis.text = ggplot2::element_blank(),
      plot.caption = ggplot2::element_text(
        family = "Helvetica",
        color = spec$terrain,
        face = "bold",
        size = 15
      )
    ) +
    ggplot2::labs(
      caption = tail(spec$formal, 1)
    )
}

save_map <- function(
  plot,
  spec,
  country,
  base = 5,
  dpi = 500
) {
  # Saves a map with defaults

  file_path <- glue::glue("img/{country}.png")

  ggplot2::ggsave(
    filename = here::here(file_path),
    width = spec$aspect * base,
    height = base,
    plot = plot,
    dpi = dpi
  )
}
