#!/usr/bin/env just --justfile
# https://github.com/casey/just
# https://cheatography.com/linux-china/cheat-sheets/justfile/
# Add a .env file with secrets at top level

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

# Run a Docker command against the Devcontainer Docker host, quote if using multiple args
docker options='':
  #!/usr/bin/env bash
  DOCKER_HOST=unix:///var/run/docker-host.sock docker {{options}}

# CKAN logs
ckan_logs:
  #!/usr/bin/env bash
  DOCKER_HOST=unix:///var/run/docker-host.sock docker logs ckan

# Stop CKAN
ckan_stop:
  #!/usr/bin/env bash
  DOCKER_HOST=unix:///var/run/docker-host.sock docker compose -f .devcontainer/docker-compose-dev.yml stop ckan postgres solr redis

#--------------------------------------------------------------------------------------#
# R tooling (alternative to VS Code tasks via Ctrl-Shift-B)
#--------------------------------------------------------------------------------------#

lint:
  #!/usr/bin/env bash
  jarl check R/*

# R: Document package
doc:
  #!/usr/bin/env Rscript
  devtools::document()
  knitr::knit('README.Rmd')

# R: Build package
build:
  #!/usr/bin/env Rscript
  devtools::build()

# R: load all package files without installing
load_all:
  #!/usr/bin/env Rscript
  devtools::load_all()

# R: install package
install:
  #!/usr/bin/env Rscript
  devtools::document()
  knitr::knit('README.Rmd')
  devtools::build()
  devtools::install()

# R: check package
check:
  #!/usr/bin/env Rscript
  devtools::check()
  devtools::run_examples()

# R: check Windows
check_win:
  #!/usr/bin/env Rscript
  devtools::check_win_devel()
  devtools::check_win_release()

# R: run tests
test:
  #!/usr/bin/env Rscript
  devtools::test()

# R: install development dependencies (System and R packages)
deps:
  #!/usr/bin/env Rscript
  pak::local_install_dev_deps()
