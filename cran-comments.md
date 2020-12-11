## Test environments
* local OS X install, R 4.0.2
* ubuntu 16.04 (on travis-ci), R 4.0.2
* win-builder (devel and release)

## R CMD check results
There were no ERRORs or WARNINGs. 

There was 1 NOTE:

  * checking CRAN incoming feasibility ... NOTE
  Maintainer: 'Jay Lee <jaylee@reed.edu>'
  
  New submission
  
  Possibly mis-spelled words in DESCRIPTION:
    Achen (20:24)
    Hur (20:18)
    recoding (15:58)

The author has submitted a package before; I believe this note is occurring because that package (rcv) is currently archived. Spelling is as desired.

## Resubmission edits
* Reduced length of title
* Added methods references to DESCRIPTION
* Added examples to Rd files
* Edited invalid urls
