## Summary

This is a minor update that includes newly released data from the 2020 election, 
as well as some bug fixes and stylistic changes.

## Test environments
* local OS X install, R 4.0.2
* ubuntu 16.04 (on travis-ci), R 4.0.2
* Windows Server 2008 R2 SP1, R-devel, 32/64 bit

## R CMD check results
There were no ERRORs or WARNINGs. There was 1 NOTE:

> checking CRAN incoming feasibility ... NOTE
  Maintainer: ‘Jay Lee <jay.lee.tx@gmail.com>’
  
  New maintainer:
    Jay Lee <jay.lee.tx@gmail.com>
  Old maintainer(s):
    Jay Lee <jaylee@reed.edu>
  
  Found the following (possibly) invalid DOIs:
    DOI: 10.1093/poq/nft042
      From: DESCRIPTION
      Status: Forbidden
      Message: 403

The author has submitted this package before; their institution and email has 
changed. The DOI is correct; it resolves as expected from (https://www.doi.org) 
and is identical to the DOI listed at the current source link 
(https://academic.oup.com/poq/article-abstract/77/4/985/1843466?redirectedFrom=fulltext).
