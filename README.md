# qrandom

Overview
--------
[![CRAN_Status_Badge](http://www.r-pkg.org/badges/version/qrandom)](https://cran.r-project.org/package=qrandom)
[![Project Status: Active – The project has reached a stable, usable state and is being actively developed.](http://www.repostatus.org/badges/latest/active.svg)](http://www.repostatus.org/#active)
[![Travis-CI Build Status](https://travis-ci.org/skoestlmeier/qrandom.svg?branch=master)](https://travis-ci.org/skoestlmeier/qrandom)
[![Build status](https://ci.appveyor.com/api/projects/status/nsrpduvdn28gf78r?svg=true)](https://ci.appveyor.com/project/skoestlmeier/qrandom)
[![codecov](https://codecov.io/gh/skoestlmeier/qrandom/branch/master/graph/badge.svg)](https://codecov.io/gh/skoestlmeier/qrandom)
[![Total Downloads](https://cranlogs.r-pkg.org/badges/grand-total/qrandom?color=blue)](https://CRAN.R-project.org/package=qrandom)
[![License: GPL v2](https://img.shields.io/badge/License-GPL%20v2-blue.svg)](https://www.gnu.org/licenses/old-licenses/gpl-2.0.en.html)

`qrandom` is an R package providing an interface to the [ANU Quantum Random Number Generator](https://qrng.anu.edu.au/index.php) provided by the Australian National University. An ultra-high bandwith of true random numbers is generated in real-time by measuring the quantum fluctuations of the vacuum. The quantum Random Number Generator is based on the papers *[Real time demonstration of high bitrate quantum random number generation with coherent laser light](https://doi.org/10.1063/1.3597793)* by Symul et al., (2011) and 
*[Maximization of Extractable Randomness in a Quantum Random-Number Generator](https://doi.org/10.1103/PhysRevApplied.3.054004)* by Haw, et al. (2015).

### Key Features
This package offers functions to retrieve a sequenze of random integers or hexadecimals and to generate true random samples from a normal or uniform distribution. Functions of `qrandom` are:

* qrandom (sequence of true random numbers)
* qrandomunif (true random numbers from a uniform distribution)
* qrandomnorm (true random numbers from a normal distribution)

Installation
------------
```r
# The easiest way to install qrandom is to download via CRAN
install.packages("qrandom")

# Alternatively, you can install the development version from GitHub
# install.packages("devtools")
devtools::install_github("skoestlmeier/qrandom")
```

Data
-----
We try our best to provide unique true random numbers. All API requests provided by this package are using SSL. As long as nobody is able to break the encryption protocol, the random numbers you obtain should be unique and secure.


The true random numbers provided by this package are generated in real-time by measuring the quantum fluctuations of the vacuum. The official [QRNG@ANU JSON API](https://qrng.anu.edu.au/API/api-demo.php) currently supports only a maximum of 1,024 random numbers per request, thus requests for more numbers have to split up into smaller requests of maximum 1,024 numbers. In fact, each request may take a couple of seconds to be served.

The greatest possible requestes per function

* `qrandom(n = 100000, type = "hex16", blocksize = 1024)` takes about 13 minutes and its size is about 201.4 MB

* `qrandomunif(n = 100000)` takes about 7 minutes and its size is about 781.3 KB

* `qrandomnorm(n = 100000, method = "boxmuller")` takes about 8 minutes and its size is about 781.3 KB

via a DSL 16,000 internet connection.

Notes
-----


* **qrandom**

  This function generates a true random sequence of up to 100,000 numbers per request. The type
  - 'uint8' generates integer values between 0 and 255 (both including).
  - 'uint16' generates integer values between 0 and 65,535 (both including).
  - 'hex16' generates hexadecimal values between 00 and ff (both including).
  
  The option 'blocksize' is only needed for request type 'hex16' and sets the length of each block which can be a length between 1 and 1,024 (both including).
  Further information can be obtained by the official QRNG\@ANU JSON API documentation [here](https://qrng.anu.edu.au/API/api-demo.php).

* **qrandomunif**

  This function returns a sample of 1 - 100,000 true random numbers from a uniform distribution with parameters a (minimum value) and b (maximum value), both a and b included, i.e. all values are within the interval [a; b]. Per default (a=0 and b=1), a standard uniform distribution is assumed.


* **qrandomnorm**

  This function implements 'qrandom' and transforms the true random sequence into random numbers from a normal distribution with parameters mean = a and variance = b.
  The transformation is done via ... . Be default, the transformation results in a standard normal distribution with mean 0 and variance 1.
  
  
  | method 				| stats:qnorm	| inverse | polar    | boxmuller |
  | ----------------- | -----------	| --------| ---------| ----------|
  | minimum z-value* 	| -8.209536 	| -8.12589| -8.36707 | -8.490424 |
  | maximum z-value* 	| 8.209536 	| 8.12589 | 8.36707  | 8.490424  |
  | z-values +- Inf 	| Yes 			| Yes     | No       | No        |
  **non-infinite values*.

To-Do
------------
* Ziggurat algorithm for 'qrandomnorm'.
* Speed up / parallelize requests for thousands of true random numbers in 'qrandom'.

Contributing
------------
Constributions in form of feedback, comments, code, bug reports or pull requests are most welcome. How to contribute:

* Issues, bug reports, or desired expansions: File a GitHub issue.
* Fork the source code, modify it, and issue a pull request through the project GitHub page.

Please read the [contribution guidelines](CONTRIBUTING.md) on how to contribute to this R-package.

Code of conduct
------------

Please note that this project is released with a [Contributor Code of Conduct](CODE_OF_CONDUCT.md). By participating in this project you agree to abide by its terms.

