ckanr
=====



[![Build Status](https://api.travis-ci.org/ropensci/ckanr.png)](https://travis-ci.org/ropensci/ckanr)
[![Build status](https://ci.appveyor.com/api/projects/status/5yqd882v4fbeggd5?svg=true)](https://ci.appveyor.com/project/sckott/ckanr)
[![codecov.io](https://codecov.io/github/ropensci/ckanr/coverage.svg?branch=master)](https://codecov.io/github/ropensci/ckanr?branch=master)
[![rstudio mirror downloads](http://cranlogs.r-pkg.org/badges/ckanr?color=FAB657)](https://github.com/metacran/cranlogs.app)
[![cran version](http://www.r-pkg.org/badges/version/ckanr)](https://cran.r-project.org/package=ckanr)

`ckanr` is an R client for the CKAN API. 

It is meant to be as general as possible, allowing you to work with any CKAN instance.

## Installation

Stable CRAN version


```r
install.packages("ckanr")
```

Development version


```r
install.packages("devtools")
devtools::install_github("ropensci/ckanr")
```


```r
library('ckanr')
```

Note: the default base CKAN URL is set to
[http://data.techno-science.ca/](http://data.techno-science.ca/).
Functions requiring write permissions in CKAN additionally require a privileged
CKAN API key.
You can change this using `ckanr_setup()`, or change the URL using the `url`
parameter in each function call.
To set one or both, run:


```r
ckanr_setup() # restores default CKAN url to http://data.techno-science.ca/
ckanr_setup(url = "http://data.techno-science.ca/")
ckanr_setup(url = "http://data.techno-science.ca/", key = "my-ckan-api-key")
```

## ckanr package API

There are a suite of CKAN things (package, resource, etc.) that each have a set of functions in this package. The functions for each CKAN thing have an S3 class that is returned from most functions, and can be passed to most other functions (this also facilitates piping). The following is a list of the function groups for certain CKAN things, with the prefix for the functions that work with that thing, and the name of the S3 class:

+ Packages (aka packages) - `package_*()` - `ckan_package`
+ Resources - `resource_*()` - `ckan_resource`
+ Related - `related_*()` - `ckan_related`
+ Users - `user_*()` - `ckan_user`
+ Groups - `group_*()` - `ckan_group`
+ Tags - `tag_*()` - `ckan_tag`
+ Organizations  - `organization_*()` - `ckan_organization`
+ Groups - `group_*()` - `ckan_group`
+ Users - `user_*()` - `ckan_user`
+ Related items - `related_*()` - `ckan_related`

The S3 class objects all look very similar; for example:

```r
<CKAN Resource> 8abc92ad-7379-4fb8-bba0-549f38a26ddb
  Name: Data From Digital Portal 
  Description: 
  Creator/Modified: 2015-08-18T19:20:59.732601 / 2015-08-18T19:20:59.657943
  Size: 
  Format: CSV 
```

All classes state the type of object, have the ID to the right of the type, then have a varying set of key-value fields deemed important. This printed object is just a summary of an R list, so you can index to specific values (e.g., `result$description`). If you feel there are important fields left out of these printed summaries, let us know.

> note: Many examples are given in brief for readme brevity

## Packages

List packages


```r
package_list(as = "table")
#>  [1] "artifact-data-agriculture"                                  
#>  [2] "artifact-data-aviation"                                     
#>  [3] "artifact-data-bookbinding"                                  
#>  [4] "artifact-data-chemistry"                                    
#>  [5] "artifact-data-communications"                               
#>  [6] "artifact-data-computing-technology"                         
#>  [7] "artifact-data-domestic-technology"                          
#>  [8] "artifact-data-energy-electric"                              
#>  [9] "artifact-data-exploration-and-survey"                       
#> [10] "artifact-data-fisheries"                                    
...
```

Show a package


```r
package_show('34d60b13-1fd5-430e-b0ec-c8bc7f4841cf')
#> <CKAN Package> 34d60b13-1fd5-430e-b0ec-c8bc7f4841cf 
#>   Title: Artifact Data - Vacuum Tubes
#>   Creator/Modified: 2014-10-28T18:12:11.453636 / 2014-11-05T21:25:16.848989
#>   Resources (up to 5): Artifact Data - Vacuum Tubes (XML), Data Dictionary, Tips (English), Tips (French)
#>   Tags (up to 5): Vacuum Tubes
#>   Groups (up to 5): communications
```

Search for packages


```r
x <- package_search(q = '*:*', rows = 2)
x$results
#> [[1]]
#> <CKAN Package> f4406699-3e11-4856-be48-b55da98b3c14 
#>   Title: Artifact Data - Horology
#>   Creator/Modified: 2014-10-28T16:50:30.068996 / 2015-03-30T15:06:55.218176
#>   Resources (up to 5): Artifact Data - Horology (XML), Data Dictionary, Tips (English), Tips (French)
#>   Tags (up to 5): Horology
#>   Groups (up to 5): scientific-instrumentation
#> 
#> [[2]]
#> <CKAN Package> 0a801729-aa94-4d76-a5e0-7b487303f4e5 
#>   Title: Artifact Data - Astronomy
#>   Creator/Modified: 2014-10-24T19:16:59.160533 / 2015-01-09T23:33:13.972898
#>   Resources (up to 5): Artifact Data - Astronomy (XML), Data Dictionary, Tips (English), Tips (French)
#>   Tags (up to 5): Astronomy, Scientific Instrumentation
#>   Groups (up to 5): scientific-instrumentation
```

## Resources

Search for resources


```r
x <- resource_search(q = 'name:data', limit = 2)
x$results
#> [[1]]
#> <CKAN Resource> e179e910-27fb-44f4-a627-99822af49ffa 
#>   Name: Artifact Data - Exploration and Survey (XML)
#>   Description: XML Dataset
#>   Creator/Modified: 2014-10-28T15:50:35.374303 / 
#>   Size: 
#>   Format: XML
#> 
#> [[2]]
#> <CKAN Resource> ba84e8b7-b388-4d2a-873a-7b107eb7f135 
#>   Name: Data Dictionary
#>   Description: Data dictionary for CSTMC artifact datasets.
#>   Creator/Modified: 2014-11-03T18:01:02.094210 / 
#>   Size: 
#>   Format: XLS
```

## Users

List users


```r
user_list()[1:2]
#> [[1]]
#> <CKAN User> ee100ca6-2363-4db8-b24b-066e865c33ec 
#>   Name: CSTMC
#>   Display Name: CSTMC
#>   Full Name: 
#>   No. Packages: 
#>   No. Edits: 0
#>   Created: 2014-10-16T18:15:03.685929
#> 
#> [[2]]
#> <CKAN User> de64d5d4-86ab-4510-820b-f0bd86ea7a79 
#>   Name: default
#>   Display Name: default
#>   Full Name: 
#>   No. Packages: 
#>   No. Edits: 0
#>   Created: 2014-03-20T02:55:40.628968
```

## Groups

List groups


```r
group_list(as = 'table')[, 1:3]
#>                         display_name description
#> 1                     Communications            
#> 2 Domestic and Industrial Technology            
#> 3                         Everything            
#> 4                           Location            
#> 5                          Resources            
#> 6         Scientific Instrumentation            
#> 7                     Transportation            
#>                                title
#> 1                     Communications
#> 2 Domestic and Industrial Technology
#> 3                         Everything
#> 4                           Location
#> 5                          Resources
#> 6         Scientific Instrumentation
#> 7                     Transportation
```

Show a group


```r
group_show('communications', as = 'table')$users
#>   openid about capacity     name                    created
#> 1     NA  <NA>    admin     marc 2014-10-24T14:44:29.885262
#> 2     NA          admin sepandar 2014-10-23T19:40:42.056418
#>                         email_hash sysadmin
#> 1 a32002c960476614370a16e9fb81f436    FALSE
#> 2 10b930a228afd1da2647d62e70b71bf8     TRUE
#>   activity_streams_email_notifications  state number_of_edits
#> 1                                FALSE active             379
#> 2                                FALSE active              44
#>   number_administered_packages display_name fullname
#> 1                           39         marc     <NA>
#> 2                            1     sepandar         
#>                                     id
#> 1 27778230-2e90-4818-9f00-bbf778c8fa09
#> 2 b50449ea-1dcc-4d52-b620-fc95bf56034b
```

## Tags

List tags


```r
tag_list('aviation', as = 'table')
#>   vocabulary_id                     display_name
#> 1            NA                         Aviation
#> 2            NA Canada Aviation and Space Museum
#>                                     id                             name
#> 1 cc1db2db-b08b-4888-897f-a17eade2461b                         Aviation
#> 2 8d05a650-bc7b-4b89-bcc8-c10177e60119 Canada Aviation and Space Museum
```

Show tags


```r
tag_show('Aviation')$packages[[1]][1:3]
#> $owner_org
#> [1] "fafa260d-e2bf-46cd-9c35-34c1dfa46c57"
#> 
#> $maintainer
#> [1] ""
#> 
#> $relationships_as_object
#> list()
```

## Organizations

List organizations


```r
organization_list()
#> [[1]]
#> <CKAN Organization> fafa260d-e2bf-46cd-9c35-34c1dfa46c57 
#>   Name: cstmc
#>   Display name: CSTMC
#>   No. Packages: 
#>   No. Users: 0
```

## Examples of different CKAN APIs

See `ckanr::servers()` for a list of CKAN servers. Ther are 124 as of 2015-10-21.

### The Natural History Museum

Website: [http://data.nhm.ac.uk/](http://data.nhm.ac.uk/)


```r
ckanr_setup(url = "http://data.nhm.ac.uk")
x <- package_search(q = '*:*', rows = 1)
x$results
#> [[1]]
#> <CKAN Package> 56e711e6-c847-4f99-915a-6894bb5c5dea 
#>   Title: Collection specimens
#>   Creator/Modified: 2014-12-08T16:39:22.346941 / 2015-09-30T13:42:02.859838
#>   Resources (up to 5): Specimens
#>   Tags (up to 5): 
#>   Groups (up to 5):
NA
```

### The National Geothermal Data System

Website: [http://geothermaldata.org/](http://geothermaldata.org/)


```r
ckanr_setup("http://search.geothermaldata.org")
x <- package_search(q = '*:*', rows = 1)
x$results
#> [[1]]
#> <CKAN Package> 428701c7-1b99-424a-a2ae-829cfe37794c 
#>   Title: Pagosa Springs borehole lithology intervals
#>   Creator/Modified: 2015-10-08T20:37:41.620696 / 2015-10-08T20:38:56.525277
#>   Resources (up to 5): Borehole Lithology of Pagosa Springs Temperature Gradient wells
#>   Tags (up to 5): 
#>   Groups (up to 5):
NA
```

## Meta

* Please [report any issues or bugs](https://github.com/ropensci/ckanr/issues).
* License: MIT
* Get citation information for `ckanr` in R doing `citation(package = 'ckanr')`
* Please note that this project is released with a [Contributor Code of Conduct](CONDUCT.md). By participating in this project you agree to abide by its terms.

[![ropensci](http://ropensci.org/public_images/github_footer.png)](http://ropensci.org)
