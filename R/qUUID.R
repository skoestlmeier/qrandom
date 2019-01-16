##  qUUID -- quantum random UUIDs.
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


x32bit <- function(x) {
  # x: a 32 digit hex string
  # return: a 128 raw vector, its binary representation
  idx <- seq(1, 32, by = 4)
  x8 <- substring(x, idx, idx + 3)
  x8 <- paste0("0x", x8)
  s <- c(13:16, 9:12, 5:8, 1:4)  # undo reversal by strtoi
  m8 <- sapply(x8, FUN = function(x) { intToBits(strtoi(x))[s] })
  return(as.vector(m8))
}

stampUUIDversion <- function(b) {
  # stamp the UUID random version identifier onto a 128 bit raw vector.
  # b: a length 128 raw vector
  # return: a length 128 raw vector with a RFC 4122 conforming version pattern
  b[61:64] <- as.raw(c(0, 1, 0, 0))
  b[71:72] <- as.raw(c(0, 1))
  return(b)
}

bit128x <- function(b) {
  # b: a length 128 raw vector
  # return: the 32 digit hex string represented by b
  dim(b) <- c(4, 32)
  hMap <- c("0", "1", "2", "3", "4", "5", "6", "7",
            "8", "9", "a", "b", "c", "d", "e", "f")
  p2 <- 2^(0:3)
  x <- apply(b, 2, FUN = function(x) {hMap[sum(as.integer(x) * p2) + 1]} )
  return(paste0(x, collapse = ""))
}

hyphenate <- function(x) {
  # x: a 32 character string
  # value: a 36 character string hyphenated in a 8-4-4-4-12 pattern
  from <- c(1, 9, 13, 17, 21)
  to <- c(8, 12, 16, 20, 32)
  return(paste(substring(x, from, to), collapse = "-"))
}

qUUID <- function(n = 1) {
  # n: number of uuids to return
  # value: n RFC 1422 conforming, random UUIDs

  x <- qrandom::qrandom(n = n, type = "hex16", blocksize = 16)
  x <- tolower(x)
  x <- sapply(x, FUN = x32bit)
  x <- apply(x, 2, FUN = stampUUIDversion)
  x <- apply(x, 2, FUN = bit128x)
  x <- sapply(x, FUN = hyphenate)
  names(x) <- NULL

  return(x)
}

# [END]
