#' Follower counts for CKAN objects
#'
#' Report follower totals for datasets, groups, or users.
#'
#' @param id (character or `ckan_*`) Identifier for the object to inspect.
#'   For datasets pass an id/slug or `ckan_package`, for groups pass the
#'   corresponding identifier or `ckan_group`, and for users pass a username
#'   or `ckan_user`.
#' @template args
#' @template key
#' @name follower_counts
#' @examples \dontrun{
#' ckanr_setup(url = "https://demo.ckan.org/", key = "my-key")
#' dataset_follower_count("my-dataset")
#' group_follower_count("my-group")
#' user_follower_count("demo-user")
#' }
NULL

#' @rdname follower_counts
#' @export
dataset_follower_count <- function(
  id, url = get_default_url(),
  key = get_default_key(), as = "list", ...
) {
  follower_count_request("dataset_follower_count", id, "dataset",
    url = url, key = key, as = as, opts = list(...)
  )
}

#' @rdname follower_counts
#' @export
group_follower_count <- function(
  id, url = get_default_url(),
  key = get_default_key(), as = "list", ...
) {
  follower_count_request("group_follower_count", id, "group",
    url = url, key = key, as = as, opts = list(...)
  )
}

#' @rdname follower_counts
#' @export
user_follower_count <- function(
  id, url = get_default_url(),
  key = get_default_key(), as = "list", ...
) {
  follower_count_request("user_follower_count", id, "user",
    url = url, key = key, as = as, opts = list(...)
  )
}

#' Follower lists for CKAN objects
#'
#' Return the individual follower records for CKAN datasets, groups,
#' or users.
#'
#' @inheritParams follower_counts
#' @template args
#' @template key
#' @name follower_lists
#' @examples \dontrun{
#' ckanr_setup(url = "https://demo.ckan.org/", key = "my-key")
#' dataset_follower_list("my-dataset")
#' group_follower_list("my-group")
#' user_follower_list("demo-user")
#' }
NULL

#' @rdname follower_lists
#' @export
dataset_follower_list <- function(
  id, url = get_default_url(),
  key = get_default_key(), as = "list", ...
) {
  follower_list_request("dataset_follower_list", id, "dataset",
    url = url, key = key, as = as, opts = list(...)
  )
}

#' @rdname follower_lists
#' @export
group_follower_list <- function(
  id, url = get_default_url(),
  key = get_default_key(), as = "list", ...
) {
  follower_list_request("group_follower_list", id, "group",
    url = url, key = key, as = as, opts = list(...)
  )
}

#' @rdname follower_lists
#' @export
user_follower_list <- function(
  id, url = get_default_url(),
  key = get_default_key(), as = "list", ...
) {
  follower_list_request("user_follower_list", id, "user",
    url = url, key = key, as = as, opts = list(...)
  )
}

#' Follow and unfollow CKAN datasets or groups
#'
#' Create or remove follower relationships for a CKAN object. These helpers
#' require an authenticated user (API key) representing the follower.
#'
#' @inheritParams follower_counts
#' @template args
#' @template key
#' @name follow_objects
#' @examples \dontrun{
#' ckanr_setup(url = "https://demo.ckan.org/", key = "my-key")
#' dataset_follow("my-dataset")
#' dataset_am_following("my-dataset")
#' dataset_unfollow("my-dataset")
#' }
NULL

#' @rdname follow_objects
#' @export
dataset_follow <- function(
  id, url = get_default_url(),
  key = get_default_key(), as = "list", ...
) {
  follower_mutation_request("follow_dataset", id, "dataset",
    url = url, key = key, as = as, opts = list(...)
  )
}

#' @rdname follow_objects
#' @export
dataset_unfollow <- function(
  id, url = get_default_url(),
  key = get_default_key(), as = "list", ...
) {
  follower_mutation_request("unfollow_dataset", id, "dataset",
    url = url, key = key, as = as, opts = list(...)
  )
}

#' @rdname follow_objects
#' @export
dataset_am_following <- function(
  id, url = get_default_url(),
  key = get_default_key(), ...
) {
  follower_flag_request("am_following_dataset", id, "dataset",
    url = url, key = key, opts = list(...)
  )
}

#' @rdname follow_objects
#' @export
group_follow <- function(
  id, url = get_default_url(),
  key = get_default_key(), as = "list", ...
) {
  follower_mutation_request("follow_group", id, "group",
    url = url, key = key, as = as, opts = list(...)
  )
}

#' @rdname follow_objects
#' @export
group_unfollow <- function(
  id, url = get_default_url(),
  key = get_default_key(), as = "list", ...
) {
  follower_mutation_request("unfollow_group", id, "group",
    url = url, key = key, as = as, opts = list(...)
  )
}

#' @rdname follow_objects
#' @export
group_am_following <- function(
  id, url = get_default_url(),
  key = get_default_key(), ...
) {
  follower_flag_request("am_following_group", id, "group",
    url = url, key = key, opts = list(...)
  )
}

#' Follow or unfollow users
#'
#' Manage user-to-user follower relationships.
#'
#' @param id (character or `ckan_user`) The user to follow or inspect.
#' @template args
#' @template key
#' @name follow_users
#' @examples \dontrun{
#' ckanr_setup(url = "https://demo.ckan.org/", key = "my-key")
#' follow_user("demo-user")
#' am_following_user("demo-user")
#' unfollow_user("demo-user")
#' }
NULL

#' @rdname follow_users
#' @export
follow_user <- function(
  id, url = get_default_url(),
  key = get_default_key(), as = "list", ...
) {
  follower_mutation_request("follow_user", id, "user",
    url = url, key = key, as = as, opts = list(...)
  )
}

#' @rdname follow_users
#' @export
unfollow_user <- function(
  id, url = get_default_url(),
  key = get_default_key(), as = "list", ...
) {
  follower_mutation_request("unfollow_user", id, "user",
    url = url, key = key, as = as, opts = list(...)
  )
}

#' @rdname follow_users
#' @export
am_following_user <- function(
  id, url = get_default_url(),
  key = get_default_key(), ...
) {
  follower_flag_request("am_following_user", id, "user",
    url = url, key = key, opts = list(...)
  )
}

#' Followee counts for CKAN users
#'
#' Count how many objects of each type (or overall) a user follows.
#'
#' @param id (character or `ckan_user`) User identifier.
#' @template args
#' @template key
#' @name followee_counts
#' @examples \dontrun{
#' ckanr_setup(url = "https://demo.ckan.org/", key = "my-key")
#' followee_count("demo-user")
#' user_followee_count("demo-user")
#' dataset_followee_count("demo-user")
#' }
NULL

#' @rdname followee_counts
#' @export
followee_count <- function(
  id, url = get_default_url(),
  key = get_default_key(), as = "list", ...
) {
  followee_request("followee_count", id, url, key, as = as, opts = list(...))
}

#' @rdname followee_counts
#' @export
user_followee_count <- function(
  id, url = get_default_url(),
  key = get_default_key(), as = "list", ...
) {
  followee_request("user_followee_count", id, url, key, as = as, opts = list(...))
}

#' @rdname followee_counts
#' @export
dataset_followee_count <- function(
  id, url = get_default_url(),
  key = get_default_key(), as = "list", ...
) {
  followee_request("dataset_followee_count", id, url, key,
    as = as, opts = list(...)
  )
}

#' @rdname followee_counts
#' @export
group_followee_count <- function(
  id, url = get_default_url(),
  key = get_default_key(), as = "list", ...
) {
  followee_request("group_followee_count", id, url, key,
    as = as, opts = list(...)
  )
}

#' Followee lists for CKAN users
#'
#' Return the objects being followed by a user.
#'
#' @inheritParams followee_counts
#' @param q (character) Optional prefix filter for `followee_list()`.
#' @template args
#' @template key
#' @name followee_lists
#' @examples \dontrun{
#' ckanr_setup(url = "https://demo.ckan.org/", key = "my-key")
#' followee_list("demo-user", q = "ckan")
#' dataset_followee_list("demo-user")
#' }
NULL

#' @rdname followee_lists
#' @export
followee_list <- function(
  id, q = NULL, url = get_default_url(),
  key = get_default_key(), as = "list", ...
) {
  followee_request("followee_list", id, url, key,
    as = as,
    query = list(q = q), opts = list(...)
  )
}

#' @rdname followee_lists
#' @export
user_followee_list <- function(
  id, url = get_default_url(),
  key = get_default_key(), as = "list", ...
) {
  followee_request("user_followee_list", id, url, key, as = as, opts = list(...))
}

#' @rdname followee_lists
#' @export
dataset_followee_list <- function(
  id, url = get_default_url(),
  key = get_default_key(), as = "list", ...
) {
  followee_request("dataset_followee_list", id, url, key,
    as = as, opts = list(...)
  )
}

#' @rdname followee_lists
#' @export
group_followee_list <- function(
  id, url = get_default_url(),
  key = get_default_key(), as = "list", ...
) {
  followee_request("group_followee_list", id, url, key,
    as = as, opts = list(...)
  )
}

# Internal helpers ---------------------------------------------------------

follower_coercers <- list(
  dataset = as.ckan_package,
  group = as.ckan_group,
  user = as.ckan_user
)

resolve_follow_target <- function(id, object_type, url) {
  fn <- follower_coercers[[object_type]]
  if (is.null(fn)) {
    stop(sprintf("Unsupported object type: %s", object_type), call. = FALSE)
  }
  fn(id, url = url)
}

follower_count_request <- function(
  endpoint, id, object_type, url, key,
  as = "list", opts = list()
) {
  target <- resolve_follow_target(id, object_type, url)
  resp <- ckan_GET(url, endpoint,
    query = list(id = target$id), key = key,
    opts = opts
  )
  parse_ckan_response(resp, as)
}

follower_list_request <- function(
  endpoint, id, object_type, url, key,
  as = "list", opts = list()
) {
  target <- resolve_follow_target(id, object_type, url)
  resp <- ckan_GET(url, endpoint,
    query = list(id = target$id), key = key,
    opts = opts
  )
  parse_ckan_response(resp, as)
}

follower_mutation_request <- function(
  endpoint, id, object_type, url, key,
  as = "list", opts = list()
) {
  target <- resolve_follow_target(id, object_type, url)
  resp <- ckan_POST(url, endpoint,
    body = list(id = target$id), key = key,
    opts = opts
  )
  parse_ckan_response(resp, as)
}

follower_flag_request <- function(
  endpoint, id, object_type, url, key,
  opts = list()
) {
  target <- resolve_follow_target(id, object_type, url)
  resp <- ckan_GET(url, endpoint,
    query = list(id = target$id), key = key,
    opts = opts
  )
  parse_ckan_response(resp, as = "list")
}

followee_request <- function(
  endpoint, id, url, key, as = "list",
  query = list(), opts = list()
) {
  user <- as.ckan_user(id, url = url)
  args <- cc(c(list(id = user$id), query))
  resp <- ckan_GET(url, endpoint, query = args, key = key, opts = opts)
  parse_ckan_response(resp, as)
}
