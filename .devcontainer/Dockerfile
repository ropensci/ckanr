# https://rocker-project.org/images/devcontainer/images.html
# Pinned by digest for reproducible, tamper-evident builds
# (tag documents the intent: R 4.6 on Ubuntu 24.04 noble).
# Uses the slim r-ver variant instead of geospatial: the geospatial image
# ships gigabytes of unused spatial/tidyverse/shiny packages (the previous
# image was 5.75 GB). The geo system libraries ckanr needs (sf -> GDAL/GEOS/
# PROJ) are installed explicitly below instead.
FROM ghcr.io/rocker-org/devcontainer/r-ver:4.6@sha256:1660ee0beba698f16c84b9bdeba7014c09c9e9588ee307174f6b9f53a6276c4f

# Non interactive frontend
ENV DEBIAN_FRONTEND=noninteractive

# rocker r-ver:4.6 is Ubuntu 24.04 (noble): P3M binaries must match it.
RUN echo 'options(repos = c(P3M = "https://packagemanager.posit.co/cran/__linux__/noble/latest", CRAN = "https://cloud.r-project.org"))' >>"${R_HOME}/etc/Rprofile.site"

# Install OS packages: only what ckanr needs (see DESCRIPTION, tests,
# vignettes, justfile). These are runtime system libraries backing the R
# dependency closure: libgdal/libgeos/libproj/libsqlite3 (sf), libudunits2
# (units, via sf), libxml2 (xml2), fontconfig/freetype/fribidi/harfbuzz
# (systemfonts/textshaping, via rmarkdown), pandoc (vignettes, README.Rmd).
# Deliberately NOT installed: r-cran-* debs (dead weight: R only looks in
# /usr/local/lib/R/site-library, so every R package comes from P3M below),
# cmake (no source builds; P3M binaries verified), gdal-bin (CLI tools
# unused; sf links libgdal), libabsl-dev (arrow bundles its own C++),
# libpq-dev (no Postgres client use; CKAN's Postgres is a separate
# service), libtiff/libwebp/libx11 -dev (pulled in as libgdal dependencies),
# libcurl/libssl -dev (no compilation; the runtimes ship in the base image).
RUN apt-get update && \
    apt-get -y install --no-install-recommends \
    libfontconfig1-dev libfreetype6-dev libfribidi-dev libharfbuzz-dev \
    libgdal-dev libgeos-dev libproj-dev libsqlite3-dev libudunits2-dev \
    libxml2-dev pandoc && \
    rm -rf /var/lib/apt/lists/*

# Install R packages from P3M binaries into /usr/local/lib/R/site-library
# (the only library on R's path): package Imports/Suggests (DESCRIPTION),
# vignette builders (knitr, rmarkdown), dev tooling (devtools, roxygen2,
# pak, covr, testthat), and editor support (languageserver, httpgd, tinytex).
# Transitive dependencies resolve automatically. Verified binary (no
# compilation); the uncached pak step in onCreateCommand.sh then has almost
# nothing left to do.
RUN R -q -e 'install.packages(c("arrow", "covr", "crul", "DBI", "dbplyr", "devtools", "dplyr", "httpgd", "jsonlite", "knitr", "languageserver", "pak", "readr", "readxl", "rlang", "rmarkdown", "roxygen2", "sf", "testthat", "tinytex", "xml2"))'

# Install jarl (R linter used by `just lint`) system-wide so it is on PATH
# for all users. Version-pinned for reproducible builds.
RUN curl --proto '=https' --tlsv1.2 -LsSf \
    https://github.com/etiennebacher/jarl/releases/download/0.6.0/jarl-installer.sh | sh && \
    mv /root/.local/bin/jarl /usr/local/bin/jarl && \
    rmdir -p /root/.local/bin 2>/dev/null || true

# Install OpenCode (https://opencode.ai) system-wide so it is on PATH
# for all users, not just root ($HOME/.opencode/bin at build time).
# Version-pinned for reproducible builds.
RUN curl --proto '=https' --tlsv1.2 -LsSf https://opencode.ai/install | \
    bash -s -- --no-modify-path --version 1.18.35 && \
    mv /root/.opencode/bin/opencode /usr/local/bin/opencode && \
    rmdir -p /root/.opencode/bin 2>/dev/null || true
