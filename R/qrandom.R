
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
        url(urltxt, ..., method="libcurl")
    } else {
        curl(urltxt, ...)
    }
}

closeConnection <- function(con) {
    if (capabilities()["libcurl"]) {
        close(con)
    }
}


qrandom <- function(n=1, type="uint8", blocksize=1) {

  if (!is.numeric(n) || !n%%1==0) {
    stop("The number 'n' of random numbers to return has to be an integer.")
  }
    if (n < 1 || n > 1024){
        stop("Random number requests must be between 1 and 1,024 numbers.")
      }

    if (!type %in% c("uint8", "uint16", "hex16")){
        stop("Type has to be 'uint8', 'uint16' or 'hex16'")
    }

  if (!is.numeric(blocksize) || !blocksize%%1==0){
    stop("The variable 'blocksize' has to be an integer.")
  }

  if(blocksize < 1 || blocksize > 1024){
    stop("The variable 'blocksize' must be between 1 and 1,024.")
  }

    urlbase <- "https://qrng.anu.edu.au/API/jsonI.php"

    urltxt <- paste(urlbase,
                      "?length=", format(n, scientific=FALSE),
                      "&type=", format(type, scientific=FALSE),
                      sep="")

    if(type=="hex16"){
      urltxt <- paste(urltxt,
                      "&size=", format(blocksize, scientific=FALSE),
                      sep="")
    }


    con <- getConnection(url = urltxt, open="r")
    randNum <- as.character(read.table(con, as.is=TRUE))
    randNum <- fromJSON(randNum)
    closeConnection(con)
    return(randNum$data)
}

qrandomunif <- function(n=1, type="uint8", blocksize=1) {
  ## uniform dist bet 0 and 1 -> add parameter for any range [a, b]
  ## test with hex

  tmp <- qrandom(n, type, blocksize)

  urand <- (tmp - min(tmp))/(max(tmp) - min(tmp))

  return(urand)
}

qrandomnorm <- function(n=1, type="uint8", blocksize=1) {
  ## normal dist with mean 0 and sd. 1 -> add parameter for any variables a, b
  ## test with hex
  ## inf. value when applying inv. method for univ. dist.!

  #U <- runif(1e6)
  #X <- qnorm(U)
}
