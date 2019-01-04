\name{qrandom}
\alias{qrandom}
\title{Raw sequence of true random numbers by measuring the quantum fluctuations of the vacuum}
\description{
  \code{qrandom} implements an interface to the \href{https://qrng.anu.edu.au/index.php}{ANU Quantum Random Number Generator} provided by the Australian National University. An ultra-high bandwith of true random numbers is generated in real-time by measuring the quantum fluctuations of the vacuum.
}
\usage{
qrandom(n = 1, type = "uint8", blocksize = 1)
}
\details{
\code{qrandom} is based on the official \href{https://qrng.anu.edu.au/API/api-demo.php}{QRNG@ANU JSON API}. The data type
\itemize{
  \item \code{uint8} returns uniformly distributed integers from the interval \eqn{[0; 255]}.
  \item \code{uint16} returns uniformly distributed integers from the interval \eqn{[0; 65,535]}.
  \item \code{hex16} returns uniformly distributed hexadecimal characters from the interval \eqn{[00; ff]} for \code{blocksize = 1}.
}

Each request can return a minimum of 1 and a maximum of 100,000 true random numbers. The parameter \code{blocksize} is only relevant for data type \code{hex16} and sets the length of each block. \code{blocksize} must be between 1 and 1,024. A request with data type \code{"hex16"} returns hexadecimal characters with class \code{\link{class}} \code{character} and type \code{character}. For numeric calculation with these characters \code{randomHexCharacters}, they have to be coerced e.g. with \code{base::as.hexmode(randomHexCharacters)} for smaller hexadecimal numbers, or e.g. with \code{Rmpfr::mpfr(randomHexCharacters, base = 16)} for arbitrary precision floating point numbers.

The true random numbers are generated in real-time by measuring the quantum fluctuations of the vacuum. The official \href{https://qrng.anu.edu.au/API/api-demo.php}{QRNG@ANU JSON API} supports only a maximum of 1,024 random numbers per request, thus requests for more numbers have to split up into smaller requests of 1,024 numbers. In fact, each request may take a couple of seconds to be served. The greatest possible request \code{qrandom(n = 100000, type = "hex16", blocksize = 1024)} takes about 13 minutes (via DSL 16,000 internet connection) and its size is about 201.4 MB.

At the moment, there is no limitation for the number of requests per user but if you need a huge amount of (non-live) true random numbers, there is a 10 MB, a 100 MB, a 1,000 MB and a few 5,000 MB torrents of random binary files provided for download by the ANU Quantum Random Number Generator Server \href{http://qrng.anu.edu.au/FAQ.php#api}{here}.

We try our best to provide unique true random numbers. All API requests provided by this package are using SSL. As long as nobody is able to break the encryption protocol, the random numbers you obtain should be unique and secure.

Further information can be obtained from the ANU Quantum Random Number Generator \href{http://qrng.anu.edu.au/FAQ.php}{FAQ} and the list of references to \href{http://qrng.anu.edu.au/Links.php}{scientific papers}.

}
\arguments{
  \item{n}{The amount of random numbers to return. Must be between 1 and 100,000.}

  \item{type}{ The data type must be \code{uint8}, \code{uint16} or \code{hex16}.}

  \item{blocksize}{ Only needed for data type \code{hex16}. Sets the length of each block and has to be between 1 and 1,024.}
}

\value{
  \code{qrandom} returns an object of \code{\link{class}} \code{"integer"} for data type \code{uint8} or \code{uint16} and an object af class \code{"character"} for data type \code{hex16}. For numeric calculations, the hexadecimal characters have to be coerced to an appropriate class prior to calculations (e.g. with \code{base::as.hexmode} or \code{Rmpfr::mpfr}).

  The returning value of \code{"qrandom"} is a \code{"vector"} containing true random numbers.

}


\references{
  Secure Quantum Communication group,
  Centre for Quantum Computing and Communication Technology,
  Department of Quantum Sciences,
  Research School of Physics and Engineering,
  The Australian National University, Canberra, ACT 0200, Australia.
  \emph{Welcome to the ANU Quantum Random Numbers Server.}
  \href{https://qrng.anu.edu.au/index.php}{https://qrng.anu.edu.au/index.php}
}

\examples{
\donttest{
## request for 10 true random numbers within the interval [0; 255]
randomNumbers <- qrandom(n = 10)

## request for 10 true random numbers within the interval [0; 65,535]
randomNumbers <- qrandom(n = 10, type = "uint16")

## request for 10 true random hexadecimal characters within the interval [00; ff]
randomNumbers <- qrandom(n = 10, type = "hex16")

## requests with data type 'hex16' are characters
class(randomNumbers)
typeof(randomNumbers)

## request for 10 true random hexadecimal numbers within the interval [0000; ffff]
randomNumbers <- qrandom(n = 10, type = "hex16", blocksize = 2)

## coerce hexadecimal random characters to hexadecimal numbers prior to numeric calculations
## calculate mean of randomNumbers
library(Rmpfr)
mean(as.hexmode(randomNumbers))
mean(mpfr(randomNumbers, base = 16))
}
}
