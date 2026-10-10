## Test environments

* GitHub Codespaces uses the Devcontainer setup. It provides a disposable CKAN 2.9, 2.10, 2.11, or 2.12 instance.
* GitHub Actions runs tests against CKAN 2.9, 2.10, 2.11, and 2.12 on ubuntu-latest (24.04)
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

`ckanr` now covers the complete CKAN 2.11 and 2.12 APIs and improves test coverage to above 99%.
Older supported CKAN versions are gated through the configured version number, so that users receive helpful warnings if they attempt to use a
not yet or no longer supported API endpoint of their respective CKAN instance.

To support development and provide a solid test target, this release adds a Devcontainer setup with a live CKAN instance to develop and test against.
It adds a GitHub Actions matrix on windows-latest, macos-latest, and ubuntu-latest. Tests run on ubuntu-latest against CKAN versions 2.9-2.12.
The source of `ckanr` now also supports agentic development through guardrails, skills, and support for Opencode in the devcontainer.

This release transfers the package maintainership.

Thank you for your consideration,
Florian Mayer
