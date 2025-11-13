#!/usr/bin/env just --justfile
# https://github.com/casey/just
# https://cheatography.com/linux-china/cheat-sheets/justfile/
# Add a .env file with secrets like VIEWFLOW_KEY at top level

set dotenv-load

# List all recipes
default:
  @just --list

alias cv := ckan_version

#--------------------------------------------------------------------------------------#
# Manage CKAN Devcontainer Docker containers and images
#--------------------------------------------------------------------------------------#

# Show running CKAN status and version
ckan_version:
  /usr/bin/curl -s http://localhost:5000/api/3/action/status_show
  echo "\n"

# Run a Docker command against the CKAN Devcontainer Docker host
docker options='':
  #!/usr/bin/env bash
  DOCKER_HOST=unix:///var/run/docker-host.sock docker {{options}}

#--------------------------------------------------------------------------------------#
# R tooling (alternative to VS Code tasks via Ctrl-Shift-B)
#--------------------------------------------------------------------------------------#

# R: Build package
build:
  /usr/bin/R --no-echo --no-restore -e devtools::build()

# R: load all package files without installing
load_all:
  /usr/bin/R --no-echo --no-restore -e devtools::load_all()

# R: install package
install:
  /usr/bin/R --no-echo --no-restore -e devtools::install()

# R: check package
check:
  /usr/bin/R --no-echo --no-restore -e devtools::check()

# R: run tests
test:
  /usr/bin/R --no-echo --no-restore -e devtools::test()

# R: install development dependencies (System and R packages)
deps:
  /usr/bin/R --no-echo --no-restore -e pak::local_install_dev_deps()
