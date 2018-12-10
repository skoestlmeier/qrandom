\name{qrandom}
\alias{qrandom}
\title{Raw sequence of true random numbers by measuring the quantum fluctuations of the vacuum}
\description{
  \code{qrandom} implements an interface to the \href{https://qrng.anu.edu.au/index.php}{ANU Quantum Random Number Generator} provided by the Australian National University. An ultra-high bandwith of true random numbers is generated in real-time by measuring the quantum fluctuations of the vacuum.
}
\usage{
qrandom(n=1, type="uint8", blocksize=1)
}
\details{
\code{qrandom} is based on the official \href{https://qrng.anu.edu.au/API/api-demo.php}{QRNG@ANU JSON API}. The data type
\itemize{
  \item \code{uint8} returns uniformly distributed integers from the interval \eqn{[0; 255]}.
  \item \code{uint16} returns uniformly distributed integers from the interval \eqn{[0; 65,535]}.
  \item \code{hex16} returns uniformly distributed hexadecimal characters from the interval \eqn{[00; ff]}.
}

Each request can return a minimum of 1 and a maximum of 1,024 true random numbers. The parameter \code{blocksize} is only needed for the data type \code{hex16} and sets the length of each block. \code{blocksize} must be between 1 and 1,024.

The true random numbers are generated in real-time by measuring the quantum fluctuations of the vacuum. Therefore, each request may take a couple of seconds to be served. At the moment, there is no limitation for the number of requests per user but if you need a huge amount of (non-live) true random numbers, there is a 10 MB, a 100 MB, a 1,000 MB and a few 5,000 MB torrents of random binary files provided for download by the ANU Quantum Random Number Generator Server \href{http://qrng.anu.edu.au/FAQ.php#api}{here}.

Further information can be obtained from the ANU Quantum Random Number Generator \href{http://qrng.anu.edu.au/FAQ.php}{FAQ} and the list of references to \href{http://qrng.anu.edu.au/Links.php}{scientific papers}.

}
\arguments{
  \item{n}{The amount of random numbers to return. Must be between 1 and 1,024.}

  \item{type}{ The data type must be \code{uint8}, \code{uint16} or \code{hex16}.}

  \item{blocksize}{ Only needed for data type \code{hex16}. Sets the length of each block and has to be between 1 and 1,024.}
}

\value{
  \code{qrandom} returns an object of \code{\link{class}} \code{"integer"} for data type \code{uint8} or \code{uint16} and an object af class \code{"character"} for data type \code{hex16}.

  The returning value of \code{"qrandom"} is a \code{"vector"} containing true random numbers.

}


\references{

}

\examples{

}
