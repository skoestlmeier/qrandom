\name{qrandomnorm}
\alias{qrandomnorm}
\title{Normal distributed sample of true random numbers}
\description{
  \code{qrandomnorm} generates normal distributed true random numbers in real-time by measuring the quantum fluctuations of the vacuum.
  Per default, the data follows a standard normal distribution \eqn{N(0,1)}, with mean zero and standard deviation one.
}
\usage{
qrandomnorm(n = 1, mean = 0, sd = 1, method = "inverse")
}
\details{
\code{qrandomnorm} is based on the function \code{\link{qrandom}} to generate a sequence of a minimum of 1 and a maximum of 100,000 true random numbers.
The true random numbers are generated in real-time by measuring the quantum fluctuations of the vacuum. The official \href{https://qrng.anu.edu.au/API/api-demo.php}{QRNG@ANU JSON API} currently supports only a maximum of 1,024 random numbers per request, thus requests for more numbers have to split up into smaller requests of maximum 1,024 numbers. In fact, each request may take a couple of seconds to be served. The greatest possible requests \code{qrandomnorm(n = 100000, method = "polar")} or \code{qrandomnorm(n = 100000, method = "boxmuller")} take about 8 minutes (via DSL 16,000 internet connection) and their size is about 781.3 KB. Per default, the sequence of numbers is transformed into a standard normal distribution \eqn{N(0,1)}, with \eqn{mean=0} and standard deviation \eqn{sd=1}.

Internally, uniformly distributed true random numbers within the interval [0; 1] from the function \link[qrandom]{qrandomunif} are used to obtain normal distributed data. Within these uniformly data, the smallest possible number greater than zero is 2.220446e-16 and the largest possible number less than one is 0.9999999999999997779554.

We provide three methods to transform our standard uniformly data \eqn{U(0,1)} into a normal distribution \eqn{N(mean, sd)}:
\itemize{
\item{inverse}{The sample of standard uniformly data is interpreted as a probability and transformed into a normal distribution applying the stats::qnorm() function.}

\item{polar}{Using the polar-method by George Marsaglia for generating normal distributed data.}

\item{boxmuller}{Using the Box-Muller transformation by George Box and Mervin Muller for generating normal distributed data.}
}

Be aware that only the default method 'inverse' is able to return -Inf and +Inf z-values for the normal distribution. The following table summarizes the non-infinite minimum and maximum z-values for a standard normal distribution for each method provided and compares them with the non-infinite extreme values from \link[stats]{qnorm}:

\tabular{lcccc}{
    method            \tab stats:qnorm()  \tab inverse    \tab polar    \tab boxmuller\cr
    minimum z-value*  \tab -8.209536      \tab -8.12589   \tab -8.36707 \tab -8.490424\cr
    maximum z-value*  \tab 8.209536       \tab 8.12589    \tab 8.36707  \tab 8.490424\cr
    z-values +-Inf    \tab Yes            \tab Yes        \tab No       \tab No
  }
*non-infinite values.

At the moment, there is no limitation for the number of requests per user but if you need a huge amount of (non-live) true random numbers, there is a 10 MB, a 100 MB, a 1,000 MB and a few 5,000 MB torrents of random binary files provided for download by the ANU Quantum Random Number Generator Server \href{http://qrng.anu.edu.au/FAQ.php#api}{here}.

We try our best to provide unique true random numbers. All API requests provided by this package are using SSL. As long as nobody is able to break the encryption protocol, the random numbers you obtain should be unique and secure.

Further information can be obtained from the ANU Quantum Random Number Generator \href{http://qrng.anu.edu.au/FAQ.php}{FAQ} and the list of references to \href{http://qrng.anu.edu.au/Links.php}{scientific papers}.
}
\arguments{
  \item{n}{The amount of random numbers to return. Must be between 1 and 100,000.}

  \item{mean}{The mean-value for the normal distribution.}

  \item{sd}{The standard deviation for the normal distribution.}

  \item{method}{The method used for transforming internally used standard uniformly distributed data into normal distributed data. Currently provided methods are 'inverse' for inverse transform sampling using stats::qnorm(), 'polar' for the polar-method by George Marsaglia and 'boxmuller' for the Box-Muller transformation by George Box and Mervin Muller.}
}

\value{
  \code{qrandomnorm} returns an object of \code{\link{class}} \code{"numeric"} with type \code{"double"}.

  The returning value of \code{"qrandomnorm"} is a \code{"vector"} containing true random numbers which are normally distributed \eqn{N(mean, sd)}.

}


\references{
    Benjamin, April 25th, 2017, answer on teo93, "generate N(0,1) using uniform(0,1) in R", Stack Overflow, January 4th 2009, https://stackoverflow.com/a/43619239/8512077.

    Box, G. E. P. and Muller, Mervin E. (1958). A Note on the Generation of Random Normal Deviates. \emph{The Annals of Mathematical Statistics}, \bold{29}, No. 2, p. 610-–611, \doi{10.1214/aoms/1177706645}.

  Marsaglia, G. and Bray, T. A. (1964): A Convenient Method for Generating Normal Variables. \emph{SIAM Review}, \bold{6}, No. 3, p. 260-–264, \doi{10.1137/1006063}.

  Secure Quantum Communication group,
  Centre for Quantum Computing and Communication Technology,
  Department of Quantum Sciences,
  Research School of Physics and Engineering,
  The Australian National University, Canberra, ACT 0200, Australia.
  \emph{Welcome to the ANU Quantum Random Numbers Server.}
  \href{https://qrng.anu.edu.au/index.php}{https://qrng.anu.edu.au/index.php}

  Wikipedia contributors. (2018, November 2). Inverse transform sampling. In Wikipedia, The Free Encyclopedia. Retrieved 13:03, January 4, 2019, from \href{https://en.wikipedia.org/w/index.php?title=Inverse_transform_sampling&oldid=866923287}{https://en.wikipedia.org/w/index.php?title=Inverse_transform_sampling&oldid=866923287}.

  Wikipedia contributors. (2018, December 15). Box–Muller transform. In Wikipedia, The Free Encyclopedia. Retrieved 12:55, January 4, 2019, from \href{https://en.wikipedia.org/w/index.php?title=Box-Muller_transform&oldid=873905617}{https://en.wikipedia.org/w/index.php?title=Box-3Muller_transform&oldid=873905617}.

  Wikipedia contributors. (2018, November 29). Marsaglia polar method. In Wikipedia, The Free Encyclopedia. Retrieved 12:57, January 4, 2019, from \href{https://en.wikipedia.org/w/index.php?title=Marsaglia_polar_method&oldid=871161902}{https://en.wikipedia.org/w/index.php?title=Marsaglia_polar_method&oldid=871161902}.
}

\seealso{
\link[qrandom]{qrandomunif}
}

\examples{
\donttest{
## request for 10 true standard normal distributed random numbers
randomNumbers <- qrandomnorm(n = 10)

## request for 10 true random numbers with mean 5 and standard deviation of 3
randomNumbers <- qrandomnorm(n = 10, mean = 5, sd = 3)

## request for 10 true random numbers with mean 8, standard deviation of 2 and using
## the polar-method by George Marsaglia to transform internally used uniformly data
## into a normal distribution
randomNumbers <- qrandomnorm(n = 10, mean = 8, sd = 2, method = "polar")

## calculate mean of randomNumbers
mean(randomNumbers)
}
}

