#!/usr/bin/env just --justfile
# https://github.com/casey/just
# https://cheatography.com/linux-china/cheat-sheets/justfile/
# Add a .env file with secrets like VIEWFLOW_KEY at top level

set dotenv-load

# List all recipes
default:
  @just --list

alias cv := ckan_version
alias cr := ckan_rebuild

# Show running CKAN status and version
ckan_version:
  /usr/bin/curl -s http://localhost:5000/api/3/action/status_show
  echo "\n"

docker options='':
  #!/usr/bin/env bash
  DOCKER_HOST=unix:///var/run/docker-host.sock docker {{options}}


# Stop Devcontainer CKAN
ckan_down:
  #!/usr/bin/env bash
  DOCKER_HOST=unix:///var/run/docker-host.sock docker-compose -f .devcontainer/docker-compose-dev.yml down

# Delete cached CKAN Docker images
ckan_rm:
  #!/usr/bin/env bash
  DOCKER_HOST=unix:///var/run/docker-host.sock docker rmi -f ckan postgres solr redis datapusher

# Startup Devcontainer CKAN with .env
ckan_up:
  #!/usr/bin/env bash
  DOCKER_HOST=unix:///var/run/docker-host.sock docker-compose -f .devcontainer/docker-compose-dev.yml up -d

ckan_rebuild:
  just ckan_down
  just ckan_rm
  just ckan_up


# Build package
build:
  /usr/bin/R --no-echo --no-restore -e devtools::build()

load_all:
  /usr/bin/R --no-echo --no-restore -e devtools::load_all()

test:
  /usr/bin/R --no-echo --no-restore -e devtools::test()
