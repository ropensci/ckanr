#!/bin/bash
set -euo pipefail

echo "Running post attach commands..."
# Generate CKANR_TEST_KEY
# This command uses the Docker host from the Devcontainer to exec into the CKAN container
# Running "docker " would use the Devcontainer's own Docker daemon, which doesn't have access to the CKAN container
# The devcontainer's own Docker daemon is provided by the docker-in-docker feature and allows to run
# CKAN from the top level dpcker-compose file.
export CKANR_TEST_KEY=$(sudo DOCKER_HOST=unix:///var/run/docker-host.sock docker exec ckan ckan user token add ckan_admin dev_token 2>/dev/null | grep -A1 'API Token created:' | tail -1 | tr -d '\\n\\t ')
echo "CKANR_TEST_KEY set"

export CKANR_DEFAULT_KEY=$CKANR_TEST_KEY
echo "CKANR_DEFAULT_KEY set"