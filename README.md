ckanr
=====



[![Build Status](https://api.travis-ci.org/ropensci/ckanr.png)](https://travis-ci.org/ropensci/ckanr)
[![Build status](https://ci.appveyor.com/api/projects/status/5yqd882v4fbeggd5?svg=true)](https://ci.appveyor.com/project/sckott/ckanr)

`ckanr` is an R client for the generic CKAN API - that is, plug in a base url for the CKAN instance of interest. 

## Installation


```r
install.packages("devtools")
devtools::install_github("ropensci/ckanr")
```


```r
library('ckanr')
```

Note: the default base CKAN URL is set to [http://data.techno-science.ca/](http://data.techno-science.ca/). You can change this using `set_ckanr_url()`.

## Changes


```r
changes(limit = 2, as = "table")
#>                                user_id                  timestamp
#> 1 b50449ea-1dcc-4d52-b620-fc95bf56034b 2014-11-06T18:58:08.001743
#> 2 b50449ea-1dcc-4d52-b620-fc95bf56034b 2014-11-06T18:55:55.059527
#>                              object_id
#> 1 cc6a523c-cecf-4a95-836b-295a11ce2bce
#> 2 cc6a523c-cecf-4a95-836b-295a11ce2bce
#>                            revision_id data.package.maintainer
#> 1 5d11079e-fc05-4121-9fd5-fe086f5e5f33                        
#> 2 4a591538-0584-487b-8ed1-3260d1d09d77                        
#>   data.package.name data.package.metadata_modified data.package.author
#> 1              test     2014-11-06T18:55:54.772675                    
#> 2              test     2014-11-06T18:55:54.772675                    
#>   data.package.url data.package.notes               data.package.owner_org
#> 1                                     fafa260d-e2bf-46cd-9c35-34c1dfa46c57
#> 2                                     fafa260d-e2bf-46cd-9c35-34c1dfa46c57
#>   data.package.private data.package.maintainer_email
#> 1                FALSE                              
#> 2                FALSE                              
#>   data.package.author_email data.package.state data.package.version
#> 1                                      deleted                     
#> 2                                       active                     
#>           data.package.creator_user_id
#> 1 b50449ea-1dcc-4d52-b620-fc95bf56034b
#> 2 b50449ea-1dcc-4d52-b620-fc95bf56034b
#>                        data.package.id data.package.title
#> 1 cc6a523c-cecf-4a95-836b-295a11ce2bce               test
#> 2 cc6a523c-cecf-4a95-836b-295a11ce2bce               test
#>               data.package.revision_id data.package.type
#> 1 5d11079e-fc05-4121-9fd5-fe086f5e5f33           dataset
#> 2 4a591538-0584-487b-8ed1-3260d1d09d77           dataset
#>   data.package.license_id                                   id
#> 1            notspecified 59c308c8-68b2-4b92-bc57-129378d31882
#> 2            notspecified a8577e2c-f742-49c2-bef3-ca3299e58704
#>     activity_type
#> 1 deleted package
#> 2 changed package
```

## List datasets


```r
datasets(as = "table")
#> Error in eval(expr, envir, enclos): could not find function "datasets"
```

## List tags


```r
tag_list('aviation', as='table')
#>   vocabulary_id                     display_name
#> 1            NA                         Aviation
#> 2            NA Canada Aviation and Space Museum
#>                                     id                             name
#> 1 cc1db2db-b08b-4888-897f-a17eade2461b                         Aviation
#> 2 8d05a650-bc7b-4b89-bcc8-c10177e60119 Canada Aviation and Space Museum
```

## Show tags

Subset for readme brevity


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

## List groups


```r
group_list(as='table')
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
#>                                                                   image_display_url
#> 1       http://data.techno-science.ca/uploads/group/20141024-162305.6896412comm.jpg
#> 2    http://data.techno-science.ca/uploads/group/20141024-162324.3636615domtech.jpg
#> 3 http://data.techno-science.ca/uploads/group/20141024-162448.0656596everything.jpg
#> 4   http://data.techno-science.ca/uploads/group/20141024-162528.8786547location.jpg
#> 5     http://data.techno-science.ca/uploads/group/20141024-162608.3732604resour.jpg
#> 6    http://data.techno-science.ca/uploads/group/20141024-162549.1925831sciinst.jpg
#> 7  http://data.techno-science.ca/uploads/group/20141024-162624.1872823transport.jpg
#>   approval_status is_organization  state
#> 1        approved           FALSE active
#> 2        approved           FALSE active
#> 3        approved           FALSE active
#> 4        approved           FALSE active
#> 5        approved           FALSE active
#> 6        approved           FALSE active
#> 7        approved           FALSE active
#>                               image_url
#> 1       20141024-162305.6896412comm.jpg
#> 2    20141024-162324.3636615domtech.jpg
#> 3 20141024-162448.0656596everything.jpg
#> 4   20141024-162528.8786547location.jpg
#> 5     20141024-162608.3732604resour.jpg
#> 6    20141024-162549.1925831sciinst.jpg
#> 7  20141024-162624.1872823transport.jpg
#>                            revision_id packages  type
#> 1 cc302424-2e68-4fcc-9a3a-6de60748c2e4        5 group
#> 2 b7d95b87-5999-45f9-8775-c64094842551        2 group
#> 3 c2f0c59a-a543-4d67-a61f-4f387068ba53        1 group
#> 4 6816d571-d2bd-4131-b99d-80e7e6797492        4 group
#> 5 e37ee30d-577b-4349-8f0e-eaa4543497e8        6 group
#> 6 74eba42e-08b3-4400-b40f-3d6159ae6e9d       10 group
#> 7 a6cc4aab-eae9-42ba-9ab4-cbf45d5c6a0e        7 group
#>                                     id                               name
#> 1 5268ce18-e3b8-4802-b29e-30740b46e52d                     communications
#> 2 5a9a8095-9e0c-485e-84f6-77f577607991 domestic-and-industrial-technology
#> 3 d7dd233e-a1cc-43da-8152-f7ed15d26756                         everything
#> 4 770fc9c0-d4f3-48b0-a4ee-e00c6882df1d                           location
#> 5 f6c205de-cc95-4308-ac9f-5a63f1a5c7ee                          resources
#> 6 b98ff457-2031-48b6-b681-9adb3afc501b         scientific-instrumentation
#> 7 a73bf7be-310d-472e-83e1-43a3d87602ba                     transportation
```

## Show groups

Subset for readme brevity


```r
group_show('communications', as='table')$users
#>   openid about capacity     name                    created
#> 1     NA  <NA>    admin     marc 2014-10-24T14:44:29.885262
#> 2     NA          admin sepandar 2014-10-23T19:40:42.056418
#>                         email_hash sysadmin
#> 1 a32002c960476614370a16e9fb81f436    FALSE
#> 2 10b930a228afd1da2647d62e70b71bf8     TRUE
#>   activity_streams_email_notifications  state number_of_edits
#> 1                                FALSE active             376
#> 2                                FALSE active              44
#>   number_administered_packages display_name fullname
#> 1                           39         marc     <NA>
#> 2                            1     sepandar         
#>                                     id
#> 1 27778230-2e90-4818-9f00-bbf778c8fa09
#> 2 b50449ea-1dcc-4d52-b620-fc95bf56034b
```

## Show a package


```r
package_show('34d60b13-1fd5-430e-b0ec-c8bc7f4841cf', as='table')$resources
#>                      resource_group_id cache_last_updated
#> 1 ea8533d9-cdc6-4e0e-97b9-894e06d50b92                 NA
#> 2 ea8533d9-cdc6-4e0e-97b9-894e06d50b92                 NA
#> 3 ea8533d9-cdc6-4e0e-97b9-894e06d50b92                 NA
#> 4 ea8533d9-cdc6-4e0e-97b9-894e06d50b92                 NA
#>           revision_timestamp webstore_last_updated
#> 1 2014-10-28T18:13:22.213530                    NA
#> 2 2014-11-04T02:59:50.567068                    NA
#> 3 2014-11-05T21:23:58.533397                    NA
#> 4 2014-11-05T21:25:16.848423                    NA
#>                                     id size  state hash
#> 1 be2b0af8-24a8-4a55-8b30-89f5459b713a   NA active     
#> 2 7d65910e-4bdc-4f06-a213-e24e36762767   NA active     
#> 3 97622ad7-1507-4f6a-8acb-14e826447389   NA active     
#> 4 7a72498a-c49c-4e84-8b10-58991de10df6   NA active     
#>                                    description format
#> 1                                  XML Dataset    XML
#> 2 Data dictionary for CSTMC artifact datasets.    XLS
#> 3       Tips for using the artifacts datasets.   .php
#> 4       Tips for using the artifacts datasets.   .php
#>   tracking_summary.total tracking_summary.recent mimetype_inner url_type
#> 1                      0                       0             NA       NA
#> 2                      0                       0             NA       NA
#> 3                      0                       0             NA       NA
#> 4                      0                       0             NA       NA
#>   mimetype cache_url                               name
#> 1       NA        NA Artifact Data - Vacuum Tubes (XML)
#> 2       NA        NA                    Data Dictionary
#> 3       NA        NA                     Tips (English)
#> 4       NA        NA                      Tips (French)
#>                      created
#> 1 2014-10-28T18:13:22.240393
#> 2 2014-11-04T02:59:50.643658
#> 3 2014-11-04T18:14:23.952937
#> 4 2014-11-05T21:25:16.887796
#>                                                                                                                                                    url
#> 1                         http://source.techno-science.ca/datasets-donn%C3%A9es/artifacts-artefacts/groups-groupes/vacuum-tubes-tubes-electronique.xml
#> 2 http://source.techno-science.ca/datasets-donn%C3%A9es/artifacts-artefacts/cstmc-artifact-data-dictionary-dictionnaire-de-donnees-artefacts-smstc.xls
#> 3                                                                          http://techno-science.ca/en/open-data/tips-using-artifact-open-data-set.php
#> 4                                                                 http://techno-science.ca/fr/donnees-ouvertes/conseils-donnees-ouvertes-artefacts.php
#>   webstore_url last_modified position                          revision_id
#> 1           NA            NA        0 9a27d884-f181-4842-ab47-cda35a8bf99a
#> 2           NA            NA        1 5d27b3e6-7870-4c12-a122-9e9f5adee4a0
#> 3           NA            NA        2 40993f16-402b-439c-9288-2f2b177e4b8f
#> 4           NA            NA        3 57f1488e-a140-4eb6-9329-fc13202a73af
#>   resource_type
#> 1            NA
#> 2            NA
#> 3            NA
#> 4            NA
```

## Search for packages


```r
out <- package_search(q = '*:*', rows = 2, as="table")$results
out[, !names(out) %in% 'resources']
#>                      license_title maintainer relationships_as_object
#> 1 Open Government Licence - Canada                               NULL
#> 2 Open Government Licence - Canada                               NULL
#>   private maintainer_email         revision_timestamp
#> 1   FALSE                  2014-11-05T23:17:46.220002
#> 2   FALSE                  2014-11-05T23:17:04.923594
#>                                     id           metadata_created
#> 1 35d5484d-38ce-495e-8722-7857c4fd17bf 2014-10-28T20:13:11.572558
#> 2 da65507d-b018-4d3b-bde3-5419cf29d144 2014-10-28T14:59:21.386177
#>            metadata_modified author author_email  state version
#> 1 2014-11-05T23:17:46.220657                     active        
#> 2 2014-11-05T23:17:04.924229                     active        
#>                        creator_user_id    type num_resources
#> 1 27778230-2e90-4818-9f00-bbf778c8fa09 dataset             4
#> 2 27778230-2e90-4818-9f00-bbf778c8fa09 dataset             4
#>                                                                                                                       tags
#> 1                         NA, Location, Location, 2014-10-28T20:13:11.572558, active, da88c5a2-3766-41ea-a75b-9c87047cc528
#> 2 NA, Computing Technology, Computing Technology, 2014-10-28T14:59:21.386177, active, 5371dc28-9ce8-4f21-9afb-1f155f132bfe
#>   tracking_summary.total tracking_summary.recent
#> 1                     42                       3
#> 2                     27                       3
#>                                                                                                                                                                                                       groups
#> 1                                                      Location, , http://data.techno-science.ca/uploads/group/20141024-162528.8786547location.jpg, Location, 770fc9c0-d4f3-48b0-a4ee-e00c6882df1d, location
#> 2 Scientific Instrumentation, , http://data.techno-science.ca/uploads/group/20141024-162549.1925831sciinst.jpg, Scientific Instrumentation, b98ff457-2031-48b6-b681-9adb3afc501b, scientific-instrumentation
#>   license_id relationships_as_subject num_tags organization.description
#> 1 ca-ogl-lgo                     NULL        1                         
#> 2 ca-ogl-lgo                     NULL        1                         
#>         organization.created organization.title organization.name
#> 1 2014-10-24T14:49:36.878579              CSTMC             cstmc
#> 2 2014-10-24T14:49:36.878579              CSTMC             cstmc
#>   organization.revision_timestamp organization.is_organization
#> 1      2014-10-24T14:49:36.813670                         TRUE
#> 2      2014-10-24T14:49:36.813670                         TRUE
#>   organization.state organization.image_url
#> 1             active                       
#> 2             active                       
#>               organization.revision_id organization.type
#> 1 7a325a56-46f1-419c-b7b2-ec7501edb35a      organization
#> 2 7a325a56-46f1-419c-b7b2-ec7501edb35a      organization
#>                        organization.id organization.approval_status
#> 1 fafa260d-e2bf-46cd-9c35-34c1dfa46c57                     approved
#> 2 fafa260d-e2bf-46cd-9c35-34c1dfa46c57                     approved
#>                                                          name isopen url
#> 1 artifact-data-location-canada-science-and-technology-museum  FALSE    
#> 2                          artifact-data-computing-technology  FALSE    
#>                                                                                                                                                                        notes
#> 1 This dataset includes artifacts in the collection of the Canada Science and Technology Museums Corporation that are currently in the Canada Science and Technology Museum.
#> 2                                This dataset includes artifacts in the collection of the Canada Science and Technology Museums Corporation related to computing technology.
#>                              owner_org extras
#> 1 fafa260d-e2bf-46cd-9c35-34c1dfa46c57   NULL
#> 2 fafa260d-e2bf-46cd-9c35-34c1dfa46c57   NULL
#>                                            license_url
#> 1 http://data.gc.ca/eng/open-government-licence-canada
#> 2 http://data.gc.ca/eng/open-government-licence-canada
#>                                                             title
#> 1 Artifact Data - Location - Canada Science and Technology Museum
#> 2                            Artifact Data - Computing Technology
#>                            revision_id
#> 1 694a977a-c238-47a4-8671-caddca4edfca
#> 2 858cb240-76a0-406a-800c-e4ae6cc56ab9
```

## Search for resources


```r
resource_search(q = 'name:data', limit = 2, as='table')
#> $count
#> [1] 71
#> 
#> $results
#>                      resource_group_id cache_last_updated
#> 1 01a82e52-01bf-4a9c-9b45-c4f9b92529fa                 NA
#> 2 01a82e52-01bf-4a9c-9b45-c4f9b92529fa                 NA
#>   webstore_last_updated                                   id size  state
#> 1                    NA e179e910-27fb-44f4-a627-99822af49ffa   NA active
#> 2                    NA ba84e8b7-b388-4d2a-873a-7b107eb7f135   NA active
#>   last_modified hash                                  description format
#> 1            NA                                       XML Dataset    XML
#> 2            NA      Data dictionary for CSTMC artifact datasets.    XLS
#>   mimetype_inner url_type mimetype cache_url
#> 1             NA       NA       NA        NA
#> 2             NA       NA       NA        NA
#>                                           name                    created
#> 1 Artifact Data - Exploration and Survey (XML) 2014-10-28T15:50:35.374303
#> 2                              Data Dictionary 2014-11-03T18:01:02.094210
#>                                                                                                                                                    url
#> 1              http://source.techno-science.ca/datasets-donn%C3%A9es/artifacts-artefacts/groups-groupes/exploration-and-survey-exploration-et-leve.xml
#> 2 http://source.techno-science.ca/datasets-donn%C3%A9es/artifacts-artefacts/cstmc-artifact-data-dictionary-dictionnaire-de-donnees-artefacts-smstc.xls
#>   webstore_url position                          revision_id resource_type
#> 1           NA        0 a22e6741-3e89-4db0-a802-ba594b1c1fad            NA
#> 2           NA        1 da1f8585-521d-47ef-8ead-7832474a3421            NA
```

## Examples of different CKAN APIs

### The Natural History Museum

Website: [http://data.nhm.ac.uk/](http://data.nhm.ac.uk/)

List datasets


```r
nhmbase <- "http://data.nhm.ac.uk"
package_list(as = "table", url = nhmbase)
#> [1] "bioacoustica"                               
#> [2] "collection-artefacts"                       
#> [3] "collection-indexlots"                       
#> [4] "collection-specimens"                       
#> [5] "crowdsourcing-the-collection"               
#> [6] "natural-history-museum-library-and-archives"
#> [7] "natural-history-museum-picture-library"     
#> [8] "notes-from-nature"
```

List tags


```r
tag_list(as="table", url = nhmbase)
#>    vocabulary_id         display_name                                   id
#> 1             NA           arthropods f9245868-f4cb-4c85-a59d-11692db19e86
#> 2             NA         bioacoustics 11faa593-7ccb-4a6f-8a97-c88ca8939624
#> 3             NA         biodiversity bd09adfa-22d6-4318-9883-dde4595bcd10
#> 4             NA                  nbn 9ba85356-a041-432f-8470-44de5b7a64dc
#> 5             NA    Science uncovered 39440d40-f005-47c0-a8ae-2ac52a720236
#> 6             NA                sound 4ae4457a-0f0e-4e0d-a168-cc27969ecd20
#> 7             NA               su2014 0283e601-ae8a-4772-8031-4c76688bd4d3
#> 8             NA             taxonomy c091064c-81c2-4cc8-a54e-2ff8ca8e28b0
#> 9             NA                 uksi 3ffcd635-7f59-4401-9843-93e51f525701
#> 10            NA uk species inventory 96ddf4fe-af85-4b31-93fa-13cc483ae24e
#>                    name
#> 1            arthropods
#> 2          bioacoustics
#> 3          biodiversity
#> 4                   nbn
#> 5     Science uncovered
#> 6                 sound
#> 7                su2014
#> 8              taxonomy
#> 9                  uksi
#> 10 uk species inventory
```


```r
tag_show('arthropods', as='table', url = nhmbase)
#> $vocabulary_id
#> NULL
#> 
#> $packages
#> list()
#> 
#> $display_name
#> [1] "arthropods"
#> 
#> $id
#> [1] "f9245868-f4cb-4c85-a59d-11692db19e86"
#> 
#> $name
#> [1] "arthropods"
```

Packages


```r
package_search(q = '*:*', rows = 2, as='table', url = nhmbase)
#> $count
#> [1] 8
#> 
#> $sort
#> [1] "promoted asc, metadata_modified desc"
#> 
#> $facets
#> named list()
#> 
#> $results
#>             license_title maintainer relationships_as_object private
#> 1 Creative Commons CCZero         NA                    NULL   FALSE
#> 2 Creative Commons CCZero         NA                    NULL   FALSE
#>   maintainer_email num_tags update_frequency
#> 1               NA        1           weekly
#> 2               NA        1           weekly
#>                                     id           metadata_created
#> 1 56e711e6-c847-4f99-915a-6894bb5c5dea 2014-12-08T16:39:22.346941
#> 2 9dfb777e-2296-4800-a053-b1c80fd30bac 2014-12-15T13:20:25.858259
#>            metadata_modified                 author author_email
#> 1 2014-12-19T13:04:02.494218 Natural History Museum             
#> 2 2014-12-19T12:35:21.910176 Natural History Museum         <NA>
#>   temporal_extent  state version
#> 1                 active      NA
#> 2                 active      NA
#>                                                                                  spatial
#> 1 {"type":"Polygon","coordinates":[[[-180,82],[180,82],[180,-82],[-180,-82],[-180,82]]]}
#> 2                                                                                       
#>   license_id    type
#> 1    cc-zero dataset
#> 2    cc-zero dataset
#>                                                                                                                                                                                                                                                                                                                                                                                                                                              resources
#> 1                                                             fefa4aca-61e0-4978-9507-040db59c1641, datastore, NA, 2014-12-19T13:04:02.486957, NA, associatedMedia, 05ff2255-c38a-40c9-b657-4ccb55ab2feb, NA, cc-by, active, , Specimen records, dwc, 0, 0, NA, None, NA, NA, Specimens, 2014-12-08T16:43:25.016679, /datastore/dump/05ff2255-c38a-40c9-b657-4ccb55ab2feb, NA, 2014-12-19T13:04:01.320379, 0, 1c5ddbf8-f085-40d2-9ea7-69a76cf008e9, NA
#> 2 c0775a70-a11b-4fb0-8c70-bf7830cd5bc3, datastore, NA, 2014-12-19T12:35:21.908374, NA, None, bb909597-dedf-427d-8c04-4c02b3a24db3, NA, , active, , Species level record denoting the presence of a taxon in the Museum collection., CSV, 0, 0, NA, Catalogue number, NA, NA, Index Lots, 2014-12-15T13:20:27.010266, /datastore/dump/bb909597-dedf-427d-8c04-4c02b3a24db3, NA, 2014-12-19T12:35:20.825106, 0, b6335919-3896-4161-8add-0fd9848a56ca, NA
#>   num_resources tracking_summary.total tracking_summary.recent
#> 1             1                     10                      10
#> 2             1                     13                      13
#>   dataset_type groups                      creator_user_id
#> 1  Collections   NULL adf402e6-f82f-4545-8bbe-68634a349107
#> 2  Collections   NULL adf402e6-f82f-4545-8bbe-68634a349107
#>   relationships_as_subject         revision_timestamp
#> 1                     NULL 2014-12-16T10:56:07.533454
#> 2                     NULL 2014-12-15T13:20:25.858259
#>   organization.description       organization.created
#> 1                          2014-12-08T16:35:24.247079
#> 2                          2014-12-08T16:35:24.247079
#>       organization.title organization.name organization.revision_timestamp
#> 1 Natural History Museum               nhm      2014-12-08T16:35:24.188888
#> 2 Natural History Museum               nhm      2014-12-08T16:35:24.188888
#>   organization.is_organization organization.state organization.image_url
#> 1                         TRUE             active                       
#> 2                         TRUE             active                       
#>               organization.revision_id organization.type
#> 1 a11d1487-e85b-453a-9ea7-d5ed17f875ed      organization
#> 2 a11d1487-e85b-453a-9ea7-d5ed17f875ed      organization
#>                        organization.id organization.approval_status
#> 1 7854c918-d7eb-4341-96e9-3adfb8d636a0                     approved
#> 2 7854c918-d7eb-4341-96e9-3adfb8d636a0                     approved
#>                   name isopen url
#> 1 collection-specimens   TRUE  NA
#> 2 collection-indexlots   TRUE  NA
#>                                                            notes
#> 1  Specimen records from the Natural History Museum's collection
#> 2 Index Lot records from the Natural History Museum's collection
#>                              owner_org
#> 1 7854c918-d7eb-4341-96e9-3adfb8d636a0
#> 2 7854c918-d7eb-4341-96e9-3adfb8d636a0
#>                                      license_url promoted
#> 1 http://www.opendefinition.org/licenses/cc-zero     True
#> 2 http://www.opendefinition.org/licenses/cc-zero     <NA>
#>                  title                          revision_id
#> 1 Collection specimens 406f4a2c-1bd7-4474-bb9c-68b71d60925e
#> 2 Index Lot collection 85a92d0f-4081-4c58-a4be-2f27a7aced41
#> 
#> $search_facets
#> named list()
```


```r
package_show(id = "56e711e6-c847-4f99-915a-6894bb5c5dea", as="table", url = nhmbase)
#> $domain
#> [1] "data.nhm.ac.uk"
#> 
#> $owner_org
#> [1] "7854c918-d7eb-4341-96e9-3adfb8d636a0"
#> 
#> $maintainer
#> NULL
#> 
#> $relationships_as_object
#> list()
#> 
#> $private
#> [1] FALSE
#> 
#> $maintainer_email
#> NULL
#> 
#> $revision_timestamp
#> [1] "2014-12-16T10:56:07.533454"
#> 
#> $id
#> [1] "56e711e6-c847-4f99-915a-6894bb5c5dea"
#> 
#> $metadata_created
#> [1] "2014-12-08T16:39:22.346941"
#> 
#> $metadata_modified
#> [1] "2014-12-19T13:04:02.494218"
#> 
#> $author
#> [1] "Natural History Museum"
#> 
#> $author_email
#> [1] ""
#> 
#> $state
#> [1] "active"
#> 
#> $version
#> NULL
#> 
#> $creator_user_id
#> [1] "adf402e6-f82f-4545-8bbe-68634a349107"
#> 
#> $type
#> [1] "dataset"
#> 
#> $resources
#>                      resource_group_id _title_field cache_last_updated
#> 1 fefa4aca-61e0-4978-9507-040db59c1641         None                 NA
#>           revision_timestamp webstore_last_updated webstore_url
#> 1 2014-12-19T13:04:02.486957                    NA           NA
#>   datastore_active                                   id size
#> 1             TRUE 05ff2255-c38a-40c9-b657-4ccb55ab2feb   NA
#>   _image_licence  state hash      description format
#> 1          cc-by active      Specimen records    dwc
#>   tracking_summary.total tracking_summary.recent mimetype_inner  url_type
#> 1                      0                       0             NA datastore
#>   mimetype cache_url      name                    created
#> 1       NA        NA Specimens 2014-12-08T16:43:25.016679
#>                                                    url    _image_field
#> 1 /datastore/dump/05ff2255-c38a-40c9-b657-4ccb55ab2feb associatedMedia
#>                last_modified position                          revision_id
#> 1 2014-12-19T13:04:01.320379        0 1c5ddbf8-f085-40d2-9ea7-69a76cf008e9
#>   resource_type
#> 1            NA
#> 
#> $num_resources
#> [1] 1
#> 
#> $tags
#>                          vocabulary_id display_name        name
#> 1 7e4e2739-1697-4c99-82ee-e3c9fdebc468  Collections Collections
#>           revision_timestamp  state                                   id
#> 1 2014-12-08T16:39:22.346941 active d0ce043d-f8b5-4c57-9fad-58640b764f63
#> 
#> $title
#> [1] "Collection specimens"
#> 
#> $tracking_summary
#> $tracking_summary$total
#> [1] 129
#> 
#> $tracking_summary$recent
#> [1] 94
#> 
#> 
#> $groups
#> list()
#> 
#> $license_id
#> [1] "cc-zero"
#> 
#> $relationships_as_subject
#> list()
#> 
#> $validated_data_dict
#> [1] "{\"owner_org\": \"7854c918-d7eb-4341-96e9-3adfb8d636a0\", \"maintainer\": null, \"relationships_as_object\": [], \"private\": false, \"maintainer_email\": null, \"num_tags\": 1, \"update_frequency\": \"weekly\", \"id\": \"56e711e6-c847-4f99-915a-6894bb5c5dea\", \"metadata_created\": \"2014-12-08T16:39:22.346941\", \"metadata_modified\": \"2014-12-19T13:04:02.494218\", \"author\": \"Natural History Museum\", \"author_email\": \"\", \"temporal_extent\": \"\", \"state\": \"active\", \"version\": null, \"spatial\": \"{\\\"type\\\":\\\"Polygon\\\",\\\"coordinates\\\":[[[-180,82],[180,82],[180,-82],[-180,-82],[-180,82]]]}\", \"license_id\": \"cc-zero\", \"type\": \"dataset\", \"resources\": [{\"resource_group_id\": \"fefa4aca-61e0-4978-9507-040db59c1641\", \"url_type\": \"datastore\", \"cache_last_updated\": null, \"revision_timestamp\": \"2014-12-19T13:04:02.486957\", \"webstore_last_updated\": null, \"webstore_url\": null, \"id\": \"05ff2255-c38a-40c9-b657-4ccb55ab2feb\", \"size\": null, \"_image_licence\": \"cc-by\", \"state\": \"active\", \"hash\": \"\", \"description\": \"Specimen records\", \"format\": \"dwc\", \"tracking_summary\": {\"total\": 0, \"recent\": 0}, \"mimetype_inner\": null, \"_title_field\": \"None\", \"mimetype\": null, \"cache_url\": null, \"name\": \"Specimens\", \"created\": \"2014-12-08T16:43:25.016679\", \"url\": \"/datastore/dump/05ff2255-c38a-40c9-b657-4ccb55ab2feb\", \"_image_field\": \"associatedMedia\", \"last_modified\": \"2014-12-19T13:04:01.320379\", \"position\": 0, \"revision_id\": \"1c5ddbf8-f085-40d2-9ea7-69a76cf008e9\", \"resource_type\": null}], \"num_resources\": 1, \"title\": \"Collection specimens\", \"tracking_summary\": {\"total\": 10, \"recent\": 10}, \"dataset_type\": [\"Collections\"], \"groups\": [], \"creator_user_id\": \"adf402e6-f82f-4545-8bbe-68634a349107\", \"relationships_as_subject\": [], \"revision_timestamp\": \"2014-12-16T10:56:07.533454\", \"name\": \"collection-specimens\", \"isopen\": true, \"url\": null, \"notes\": \"Specimen records from the Natural History Museum's collection\", \"license_title\": \"Creative Commons CCZero\", \"license_url\": \"http://www.opendefinition.org/licenses/cc-zero\", \"promoted\": \"True\", \"organization\": {\"description\": \"\", \"title\": \"Natural History Museum\", \"created\": \"2014-12-08T16:35:24.247079\", \"approval_status\": \"approved\", \"revision_timestamp\": \"2014-12-08T16:35:24.188888\", \"is_organization\": true, \"state\": \"active\", \"image_url\": \"\", \"revision_id\": \"a11d1487-e85b-453a-9ea7-d5ed17f875ed\", \"type\": \"organization\", \"id\": \"7854c918-d7eb-4341-96e9-3adfb8d636a0\", \"name\": \"nhm\"}, \"revision_id\": \"406f4a2c-1bd7-4474-bb9c-68b71d60925e\"}"
#> 
#> $num_tags
#> [1] 1
#> 
#> $doi
#> [1] "10.5519/0002965"
#> 
#> $name
#> [1] "collection-specimens"
#> 
#> $isopen
#> [1] TRUE
#> 
#> $url
#> NULL
#> 
#> $notes
#> [1] "Specimen records from the Natural History Museum's collection"
#> 
#> $license_title
#> [1] "Creative Commons CCZero"
#> 
#> $extras
#>                             package_id
#> 1 56e711e6-c847-4f99-915a-6894bb5c5dea
#> 2 56e711e6-c847-4f99-915a-6894bb5c5dea
#> 3 56e711e6-c847-4f99-915a-6894bb5c5dea
#> 4 56e711e6-c847-4f99-915a-6894bb5c5dea
#>                                                                                    value
#> 1                                                                                   True
#> 2 {"type":"Polygon","coordinates":[[[-180,82],[180,82],[180,-82],[-180,-82],[-180,82]]]}
#> 3                                                                                       
#> 4                                                                                 weekly
#>           revision_timestamp  state              key
#> 1 2014-12-17T10:25:53.896847 active         promoted
#> 2 2014-12-15T13:00:35.296296 active          spatial
#> 3 2014-12-08T16:39:22.346941 active  temporal_extent
#> 4 2014-12-08T16:39:22.346941 active update_frequency
#>                            revision_id
#> 1 3c599446-214f-462f-be0e-0f7abc2f2d8b
#> 2 04dc3a9b-d2e8-4d29-95ca-3877b59f8ecb
#> 3 74152f29-bd09-4633-8d23-e773e727dfdf
#> 4 74152f29-bd09-4633-8d23-e773e727dfdf
#>                                     id
#> 1 f9441b1b-2bf0-4e85-943b-718c8ced51b9
#> 2 7c3fb58e-bb2d-4335-bc7c-ec9f8627a188
#> 3 fc8ac857-8784-4daa-983c-23152f822615
#> 4 be39fa30-3dd4-4558-bbc7-edea6b3cd41c
#> 
#> $license_url
#> [1] "http://www.opendefinition.org/licenses/cc-zero"
#> 
#> $organization
#> $organization$description
#> [1] ""
#> 
#> $organization$created
#> [1] "2014-12-08T16:35:24.247079"
#> 
#> $organization$title
#> [1] "Natural History Museum"
#> 
#> $organization$name
#> [1] "nhm"
#> 
#> $organization$revision_timestamp
#> [1] "2014-12-08T16:35:24.188888"
#> 
#> $organization$is_organization
#> [1] TRUE
#> 
#> $organization$state
#> [1] "active"
#> 
#> $organization$image_url
#> [1] ""
#> 
#> $organization$revision_id
#> [1] "a11d1487-e85b-453a-9ea7-d5ed17f875ed"
#> 
#> $organization$type
#> [1] "organization"
#> 
#> $organization$id
#> [1] "7854c918-d7eb-4341-96e9-3adfb8d636a0"
#> 
#> $organization$approval_status
#> [1] "approved"
#> 
#> 
#> $revision_id
#> [1] "406f4a2c-1bd7-4474-bb9c-68b71d60925e"
```

## Meta

* Please [report any issues or bugs](https://github.com/ropensci/ckanr/issues).
* License: MIT
* Get citation information for `ckanr` in R doing `citation(package = 'ckanr')`

[![ropensci](http://ropensci.org/public_images/github_footer.png)](http://ropensci.org)
