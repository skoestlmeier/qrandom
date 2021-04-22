context('functions')

test_that("qUUID() returns valid output", {
  skip_if_offline(host = "qrng.anu.edu.au")

  x <- qUUID(10)

  skip_if(is.null(x))

  # returns values
  expect_equal(10, length(x))
  # correct string length
  expect_true(all(nchar(x) == 36))

  x <- gsub("-", "", x)   # purge hyphens
  expect_true(all(nchar(x) == 32))

  # test valid characters
  expect_true(all(! grepl("[^0-9a-f]", x)))

  x <- sapply(x, FUN = x32bit)    # convert to bit matrix

  expect_true(all(x[61, ] == 0))
  expect_true(all(x[62, ] == 1))
  expect_true(all(x[63, ] == 0))
  expect_true(all(x[64, ] == 0))

  expect_true(all(x[71, ] == 0))
  expect_true(all(x[72, ] == 1))

})

# [END]
