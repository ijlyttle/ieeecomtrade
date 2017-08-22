
``` r
library("ieeecomtrade")
library("devtools")
```

This is to document how the `keating_1999` comtrade object is constructed and put into the package's data.

First, let's create the constituent elements:

``` r
config <- ct_example("keating_1999.CFG") %>% ct_read_config()
data <- ct_example("keating_1999.DAT") %>% ct_read_data_config(config)
```

Next, construct the comtrade object:

``` r
keating_1999 <- comtrade(config = config, data = data)

print(keating_1999)
```

    ## $config
    ## $config$station_name
    ## [1] "4_Victoria_Keating.main_7650"
    ## 
    ## $config$rec_dev_id
    ## [1] "4_Victoria_Keating.main_7650"
    ## 
    ## $config$rev_year
    ## [1] 1999
    ## Levels: 1991 1999 2013
    ## 
    ## $config$TT
    ## [1] 8
    ## 
    ## $config$`##A`
    ## [1] 8
    ## 
    ## $config$`##D`
    ## [1] 0
    ## 
    ## $config$analog_channel
    ## # A tibble: 8 x 13
    ##      An ch_id    ph                         ccbm     uu           a
    ##   <int> <chr> <chr>                        <chr>  <chr>       <dbl>
    ## 1     1    I1    I1 4_Victoria_Keating.main_7650 ampere -0.01976144
    ## 2     2    I2    I2 4_Victoria_Keating.main_7650 ampere -0.01977059
    ## 3     3    I3    I3 4_Victoria_Keating.main_7650 ampere -0.01975111
    ## 4     4    I4    I4 4_Victoria_Keating.main_7650 ampere -0.27515155
    ## 5     5    U1    V1 4_Victoria_Keating.main_7650   volt -0.11381631
    ## 6     6    U2    V2 4_Victoria_Keating.main_7650   volt -0.11388410
    ## 7     7    U3    V3 4_Victoria_Keating.main_7650   volt -0.11343370
    ## 8     8    U4    V4 4_Victoria_Keating.main_7650   volt -0.03804154
    ## # ... with 7 more variables: b <dbl>, skew <dbl>, min <int>, max <int>,
    ## #   primary <dbl>, secondary <dbl>, PS <fctr>
    ## 
    ## $config$lf
    ## [1] 60
    ## 
    ## $config$nrates
    ## [1] 1
    ## 
    ## $config$sampling_rate
    ## # A tibble: 1 x 2
    ##       samp endsamp
    ##      <dbl>   <int>
    ## 1 30707.24    2048
    ## 
    ## $config$instant_first
    ## integer64
    ## [1] 1447824783765333000
    ## attr(,".S3Class")
    ## [1] integer64
    ## attr(,"class")
    ## [1] nanotime
    ## attr(,"class")attr(,"package")
    ## [1] nanotime
    ## 
    ## $config$instant_trigger
    ## integer64
    ## [1] 1447824783790289000
    ## attr(,".S3Class")
    ## [1] integer64
    ## attr(,"class")
    ## [1] nanotime
    ## attr(,"class")attr(,"package")
    ## [1] nanotime
    ## 
    ## $config$ft
    ## [1] ASCII
    ## Levels: ASCII BINARY
    ## 
    ## $config$timemult
    ## [1] 1
    ## 
    ## 
    ## $data
    ## # A tibble: 2,048 x 10
    ##        n timestamp a000001 a000002 a000003 a000004 a000005 a000006 a000007
    ##    <int>     <int>   <int>   <int>   <int>   <int>   <int>   <int>   <int>
    ##  1     1        NA    1571   -7576   10201   -1735    1905   -4321    2575
    ##  2     2        NA    1651   -7584   10054   -1734    1966   -4324    2507
    ##  3     3        NA    1777   -7531    9933   -1731    2023   -4339    2465
    ##  4     4        NA    1892   -7533    9806   -1736    2064   -4352    2429
    ##  5     5        NA    2005   -7525    9692   -1737    2096   -4349    2392
    ##  6     6        NA    2110   -7512    9623   -1733    2143   -4335    2333
    ##  7     7        NA    2221   -7506    9525   -1733    2197   -4329    2268
    ##  8     8        NA    2351   -7514    9405   -1732    2258   -4330    2201
    ##  9     9        NA    2443   -7488    9327   -1731    2307   -4326    2151
    ## 10    10        NA    2538   -7495    9266   -1736    2342   -4328    2109
    ## # ... with 2,038 more rows, and 1 more variables: a000008 <int>
    ## 
    ## $header
    ## NULL
    ## 
    ## $info
    ## NULL
    ## 
    ## attr(,"class")
    ## [1] "comtrade"

Finally, write to package-data:

``` r
use_data(keating_1999, overwrite = TRUE)
```

    ## Saving keating_1999 as keating_1999.rda to /Users/ijlyttle/Documents/git/github/PQ-Waveform/ieeecomtrade/data
