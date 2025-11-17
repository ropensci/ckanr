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

# Stop CKAN
ckan_logs:
  #!/usr/bin/env bash
  DOCKER_HOST=unix:///var/run/docker-host.sock docker logs ckan

# Stop CKAN
ckan_stop:
  #!/usr/bin/env bash
  DOCKER_HOST=unix:///var/run/docker-host.sock docker compose -f .devcontainer/docker-compose-dev.yml stop ckan postgres solr

#--------------------------------------------------------------------------------------#
# R tooling (alternative to VS Code tasks via Ctrl-Shift-B)
#--------------------------------------------------------------------------------------#

# R: Document package
doc:
  #!/usr/bin/env Rscript
  devtools::document()

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
  devtools::install()

# R: check package
check:
  #!/usr/bin/env Rscript
  devtools::check()

# R: run tests
test:
  #!/usr/bin/env Rscript
  devtools::test()

# R: install development dependencies (System and R packages)
deps:
  #!/usr/bin/env Rscript
  pak::local_install_dev_deps()
