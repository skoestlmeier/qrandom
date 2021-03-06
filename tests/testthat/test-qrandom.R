context('functions')

test_that('qrandom', {
  skip_on_cran()

  tmp <- qrandom()

  expect_equal(length(tmp), 1)
  expect_success(expect_error(qrandom(n = "a"), "The number 'n' of random numbers to return has to be an integer."))
  expect_success(expect_error(qrandom(n = 2.5, blocksize = 1), "The number 'n' of random numbers to return has to be an integer."))
  expect_success(expect_error(qrandom(n = -3), "Random number requests must be between 1 and 100,000 numbers."))
  expect_success(expect_error(qrandom(n = 100001), "Random number requests must be between 1 and 100,000 numbers."))
  expect_failure(expect_error(qrandom(type = "uint8"), "Type has to be 'uint8', 'uint16' or 'hex16'."))
  expect_success(expect_error(qrandom(type = "INVALID-TYPE"), "Type has to be 'uint8', 'uint16' or 'hex16'."))
  expect_failure(expect_error(qrandom(blocksize =  1), "The variable 'blocksize' has to be an integer."))
  expect_success(expect_error(qrandom(blocksize =  1.5), "The variable 'blocksize' has to be an integer."))
  expect_success(expect_error(qrandom(blocksize = "a"), "The variable 'blocksize' has to be an integer."))
  expect_success(expect_error(qrandom(blocksize = 0), "The variable 'blocksize' must be between 1 and 1,024."))
  expect_success(expect_error(qrandom(blocksize = 1025), "The variable 'blocksize' must be between 1 and 1,024."))
  expect_success(expect_error(qrandom(blocksize = 2.5), "The variable 'blocksize' has to be an integer."))
  expect_equal(class(tmp), c("integer"))
  expect_equal(dim(tmp), NULL)

  tmp<-qrandom(type = "hex16")
  expect_equal(class(tmp), c("character"))
  expect_equal(dim(tmp), NULL)

  tmp <- qrandomnorm(method = "polar")
  expect_type(tmp, "double")

  tmp <- qrandomnorm(method = "boxmuller")
  expect_type(tmp, "double")

})
