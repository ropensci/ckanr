#' @title R client for the CKAN API
#'
#' @description ckanr is a full client for the CKAN API, wrapping all
#' APIs, including for reading and writing data. Please get in touch
#' (<https://github.com/ropensci/ckanr/issues> or <https://discuss.ropensci.org/>)
#' if you have problems, or have use cases that we don't cover yet.
#'
#' @section CKAN API:
#'
#' Document for the CKAN API is at <http://docs.ckan.org/en/latest/api/index.html>.
#' We'll always be following the lastest version of the API.
#'
#' @section ckanr package API:
#'
#' The functions can be grouped into those for setup, packages,
#' resources, tags, organizations, groups, and users.
#'
#' - Setup - The main one is [ckanr_setup()] - and many related
#'  functions, e.g., [get_default_key()]
#' - Packages - Create a package with [package_create()], and see
#'  other functions starting with `package_*`
#' - Resources - Create a package with [resource_create()], and see
#'  other functions starting with `resource_*`
#' - Tags - List tags with [tag_list()], and see
#'  other functions starting with `tag_*`
#' - Organizations - List organizations with [organization_list()],
#'  show a specific organization with [organization_show()], and
#'  create with [organization_create()]
#' - Groups - List groups with [group_list()], and see
#'  other functions starting with `group_*`
#' - Users - List users with [user_list()], and see
#'  other functions starting with `user_*`
#' - Related items - See functions starting with `related_*`
#'
#' @section Datastore:
#'
#' We are also working on supporting the Datastore extension
#' (<http://docs.ckan.org/en/latest/maintaining/datastore.html>).
#' We currently have these functions:
#'
#' - [ds_create()]
#' - [ds_create_dataset()]
#' - [ds_search()]
#' - [ds_search_sql()]
#'
#' @section Fetch:
#'
#' Data can come back in a huge variety of formats. We've attempted a function to
#' help you fetch not just metadata but the actual data for a link to a file on
#' a CKAN instance. Though if you know what you're doing, you can easily use
#' whatever is your preferred tool for the job (e.g., maybe you like
#' [read.csv()] for reading csv files).
#'
#' @section CKAN Instances:
#'
#' We have a helper function ([servers()]) that spits out the current
#' CKAN instances we know about, with URLs to their base URLs that should work
#' using this package. That is, not necessarily landing pages of each instance,
#' although, the URL may be the landing page and the base API URL.
#'
#' @importFrom methods new
#' @importFrom stats na.omit
#' @importFrom utils read.csv unzip
#' @importFrom crul HttpClient proxy upload
#' @importFrom jsonlite fromJSON
#' @import DBI
#' @name ckanr-package
#' @aliases ckanr
#' @docType package
#' @author Scott Chamberlain \email{myrmecocystus@@gmail.com}
#' @author Florian Mayer \email{florian.wendelin.mayer@@gmail.com}
#' @author Wush Wu
#' @author Imanuel Costigan \email{i.costigan@@me.com}
#' @keywords package
NULL

#' Deprecated functions in \pkg{ckanr}
#'
#' These functions still work but will be removed (defunct) in the next version.
#'
#' - [ds_create_dataset()]: The functionality of this function is already in
#'  another function in this package. See function [resource_create()]
#'
#' @name ckanr-deprecated
NULL
