ckanr
=====



`ckanr` is an R client for the generic CKAN API - that is, plug in a base url for the CKAN instance of interest. 

## Installation


```r
install.packages("devtools")
devtools::install_github("sckott/ckanr")
```


```r
library('ckanr')
```

> Note: the default URL is for http://data.techno-science.ca/. You can change that in the `url` parameter

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
#> [11] "artifact-data-forestry"                                     
#> [12] "artifact-data-horology"                                     
#> [13] "artifact-data-industrial-technology"                        
#> [14] "artifact-data-lighting-technology"                          
#> [15] "artifact-data-location-canada-agriculture-and-food-museum"  
#> [16] "artifact-data-location-canada-aviation-and-space-museum"    
#> [17] "artifact-data-location-canada-science-and-technology-museum"
#> [18] "artifact-data-marine-transportation"                        
#> [19] "artifact-data-mathematics"                                  
#> [20] "artifact-data-medical-technology"                           
#> [21] "artifact-data-meteorology"                                  
#> [22] "artifact-data-metrology"                                    
#> [23] "artifact-data-mining-and-metallurgy"                        
#> [24] "artifact-data-motorized-ground-transportation"              
#> [25] "artifact-data-non-motorized-ground-transportation"          
#> [26] "artifact-data-on-loan"                                      
#> [27] "artifact-data-photography"                                  
#> [28] "artifact-data-physics"                                      
#> [29] "artifact-data-printing"                                     
#> [30] "artifact-data-railway-transportation"                       
#> [31] "artifact-dataset-fire-fighting"
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
#> 1                     28                      26
#> 2                     22                      19
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
