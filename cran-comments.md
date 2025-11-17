## Test environments

* GitHub Codespaces using Devcontainer setup providing a disposable CKAN 2.9, 2.10, or 2.11 instance.
* ubuntu 22.04 (on github actions), R devel
* win-builder

## R CMD check results

0 errors | 0 warnings | 0 notes

Maintainer: 'Florian Mayer <florian.wendelin.mayer@gmail.com>'

New maintainer:
  Florian Mayer <florian.wendelin.mayer@gmail.com>
Old maintainer(s):
  Francisco Alves <fjunior.alves.oliveira@gmail.com>


## Reverse dependencies

We checked 1 reverse dependencies, comparing R CMD check results across CRAN and dev versions of this package.

 * We saw 0 new problems
 * We failed to check 0 packages

--------

This release adds a Devcontainer setup providing a range of CKAN versions to develop against,
a GitHub Actions matrix checking on windows-latest, macos-latest, and ubuntu-latest,
plus it runs tests (on ubuntu-latest) against CKAN versions 2.9-2.11.
It implements the remaining endpoints of the CKAN 2.11 API and adds comprehensive test coverage.
This release transfers the package maintainership.

Thanks very much,
Florian Mayer
