# CONTRIBUTING #

### Bugs?
* Submit an issue on the [Issues page](https://github.com/ropensci/ckanr/issues)
* We welcome ideas and experiences about the developer experience.
  Reach out in the rOpenSci forum or submit a GitHub issue.

### Code contributions
Use VS Code or any IDE with the devcontainer setup for `ckanr` development.

* Fork this repo to your Github account.
* Open the code in Codespaces either in browser or in VS Code. The latter works best.
  Codespaces usage bills against your account, which includes a free usage quota.
  The first build takes a while. Later builds run faster.
* The devcontainer setup provides a running CKAN instance.
  Package tests use it through `http://localhost:5000`. Codespaces uses it
  through the published port 5000 under a URL like `https://${CODESPACE_NAME}-5000.app.github.dev`.
* Install `ckanr` via VS Code build task (<kbd>Ctrl</kbd><kbd>Shift</kbd><kbd>B</kbd>) "Install"
  or via running `just install` in the terminal.
* Install development dependencies via build task "Install Dev Deps" or `just deps`.
* Build your changes locally via build task "Build" or `just build`.
* Test your changes locally via build task "Test" or `just test`.
* Make your changes on a new feature branch, named after the `ckanr` GitHub issue it addresses:
  `git checkout -b <ISSUE_ID>-<SHORT_BRANCH_NAME>`.
* Submit a pull request to `ropensci/ckanr`.
  We welcome early draft pull requests. They help with questions, review, and collaboration.

### Agentic development
Consult the rOpenSci AI guidelines. Review any agentic output.

To use opencode:

- The provided devcontainer has opencode pre-installed. If you develop locally, 
  install opencode in your local environment.
- In a terminal, run `opencode`, enter `\connect' and enter your opencode API token.
- The system does not store the API token between sessions.
- At the time of writing, opencode offers the best value.

If you run GitHub Copilot, connect VS Code to your GitHub.

### Agent skills

The repo includes two agent skills under `.agents/skills/`. Both
opencode and GitHub Copilot use them in the devcontainer and in local checkouts:

- `adversarial-review` (from `https://oy.adonm.dev/adversarial-review.html`):
  independent review of changes or plans via a read-only subagent. opencode also
  defines the required `adversarial-review` subagent in
  `.opencode/agent/adversarial-review.md` and discovers repo skills through
  `opencode.json`.
- `simple-english` (from `https://github.com/AminBlg/SimpleEnglish`): write
  docs in ASD-STE100 Simplified Technical English.

After changing `opencode.json` or any skill file, quit and restart opencode.
Copilot finds repo skills automatically. Invoke them from the chat `/` menu
or by matching description keywords.

`.github/copilot-instructions.md` is Copilot's project instructions and opencode 
loads it through the `instructions` entry in `opencode.json`. Keep it as
the single source of project context.

We welcome suggestions and contributions. They make agentic development easier to use
and improve the output.

### Test CKAN
List running Docker containers with `just docker ps`.
You can run any docker command against the devcontainer with `just docker ...`.

To change Test CKAN versions, update `.devcontainer/.env`. Enable the variables for the
desired CKAN version, then rebuild the Codespace. The first run takes longer.
Downloaded Docker images stay cached, so later rebuilds run fast.

Verify the version and status of the running CKAN with `just ckan_version` (alias: `just cv`).

### Also, check out our [discussion forum](https://discuss.ropensci.org)

### Email
Do not send email. Open an issue instead.
