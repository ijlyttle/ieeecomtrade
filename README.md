
<!-- README.md is generated from README.Rmd. Please edit that file -->
ieeecomtrade
============

This is a package to help you work with IEEE COMTRADE files. Currently, this package is restricted to:

-   COMTRADE 1999 format
-   considers only configuration and data files
-   data files must be ASCII

In time, it is hoped to lift these restrictions, particularly as the need may present itself.

Installation
------------

This package is not yet on CRAN. However, you can install it from GitHub:

``` r
# install.packages("devtools")
install_github("ijlyttle/ieeecomtrade")
```

Usage
-----

The central object in this package is a **comtrade** object. You can build a comtrade object by reading in the configuration and data files, or you can read a zip file that contains exactly one configuration file and exactly one data file.

Let's look at reading in some sample files provided with this package. As a first example, let's build a comtrade object by reading the configuration file and data file individually.

``` r
library("ieeecomtrade")

config <- 
  ct_example("keating_1999.CFG") %>%  # returns a file path
  ct_read_config()                    # returns a configuration object

data <- 
  ct_example("keating_1999.DAT") %>%
  ct_read_data_config(config)
  
keating <- comtrade(config = config, data = data)  
```

Similarly, you can read from a zip file

``` r
keating <- 
  ct_example("keating_1999.zip") %>%
  ct_read_zip()
```

If you want a data frame with scaled values and a timestamp:

``` r
ct_instant(keating)
#> # A tibble: 2,048 x 9
#>         instant         I1       I2        I3           I4        V1
#>           <dbl>      <dbl>    <dbl>     <dbl>        <dbl>     <dbl>
#>  1 0.000000e+00  -5.671533 175.6419 -177.0687 1.100606e+00 -208.3977
#>  2 3.256561e-05  -7.252448 175.8001 -174.1653 8.254547e-01 -215.3405
#>  3 6.513121e-05  -9.742390 174.7522 -171.7754 1.705303e-13 -221.8280
#>  4 9.769682e-05 -12.014955 174.7918 -169.2670 1.375758e+00 -226.4944
#>  5 1.302624e-04 -14.247998 174.6336 -167.0154 1.650909e+00 -230.1366
#>  6 1.628280e-04 -16.322949 174.3766 -165.6525 5.503031e-01 -235.4859
#>  7 1.953936e-04 -18.516469 174.2580 -163.7169 5.503031e-01 -241.6320
#>  8 2.279592e-04 -21.085456 174.4161 -161.3468 2.751516e-01 -248.5748
#>  9 2.605248e-04 -22.903508 173.9021 -159.8062 1.705303e-13 -254.1518
#> 10 2.930904e-04 -24.780845 174.0405 -158.6014 1.375758e+00 -258.1354
#> # ... with 2,038 more rows, and 3 more variables: V2 <dbl>, V3 <dbl>,
#> #   V4 <dbl>
```

Code of Conduct
---------------

Please note that this project is released with a [Contributor Code of Conduct](CONDUCT.md). By participating in this project you agree to abide by its terms.
