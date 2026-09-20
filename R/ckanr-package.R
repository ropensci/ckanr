#' @title R client for the CKAN API
#'
#' @description ckanr is a client for the CKAN API. It wraps all
#' APIs for reading and writing data. If you have problems, or
#' have use cases that the package does not cover yet, get in touch
#' (<https://github.com/ropensci/ckanr/issues> or
#' <https://discuss.ropensci.org/>)
#'
#' @section CKAN API:
#'
#' Documentation for the CKAN API is at
#' <https://docs.ckan.org/en/latest/api/index.html>.
#' The package follows the latest version of the API.
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
#' The package supports the Datastore extension
#' (<https://docs.ckan.org/en/latest/maintaining/datastore.html>).
#' It provides these functions:
#'
#' - [ds_create()]
#' - [ds_create_dataset()]
#' - [ds_search()]
#' - [ds_search_sql()]
#'
#' @section Fetch:
#'
#' Data comes back in a wide range of formats.
#' The package provides a function to help you fetch metadata.
#' The function also fetches the actual data for a link to a file
#' on a CKAN instance.
#' If you know what you are doing, you can use your preferred tool for the job.
#' For example, you like [read.csv()] for reading csv files.
#'
#' @section CKAN Instances:
#'
#' A helper function ([servers()]) lists the current
#' CKAN instances that the package knows about. It gives the base URLs
#' that work with this package. The URLs are not necessarily landing pages
#' of each instance, but the URL can be the landing page and the base API URL.
#'
#' @importFrom methods new
#' @importFrom stats na.omit
#' @importFrom utils read.csv unzip
#' @importFrom crul HttpClient proxy upload
#' @importFrom jsonlite fromJSON
#' @import DBI
#' @name ckanr-package
#' @aliases ckanr
#' @author Scott Chamberlain \email{myrmecocystus@@gmail.com}
#' @author Florian Mayer \email{florian.wendelin.mayer@@gmail.com}
#' @author Wush Wu
#' @author Imanuel Costigan \email{i.costigan@@me.com}
#' @author Sharla Gelfand
#' @author Francisco Alves \email{fjunior.alves.oliveira@gmail.com}
#' @keywords package
"_PACKAGE"

#' Deprecated functions in \pkg{ckanr}
#'
#' These functions still work but will be removed (defunct) in the next version.
#'
#' - [ds_create_dataset()]: Another function in this package already provides
#'  this functionality. See function [resource_create()]
#'
#' @name ckanr-deprecated
NULL
