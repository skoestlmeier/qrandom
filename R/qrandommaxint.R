##  qrandommaxint -- quantom random integers from the full range of signed
##                   integers.
##
##  Copyright (C) 2019  Boris Steipe <boris.steipe@utoronto.ca>
##                      ORCID: 0000-0002-1134-6758
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


x2bit <- function(x) {
  # x: an 8 digit hex string
  # return: a 32 integer vector of [0, 1] as its binary representation
  x4 <- substring(x, c(1, 3, 5, 7), c(2, 4, 6, 8))
  x4 <- rev(paste0("0x", x4))
  m4 <- sapply(x4, FUN = function(x) { intToBits(strtoi(x))[1:8] })
  return(as.integer(as.vector(m4)))
}

bit2int <- function(x) {
  # x: a 32 integer vector of [0, 1]
  # return: its signed integer equivalent
  p2 <- 2^(0:30)                              # powers of two
  s <- 1                                      # initialize sign
  if (x[32] == 1) {                           # sign bit is set
    x <- c(ifelse(x[1:31] == 1, 0, 1), x[32]) # flip bits
    s <- -1                                   # sign is negative
  }
  return(as.integer((s * sum(x[1:31] * p2)) - x[32]))
}

qrandommaxint <- function(n = 1) {
  # n: integer: number of values to return. See restrictions of qrandom().
  #             Default 1.
  # return: integer: n signed 32-bit integers in the range
  #                  [-.Machine$integer.max; .Machine$integer.max]

  x <- qrandom::qrandom(n = n, type = "hex16", blocksize = 4)
  x[x == "80000000"] <- "00000000"  # input would underflow: "-0"

  int <- sapply(x, FUN = function(x) { bit2int(x2bit(x)) }, USE.NAMES = FALSE)

  return(int)

}

# [END]
