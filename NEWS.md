ckanr 0.3.0
===========

### NEW FEATURES

* new package maintainer Sharla Gelfand !!!
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

* Releasd to CRAN.
