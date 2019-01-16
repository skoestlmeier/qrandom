# Pull request for two added functions: `qrandommaxint()` and `qUUID()`

## Description

I offer to contribute two functions to extend the use of qrandom to two use cases. 

`qrandommaxint()` is for generating uniformly distributed signed integers directly from the hex-stream.  

`qUUID()` creates RFC 4122 compliant UUIDs.


## Motivation and Context

Regarding `qrandommaxint()`, the generation of signed integers from multiplying the range `[-.Machine$integer.max; .Machine$integer.max]` with numbers from U(0, 1) is not completely sound (cf. [Ottoboni & Stark, 2018](https://www.stat.berkeley.edu/~stark/Preprints/r-random-issues.pdf)). Generating such integers reliably is difficult since the RNG seed space is very much smaller than the number space. Thus an interesting use is for initializing the RNG with `set.seed(qrandommaxint())`. The code is not entirely trivial, since the inbuilt `strtoi()` function fails for negative integers. Thus only numbers from `0x00000000` to `0x7ffffffff` are available using available R tools. 

A similar issue arises with UUIDs, where the distribution of RNG generated UUIDs may suffer from ill-chosen RNG seeds. Thus generating such 128 bit numbers (122 random bits) from true random numbers is desirable. However making the numbers RFC 4122 compliant is not entirely trivial, it requires converting the hex-pattern to bits, stamping the required 6-bit version information, re-converting to hex, and adding four hyphens.

Along with adding the sources into `./R` I have created the two `./man/...Rd` files, exported the functions via `NAMESPACE`, bumped the version number to 1.1, created an appropriate entry for `NEWS`, updated `README.md`, added my name in a `"ctb"` role to `DESCRIPTION`, and added two `./tests/testthat/test-....R` files. I believe that this makes the contribution complete and results in a fully CRAN compliant package without need for further change.

These functions require no additional dependencies.

## How Has This Been Tested?
The tests are included in `./tests/testthat/test-qrandommax.R` and `./tests/testthat/test-qUUID.R`. I test internal functions and valid output.

RStudios menu driven R CMD check passes without errors, warnings or notes.

## Screenshots (if appropriate):

## Types of changes

- [ ] Bug fix (non-breaking change which fixes an issue)
- [X] New feature (non-breaking change which adds functionality)
- [ ] Breaking change (fix or feature that would cause existing functionality to change)

## Checklist:

- [X] My code follows the code style of this project.
- [X] My change requires a change to the documentation.
- [X] I have updated the documentation accordingly.
- [X] I have read the **CONTRIBUTING** document.
- [X] I have added tests to cover my changes.
- [X] All new and existing tests passed.

