# AGENTS.md — ckanr

R client for the CKAN API (packages, resources, orgs, groups, users, tags,
datastore). Tested against CKAN 2.9–2.12. Deep R conventions live in
`.github/copilot-instructions.md` — read it before writing package code.

## Environment

- Devcontainer (R 4.6). Docker needs
  `DOCKER_HOST=unix:///var/run/docker-host.sock` (`just docker` sets it).
- CKAN test instance at `localhost:5000` (via `docker-compose-dev.yml`);
  fixtures auto-create on first test run (`prepare_test_ckan()`).
- Tests need `NOT_CRAN=true` or `skip_on_cran()` skips everything.
  Write ops need `CKANR_TEST_URL` / `CKANR_TEST_KEY` in the environment.

## Commands (`justfile`)

- `just doc` (roxygen2), `just build`, `just test`, `just check`,
  `just deps`, `just lint` (jarl). Filter tests:
  `devtools::test(filter = "package")`.

## Binding rules

- Never remove/rename exported functions; gate version behavior instead.
- Never hand-edit `NAMESPACE` or `man/*.Rd` — roxygen2 owns them. Edit
  docstrings and run `devtools::document()`.
- New functions ship with tests (`skip_on_cran()`, CKAN checks, fixture
  cleanup, json/list/table outputs, error paths) and full roxygen docs
  reusing `man-roxygen/` fragments.
- Verify by executing: run the affected tests, not just a parse check.

## Hygiene

- Air formats R code via the `air-format` pre-commit hook. Run
  `pre-commit install` once per clone. Never commit secrets.

## Skills (load on demand via the skill tool)

- `adversarial-review`: independent critique of larger work before finishing.
- `simple-english`: plain-language docs for non-specialists.
