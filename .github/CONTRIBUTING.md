# CONTRIBUTING #

### Bugs?
* Submit an issue on the [Issues page](https://github.com/ropensci/ckanr/issues)
* We are also grateful for ideas and experiences around the developer experience.
  Feel free to reach out in the rOpenSci forum or submit a GitHub issue.

### Code contributions
The recommended development environment for `ckanr` is VS Code or any IDE compatible with
the devcontainer setup.

* Fork this repo to your Github account.
* Open the code in Codespaces either in browser or in VS Code.
  Note, Codespaces usage will be billed against your account, which includes a free usage quota.
  The first build will take a while, subsequent builds are faster.
* The devcontainer setup provides a running CKAN instance,
  available to package tests via `http://localhost:5000` and accessible to Codespaces
  via the published port 5000 under a URL like `https://${CODESPACE_NAME}-5000.app.github.dev`.
* Install `ckanr` via VS Code build task (<kbd>Ctrl</kbd><kbd>Shift</kbd><kbd>B</kbd>) "Install"
  or via running `just install` in the terminal.
* Install development dependencies via build task "Install Dev Deps" or `just deps`.
* Build your changes locally via build task "Build" or `just build`.
* Test your changes locally via build task "Test" or `just test`.
* Make your changes on a new feature branch, named after the `ckanr` GitHub issue it addresses:
  `git checkout -b <ISSUE_ID>-<SHORT_BRANCH_NAME>`.
* Submit a pull request to `ropensci/ckanr`.
  We encourage early / draft pull requests to facilitate questions, review, and collaboration.

### Test CKAN
List running Docker containers with `just docker ps`.
In general, you can run any docker command against the devcontainer with `just docker ...`.

Change Test CKAN versions: Update `.devcontainer/.env`, enabling the variables for the
desired CKAN version, then rebuild the Codespace. This will take longer on the first run,
but already downloaded Docker images are cached, so subsequent rebuilds run quickly.

Verify the version and status of the running CKAN with `just ckan_version` (alias: `just cv`).

### Also, check out our [discussion forum](https://discuss.ropensci.org)

### Email
Don't send email. Open an issue instead.
