# carto

## Introduction

My digital map making workflow for topographic maps. This
repo works by pulling public terrain data and rendering it
as `ggplot` graphics using a specification described in 
`src/manifest.yaml`

> [!WARNING]
> `rgeoboundaries` is no longer on CRAN. If you try to run
> this codebase, you may need to install it from GitHub.

<img src="https://raw.githubusercontent.com/walkerjameschris/carto/refs/heads/main/img/switzerland.png" height="300" />

## Contents

* `analysis/`: Core components of the analysis
* `data/`: Elevation data as `Rds` files
* `img/`: Final maps as images
* `src/`: Functions and source files
