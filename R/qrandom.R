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

getConnection <- function(urltxt, ...) {
  if (capabilities()["libcurl"]) {
    url(urltxt, ..., method = "libcurl")
  } else {
    curl(urltxt, ...)
  }
}

closeConnection <- function(con) {
  if (capabilities()["libcurl"]) {
    close(con)
  }
}


qrandom <- function(n = 1,
                    type = "uint8",
                    blocksize = 1) {
  if (!is.numeric(n) || !n %% 1 == 0) {
    stop("The number 'n' of random numbers to return has to be an integer.")
  }
  if (n < 1 || n > 1024) {
    stop("Random number requests must be between 1 and 1,024 numbers.")
  }

  if (!type %in% c("uint8", "uint16", "hex16")) {
    stop("Type has to be 'uint8', 'uint16' or 'hex16'")
  }

  if (!is.numeric(blocksize) || !blocksize %% 1 == 0) {
    stop("The variable 'blocksize' has to be an integer.")
  }

  if (blocksize < 1 || blocksize > 1024) {
    stop("The variable 'blocksize' must be between 1 and 1,024.")
  }

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
    urltxt <- paste(
                    urltxt,
                    "&size=",
                    format(blocksize, scientific = FALSE),
                    sep = "")
  }


  con <- getConnection(url = urltxt, open = "r")
  randNum <- as.character(read.table(con, as.is = TRUE))
  randNum <- fromJSON(randNum)
  if (type == "hex16") {
    randNum <- as.hexmode(randNum)
  }
  closeConnection(con)
  return(randNum$data)
}

qrandomunif <- function(n = 1,
                        a = 0,
                        b = 1) {
  ## No hex-mode supported yet

  if (!is.numeric(n) || !n %% 1 == 0) {
    stop("The number 'n' of random numbers to return has to be an integer.")
  }
  if (n < 2 || n > 1024) {
    stop("Random number requests must be between 2 and 1,024 numbers.")
  }

  if (!is.numeric(a) || !is.numeric(b)) {
    stop("The parameters 'a' and 'b' must be numeric.")
  }

  if (!a < b) {
    stop("The minimum value 'a' of the distribution has to be less than parameter 'b'.")
  }

  tmp <- qrandom(n = n, type = "uint16")

  ## Normalization of data into the interval [0, 1] using the "min-max" formula,
  ## see https://stats.stackexchange.com/a/178629/188976
  ## The min-max formula can be applied only if there is a minimum of three input numbers:
  ##    - One input number leads to a division by zero
  ##    - Two input numbers results into returning the numbers 0 and 1.
  ## For theese cases, the input number x1 (and eventually x2) within [0, 65535] are divided by their
  ## possible maximum value of 65535, so x1_new (x2_new) are within the interval [0, 1].

  urand <- vector("numeric", n)

  if (n == 1 || n == 2) {
    urand <- tmp / 65535
  } else{
    urand <- (tmp - min(tmp)) / (max(tmp) - min(tmp))
  }

  if (a != 0 || b != 1) {
    ## transform distribution to have minimum value 'a' and maximum value of 'b',
    ## so data is uniformly distributed within the interval [a, b].
    ## see https://math.stackexchange.com/a/205854/474480
    urand <- (b - a) * urand + a
  }

  return(urand)

}

qrandomnorm <- function(n = 2,
                        mu = 0,
                        sd = 1) {
  ## No hex-mode supported yet

  ## normal dist with mean 0 and sd. 1 -> add parameter for any variables a, b
  ## inf. value when applying inv. method for univ. dist.!
  ## minim value fordern? / rnorm hat kein minimum
  ## also implement Box-muller transformation?!?

  ## Evtl. direkt aus verteilung von qrandom (nicht erst aus 0,1 range) verteilung erstellen


  #U <- runif(1e6)
  #X <- qnorm(U)

  if (!is.numeric(n) || !n %% 1 == 0) {
    stop("The number 'n' of random numbers to return has to be an integer.")
  }
  if (n < 2 || n > 1024) {
    stop("Random number requests must be between 2 and 1,024 numbers.")
  }

  if (!is.numeric(mu) || !is.numeric(sd)) {
    stop("The parameters 'mu' and 'sd' must be numeric.")
  }

  tmp_1 <- qrandomunif(n = n, type = "uint16")
  tmp_2 <- qrandomunif(n = n, type = "uint16")

  ## Marsaglia polar method - see https://stackoverflow.com/a/43619239/8512077
  nrand <-
    marsaglia_bray(
      n = n,
      tmp_1 = tmp_1,
      tmp_2 = tmp_2,
      mu = mu,
      sd = sd
    )

  return(nrand)
}

marsaglia_bray <- function(n = 1,
                           tmp_1,
                           tmp_2,
                           mu = 0,
                           sd = 1)
{
  x <- vector("numeric", n)

  i <- 1

  while (i <= n)
  {
    u <- c(tmp_1[i], tmp_2[i])
    v <- 2 * u - 1
    w <- sum(v ^ 2)

    if (w < 1)
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
  }

  return(x * sd + mu)
}

rweight <- function(a)
{
  asort <- sort(a)
  for(i in 1:length(a)){
    ord <- which(a==asort[i])
  }

  ## range: 0 - 65,535
  ## daher +1 um Wert 0 auszuschließen und um maximum 65,535+1 (=..36) auszuschließen:
  ## division durch 65,537
  a <- (a+1)/65537

  # #X <- qnorm(U) ?

  i <- 1

  while (i <= n)
  {
    u <- c(tmp_1[i], tmp_2[i])
    v <- 2 * u - 1
    w <- sum(v ^ 2)

    if (w < 1)
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
  }

  return(x * sd + mu)
}
