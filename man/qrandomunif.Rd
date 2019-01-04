\name{qrandomunif}
\alias{qrandomunif}
\title{Uniformly distributed sample of true random numbers}
\description{
  \code{qrandomunif} generates uniformly distributed true random numbers in real-time by measuring the quantum fluctuations of the vacuum.
  Per default, the data follows a standard uniform distribution \eqn{U(0,1)} with minimum value \eqn{a=0} and maximum value \eqn{b=1}, where both values are included.
}
\usage{
qrandomunif(n = 1, a = 0, b = 1)
}
\details{
\code{qrandomunif} is based on the function \code{\link{qrandom}} to generate a sequence of a minimum of 1 and a maximum of 100,000 true random numbers.
The true random numbers are generated in real-time by measuring the quantum fluctuations of the vacuum. The official \href{https://qrng.anu.edu.au/API/api-demo.php}{QRNG@ANU JSON API} currently supports only a maximum of 1,024 random numbers per request, thus requests for more numbers have to split up into smaller requests of maximum 1,024 numbers. In fact, each request may take a couple of seconds to be served. The greatest possible request \code{qrandomunif(n = 100000)} takes about 7 minutes (via DSL 16,000 internet connection) and its size is about 781.3 KB. The sequence of numbers is transformed into a uniformly distribution \eqn{U(a,b)}, where \eqn{a=0} and \eqn{b=1} are its minimum and maximum values (both included and \eqn{a<b} is required).

Internally, hexadecimal numbers with block-size 7 are obtained via qrandom() and each of their first (random) character is deleted.
These numbers are uniformly distributed within the range [0x0000000000000; 0xfffffffffffff] which is [0; 4,503,599,627,370,495] in decimal integers.
As we already have uniformly distributed numbers, we just divide each number by the maximum possible value of 0xfffffffffffff to normalize our random numbers. After conversion into decimal numbers we obtain uniformly distributed numbers within the interval [0; 1]. Our procedure garanties, that the smallest possible number greater than zero is 2.220446e-16 and the largest possible number less than one is 0.9999999999999997779554. For further information on why these boundaries are chosen, see \link[qrandom]{qrandomnorm}.

At the moment, there is no limitation for the number of requests per user but if you need a huge amount of (non-live) true random numbers, there is a 10 MB, a 100 MB, a 1,000 MB and a few 5,000 MB torrents of random binary files provided for download by the ANU Quantum Random Number Generator Server \href{http://qrng.anu.edu.au/FAQ.php#api}{here}.

We try our best to provide unique true random numbers. All API requests provided by this package are using SSL. As long as nobody is able to break the encryption protocol, the random numbers you obtain should be unique and secure.

Further information can be obtained from the ANU Quantum Random Number Generator \href{http://qrng.anu.edu.au/FAQ.php}{FAQ} and the list of references to \href{http://qrng.anu.edu.au/Links.php}{scientific papers}.
}
\arguments{
  \item{n}{The amount of random numbers to return. Must be between 1 and 100,000.}

  \item{a}{Minimum value restriction for the uniform distribution (inclusive \eqn{a}).}

  \item{b}{Maximum value restriction for the uniform distribution (inclusive \eqn{b}).}
}

\value{
  \code{qrandomunif} returns an object of \code{\link{class}} \code{"numeric"} with type \code{"double"}.

  The returning value of \code{"qrandomunif"} is a \code{"vector"} containing true random numbers which are uniformly distributed \eqn{U(a,b)}.

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

\seealso{
\link[qrandom]{qrandomnorm}
}

\examples{
\donttest{
## request for 10 true standard uniformed random numbers
randomNumbers <- qrandomunif(n = 10)

## request for 10 true random numbers within the interval [-10; 10]
randomNumbers <- qrandomunif(n = 10, a = -10, b = 10)

## calculate mean of randomNumbers
mean(randomNumbers)
}
}

