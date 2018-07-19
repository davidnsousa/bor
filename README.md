[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.1317543.svg)](https://doi.org/10.5281/zenodo.1317543)

bor
===

Overview
--------

`bor` is an `R` package designed to transform focal observations' data, referring to the occurrence of social interactions, into asymmetric data matrices. Each matrix cell provides counts on the number of times a specific type of social interaction was initiated by the row subject and directed to the column subject.

Currently, the package includes three objects:

-   `dtable()` a function that transforms raw focal observations' data into a data frame more suitable for data analysis

-   `countb()` a function that computes asymmetric data matrices, separately for each observer and type of social interaction, from a data frame with a structure similar to that of the output of `dtable()` function

-   `ex_field_data` a data frame containing an example of raw focal observations' data; data frames passed to `dtable()` function should have this structure.

Read `bor` help file (`?bor`) to learn more about this package.

Installation
------------

``` r
# to install R packages from github you need the devtools package
# to install devtools from CRAN type:
install.packages("devtools")

# to install bor from github type:
devtools::install_github("davidnsousa/bor")
```

Details
-------

`ex_field_data` details the required structure of raw focal observations' data that can be passed to the `dtable()` function. Below we present the first lines of this data frame:

``` r
head(ex_field_data)
```

    ##   id1       act obs
    ## 1  s2         x   1
    ## 2  s3         0   1
    ## 3  s5         x   1
    ## 4  s1      +.s4   1
    ## 5  s1         x   1
    ## 6  s5 s4.-;s2.+   1

-   `id1` - focal subject's identification code.
-   This example includes 9 different subjects (coded **s1** to **s9**).

-   `act` - recorded social interactions (SIs) in each focal sample.
-   In this example two different SIs were recorded (coded **+** and **-**); SIs codes, subjects' id codes, and separation characters should not overlap.
-   The **.** character is used to separate subjects' id codes from the SIs' codes, and the **;** character is used to separate different SIs occurring within the same focal sample.
-   Whenever a subject's id appears before a SI's code it means that, that subject initiated a SI with the focal subject (see row 6 of `ex_field_data`); whenever a subject's id appears after the SI's it means that the focal subject (id1 column) initiated a SI with that subject (see row 4).
-   For example, in `ex_field_data`, the 4th row indicates that the focal subject **s1** initiated a **+** social interaction with subject **s4**, while the 6th row indicates that the focal subject **s5** was involved in two social interactions- the first initiated by **s4** (**-**), the second (**+**) initiated by **s2**.
-   **0**s in this column refer to focal observations where no SIs were recorded, and **x**s refer to focal observations where the focal subject was unavailable for observation.

-   `obs` - observer's identification code.
-   This example includes 2 different observers (coded **1** and **2**).

See `?ex_field_data` for further details. `dtable()` function does not require that the input data frame has matching column names to that of `ex_field_data`, but input data frame should include three columns, with the type of data as described above and in the same column order.

Example
-------

The following uses `dtable()` function to convert `ex_field_data` data frame (see details above) in a new data frame (e.g., **data**) that can be passed to `countb()` function. `dtable()` function requires that recorded social interactions' codes are provided (**bset** argument). In `ex_field_data` these codes are **+** and **-**. Below we leave **bsep**, **asep**, **missing** and **noc** `dtable()`'s arguments at their default values (".", ";", "x", "0" respectively). See `?dtable` for further details.

``` r
 b <- c("+","-")
 data <- dtable(ex_field_data, bset = b)
 head(data)
```

    ##   id1  id2 sender_id1 behavior no_occurrence missing observer
    ## 1  s2 <NA>         NA     <NA>            NA       1        1
    ## 2  s3 <NA>         NA     <NA>             1      NA        1
    ## 3  s5 <NA>         NA     <NA>            NA       1        1
    ## 4  s1   s4          1        +            NA      NA        1
    ## 5  s1 <NA>         NA     <NA>            NA       1        1
    ## 6  s5   s4          0        -            NA      NA        1

`data` object has 7 columns: \* `id1`- focal subject's identification code. \* `id2`- identification code of the social interactions partner. \* `sender_id1` - indicates whether the focal subject was the initiator/sender (coded 1) or the target of the social interaction (coded 0). \* `behavior` - indicates the code of the social interaction recorded. \* `no_occurrence` - indicates whether no social interaction were recorded (coded 1; NA otherwise). \* `missing` - indicates whether the focal subject was unavailable for observation (coded 1; NA otherwise). \* `observer` - observer's identification code.

`countb()` function can now be used on `data` to compute asymmetric data matrices, containing the number of times a specific type of social interaction was initiated by the row subject and directed to the column subject (target), separately for each social interaction and for each observer. Data matrices are stored inside a list (e.g., **observations**).

``` r
  data2 <- countb(data)
  data2
```

    ## $`1`
    ## $`1`$`-`
    ##    s1 s2 s3 s4 s5
    ## s1  0  1  0  0  2
    ## s2  0  0  0  0  1
    ## s3  0  0  0  1  0
    ## s4  0  0  1  0  1
    ## s5  0  1  1  1  0
    ## 
    ## $`1`$`+`
    ##    s1 s2 s3 s4 s5
    ## s1  0  1  1  1  0
    ## s2  0  0  2  0  2
    ## s3  2  0  0  0  0
    ## s4  0  1  0  0  0
    ## s5  0  0  0  1  0
    ## 
    ## 
    ## $`2`
    ## $`2`$`-`
    ##    s1 s2 s3 s4 s5
    ## s1  0  0  1  2  0
    ## s2  0  0  0  3  0
    ## s3  0  1  0  1  0
    ## s4  0  2  1  0  1
    ## s5  1  1  1  0  0
    ## 
    ## $`2`$`+`
    ##    s1 s2 s3 s4 s5
    ## s1  0  0  1  0  0
    ## s2  0  0  0  2  0
    ## s3  0  1  0  2  1
    ## s4  0  0  1  0  0
    ## s5  1  0  1  0  0

`data2` is a list of lists: one for each observer (in this example `` data2$`1` `` and `` data2$`2` ``). Inside each list there is one asymmetric interaction matrix per social interaction recorded (e.g., `` data2$`1`$`-` ``). Cells in these matrices provide counts on the number of times a specific type of social interaction was initiated by the row subject and directed to the column subject.

See `?countb` for further details on the `countb()` function.
