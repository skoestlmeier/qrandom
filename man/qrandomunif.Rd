\name{qrandomunif}
\alias{qrandomunif}
\title{Uniformly distributed sample of true random numbers}
\description{
  \code{qrandomunif} generates uniformly distributed true random numbers in real-time by measuring the quantum fluctuations of the vacuum.
  Per default, return data has a standard uniform distribution \eqn{U(0,1)}, i.e. \eqn{a=0} and \eqn{b=1} where both values are included.
}
\usage{
qrandomunif(n=1, a=0, b=1)
}
\details{
\code{qrandomunif} is based on the function \code{\link{qrandom}} to generate a sequence of a minimum of 1 and a maximum of 1,024 true random numbers. Internally, the data type \code{"uint16"} is used for number generation. The true random numbers are generated in real-time by measuring the quantum fluctuations of the vacuum. Therefore, each request may take a couple of seconds to be served. The sequence of numbers is transformed into a uniformly distribution \eqn{U(a,b)}, where \eqn{a=0} and \eqn{b=1} are its minimum and maximum values (both included and \eqn{a<b} is required).

Normalization of data into the interval [a; b] is done by using the "min-max" formula as described \href{https://stats.stackexchange.com/a/178629/188976}{here}. This method can not be applied for one single number as this would result in the attempt of a  division by zero. For two number,
this method results into returning 0 and 1 in all cases. So if only one or two numbers are requested, these numbers (which are within the interval [0; 65,535]) are divided by their possible maximum value of 65,535. For all requests with three or more true random numbers (i.e. \eqn{2<n<1,025}), the min-max normalization is used.

At the moment, there is no limitation for the number of requests per user but if you need a huge amount of (non-live) true random numbers, there is a 10 MB, a 100 MB, a 1,000 MB and a few 5,000 MB torrents of random binary files provided for download by the ANU Quantum Random Number Generator Server \href{http://qrng.anu.edu.au/FAQ.php#api}{here}.

Further information can be obtained from the ANU Quantum Random Number Generator \href{http://qrng.anu.edu.au/FAQ.php}{FAQ} and the list of references to \href{http://qrng.anu.edu.au/Links.php}{scientific papers}.
}
\arguments{
  \item{n}{The amount of random numbers to return. Must be between 1 and 1,024.}

  \item{a}{Minimum value restriction for the uniform distribution.}

  \item{b}{Maximum value restriction for the uniform distribution.}
}

\value{
  \code{qrandomunif} returns an object of \code{\link{class}} \code{"numeric"} with type \code{"double"}.

  The returning value of \code{"qrandomunif"} is a \code{"vector"} containing true random numbers which are uniformly distributed \eqn{U(a,b)}.

}


\references{

}

\examples{

}
