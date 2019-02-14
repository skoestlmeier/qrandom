##  qrandom -- An R interface to the ANU Quantum Random Numbers Server
##
##  Copyright (C) 2018  Siegfried Köstlmeier <siegfried.koestlmeier@gmail.com>
##
##  This file is part of the qrandom R-package
##
##  qrandom is free software; you can redistribute it and/or
##  modify it under the terms of the GNU General Public License
##  as published by the Free Software Foundation; either version 2
##  of the License, or (at your option) any later version.
##
##  qrandom is distributed in the hope that it will be useful,
##  but WITHOUT ANY WARRANTY; without even the implied warranty of
##  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
##  GNU General Public License for more details.
##
##  You should have received a copy of the GNU General Public License
##  along with qrandom. If not, see <http://www.gnu.org/licenses/>.

getConnection <- function(website, ...) {
  if (capabilities()["libcurl"]) {
    url(website, ..., method = "libcurl")
  } else {
    curl(website, ...)
  }
}

closeConnection <- function(con) {
  if (capabilities()["libcurl"]) {
    close(con)
  }
}


get_sequence <- function(n = 1,
                         type = "uint8",
                         blocksize = 1) {
  urlbase <- "https://qrng.anu.edu.au/API/jsonI.php"

  urltxt <- paste(
    urlbase,
    "?length=",
    format(n, scientific = FALSE),
    "&type=",
    format(type, scientific = FALSE),
    sep = ""
  )

  if (type == "hex16") {
    urltxt <- paste(urltxt,
                    "&size=",
                    format(blocksize, scientific = FALSE),
                    sep = "")
  }

  con <- getConnection(website = urltxt, open = "r")
  rt <- readLines(con, encoding = "UTF-8")
  randNum <- as.character(rt)
  randNum <- fromJSON(randNum)
  randNum <- randNum$data
  closeConnection(con)
  return(randNum)
}

qrandom <- function(n = 1,
                    type = "uint8",
                    blocksize = 1) {
  if (!is.numeric(n) || !n %% 1 == 0) {
    stop("The number 'n' of random numbers to return has to be an integer.")
  }
  if (n < 1 || n > 100000) {
    stop("Random number requests must be between 1 and 100,000 numbers.")
  }
  if (!type %in% c("uint8", "uint16", "hex16")) {
    stop("Type has to be 'uint8', 'uint16' or 'hex16'.")
  }
  if (!is.numeric(blocksize) || !blocksize %% 1 == 0) {
    stop("The variable 'blocksize' has to be an integer.")
  }
  if (blocksize < 1 || blocksize > 1024) {
    stop("The variable 'blocksize' must be between 1 and 1,024.")
  }

  tmp <- c()

  count <- n %/% 1024
  remain <- n %% 1024

  if (count != 0) {
    ##  true, if more than 1,024 numbers are requested
    progress <- txtProgressBar(min = 0,
                               max = count,
                               style = 3)
    for (i in 1:count) {
      tmp <-
        c(tmp,
          get_sequence(
            n = 1024,
            type = type,
            blocksize = blocksize
          ))
      setTxtProgressBar(progress, i)
    }
    if (remain != 0) {
      tmp <-
        c(tmp,
          get_sequence(
            n = remain,
            type = type,
            blocksize = blocksize
          ))
    }
    close(progress)
  } else{
    tmp <-
      get_sequence(n = n,
                   type = type,
                   blocksize = blocksize)
  }
  return(tmp)
}

qrandomunif <- function(n = 1,
                        a = 0,
                        b = 1) {
  if (!is.numeric(n) || !n %% 1 == 0) {
    stop("The number 'n' of random numbers to return has to be an integer.")
  }
  if (n < 1 || n > 100000) {
    stop("Random number requests must be between 1 and 100,000 numbers.")
  }
  if (!is.numeric(a) || !is.numeric(b)) {
    stop("The parameters 'a' and 'b' must be numeric.")
  }
  if (!a < b) {
    stop("The minimum value 'a' of the distribution has to be less than parameter 'b'.")
  }

  ## We use this function qrandomunif() for further calculations in qrandomnorm(), so
  ## we decided to use hexadecimal numbers with block-size 7 for uniform distribution data
  ## and deleting the first character of each hexadecimal number.
  ## Therefore, the numbers here are uniformly distributed within the range [0x0000000000000; 0xfffffffffffff]
  ## which is [0; 4,503,599,627,370,495] in decimal integers.
  ## As we already have uniformly distributed numbers, we just divide each number by the maximum possible
  ## value of 0xfffffffffffff to normalize our random numbers. After conversion into decimal numbers we
  ## obtain uniformly distributed numbers within the interval [0; 1].
  ##
  ## See the comment on qrandomnorm() for futher information on why we choose especially
  ## block-size 7 and delete the first character of each hexadecimal number.

  tmp <-
    qrandom(n = n,
            type = "hex16",
            blocksize = 7)

  # cast 'a' and 'b' to mpfr
  # see https://github.com/skoestlmeier/qrandom/issues/2 for further details
  a_tmp <- mpfr(a, base = 10, precBits = 52)
  b_tmp <- mpfr(b, base = 10, precBits = 52)

  ## delete first (random) character
  tmp <- substring(tmp, 2)

  tmp <- mpfr(tmp, base = 16)
  tmp <- new("mpfr", unlist(tmp))

  ## Normalization within the interval [0; 1]
  urand <- tmp / mpfr("fffffffffffff", base = 16)
  #urand <- as.numeric(urand)


  if (a != 0 || b != 1) {
    ## transform distribution to have minimum value 'a' and maximum value of 'b',
    ## so data is uniformly distributed within the interval [a, b].
    urand <- (b_tmp - a_tmp) * urand + a_tmp
  }

  return(as.numeric(urand))

}

qrandomnorm <- function(n = 1,
                        mean = 0,
                        sd = 1,
                        method = "inverse") {
  if (!is.numeric(n) || !n %% 1 == 0) {
    stop("The number 'n' of random numbers to return has to be an integer.")
  }
  if (n < 1 || n > 100000) {
    stop("Random number requests must be between 1 and 100,000 numbers.")
  }
  if (!is.numeric(mean) || !is.numeric(sd)) {
    stop("The parameters 'mean' and 'sd' must be numeric.")
  }
  if (sd < 0) {
    stop("The standard deviation 'sd' must not be negative.")
  }
  if (!method %in% c("inverse", "polar", "boxmuller")) {
    stop(
      "The method for generating true normal random variables has to be 'inverse', 'polar' or 'boxmuller'."
    )
  }

  ## Our procedure described in the initial comment on qrandomunif() garanties that qrandomunif() returns true random numbers,
  ## where the smallest possible number greater than zero is 2.220446e-16 and the largest possible number less than
  ## one is 0.9999999999999997779554. This is useful as the function qrandomnorm() is internally based on the uniformly data in qrandomunif().

  x <- vector("numeric", n)

  if (method == "inverse") {
    ## Using qrandomunif() for getting standard uniformly distributed true random numbers
    ## and applying the Inverse transform sampling described in https://en.wikipedia.org/w/index.php?title=Inverse_transform_sampling&oldid=866923287
    ## (which is also known as inversion sampling, the inverse probability integral transform, or the inverse transformation method).

    tmp <- qrandomunif(n = n)

    ## tmp is within the range [0; 1]. Applying qnrom() results in -Inf if tmp equals 0 and +Inf if tmp equals 1.
    ## Applying stats::qnorm() on the smallest possible number greater than zero (2.220446e-16) and on the
    ## largest possible number less than one (0.9999999999999997779554) results in a limitation for our
    ## non-infinite z-values within the interval [-8.125891; 8.125891]. In comparison, the non-infinite z-values
    ## for the function stats::qnorm() are limited within the interval [-8.209536; 8.209536].

    ## +-Inf for z-values of normal distributed data are only possible when using this 'inverse' method.
    tmp <- qnorm(tmp)
    x <- sd * tmp + mean
  } else if (method == "polar") {
    ## Only non-infinite z-values are possible when using this 'polar' method.
    ## Apply method 'inverse' for the possibilty of +-Inf z-values.
    ## z-values for a standard normal distribution with mean = 0 and sd = 1 are bound within the
    ## interval [-8.36707;  8.36707].
    x <- marsaglia_bray(n = n, mean = mean, sd = sd)
  } else if (method == "boxmuller") {
    ## Only non-infinite z-values are possible when using this 'boxmuller' method.
    ## Apply method 'inverse' for the possibilty of +-Inf z-values.
    ## z-values for a standard normal distribution with mean = 0 and sd = 1 are bound within the
    ## interval [-8.490424;  8.490424]
    x <- box_muller(n = n, mean = mean, sd = sd)
  }

  return(x)
}

## Implementation of the Marsaglia Bray Polar method, see https://en.wikipedia.org/w/index.php?title=Marsaglia_polar_method&oldid=871161902
## and https://stackoverflow.com/a/43619239/8512077 for the original code
marsaglia_bray <- function(n = 1,
                           mean = 0,
                           sd = 1)
{
  x <- vector("numeric", n)

  i <- 1

  count <- 1
  cat("Request 1/2:\n")
  tmp1 <- qrandomunif(n)
  cat("Request 2/2:\n")
  tmp2 <- qrandomunif(n)

  while (i <= n)
  {
    if (count > n) {
      count <- 1
      tmp1 <- qrandomunif(n)
      tmp2 <- qrandomunif(n)
    }
    u <- c(tmp1[count], tmp2[count])
    v <- 2 * u - 1
    w <- sum(v ^ 2)

    if (w > 0 && w < 1)
    {
      y <- sqrt(-2 * log(w) / w)

      z <- v * y

      x[i] <- z[1]

      if ((i + 1) <= n)
      {
        x[i + 1] <- z[2]
        i <- i + 1
      }

      i <- i + 1
    }
    count <- count + 1
  }

  x * sd + mean
}

## Implementation of the Box–Muller transformation, see https://en.wikipedia.org/w/index.php?title=Box%E2%80%93Muller_transform&oldid=873905617
## and https://stackoverflow.com/a/43619239/8512077 for the original code
box_muller <- function(n = 1,
                       mean = 0,
                       sd = 1)
{
  x <- vector("numeric", n)

  count <- 1
  cat("Request 1/2:\n")
  tmp1 <- qrandomunif(n)
  cat("Request 2/2:\n")
  tmp2 <- qrandomunif(n)

  i <- 1
  while (i <= n)
  {
    if (count > n) {
      count <- 1
      tmp1 <- qrandomunif(n)
      tmp2 <- qrandomunif(n)
    }

    u1 <- tmp1[count]
    u2 <- tmp2[count]
    if (!u1 == 0) {
      x[i] <- sqrt(-2 * log(u1)) * cos(2 * pi * u2)

      if ((i + 1) <= n)
      {
        x[i + 1] <- sqrt(-2 * log(u1)) * sin(2 * pi * u2)
        i <- i + 1
      }

      i <- i + 1
    }
    count <- count + 1
  }

  x * sd + mean
}
