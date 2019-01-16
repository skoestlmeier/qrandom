\name{qrandommaxint}
\alias{qrandommaxint}
\title{Uniformly distributed true random signed integers in the full range}
\description{
  \code{qrandommaxint} generates uniformly distributed true random signed integers from the API of the vacuum quantum-fluctuation server at the Australian National University.
  The numbers are uniformly distributed over the full range of signed integers \eqn{U(-.Machine$integer.max,.Machine$integer.max)}, where both values are included.
}
\usage{
qrandommaxint(n = 1)
}
\details{
\code{qrandommaxint} is based on the function \code{\link{qrandom}} to generate input of n 32-bit numbers in hexadecimal representation. These numbers are converted to bit-representations and then interpreted as signed integers. This approach does not suffer from the sampling bias inherent in multiplying an integer range with a number from \eqn{U(0, 1)}.

The true random numbers are generated in real-time by measuring the quantum fluctuations of the vacuum. The official \href{https://qrng.anu.edu.au/API/api-demo.php}{QRNG@ANU JSON API} currently supports only a maximum of 1,024 random numbers per request, thus requests for more numbers are split up into smaller requests of maximum 1,024 numbers. In fact, each request may take a couple of seconds to be served. The greatest possible request \code{qrandommaxint(n = 100000)} takes about 7 minutes (via DSL 16,000 internet connection) and its size is about 781.3 KB. The sequence of uniformly distributed hexadeximal octets is transformed into signed integers \eqn{U(-.Machine$integer.max,.Machine$integer.max)}, which usually corresponds to \eqn{U(-2,147,483,647, 2,147,483,647)}. These numbers can be used to initialize R's RNG.

Although it is of little practical importance, note that both input patterns \code{0x00000000} and \code{0x80000000} are internally interpreted as zero, whereas \code{strtoi("0x80000000")} (and all larger, i.e. negative numbers) return \code{NA}.

For further information on the underlying function to retrieve quantum random numbers, see \link[qrandom]{qrandom}.

Further information can be obtained from the ANU Quantum Random Number Generator \href{http://qrng.anu.edu.au/FAQ.php}{FAQ} and the list of references to \href{http://qrng.anu.edu.au/Links.php}{scientific papers}.
}
\arguments{
  \item{n}{The number of random signed integers to return. Must be between 1 and 100,000. Default is 1.}
}

\value{
  \code{qrandommaxint} returns an integer vector of length n \code{\link{class}} \code{"integer"} with type \code{"integer"} with n true random numbers, uniformly distributed \eqn{U(-.Machine$integer.max,.Machine$integer.max)}.
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
\link[qrandom]{qrandom}
}

\examples{
\donttest{
## request for 10 true random integers
randomIntegers <- qrandommaxint(n = 10)

## randomly set the RNG seed
set.seed(qrandommaxint())
}
}

