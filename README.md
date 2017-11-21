# farsdata

[![Travis-CI Build Status](https://travis-ci.org/einabadi-sh/farsdata.svg?branch=master)](https://travis-ci.org/einabadi-sh/farsdata) [![AppVeyor Build Status](https://ci.appveyor.com/api/projects/status/github/einabadi-sh/farsdata?branch=master&svg=true)](https://ci.appveyor.com/project/einabadi-sh/farsdata)


This package is designed to create some simple reports and graphs for the FARS data. The FARS data from the US National Highway Traffic Safety Administration's Fatality Analysis Reporting System, which is a nationwide census providing the American public yearly data regarding fatal injuries suffered in motor vehicle traffic crashes.

## Installation

You can install farsdata from github with:


``` r
# install.packages("devtools")
devtools::install_github("einabadi-sh/farsdata")
```

## Example

This is a basic example which shows you how to solve a common problem:

``` {r , echo = FALSE}
## basic example code
file <- system.file("extdata", "accident_2013.csv.bz2", package = "farsdata")
fars_read(file)
```
