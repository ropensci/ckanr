## Test environments

* GitHub Codespaces uses the Devcontainer setup. It provides a disposable CKAN 2.9, 2.10, or 2.11 instance.
* GitHub Actions runs tests against CKAN 2.9, 2.10, 2.11 on ubuntu-latest (24.04)
* GitHub Actions runs tests without a live CKAN on windows-latest and macOS-latest
* win-builder

## R CMD check results

0 errors | 0 warnings | 0 notes

Maintainer: 'Florian Mayer <florian.wendelin.mayer@gmail.com>'

New maintainer:
  Florian Mayer <florian.wendelin.mayer@gmail.com>
Old maintainer:
  Francisco Alves <fjunior.alves.oliveira@gmail.com>


## Reverse dependencies

We checked 1 reverse dependencies, comparing R CMD check results across CRAN and dev versions of this package.

 * We saw 0 new problems
 * We failed to check 0 packages

--------

This release adds a Devcontainer setup. It provides CKAN versions to develop and test against. It adds a GitHub Actions matrix on windows-latest, macos-latest, and ubuntu-latest. Tests run on ubuntu-latest against CKAN versions 2.9-2.11.
It adds the remaining endpoints of the CKAN 2.11 API and improves test coverage to
70%.
This release transfers the package maintainership.

Thanks very much,
Florian Mayer
