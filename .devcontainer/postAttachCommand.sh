#!/bin/bash
# set -euo pipefail

echo "Running post attach commands..."
# Generate CKANR_TEST_KEY
# This command uses the Docker host from the Devcontainer to exec into the CKAN container
# Running "docker " would use the Devcontainer's own Docker daemon, which doesn't have access to the CKAN container
# The devcontainer's own Docker daemon is provided by the docker-in-docker feature and allows to run
# CKAN from the top level dpcker-compose file.

# If CKAN_VERSION=2.10-py3.10 or CKAN_VERSION=2.11 CKAN_VERSION=2.9
CKANR_TEST_KEY=$(DOCKER_HOST=unix:///var/run/docker-host.sock docker exec ckan ckan user token add ckan_admin dev_token 2>/dev/null | grep -A1 'API Token created:' | tail -1 | tr -d '\n\t ')
# If CKAN_VERSION=2.8
# CKANR_TEST_KEY=$(DOCKER_HOST=unix:///var/run/docker-host.sock docker exec ckan paster --plugin=ckan user ckan_admin | grep -o -P '(?<=apikey=).*(?= created)')


# This is the public facing URL which only works for users of the codespace.
# Access is protected by GitHub authentication.
# R scripts can only access CKAN via localhost port forwarding.
#CKANR_TEST_URL=https://$CODESPACE_NAME-5000.app.github.dev
CKANR_TEST_URL=${CKAN_INTERNAL_URL:-http://ckan:5000}
CODESPACE_PUBLIC_URL=${CKAN_PUBLIC_URL:-http://localhost:5000}
CODESPACE_NAME=${CODESPACE_NAME}

# Persist environment variables to shell profile for all future terminal sessions
echo "export CKANR_TEST_KEY='$CKANR_TEST_KEY'" >> ~/.bashrc
echo "export CKANR_DEFAULT_KEY='$CKANR_TEST_KEY'" >> ~/.bashrc
echo "export CKANR_TEST_URL='$CKANR_TEST_URL'" >> ~/.bashrc
echo "export CKANR_DEFAULT_URL='$CKANR_TEST_URL'" >> ~/.bashrc
echo "export CKANR_BROWSER_URL='$CODESPACE_PUBLIC_URL'" >> ~/.bashrc
echo "Environment variables persisted to ~/.bashrc"

# Persist environment variables to R environment for R sessions
echo "CKANR_DEFAULT_URL=$CKANR_TEST_URL" >> ~/.Renviron
echo "CKANR_DEFAULT_KEY=$CKANR_TEST_KEY" >> ~/.Renviron
echo "CKANR_TEST_URL=$CKANR_TEST_URL" >> ~/.Renviron
echo "CKANR_TEST_KEY=$CKANR_TEST_KEY" >> ~/.Renviron
echo "CODESPACE_NAME=$CODESPACE_NAME" >> ~/.Renviron
echo "CKANR_ALLOW_PURGE_TESTS=TRUE" >> ~/.Renviron
echo "CKANR_BROWSER_URL=$CODESPACE_PUBLIC_URL" >> ~/.Renviron
echo "Environment variables persisted to ~/.Renviron for R sessions"
