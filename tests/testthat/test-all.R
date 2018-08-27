context("all")

## run package example
b <- c("+","-")
data <- dtable(ex_field_data, bset = b)
data2 <- countb(data)

# create the expected output for the package example

subjects <- c("s1","s2","s3","s4","s5")
o1neg <- as.data.frame(matrix(c(0,0,0,0,0,1,0,0,0,1,0,0,0,1,1,0,0,1,0,1,2,1,0,1,0),nrow=5, dimnames = list(subjects, subjects)))
o1pos <- as.data.frame(matrix(c(0,0,2,0,0,1,0,0,1,0,1,2,0,0,0,1,0,0,0,1,0,2,0,0,0),nrow=5, dimnames = list(subjects, subjects)))
o2neg <- as.data.frame(matrix(c(0,0,0,0,1,0,0,1,2,1,1,0,0,1,1,2,3,1,0,0,0,0,0,1,0),nrow=5, dimnames = list(subjects, subjects)))
o2pos <- as.data.frame(matrix(c(0,0,0,0,1,0,0,1,0,0,1,0,0,1,1,0,2,2,0,0,0,0,1,0,0),nrow=5, dimnames = list(subjects, subjects)))

expected_output <- list(`1` =
                          list( `-` = o1neg, `+` = o1pos),
                        `2` =
                          list( `-` = o2neg, `+` = o2pos)
                        )
# compare both

test_that("The package example output is equal to the expected output", {
  expect_equal(data2,expected_output)
})
