# CONTRIBUTING #

### Bugs?

* Submit an issue on the [Issues page](https://github.com/ropensci/ckanr/issues)

### Code contributions

* Fork this repo to your Github account.
* Open the code in Codespaces either in browser or in VS Code.
* A test CKAN will run in the background, available to package tests via http://localhost:5000 and accessible
  to you via the published port 5000.
* Install ckanr via <kbd>Ctrl</kbd><kbd>Shift</kbd><kbd>B</kbd> > "Install" or `devtools::install()`.
* Make your changes on a new feature branch, named after the ckanr GitHub issue it addresses:
  `git checkout -b <ISSUE_ID>-<SHORT_BRANCH_NAME>`.
* Build your changes locally via <kbd>Ctrl</kbd><kbd>Shift</kbd><kbd>B</kbd> > "Build" or `devtools::build()`.
* Test your changes locally via <kbd>Ctrl</kbd><kbd>Shift</kbd><kbd>B</kbd> > "Test" or `devtools::test()`.
* Submit a pull request to home base (likely `main` branch, but check to make sure) at `ropensci/ckanr`.
  We encourage early / draft pull requests which makes it easy to ask questions and collaborate.

### Also, check out our [discussion forum](https://discuss.ropensci.org)

### Email

Don't send email. Open an issue instead.
