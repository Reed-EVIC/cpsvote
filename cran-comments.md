## R CMD check results

0 errors | 0 warnings | 1 note

* NOTE: Days since last update: 5
  We are submitting a patch release shortly after 0.2.0 because the
  vignettes in that release did not render on CRAN's servers (they
  required downloading external data files not available in the check
  environment). This patch fixes that by switching all vignettes to use
  the built-in sample dataset, making them self-contained. As a result,
  the package tarball is now 2.5 MB (down from ~12 MB). We apologize
  for the rapid resubmission.

## Test environments

* local macOS (aarch64), R 4.5.2
* win-builder (R-devel), 0 errors, 0 warnings, 1 note (days since last update)
* GitHub Actions: macOS-latest, windows-latest, ubuntu-latest (R release + devel)

## Submission notes

This is a patch release (0.2.1). Changes since 0.2.0:

- All vignettes now use the built-in cps_allyears_100k sample dataset and
  render without requiring a full CPS data download. This allows vignettes
  to build on CRAN's servers directly and removes the need for pre-built
  vignette output in inst/doc/.
- Reduced oversized plot title fonts in two vignettes that were causing
  titles to be clipped in rendered HTML output.
