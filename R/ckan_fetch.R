#' Download a file
#'
#' @export
#'
#' @param x URL for the file
#' @param store One of session (default) or disk. session stores in R session, and
#' disk saves the file to disk.
#' @param path if store=disk, you must give a path to store file to
#' @param format Format of the file. Required if format is not detectable through file URL.
#' @param ... Curl arguments passed on to \code{\link[httr]{GET}}
#' @examples \dontrun{
#' # CSV file
#' ckanr_setup("http://datamx.io")
#' res <- resource_show(id = "6145a539-cbde-4b0d-a3d3-d1a5eb013f5c", as = "table")
#' head(ckan_fetch(res$url))
#' ckan_fetch(res$url, "disk", "myfile.csv")
#'
#' # CSV file, format not available
#' ckanr_setup("https://ckan0.cf.opendata.inter.sandbox-toronto.ca")
#' res <- resource_show(id = "75c69a49-8573-4dda-b41a-d312a33b2e05", as = "table")
#' res$url
#' res$format
#' head(ckan_fetch(res$url, format = res$format))
#'
#' # Excel file - requires readxl package
#' ckanr_setup("http://datamx.io")
#' res <- resource_show(id = "e883510e-a082-435c-872a-c5b915857ae1", as = "table")
#' head(ckan_fetch(res$url))
#'
#' # XML file - requires xml2 package
#' ckanr_setup("http://data.ottawa.ca")
#' res <- resource_show(id = "380061c1-6c46-4da6-a01b-7ab0f49a881e", as = "table")
#' ckan_fetch(res$url)
#'
#' # HTML file - requires xml2 package
#' ckanr_setup("http://open.canada.ca/data/en")
#' res <- resource_show(id = "80321bac-4283-487c-93bd-c65acaa660f5", as = "table")
#' ckan_fetch(res$url)
#' library("xml2")
#' xml_text(xml_find_first(xml_children(ckan_fetch(res$url))[[1]], "title"))
#'
#' # JSON file, by default reads in to a data.frame for ease of use
#' ckanr_setup("http://data.surrey.ca")
#' res <- resource_show(id = "8d07c662-800d-4977-9e3e-5a3d2d1e99ab", as = "table")
#' head(ckan_fetch(res$url))
#'
#' # SHP file (spatial data, ESRI format) - requires sf package
#' ckanr_setup("https://ckan0.cf.opendata.inter.sandbox-toronto.ca")
#' res <- resource_show(id = "6cbb0aa3-a8d1-421c-9c40-14c6f05e0c73", as = "table")
#' x <- ckan_fetch(res$url)
#' class(x)
#' plot(x)
#'
#' # GeoJSON file - requires sf package
#' ckanr_setup("http://datamx.io")
#' res <- resource_show(id = "b1cd35b7-479e-4fa0-86e9-e897d3c617e6", as = "table")
#' x <- ckan_fetch(res$url)
#' class(x)
#' plot(x[, c("mun_name", "geometry")])
#'
#' }
ckan_fetch <- function(x, store = "session", path = "file", format = NULL, ...) {
  store <- match.arg(store, c("session", "disk"))
  file_fmt <- file_fmt(x)
  if (identical(file_fmt, character(0)) & is.null(format)) {
    stop("File format is not available from URL; please specify via `format` argument.")
  }
  fmt <- ifelse(identical(file_fmt, character(0)), format, file_fmt)
  fmt <- tolower(fmt)
  res <- fetch_GET(x, store, path, format = fmt, ...)
  if (store == "session") {
    temp_res <- read_session(res$fmt, res$data, res$path)
    unlink(res$temp_files)
    temp_res
  } else {
    res
  }
}

read_session <- function(fmt, dat, path) {
  switch(fmt,
         csv = read.csv(text = dat),
         xls = {
           check4X("readxl")
           readxl::read_excel(path)
         },
         xlsx = {
           check4X("readxl")
           readxl::read_excel(path)
         },
         xml = {
           check4X("xml2")
           xml2::read_xml(dat)
         },
         html = {
           check4X("xml2")
           xml2::read_html(dat)
         },
         json = jsonlite::fromJSON(dat),
         shp = {
           check4X("sf")
           sf::st_read(path)
         },
         geojson = {
           check4X("sf")
           sf::st_read(path)
         }
  )
}
