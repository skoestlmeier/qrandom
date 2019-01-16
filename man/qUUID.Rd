\name{qUUID}
\alias{qUUID}
\title{True random UUIDs conforming to RFC 4122}
\description{
  \code{qUUID} generates true random UUIDs conforming to RFC 4122 from random numbers retrieved through the API of the vacuum quantum-fluctuation server at the Australian National University. The UUIDs are taken from a space of  \code{2^122 == 5.3e+36} possibilities.
}
\usage{
qUUID(n = 1)
}
\details{
\code{qUUID} returns true random Universally Unique IDentifiers (UUID) that conform to RFC 4122. The construction is based on the function \code{\link{qrandom}} to generate an input of \code{n} 128-bit numbers in hexadecimal representation. These numbers are converted to bit-representations, the 6-bit RFC 4122-required pattern for random UIDs is stamped onto these, and the result is converted back to hexadecimals giving \code{2^122 == 5.3e+36} possibilities. The resulting UUIDs are patterned like \code{"e3da74ea-b88d-fea2-0b69-56a16caeda0a"}; bits 61 to 64 are \code{(00 01 00 00)}, and bits 71 to 72 are \code{(00 01)} (counting from 1).

The true random source is generated in real-time by measuring the quantum fluctuations of the vacuum. The official \href{https://qrng.anu.edu.au/API/api-demo.php}{QRNG@ANU JSON API} currently supports only a maximum of 1,024 random numbers per request, thus requests for more numbers are split up into smaller requests of maximum 1,024 numbers. In fact, each request may take a couple of seconds to be served.

For further information on the underlying function to retrieve quantum random numbers, see \link[qrandom]{qrandom}.

Further information can be obtained from the ANU Quantum Random Number Generator \href{http://qrng.anu.edu.au/FAQ.php}{FAQ} and the list of references to \href{http://qrng.anu.edu.au/Links.php}{scientific papers}.

For the UUID specification see \href{https://tools.ietf.org/html/rfc4122}{RFC 4122}.
}
\arguments{
  \item{n}{The number of UUIDs to return. Must be between 1 and 100,000. Default is 1.}
}

\value{
  \code{qUUID} returns a character vector of length n, \code{\link{class}} \code{"character"}, type \code{"character"} containing n true random UUIDs conforming to RFC 4122.
}


\references{
  Secure Quantum Communication group,
  Centre for Quantum Computing and Communication Technology,
  Department of Quantum Sciences,
  Research School of Physics and Engineering,
  The Australian National University, Canberra, ACT 0200, Australia.
  \emph{Welcome to the ANU Quantum Random Numbers Server.}
  \href{https://qrng.anu.edu.au/index.php}{https://qrng.anu.edu.au/index.php}

  Network Working Group (2005),
  \emph{A Universally Unique IDentifier (UUID) URN Namespace (RFC 4122).}
  \href{https://tools.ietf.org/html/rfc4122}{https://tools.ietf.org/html/rfc4122}
}

\seealso{
\link[qrandom]{qrandom}
}

\examples{
\donttest{
## generate five true random UUIDs
myUUIDs <- qUUID(5)
}
}

