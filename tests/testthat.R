## load dependencies
library(testthat)
library(qrandom)

check_qrng <- function(){
  tryCatch(
    expr = {
      req <- curl::curl_fetch_memory('https://qrng.anu.edu.au/')
      req$status_code
    },
    error = function(e){
      -1
    }
  )
}

## test package separated with filter due to limited Travis-CI build time
if(curl::has_internet() && check_qrng() == 200){
  test_check('qrandom', filter = "qrandom")
  test_check('qrandom', filter = "qrandomunif")
  test_check('qrandom', filter = "qrandomnorm")
  test_check('qrandom', filter = "qUUID")
  test_check('qrandom', filter = "qrandommaxint")
}
