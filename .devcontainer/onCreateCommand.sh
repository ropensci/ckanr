#!/bin/bash
# set -euo pipefail
echo "Making docker executable and R library writable for devcontainer user"
sudo chown -R $(whoami) /var/run/docker* /usr/local/lib/R/site-library
# sudo echo "127.0.0.1 ckan" | sudo tee -a /etc/hosts
echo "Installing R dependencies"
# The dependencies identified by pak are installed in the (cached) Dockerfile so that
# Codespace rebuilds (to switch CKAN versions) are faster
/usr/bin/Rscript -e "pak::local_install_dev_deps()"
