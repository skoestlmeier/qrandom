# qrandom 1.2.6
* Bug fixes for v.1.2.6.

# qrandom 1.2.5
* Manual adjustments for KaTeX (or Mathjax) to render LaTeX-like mathematical equations.

# qrandom 1.2.4
* Bug fixes for v.1.2.3

# qrandom 1.2.3
* This update implements the CRAN policy for the provided functions to fail gracefully if no internet resource is available:
'Packages which use Internet resources should fail gracefully with an informative message if the resource is not available (and not give a check warning nor error)'.

# qrandom 1.2.2
* This update extends the implementation of v1.2.1. While the latter just checks if the device is connected to the internet, this version explicitely checks if the ANU Quantum Random Number Generator provided by the Australian National University is available and accessible by its provided API.

# qrandom 1.2.1
* The CRAN policy states that packages which use Internet resources should fail gracefully with an informative message if the resource is not available (and not give a check warning nor error). This is implemented both in the package functions and the testthat unit tests.

# qrandom 1.2
* Added `testthat` test-cases for further development

# qrandom 1.1
## New features

* qrandommaxint (true random signed integers)
* qUUID (true random Universally Unique IDs (UUID))

# qrandom 1.0
## New features

`qrandom` implements an interface to the ANU Quantum Random Numbers Server and offers true random numbers by measuring the quantum fluctuations of the vacuum.

This package offers functions to retrieve a sequenze of random integers or hexadecimals and to generate true random samples from a normal or uniform distribution. Functions of `qrandom` are:

* qrandom (sequence of true random numbers)
* qrandomunif (true random numbers from a uniform distribution)
* qrandomnorm (true random numbers from a normal distribution)

## References
  Secure Quantum Communication group,
  Centre for Quantum Computing and Communication Technology,
  Department of Quantum Sciences,
  Research School of Physics and Engineering,
  The Australian National University, Canberra, ACT 0200, Australia.
  *Welcome to the ANU Quantum Random Numbers Server.*
  https://qrng.anu.edu.au/index.php
  
  T. Symul, S. M. Assad and P. K. Lam (2011):
  Real time demonstration of high bitrate quantum random number generation with coherent laser light .
  *Applied Physics Letters*, **98**, 231103.
  doi: [10.1063/1.3597793](https://doi.org/10.1063/1.3597793).
  
  J. Y. Haw, S. M. Assad, A. M. Lance, N. H. Y. Ng, V. Sharma, P. K. Lam, and T. Symul (2015):
  Maximization of Extractable Randomness in a Quantum Random-Number Generator.
  *Physical Review Applied*, **3**, 054004.
  doi: [10.1103/PhysRevApplied.3.054004](https://doi.org/10.1103/PhysRevApplied.3.054004).
