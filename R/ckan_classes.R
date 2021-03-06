#' ckanr S3 classes
#'
#' @name ckan_classes
#'
#' @section The classes:
#' 
#' - ckan_package - CKAN package
#' - ckan_resource - CKAN resource
#' - ckan_related - CKAN related item
#'
#' @section Coercion:
#' The functions `as.ckan_*()` for each CKAN object type coerce something
#' to a S3 class of that type. For example, you can coerce a package ID as a
#' character string into an `ckan_package` object by calling
#' `as.ckan_package(<id>`.
#'
#' @section Testing for classes:
#' To test whether an object is of a particular `ckan_*` class, there is a
#' `is._ckan_*()` function for all of the classes listed above. You can use
#' one of those functions to get a logical back, `TRUE` or `FALSE`.
#'
#' @section Manipulation:
#' These are simple S3 classes, basically an R list with an attached class
#' so we can know what to do with the object and have flexible inputs and
#' outputs from functions. You can edit one of these classes yourself
#' by simply changing values in the list.
NULL
