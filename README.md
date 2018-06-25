bor
===

Overview
--------

`bor` is an `R` package design for data analysis of field behavior observations of dyadic social interactions. Currently the package provides only two functions. The package includes 3 objects:

-   `dtable()` a function to prepare your field data records for further statistical analysis;
-   `countb()` a function to count the number of interactions observed of each interaction type for each individual under observation;
-   `ex_field_data` a data frame containing an example of a field data record;

Read `bor` help file (`?bor`) to learn more about this package;

Installation
------------

``` r
# to install R packages from github you the devtools package
# the following installs the devtools package from CRAN
install.packages("devtools")

# to install bor from github type:
devtools::install_github("davidnsousa/bor")
```

Details
-------

To show an example of how field data should be recorded for input, here we show the first few lines of `ex_field_data`:

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

where `id1` is the subject under observation, `act` the action observed and `obs` the observed id. 9 subjects are considered. Actions are described by a reference to the interaction partner \[partner id\] (one element of the set of subjects except the self) and the behavior observed \[behavior\]. When \[partner id\] appears before \[behavior\], the former is the receiver and the later the sender, otherwise the symmetric is true. In this example there are two possible types of \[behavior\], namely a positive behavior "+" and a negative behavior "-". The behavior separation character \[bsep\], in this case the character ".", is use to separate behaviors from ids. Sometimes multiple actions are recorded in the same action entry (multiple dyadic interactions by the same subject in the same time interval). In these cases an action separation character \[asep\] is needed. In this example, a ";" is used. Action entries are equal to "x" or "0" when subjects are missing or no ocurrences are observed. The third variable indicates the observer of a particular observation. In this hypothetical record, two observers did the job (See `?ex_field_data`).

Example
-------

The following uses `dtable()` function on `ex_field_data` (see the details above) to make the input for `countb()` function. The set of behaviors `bset` must be specified for input in `dtable()`:

Read `dtable` and `countb` help files (`?dtable` and `?countb`) to learn more details about these function's input and output.
