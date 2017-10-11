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
redash_url <- "http://localhost"

drv <- Redash()
conn <- dbConnect(drv, base_url = redash_url, api_key = api_key, data_source_name = "pg")
dbi_res <- dbSendQuery(conn, "Select * from iris limit 10;")

dbFetch(dbi_res)
```

Or, you can use this via dplyr (SQL translation is not implemented yet):

``` r
library(dbplyr)
library(dplyr)

redash_iris <- tbl(conn, "iris")
redash_iris %>% 
  select(sepallength, petallength, name) %>%
  filter(name == "Iris-setosa") %>%
  collect()
```
