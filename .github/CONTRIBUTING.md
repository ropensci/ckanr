# CONTRIBUTING #

### Bugs?

* Submit an issue on the [Issues page](https://github.com/ropensci/ckanr/issues)

### Code contributions

The recommended development environment for ckanr is VS Code or any IDE compatible with the devcontainer setup.

* Fork this repo to your Github account.
* Open the code in Codespaces either in browser or in VS Code.
* The devcontainer setup provides a running CKAN instance,
  available to package tests via http://localhost:5000 and accessible to Codespaces via the published port 5000
  under a URL like `https://${CODESPACE_NAME}-5000.app.github.dev`.
* Install ckanr via <kbd>Ctrl</kbd><kbd>Shift</kbd><kbd>B</kbd> > "Install" or `devtools::install()`.
* Make your changes on a new feature branch, named after the ckanr GitHub issue it addresses:
  `git checkout -b <ISSUE_ID>-<SHORT_BRANCH_NAME>`.
* Build your changes locally via <kbd>Ctrl</kbd><kbd>Shift</kbd><kbd>B</kbd> > "Build" or `devtools::build()`.
* Test your changes locally via <kbd>Ctrl</kbd><kbd>Shift</kbd><kbd>B</kbd> > "Test" or `devtools::test()`.
* Submit a pull request to home base (likely `main` branch, but check to make sure) at `ropensci/ckanr`.
  We encourage early / draft pull requests which makes it easy to ask questions and collaborate.

### Test CKAN
List running containers: `sudo DOCKER_HOST=unix:///var/run/docker-host.sock docker ps`

Change Test CKAN versions: Change `.devcontainer/.env` and enable the variables for the desired CKAN version,
then rebuild the Codespace or run:

```{bash}
sudo DOCKER_HOST=unix:///var/run/docker-host.sock docker-compose -f docker-compose-dev.yml down
sudo DOCKER_HOST=unix:///var/run/docker-host.sock docker rmi -f ckan 2>/dev/null || true
sudo DOCKER_HOST=unix:///var/run/docker-host.sock docker-compose -f docker-compose-dev.yml up -d
```

Verify the version and status of the running CKAN with `just ckan_version`.

### Also, check out our [discussion forum](https://discuss.ropensci.org)

### Email

Don't send email. Open an issue instead.
