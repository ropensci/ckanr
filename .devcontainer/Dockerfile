FROM ghcr.io/rocker-org/devcontainer/geospatial:4.5


# non interactive frontend for locales
ENV DEBIAN_FRONTEND=noninteractive

RUN echo 'options(repos = c(P3M = "https://packagemanager.posit.co/cran/__linux__/jammy/latest", CRAN = "https://cloud.r-project.org"))' >>"${R_HOME}/etc/Rprofile.site"

# Install OS packages
RUN apt-get update && \
    apt-get -y install --no-install-recommends \
    cmake gdal-bin libfontconfig1-dev libfreetype6-dev libfribidi-dev libabsl-dev \
    libgdal-dev libgeos-dev libharfbuzz-dev libproj-dev libsqlite3-dev libtiff-dev \
    libudunits2-dev libwebp-dev libx11-dev libxml2-dev r-cran-backports \
    r-cran-stringr r-cran-purrr r-cran-blob r-cran-httpcode r-cran-urltools r-cran-dbi \
    r-cran-crul r-cran-jsonlite r-cran-readxl r-cran-testthat r-cran-xml2 \
    libpq-dev libcurl4-openssl-dev libssl-dev libxml2-dev && \
    rm -rf /var/lib/apt/lists/*

RUN R -q -e 'install.packages(c("arrow", "class", "crul", "httpcode", "KernSmooth", "MASS", "purrr", "sf", "stringr", "testthat", "triebeard", "urltools", "xml2"))'
# Install any new and updated packages into the base image
# pak::local_install_dev_deps()
# → Will update 5 packages.
# → Will download 12 CRAN packages (12.60 MB).
# → Will download 1 package with unknown size.
# + class               7.3-23  [bld][cmp][dl] (22.06 kB)
# + crul                1.6.0   [bld][dl] (531.05 kB)
# + httpcode            0.3.0   [bld][dl] (17.82 kB)
# + KernSmooth          2.23-26 [bld][cmp][dl] (27.61 kB)
# + MASS                7.3-65  [bld][cmp][dl] (510.32 kB)
# + purrr      1.1.0  → 1.2.0   [bld][cmp][dl] (278.25 kB)
# + sf         1.0-21 → 1.0-22  [bld][cmp][dl] (9.87 MB) + ✔ libgdal-dev, ✔ gdal-bin, ✔ libgeos-dev, ✔ libproj-dev, ✔ libsqlite3-dev
# + stringr    1.5.2  → 1.6.0   [bld][dl] (195.83 kB)
# + testthat   3.2.3  → 3.3.0   [bld][cmp][dl] (828.22 kB)
# + triebeard           0.4.1   [bld][cmp][dl] (31.45 kB)
# + urltools            1.7.3.1 [bld][cmp][dl] (124.11 kB)
# + xml2       1.4.1  → 1.5.0   [bld][cmp][dl] (154.51 kB) + ✔ libxml2-dev
