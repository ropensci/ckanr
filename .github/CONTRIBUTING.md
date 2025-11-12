# CONTRIBUTING #

### Bugs?

* Submit an issue on the [Issues page](https://github.com/ropensci/ckanr/issues)

### Code contributions

The recommended development environment for ckanr is VS Code or any IDE compatible with the devcontainer setup.

* Fork this repo to your Github account.
* Open the code in Codespaces either in browser or in VS Code.
  Note, the usage will be billed against your account, which includes a free usage quota.
* The devcontainer setup provides a running CKAN instance,
  available to package tests via `http://localhost:5000` and accessible to Codespaces via the published port 5000
  under a URL like `https://${CODESPACE_NAME}-5000.app.github.dev`.
* Install ckanr via <kbd>Ctrl</kbd><kbd>Shift</kbd><kbd>B</kbd> > "Install" or `devtools::install()`.
* Make your changes on a new feature branch, named after the ckanr GitHub issue it addresses:
  `git checkout -b <ISSUE_ID>-<SHORT_BRANCH_NAME>`.
* Build your changes locally via <kbd>Ctrl</kbd><kbd>Shift</kbd><kbd>B</kbd> > "Build" or `devtools::build()`.
* Test your changes locally via <kbd>Ctrl</kbd><kbd>Shift</kbd><kbd>B</kbd> > "Test" or `devtools::test()`.
* Submit a pull request to home base (likely `main` branch, but check to make sure) at `ropensci/ckanr`.
  We encourage early / draft pull requests which makes it easy to ask questions and collaborate.

### Test CKAN
List running Docker containers with `just docker ps`.
In general, you can run any docker command against the devcontainer with `just docker ...`.

Change Test CKAN versions: Update `.devcontainer/.env`, enabling the variables for the desired CKAN version,
then rebuild the Codespace or run `just ckan_rebuild` (alias: `just cr`).

Verify the version and status of the running CKAN with `just ckan_version` (alias: `just cv`).
List running Docker containers with `just docker ps`.

### Also, check out our [discussion forum](https://discuss.ropensci.org)

### Email
Don't send email. Open an issue instead.
