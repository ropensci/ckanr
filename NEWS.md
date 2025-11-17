# ckanr (development version)
==============================

### MAINTENANCE

* Replace the deprecated `lazyeval` dependency with `rlang`, updating our dplyr
  tests and development tooling accordingly so contributors only need the modern
  tidy-eval stack (#93)

ckanr 0.8.1
===========

### MAINTENANCE

* Update servers(), thanks @nn-at (#176)

ckanr 0.8.0
===========

### NEW FEATURES
Remaining endpoints of the CKAN 2.11 API have been implemented.

* Add dataset collaborator helpers `package_collaborator_list()`, `package_collaborator_list_for_user()`, `package_collaborator_create()`, and `package_collaborator_delete()`.
* Expose membership utilities `member_list()`, `member_create()`, `member_delete()`, `member_roles_list()`, `group_member_create()`, `group_member_delete()`, `organization_member_create()`, `organization_member_delete()`, `user_invite()`, `group_list_authz()`, and `organization_list_for_user()` to manage user access consistently across groups and organizations.
* Add relationship management wrappers `package_relationships_list()`, `package_relationship_create()`, `package_relationship_update()`, and `package_relationship_delete()` with S3-friendly inputs.
* Provide dataset maintenance helpers `package_revise()`, `package_resource_reorder()`, `package_owner_org_update()`, and `dataset_purge()` for advanced automation workflows.
* Introduce the `ckan_resource_view` S3 class along with wrappers for `resource_view_list()`, `resource_view_show()`, `resource_view_create()`, `resource_view_update()`, `resource_view_reorder()`, `resource_view_delete()`, `resource_view_clear()`, `resource_create_default_resource_views()`, and `package_create_default_resource_views()` to manage CKAN previews from R.
* Refresh the follower/followee helpers: `dataset_*`, `group_*`, and `user_*` functions now expose counts, lists, follow/unfollow flows, and "am I following" probes, plus followee dashboards (`followee_count()`, `followee_list()`, `dataset_followee_*()`, `group_followee_*()`, `user_followee_*()`). Organization-specific helpers remain unavailable because CKAN 2.11+ no longer exposes those endpoints.
* Add activity-stream helpers covering `group_activity_list()`, `organization_activity_list()`, `recently_changed_packages_activity_list()`, `dashboard_new_activities_count()`, `dashboard_mark_activities_old()`, `activity_show()`, `activity_data_show()`, `activity_diff()`, `activity_create()`, and `send_email_notifications()` (all automatically skip when the `activity` plugin is disabled).
* Add sysadmin-only vocabulary helpers (`vocabulary_list()`, `vocabulary_show()`, `vocabulary_create()`, `vocabulary_update()`, `vocabulary_delete()`) plus `tag_autocomplete()` to round out the tag discovery toolkit.
* Implement the admin & operations toolkit: task-status maintenance (`task_status_*()`), term translations, runtime config editing, Redis/RQ job controls, API token lifecycle helpers, and diagnostic wrappers for `status_show()`/`help_show()`.

### TESTS

* Add integration coverage for collaborator and membership endpoints with dynamic skips
  when the target CKAN instance lacks the relevant feature flags.
* Cover the new relationship and dataset maintenance helpers, including opt-in purge
  coverage behind the `CKANR_ALLOW_PURGE_TESTS` gate.
* Exercise the resource view lifecycle (create/list/show/update/reorder/delete) plus
  default view helpers when the `text_view` plugin is available, while skipping gracefully
  otherwise.
* Expand the follower tests to follow/unfollow datasets, groups, and users, verifying the
  followee dashboards while automatically cleaning up temporary relationships.
* Add skips keyed off `status_show()` for all activity and dashboard tests, exercising new helpers whenever the `activity` plugin is available.
* Cover the new vocabulary lifecycle and `tag_autocomplete()` helpers, skipping gracefully when the configured CKAN user lacks sysadmin rights.
* Exercise the admin/ops helpers with sysadmin-gated tests that verify task-status roundtrips, term translations, config changes, job management, API tokens, and diagnostics while skipping when the test key lacks sufficient privileges.

### MAINTENANCE

* Add file `.github/copilot-instructions.md` to allow GenAI to reason over the codebase.
  The file is also a great read for human contributors.

ckanr 0.7.1
===========

### NEW FEATURES

* Support for parquet files: `ckan_fetch()`, `read_session()` and `fetch_GET()` now
  support parquet files, thanks @hannaboe (#217)

### MAINTENANCE

* New developer experience: A devcontainer provides a disposable CKAN instance for testing,
  replacing the need for an external CKAN instance and GitHub secrets for testing, and
  offering the choice of CKAN v2.9-2.11 (#216 #212)
* New maintainer @florianm

ckanr 0.7.0
===========

### NEW FEATURES

* `resource_update()` allows update of resource extra fields by making the `path` parameter optional (#175) thanks @nicholsn

### MINOR IMPROVEMENTS

* `revision_list` and `package_revision_list` return `NULL` instead of error for CKAN 2.9+ (#200)
* fix notes and warnings from CRAN package check results (#195)

ckanr 0.6.0
===========

### NEW FEATURES

* parameter `http_method` gained in `resource_create()`, `package_update()`, and `package_patch()`; it's passed to `as.ckan_package()` internally, but does not affect the HTTP request for the main point of the function (#163) thanks @hannaboe
* gains new function `organization_purge()` to purge an organization (which requires sysadmin) (#166) thanks @nicholsn

### MINOR IMPROVEMENTS

* update URLs for known CKAN instances behind the `servers()` function (#162) (#167) (#170)
* .Rbuildignore README.md and vignettes (#171)
* `extras` now passed in HTTP request in `package_create()` as a top level part of the request body rather than as a named `extras` element (#158) thanks @galaH
* change in `ckan_fetch()`: now when a zip file has a subdirectory an `NA` is returned rather than `character(0)` (#164)
* change in the `...` parameter in `ckan_fetch()`: was used to pass through curl options to the http request but now is used to pass through additional parameters to either `read.csv`, `xml2::read_xml`, `jsonlite::fromJSON`, `sf::st_read()`, `read.table()`, or `readxl::read_excel` (#165)
* updated docs for `package_create()` and `group_create()` - change `groups` parameter description to explain what kind of input is expected (#168)
* updated docs for `package_update()` and `resource_update()` - illustrate possible data loss when updating with incomplete package metadata (#108)


ckanr 0.5.0
===========

### NEW FEATURES

* `package_create()` gains parameter `private` (boolean) (#145)
* add support for resource extras. `resource_create()` and `resource_update()` gain new parameter `extras`, while `resource_patch()` function doesn't change but gains an example of adding an extra (#149) (#150) thanks @nicholsn
* `package_patch()` gains `extras` parameter (#94) see also (#147)

### MINOR IMPROVEMENTS

* replace httr with crul throughout package (#86) (#151)
* use markdown for docs (#148)
* `package_patch()`, `package_show()`, `package_activity_list()`, `package_delete()`, `package_update()`, and `related_create()` now pass on `key` parameter value to `as.ckan_package` internally; same for `resource_create()` and `resource_show()`, but passed to `as.ckan_resource()`  (#145) (#146)
* `servers()` gains two additional CKAN urls (#155)
* `package_show()` called `as.ckan_package()` within it, which itself calls `package_show()` - fixed now  (#127)

### BUG FIXES

* fix for `resource_search()` and `tag_search`: both were not allowing a query to be more than length 1 (#153)
* fix for `print.ckan_package`: wasn't handling well results from `package_search()` that had a named list of locale specific results (#152)


ckanr 0.4.0
===========

### NEW FEATURES

* `ckan_fetch()` gains parameter `key` for a CKAN API key; if given the API key is now included in the request headers (#133) see also (#122) by @sharlagelfand
* `ckan_fetch()` gains ability to read xls/xlsx files with multiple sheets (#135) by @sharlagelfand

### MINOR IMPROVEMENTS

* `ckan_fetch()` now sets `stringsAsFactors = FALSE` when reading data (#141) (#142) thanks @LVG77 @sharlagelfand
* in `ckan_fetch()`, use `basename(x)` instead of `gsub(paste0(tempdir(), "/"), "", x)`, to get file path (#140) by @sharlagelfand
* in `package_search()` handle better cases where the CKAN version can not be determined (#139) && fix logic for when `default_schema` and `include_private` parameters are included based on the CKAN version (#137) by @sharlagelfand
* improve `ckan_fetch()`: old behavior of the fxn with zip files was that it only worked if the zip file contained shp files; works more generally now, e.g., a zip file containing a csv file (#132) by @sharlagelfand
* fix `ckan_fetch()` examples that weren't working (#134) by @sharlagelfand
* fix to parsing CKAN version numbers, new internal fxn `parse_version_number()` - now properly parses CKAN version numbers that include patch and dev versions (#136) by @sharlagelfand


ckanr 0.3.0
===========

### NEW FEATURES

* new package author Sharla Gelfand !!!
* new functions for users: `user_create()` and `user_delete()` (#82)
* `package_show()` gains `key` parameter to pass an API key (#97)
* `package_search()` gains new parameters: `include_drafts`, `include_private`, `use_default_schema`, and `facet.mincount` (#107)
* function `fetch()` changed to `ckan_fetch()`
* gains function `organization_delet()` to delete an organization (#83)
* gains function `ckan_version()` to get version info for a CKAN instance
* gains methods for creating a CKAN remote instance as a dplyr backend: gains `src_ckan()` and it's s3 methods `tbl` and `src_tbls`, `sql_translate_env`. in addition gains the S3 methods `db_begin`, `db_explain`, `db_has_table`, `db_insert_into`, `db_query_fields`, `db_query_rows`

### MINOR IMPROVEMENTS

* fix some tests (#62)
* fix to `ds_create()` to properly format body with json data (#85) thanks @mattfullerton
* tests added for `ckan_fetch()` (#118) thanks @sharlagelfand
* `ckan_fetch()` gains `format` parameter if the user knows the file format (useful when the file format can not be guessed) (#117) thanks @sharlagelfand
* `ckan_fetch` gain support for handling geojson (#123) thanks @sharlagelfand
* `ckan_fetch` was writing to current working directory in some cases - fixed to writing to temp files and cleaning up (#125) (#128) (#129) thanks @sharlagelfand
* add USDA CKAN instance to the `servers()` function (#68)
* `ds_create_dataset()` marked as deprecated; see `recourse_create()` instead (#80) (via #79)
* removed the internal `stop()` call in `tag_create()`: now can be used, though haven't been able to test this function as you need to be a sysadmin to use it (#81)
* `ds_search()`: code spacing fixes (#69)
* `resource_update()` gains more examples and tests (#66)
* CKAN API key standardization: `key` parameter now in all fxns that make http requests - and reordering of `url` and `key` params in that order across all functions (#122) (#124)
* repair ORCID links in DESCRIPTION file (#124) by Florian

### BUG FIXES

* fix to `resource_create()`: `upload` param was inappropriately a required param (#75) thanks @mingbogo
* fixes to `resource_update()`: date sent in `last_modified` in request body needed to be converted to character (#96) (thanks @jasonajones73); and the date format needed fixing (#119) (thanks @florianm)
* fix to `ckan_fetch()` - use `sf` instead of `maptools`; in addition `ckan_fetch` can now parse xlsx files in addition to xls files;  (#114) (#115) thanks @sharlagelfand
* fix to `package_search()`: this route fails if parameters that did not exist in the CKAN instance are given; internally remove parameters as needed from query params by pinging the CKAN instance for its version (#120)


ckanr 0.1.0
===========

### NEW FEATURES

* Released to CRAN.
