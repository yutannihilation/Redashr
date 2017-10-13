# Redashr

[![CircleCI](https://circleci.com/gh/yutannihilation/Redashr.svg?style=svg)](https://circleci.com/gh/yutannihilation/Redashr)

## Installation

You can install Redashr from github with:


``` r
# install.packages("devtools")
devtools::install_github("yutannihilation/Redashr")
```

## Usage

``` r
library(Redashr)

api_key <- "xxxxxxxxxx"
redash_url <- "http://example.com/redash"

drv <- Redash()
conn <- dbConnect(drv, base_url = redash_url, api_key = api_key)
#> Warning: Using test as data source for now, but please provide
#> data_source_name.
#> Loading required package: RPostgreSQL
#> Loading required package: DBI

dbGetQuery(conn, "SELECT 1")
#> # A tibble: 1 x 1
#>   `?column?`
#>        <int>
#> 1          1
```

You can use dplyr as well.


```r
library(dplyr, warn.conflicts = FALSE)

copy_to(conn, iris)

redash_iris <- tbl(conn, "iris")
redash_iris %>% 
  select(Sepal.Length, Sepal.Width, Species) %>%
  group_by(Species) %>%
  summarise(x = sum(Sepal.Length))
#> # Source:   lazy query [?? x 2]
#> # Database: RedashConnection
#>      Species     x
#>        <chr> <dbl>
#> 1  virginica 329.4
#> 2     setosa 250.3
#> 3 versicolor 296.8
```
