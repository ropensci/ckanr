#' @title R client for the CKAN API
#'
#' @description ckanr is a full client for the CKAN API, wrapping all
#' APIs, including for reading and writing data. Please get in touch
#' (\url{https://github.com/ropensci/ckanr/issues} or \url{https://discuss.ropensci.org/})
#' if you have problems, or have use cases that we don't cover yet.
#'
#' @section CKAN API:
#'
#' Document for the CKAN API is at \url{http://docs.ckan.org/en/latest/api/index.html}.
#' We'll always be following the lastest version of the API.
#'
#' @section ckanr package API:
#'
#' The functions can be grouped into those for setup, packages,
#' resources, tags, organizations, groups, and users.
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
#'  show a specific organization with \code{\link{organization_show}}, and
#'  create with \code{\link{organization_create}}
#'  \item Groups - List groups with \code{\link{group_list}}, and see
#'  other functions starting with \code{group_*}
#'  \item Users - List users with \code{\link{user_list}}, and see
#'  other functions starting with \code{user_*}
#'  \item Related items - See functions starting with \code{related_*}
#' }
#'
#' @section Datastore:
#'
#' We are also working on supporting the Datastore extension
#' (\url{http://docs.ckan.org/en/latest/maintaining/datastore.html}).
#' We currently have these functions:
#'
#' \itemize{
#'  \item \code{\link{ds_create}}
#'  \item \code{\link{ds_create_dataset}}
#'  \item \code{\link{ds_search}}
#'  \item \code{\link{ds_search_sql}}
#' }
#'
#' @section Fetch:
#'
#' Data can come back in a huge variety of formats. We've attempted a function to
#' help you fetch not just metadata but the actual data for a link to a file on
#' a CKAN instance. Though if you know what you're doing, you can easily use
#' whatever is your preferred tool for the job (e.g., maybe you like
#' \code{\link{read.csv}} for reading csv files).
#'
#' @section CKAN Instances:
#'
#' We have a helper function (\code{\link{servers}}) that spits out the current
#' CKAN instances we know about, with URLs to their base URLs that should work
#' using this package. That is, not necessarily landing pages of each instance,
#' although, the URL may be the landing page and the base API URL.
#'
#' @importFrom methods is
#' @importFrom stats na.omit
#' @importFrom utils read.csv unzip
#' @importFrom httr GET POST upload_file write_disk add_headers content
#' stop_for_status http_condition content_type_json
#' @importFrom jsonlite fromJSON
#' @name ckanr-package
#' @aliases ckanr
#' @docType package
#' @author Scott Chamberlain \email{myrmecocystus@@gmail.com}
#' @author Florian Mayer \email{florian.wendelin.mayer@@gmail.com}
#' @author Wush Wu
#' @author Imanuel Costigan \email{i.costigan@@me.com}
#' @keywords package
NULL
