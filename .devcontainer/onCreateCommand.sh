echo "Making docker executable and R library writable for devcontainer user"
sudo chown -R $(whoami) /var/run/docker* /usr/local/lib/R/site-library
echo "Installing R dependencies"
/usr/bin/Rscript -e "pak::local_install_dev_deps()"
