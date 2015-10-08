#' @title R client for the CKAN API
#'
#' @description ckanr is a full client for the CKAN API, wrapping all
#' APIs, including for reading and writing data. Please get in touch
#' (\url{https://github.com/ropensci/ckanr/issues}) if you have problems, or
#' have use cases that we don't cover yet.
#'
#' @section CKAN API:
#'
#' Document for the CKAN API is at \url{http://docs.ckan.org/en/latest/api/index.html}.
#' We'll always be following the lastest version of the API.
#'
#' @section ckanr package API:
#'
#' The functions can be grouped into those for setup, packages,
#' resources, tags, organizations, and groups.
#'
#' \itemize{
#'  \item Setup - The main one is \code{\link{ckanr_setup}} - and many related
#'  functions, e.g., \code{\link{get_default_key}}
#'  \item Packages - Create a package with \code{\link{package_create}}, and see
#'  other functions starting with \code{package_*}
#'  \item Resources - Create a package with \code{\link{resource_create}}, and see
#'  other functions starting with \code{resource_*}
#'  \item Tags - List tags with \code{\link{tag_list}}, and see
#'  other functions starting with \code{tag_*}
#'  \item Organizations - List organizations with \code{\link{organization_list}},
#'  and show a specific organization with \code{\link{organization_show}}
#' }
#'
#' @importFrom httr GET POST upload_file write_disk add_headers content
#' stop_for_status http_condition content_type_json
#' @importFrom jsonlite fromJSON
#' @name ckanr-package
#' @aliases ckanr
#' @docType package
#' @author Scott Chamberlain \email{myrmecocystus@@gmail.com}
#' @author Imanuel Costigan \email{i.costigan@@me.com}
#' @author Wush Wu
#' @author Florian Mayer \email{florian.wendelin.mayer@@gmail.com}
#' @keywords package
NULL
