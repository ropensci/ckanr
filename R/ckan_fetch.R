#' Download a file
#'
#' @export
#'
#' @param x URL for the file
#' @param store One of session (default) or disk. session stores in R session,
#' and disk saves the file to disk.
#' @param path if `store="disk"`, you must give a path to store file to
#' @param format Format of the file. Required if format is not detectable
#' through file URL.
#' @param key A CKAN API key (optional, character)
#' @param ... Curl arguments passed on to [crul::verb-GET]
#' @examples \dontrun{
#' # CSV file
#' ckanr_setup("http://datamx.io")
#' res <- resource_show(id = "6145a539-cbde-4b0d-a3d3-d1a5eb013f5c",
#' as = "table")
#' head(ckan_fetch(res$url))
#' ckan_fetch(res$url, "disk", "myfile.csv")
#'
#' # CSV file, format not available
#' ckanr_setup("https://ckan0.cf.opendata.inter.prod-toronto.ca")
#' res <- resource_show(id = "c57c3e1c-20e2-470f-bc82-e39a0264be31",
#' as = "table")
#' res$url
#' res$format
#' head(ckan_fetch(res$url, format = res$format))
#'
#' # Excel file - requires readxl package
#' ckanr_setup("http://datamx.io")
#' res <- resource_show(id = "e883510e-a082-435c-872a-c5b915857ae1",
#' as = "table")
#' head(ckan_fetch(res$url))
#'
#' # Excel file, multiple sheets - requires readxl package
#' ckanr_setup()
#' res <- resource_show(id = "ce02a1cf-35f1-41df-91d9-11ed1fdd4186",
#' as = "table")
#' x <- ckan_fetch(res$url)
#' names(x)
#' head(x[["Mayor - Maire"]])
#'
#' # XML file - requires xml2 package
#' # ckanr_setup("http://data.ottawa.ca")
#' # res <- resource_show(id = "380061c1-6c46-4da6-a01b-7ab0f49a881e",
#' # as = "table")
#' # ckan_fetch(res$url)
#'
#' # HTML file - requires xml2 package
#' ckanr_setup("http://open.canada.ca/data/en")
#' res <- resource_show(id = "80321bac-4283-487c-93bd-c65acaa660f5",
#' as = "table")
#' ckan_fetch(res$url)
#' library("xml2")
#' xml_text(xml_find_first(xml_children(ckan_fetch(res$url))[[1]], "title"))
#'
#' # JSON file, by default reads in to a data.frame for ease of use
#' ckanr_setup("http://data.surrey.ca")
#' res <- resource_show(id = "8d07c662-800d-4977-9e3e-5a3d2d1e99ab",
#' as = "table")
#' head(ckan_fetch(res$url))
#'
#' # SHP file (spatial data, ESRI format) - requires sf package
#' ckanr_setup("https://ckan0.cf.opendata.inter.prod-toronto.ca")
#' res <- resource_show(id = "27362290-8bbf-434b-a9de-325a6c2ef923",
#' as = "table")
#' x <- ckan_fetch(res$url)
#' class(x)
#' plot(x[, c("AREA_NAME", "geometry")])
#'
#' # GeoJSON file - requires sf package
#' ckanr_setup("http://datamx.io")
#' res <- resource_show(id = "b1cd35b7-479e-4fa0-86e9-e897d3c617e6",
#' as = "table")
#' x <- ckan_fetch(res$url)
#' class(x)
#' plot(x[, c("mun_name", "geometry")])
#'
#' # ZIP file - packages required depends on contents
#' ckanr_setup("https://ckan0.cf.opendata.inter.prod-toronto.ca")
#' res <- resource_show(id = "bb21e1b8-a466-41c6-8bc3-3c362cb1ed55",
#' as = "table")
#' x <- ckan_fetch(res$url)
#' names(x)
#' head(x[["ChickenpoxAgegroups2017.csv"]])
#' }
ckan_fetch <- function(x, store = "session", path = "file", format = NULL,
  key = get_default_key(), ...) {
  
  if (length(x) != 1) {
    stop("`x` must be length 1.", call. = FALSE)
  }

  store <- match.arg(store, c("session", "disk"))
  derived_file_fmt <- file_fmt(x)
  if (is.na(derived_file_fmt) && is.null(format)) {
    stop("File format is not available from URL; please specify via `format` argument.")
  }
  fmt <- ifelse(is.na(derived_file_fmt), format, derived_file_fmt)
  fmt <- tolower(fmt)
  res <- fetch_GET(x, store, path, format = fmt, key = key, ...)
  if (store == "session") {
    if (res$fmt == "zip") {
      temp_res <- vector(mode = "list", length = length(res$path))
      for (i in seq_along(res$path)) {
        temp_res[[i]] <- read_session(
          file_fmt(res$path[[i]]), res$data, res$path[[i]])
      }
      temp_names <- res$path
      temp_names <- basename(temp_names)
      names(temp_res) <- temp_names
    } else {
      temp_res <- read_session(res$fmt, res$data, res$path)
    }
    unlink(res$temp_files)
    temp_res
  } else {
    res
  }
}

read_session <- function(fmt, dat, path) {
  switch(fmt,
         csv = {
           if (!is.null(dat)) {
             read.csv(text = dat, stringsAsFactors = FALSE,
              fileEncoding = "latin1")
           } else {
             read.csv(path, stringsAsFactors = FALSE,
              fileEncoding = "latin1")
           }
         },
         xls = {
           check4X("readxl")
           read_all_excel_sheets(path)
         },
         xlsx = {
           check4X("readxl")
           read_all_excel_sheets(path)
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

read_all_excel_sheets <- function(x) {
  sheets <- readxl::excel_sheets(x)
  if (length(sheets) > 1) {
    res <- lapply(sheets, readxl::read_excel, path = x)
    names(res) <- sheets
    res
  } else {
    readxl::read_excel(x)
  }
}
