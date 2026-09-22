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

The file `.devcontainer/.env` controls the CKAN version in the devcontainer.
The file contains one block for each tested CKAN version.
Each block sets `CKAN_VERSION`, `CKAN_PG_VERSION`, `SOLR_VERSION`, and `CKAN__PLUGINS`.
The file `.github/workflows/R-check.yaml` is the source of truth for working combinations.

Working combinations are:

- CKAN 2.12: `CKAN_VERSION=2.12`, `CKAN_PG_VERSION=2.12`, `SOLR_VERSION=2.12-solr9-spatial`.
- CKAN 2.11: `CKAN_VERSION=2.11`, `CKAN_PG_VERSION=2.11`, `SOLR_VERSION=2.10-solr9-spatial`.
- CKAN 2.10: `CKAN_VERSION=2.10-py3.10`, `CKAN_PG_VERSION=2.10`, `SOLR_VERSION=2.10-solr9-spatial`.
- CKAN 2.9: `CKAN_VERSION=2.9-py3.9`, `CKAN_PG_VERSION=2.9`, `SOLR_VERSION=2.9-solr9-spatial`.

CKAN 2.9 does not include the `activity` plugin.
For CKAN 2.9, remove `activity` from `CKAN__PLUGINS`.
For CKAN 2.10 and later, keep `activity` in `CKAN__PLUGINS`.

To switch versions, follow these steps:

1. Open `.devcontainer/.env` in the editor.
2. Add `#` to the start of each line in the active version block.
3. Remove `#` from the start of each line in the wanted version block.
4. If you use Codespaces, open the command palette and select Rebuild Container.
5. If you use local VS Code, use Dev Containers Rebuild Container.
6. Run `just ckan_version` (alias: `just cv`) to make sure that the wanted version runs.

The first rebuild takes longer because it downloads new images.
Downloaded Docker images stay cached, so later rebuilds run fast.
If CKAN does not start after a version switch, stop the stack and delete the data volumes.
Run `just docker "compose -f .devcontainer/docker-compose-dev.yml down -v"` from the repository root.
Then rebuild the container again.

### Also, check out our [discussion forum](https://discuss.ropensci.org)

### Email
Do not send email. Open an issue instead.
