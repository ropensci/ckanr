#!/bin/bash
set -euo pipefail
echo "Making R library writable for devcontainer user"
sudo chown -R "$(whoami)" /usr/local/lib/R/site-library
# The shared host-docker socket is managed by the docker-outside-of-docker
# feature; only relax it if it exists (glob must not fail when absent).
sudo chown "$(whoami)" /var/run/docker-host.sock 2>/dev/null || true
echo "Installing R dependencies"
# The dependencies identified by pak are installed in the (cached) Dockerfile so that
# Codespace rebuilds (to switch CKAN versions) are faster.
/usr/bin/Rscript -e 'if (!requireNamespace("pak", quietly = TRUE)) install.packages("pak"); pak::local_install_dev_deps()'
