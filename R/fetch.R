#' Download a file
#'
#' @export
#'
#' @param x URL for the file
#' @param store One of session (default) or disk. session stores in R session, and
#' disk saves the file to disk.
#' @param path if store=disk, you must give a path to store file to
#' @param ... Curl arguments passed on to \code{\link[httr]{GET}}
#' @examples \dontrun{
#' ckanr_setup('http://datamx.io')
#' res <- resource_show(id = "6145a539-cbde-4b0d-a3d3-d1a5eb013f5c", as = "table")
#' head(fetch(res$url))
#' fetch(res$url, "disk", "myfile.csv")
#'
#' # Excel file - requires readxl package
#' ckanr_setup()
#' res <- resource_show(id = "f4f871ae-139f-4acd-a700-8a08a1a04f95", as = "table")
#' head(fetch(res$url))
#'
#' # XML file
#' ckanr_setup("http://publicdata.eu/")
#' res <- resource_show(id = "ba447d6b-271e-42c2-965e-945f8e26b2ff", as = "table")
#' fetch(res$url)
#'
#' # HTML file
#' ckanr_setup("http://publicdata.eu/")
#' res <- resource_show(id = "9b5bebd8-ff40-476c-beeb-aae172031d5f", as = "table")
#' fetch(res$url)
#' library("xml2")
#' xml_text(xml_find_one(xml_children(fetch(res$url))[[1]], "title"))
#'
#' # JSON file, by default reads in to a data.frame for ease of use
#' ckanr_setup("http://publicdata.eu/")
#' res <- resource_show(id = "fa268f29-5e19-4402-a014-3e0fb93936a8", as = "table")
#' head(fetch(res$url))
#'
#' # SHP file (spatial data, ESRI format)
#' ckanr_setup("http://publicdata.eu/")
#' res <- resource_show(id = "7618b8e2-7308-4964-8024-f13df166e7fd", as = "table")
#' x <- fetch(res$url)
#' class(x)
#' plot(x)
#' }
fetch <- function(x, store = "session", path = "file", ...) {
  store <- match.arg(store, c("session", "disk"))
  res <- fetch_GET(x, store, path, ...)
  if (store == "session") {
    read_session(res$fmt, res$data, res$path)
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
           check4X("maptools")
           maptools::readShapePoints(path)
         }
  )
}
