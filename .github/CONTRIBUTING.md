# CONTRIBUTING #

### Bugs?
* Submit an issue on the [Issues page](https://github.com/ropensci/ckanr/issues)
* We are also grateful for ideas and experiences around the developer experience.
  Feel free to reach out in the rOpenSci forum or submit a GitHub issue.

### Code contributions
The recommended development environment for `ckanr` is VS Code or any IDE compatible with
the devcontainer setup.

* Fork this repo to your Github account.
* Open the code in Codespaces either in browser or in VS Code. The latter will work best.
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

### Agentic development
We ask to consult the rOpenSci AI guidelines and review any agentic output.

To use opencode:

- The provided devcontainer has opencode pre-installed. If you develop locally 
  you need to install opencode into your local environment.
- In a terminal, run `opencode`, enter `\connect' and enter your opencode API token.
- The API token is not stored between sessions.
- At the time of writing, opencode offers the best value.

To run GitHub Copilot, connect VS Code to your GitHub.

### Agent skills

The repo vendors two agent skills under `.agents/skills/`, available to both
opencode and GitHub Copilot in the devcontainer and in local checkouts:

- `adversarial-review` (from `https://oy.adonm.dev/adversarial-review.html`):
  independent review of changes or plans via a read-only subagent. opencode also
  defines the required `adversarial-review` subagent in
  `.opencode/agent/adversarial-review.md` and discovers repo skills through
  `opencode.json`.
- `simple-english` (from `https://github.com/AminBlg/SimpleEnglish`): write
  docs in ASD-STE100 Simplified Technical English.

After changing `opencode.json` or any skill file, quit and restart opencode.
Copilot discovers repo skills automatically; invoke them from the chat `/` menu
or by matching description keywords.

`.github/copilot-instructions.md` is Copilot's project instructions and is also
loaded by opencode via the `instructions` entry in `opencode.json` — keep it as
the single source of project context.

Suggestions and contributions to make agentic development easier to use 
and the output more robust are always welcome.

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
