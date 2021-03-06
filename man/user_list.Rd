% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/user_list.R
\name{user_list}
\alias{user_list}
\title{Return a list of the site's user accounts.}
\usage{
user_list(
  q = NULL,
  order_by = NULL,
  url = get_default_url(),
  key = get_default_key(),
  as = "list",
  ...
)
}
\arguments{
\item{q}{(character) Restrict the users returned to those whose names
contain a string}

\item{order_by}{(character) Which field to sort the list by
(optional, default: 'name')}

\item{url}{Base url to use. Default: https://data.ontario.ca/ See
also \code{\link{ckanr_setup}} and \code{\link{get_default_url}}.}

\item{key}{A privileged CKAN API key, Default: your key set with
\code{\link{ckanr_setup}}}

\item{as}{(character) One of list (default), table, or json. Parsing with
table option uses \code{jsonlite::fromJSON(..., simplifyDataFrame = TRUE)},
which attempts to parse data to data.frame's when possible, so the result
can vary from a vector, list or data.frame. (required)}

\item{...}{Curl args passed on to \code{\link[crul]{verb-POST}} (optional)}
}
\description{
Return a list of the site's user accounts.
}
\examples{
\dontrun{
# all users
user_list()

# search for a user
user_list(q = "j")

# different data formats
user_list(q = "j", as = "table")
user_list(q = "j", as = "json")
}
}
