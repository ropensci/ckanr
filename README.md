ckanr
=====



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
#> 1 912a30c8-8915-4e6d-a721-00f759b62efa 2015-01-02T20:01:55.215629
#> 2 912a30c8-8915-4e6d-a721-00f759b62efa 2015-01-02T20:01:42.121999
#>                              object_id
#> 1 559708e5-480e-4f94-8429-c49571e82761
#> 2 559708e5-480e-4f94-8429-c49571e82761
#>                            revision_id data.package.maintainer
#> 1 a94e642d-a974-41aa-8adf-79facea1e171            datagovaubot
#> 2 94a19fbb-3874-467d-afa0-a0ecbbff8ed4            datagovaubot
#>                        data.package.name data.package.metadata_modified
#> 1 energy-rating-for-household-appliances     2015-01-02T20:01:49.873819
#> 2 energy-rating-for-household-appliances     2015-01-02T20:01:37.683213
#>   data.package.author                data.package.url
#> 1           Tim Laris http://www.energyrating.gov.au/
#> 2           Tim Laris http://www.energyrating.gov.au/
#>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        data.package.notes
#> 1 ![Energy Rating](http://www.energyrating.gov.au/wp-content/uploads/2011/02/ERL_3.5_star1.gif "Optional title")\r\n\r\nThese datasets contain information about the energy efficiency of the following products that carry the Energy Rating Label.\r\n\r\n-\tAir Conditioners\r\n\r\n-\tClothes dryers\r\n\r\n-\tDishwashers\r\n\r\n-\tClothes Washers\r\n\r\n-\tFridges and Freezers\r\n\r\n-\tTelevisions\r\n\r\n-\tComputer monitors\r\n\r\n\r\nThe data is collected from suppliers when they register appliances that are going to be sold in Australia and New Zealand.\r\n\r\nFields depend on the exact dataset but generally include:\r\n\r\n-\tBrand Name (and URL)\r\n\r\n-\tOutput range (kilowatts used)\r\n\r\n-\tModel Number/name\r\n\r\n-\tCountry of Origin and where sold\r\n\r\n-\tAvailability \r\n\r\n-\tStar Rating\r\n\r\n-\tVarious other fields depending on the product type
#> 2 ![Energy Rating](http://www.energyrating.gov.au/wp-content/uploads/2011/02/ERL_3.5_star1.gif "Optional title")\r\n\r\nThese datasets contain information about the energy efficiency of the following products that carry the Energy Rating Label.\r\n\r\n-\tAir Conditioners\r\n\r\n-\tClothes dryers\r\n\r\n-\tDishwashers\r\n\r\n-\tClothes Washers\r\n\r\n-\tFridges and Freezers\r\n\r\n-\tTelevisions\r\n\r\n-\tComputer monitors\r\n\r\n\r\nThe data is collected from suppliers when they register appliances that are going to be sold in Australia and New Zealand.\r\n\r\nFields depend on the exact dataset but generally include:\r\n\r\n-\tBrand Name (and URL)\r\n\r\n-\tOutput range (kilowatts used)\r\n\r\n-\tModel Number/name\r\n\r\n-\tCountry of Origin and where sold\r\n\r\n-\tAvailability \r\n\r\n-\tStar Rating\r\n\r\n-\tVarious other fields depending on the product type
#>                 data.package.owner_org data.package.private
#> 1 90153a8c-6a29-4068-a97d-7cf06dbef700                FALSE
#> 2 90153a8c-6a29-4068-a97d-7cf06dbef700                FALSE
#>   data.package.maintainer_email data.package.author_email
#> 1          tim.laris@ret.gov.au      tim.laris@ret.gov.au
#> 2          tim.laris@ret.gov.au      tim.laris@ret.gov.au
#>   data.package.state data.package.version
#> 1             active                     
#> 2             active                     
#>           data.package.creator_user_id
#> 1 91af4eef-efb1-4e4e-87f2-171d81977ae0
#> 2 91af4eef-efb1-4e4e-87f2-171d81977ae0
#>                        data.package.id
#> 1 559708e5-480e-4f94-8429-c49571e82761
#> 2 559708e5-480e-4f94-8429-c49571e82761
#>                                                data.package.title
#> 1 Energy Rating Data for household appliances – Labelled Products
#> 2 Energy Rating Data for household appliances – Labelled Products
#>               data.package.revision_id data.package.type
#> 1 51d8ccc1-c40c-4b45-9f6a-fd7bf49db5df           dataset
#> 2 51d8ccc1-c40c-4b45-9f6a-fd7bf49db5df           dataset
#>   data.package.license_id                                   id
#> 1                   cc-by 43be37ee-6b85-4def-8798-d308799d1f6e
#> 2                   cc-by 7a41b604-87c5-4fb0-9d30-53a4946a0ce8
#>     activity_type
#> 1 changed package
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
#> list()
```

## Show tags

Subset for readme brevity


```r
tag_show('Aviation')$packages[[1]][1:3]	
#> Error in ckan_POST(url, "tag_show", body = list(id = id), ...): client error: (404) Not Found
```

## List groups


```r
group_list(as='table')
#>                       display_name
#> 1  Business Support and Regulation
#> 2             Civic Infrastructure
#> 3                   Communications
#> 4               Community Services
#> 5                 Cultural Affairs
#> 6                          Defence
#> 7           Education and Training
#> 8                       Employment
#> 9                      Environment
#> 10              Finance Management
#> 11                      Governance
#> 12                     Health Care
#> 13                     Immigration
#> 14              Indigenous Affairs
#> 15         International Relations
#> 16          Justice Administration
#> 17               Maritime Services
#> 18               Natural Resources
#> 19              Primary Industries
#> 20                         Science
#> 21                        Security
#> 22            Sport and Recreation
#> 23                         Tourism
#> 24                           Trade
#> 25                       Transport
#>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        description
#> 1                                                                                                                                                                                                             Formulating policy to regulate and support the private sector, including small business and non-profit organisations. Developing strategies to assist business growth and management. Implementing advocacy programs, providing funding and administering regulatory bodies.\r\n\r\nIncludes components listed at http://agift.naa.gov.au/000411.htm
#> 2                                                                                                                                                                                                                          Developing policy to support the growth of towns and cities. Implementing programs to manage urban development and maintain essential services. Installing buildings and services to meet the administrative, social and recreational needs of local residents.\r\n\r\nIncludes components listed at http://agift.naa.gov.au/000424.htm
#> 3                                                                  Supporting the growth and management of industries that facilitate the transmission of information. Regulating the provision of postal and telecommunication services to all citizens. Encouraging the development of standards for information management, information dissemination and information technology.\r\n\r\nIncludes components listed at http://agift.naa.gov.au/000433.htm\r\nIncludes components found at AGIFT definition of Communications http://agift.naa.gov.au/000433.htm
#> 4                                                                                                                                                                                        Developing policy to assist citizens in a particular district or those with common interests and needs. Providing welfare services and financial support. Administering disaster and emergency assistance programs.\r\n\r\nIncludes components listed at http://agift.naa.gov.au/000435.htm\r\nIncludes components defined by AGIFT at http://agift.naa.gov.au/000435.htm
#> 5                                                                                                                                                  Developing policy to support the arts and cultural organisations such as museums, libraries and galleries. Establishing programs to develop and manage cultural collections and artefacts, and to stimulate growth in cultural industries. Sponsoring activities and events to celebrate the diversity of Australian culture.\r\n\r\nIncludes components defined by AGIFT at http://agift.naa.gov.au/000442.htm
#> 6                                                                                                                                                           Ensuring the safety of Australia by building, maintaining and deploying military resources. Developing policy and programs for defence of the nation, region and allies. Includes high-level administration of the Australian Defence Forces (ADF).\r\n\r\nIncludes components listed at http://agift.naa.gov.au/000449.htm\r\n\r\nIncludes component from AGIFT at http://agift.naa.gov.au/000449.htm
#> 7  EducationaFormulating policy to support programs that provide skills and knowledge to citizens. Developing strategies to make education available to the broadest possible cross-section of the community. Providing funding to schools, universities, colleges, academies or community groups that provide education and training. Establishing programs to develop and manage educational institutions.\r\n\r\nIncludes components listed at http://agift.naa.gov.au/000467.htm\r\nIncludes components defined by AGIFT at http://agift.naa.gov.au/000467.htm
#> 8                                                                                                                                                        Formulating policy to support employment growth and regulate public or private sector working environments. Developing strategies to improve workplace relations, productivity and performance. Implementing labour market programs and providing funding. Administering regulatory bodies and arbitration services.\r\n\r\nIncludes components as defined in AGIFT at http://agift.naa.gov.au/000016.htm
#> 9                                                                                    Developing policy to support the management of the surrounding natural and built environments. Balancing competing requirements to generate long term sustainable benefits for industry, tourism and the community. Protecting elements of the natural and built environment that are of special significance. Includes conservation of the national estate and world heritage concerns.\r\n\r\nInvolves components identified by AGIFT at http://agift.naa.gov.au/000478.htm
#> 10                                                                                                                                                                                                                                Developing policy for the administration of public funds and other resources. Determining appropriate strategies for raising revenue and regulating expenditure. Monitoring economic indicators and forecasting trends to enable financial planning.\r\n\r\nInvolves components from AGIFT at http://agift.naa.gov.au/000001.htm
#> 11       Executing legislative processes in Houses of Parliament, assemblies or councils, where officers are elected to represent citizens. Administering committees that report to legislative bodies. Managing elections of government representatives and sponsoring major community celebrations. Includes official duties carried out by the titular head of the government or municipality. Includes managing the machinery of government processes at all levels of government.\r\n\r\nInvolves components from AGIFT at http://agift.naa.gov.au/000002.htm
#> 12                                                                                                                                                                                                       Providing and coordinating programs for the prevention, diagnosis and treatment of disease or injury. Developing policy to support the provision of health care services and medical research. Administering regulatory schemes for health care products and pharmaceuticals.\r\n\r\nInvolves components from AGIFT at http://agift.naa.gov.au/000003.htm
#> 13                                                                                       Assisting people wishing to enter Australia on a permanent or temporary basis. Developing policy to establish entry or deportation requirements for migrants and visitors. Includes strategies for the management of illegal immigrants.\r\n\r\nIncludes components listed at http://agift.naa.gov.au/000004.htm\r\n\r\nSee also CULTURAL AFFAIRS: for activities to celebrate multiculturalism\r\n\r\nInvolves components in AGIFT at http://agift.naa.gov.au/000004.htm
#> 14                                                                                                                                                                  Developing policy to support the advancement of Aboriginal and Torres Strait Islander people. Establishing programs to develop, manage and deliver services to Aboriginal and Torres Strait Islander people. Includes protecting areas directly associated with Aboriginal and Torres Strait Islander culture.\r\n\r\nIncludes elements defined in AGIFT at http://agift.naa.gov.au/002285.htm
#> 15                                                                                                                                         Building and maintaining relationships with other countries and international organisations. Developing strategies to protect and advance national interests. Contributing to international security, economic development, the environment, democratic principles and human rights through aid programs, treaties and diplomatic services.\r\n\r\nIncludes components listed at http://agift.naa.gov.au/000005.htm\r\n
#> 16                                                                                                                                                                                                                Developing, interpreting and applying legislation, regulations or by-laws. Regulating the conduct of individuals, business and government, to conform to agreed rules and principles. Establishing programs and services to support the operation of the justice system.\r\n\r\nIncludes components listed at http://agift.naa.gov.au/000006.htm
#> 17                                                                                                               Developing policy to regulate use of the sea as a means of transport. Negotiating passage for sea transport and maritime jurisdiction. Planning and managing maritime infrastructure. Monitoring the safety of seagoing vessels, pilots and personnel. Administering programs for marine search and rescue. Providing resources for the development of navigational aids.\r\n\r\nIncludes components listed at http://agift.naa.gov.au/000007.htm
#> 18                                                                                                                                                                                                        Developing policy for the sustainable use and management of energy, mineral, land and water supplies. Administering programs to evaluate resource consumption and exploitation practices. Regulating and supporting industries that realise the economic potential of resources.\r\n\r\nIncludes components listed at http://agift.naa.gov.au/000009.htm
#> 19                                                                                                                                 Developing policy to support and regulate rural and marine industries. Promoting strategies for efficient and sustainable operations. Administering programs to monitor current practices, to meet national and international standards. Includes liaison with industry bodies and across jurisdictions in relation to the needs of primary industries.\r\n\r\nIncludes components listed at http://agift.naa.gov.au/000008.htm
#> 20                                                                                                                Developing policy and standards to support research and systematic studies. Administering scientific bodies and monitoring industry research and development programs. Providing funding and implementing promotional strategies. Includes research into living things and their environments, natural laws and the application of knowledge to practical problems. \r\n\r\nIncludes components listed at http://agift.naa.gov.au/000010.htm\r\n
#> 21                                                                                                                                                      Maintaining the safety of Australia at all levels of society. Developing policy and programs to guard against internal or external threats to peace and stability. Providing funding for law enforcement, community protection and corrective services. Coordinating intelligence gathering and international security activities.\r\n\r\nIncludes components listed at http://agift.naa.gov.au/000011.htm
#> 22                                                                                                                                                                                                                                                                              Developing policy and programs to encourage community participation in organised games or leisure activities. Implementing promotional strategies, providing funding and administering regulatory bodies. \r\n\r\nIncludes components listed at http://agift.naa.gov.au/000012.htm
#> 23                                                                                                                                                                                    Developing policy and programs to encourage recreational visitors to a region. Supporting and regulating the tourism industry. Implementing long-term strategies for tourism development and coordinating across jurisdictions on large-scale projects. Providing funding for promotional campaigns.\r\n\r\nIncludes components listed at http://agift.naa.gov.au/000013.htm
#> 24                                                                                                                                                                                                              Developing policy to regulate the purchase, sale or exchange of commodities. Monitoring the balance of trade, industry protection and subsidy schemes. Includes foreign and domestic activities, and liaison across jurisdictions to support trade agreement negotiations.\r\n\r\nIncludes components listed at http://agift.naa.gov.au/000014.htm
#> 25                                                                                                                                                                                                               Developing policy to regulate road, rail and air transportation systems. Planning and managing schemes for the movement of people or freight. Monitoring the safety of vehicles and their operators. Providing resources for the development of transport infrastructure.\r\n\r\nIncludes components listed at http://agift.naa.gov.au/000015.htm
#>                              title image_display_url approval_status
#> 1  Business Support and Regulation                          approved
#> 2             Civic Infrastructure                          approved
#> 3                   Communications                          approved
#> 4               Community Services                          approved
#> 5                 Cultural Affairs                          approved
#> 6                          Defence                          approved
#> 7           Education and Training                          approved
#> 8                       Employment                          approved
#> 9                      Environment                          approved
#> 10              Finance Management                          approved
#> 11                      Governance                          approved
#> 12                     Health Care                          approved
#> 13                     Immigration                          approved
#> 14              Indigenous Affairs                          approved
#> 15         International Relations                          approved
#> 16          Justice Administration                          approved
#> 17               Maritime Services                          approved
#> 18               Natural Resources                          approved
#> 19              Primary Industries                          approved
#> 20                         Science                          approved
#> 21                        Security                          approved
#> 22            Sport and Recreation                          approved
#> 23                         Tourism                          approved
#> 24                           Trade                          approved
#> 25                       Transport                          approved
#>    is_organization  state image_url                          revision_id
#> 1            FALSE active           fa48d58f-b402-465b-b17d-6faa86fdf1fa
#> 2            FALSE active           6d7d2b1f-ea57-4014-9bd3-b64baec958e4
#> 3            FALSE active           64de0f0c-b727-4073-98d8-46339827f7fc
#> 4            FALSE active           11650f28-6a42-4d95-a72f-2016f084ce4a
#> 5            FALSE active           09c20dec-1bec-4f2e-be0d-1d0eae18a532
#> 6            FALSE active           d532d33e-6da4-41e5-8b40-a50ccce10934
#> 7            FALSE active           4de79ba6-bea9-485d-9574-ec690a696eac
#> 8            FALSE active           3901a66d-5ac6-4d6a-8e49-f6c87377558a
#> 9            FALSE active           ba7a2eca-c4f5-4c0e-9d80-fb5d1295ffb9
#> 10           FALSE active           b9a97227-9873-4694-ad05-604bd7a0a6c0
#> 11           FALSE active           faaa8079-4a56-48a8-811d-38d258af35c0
#> 12           FALSE active           2be70ee1-3b6a-44fd-bdff-2e8503175174
#> 13           FALSE active           e1ab36d0-9882-4b22-8b5b-aab31c1565fb
#> 14           FALSE active           444cd47b-9bcf-49a5-ad99-02a4ce9dabfb
#> 15           FALSE active           a04e7a6c-1a9c-4dbb-bd68-25491255707d
#> 16           FALSE active           940283b5-5293-4173-b9c7-a597af0ac51e
#> 17           FALSE active           d660ee4b-3a5b-41a8-9eb6-2936ed919940
#> 18           FALSE active           2f63d9b1-2b2f-4323-9abc-6a431d781512
#> 19           FALSE active           25ba2994-75c1-445c-a60b-8393d7c33a93
#> 20           FALSE active           9b9715ba-4f56-467f-845a-7453ced1d264
#> 21           FALSE active           38d59393-6aed-4b91-b2af-a20d21c632fc
#> 22           FALSE active           d261292d-16ca-46ef-8926-821e86add81d
#> 23           FALSE active           4c22cb32-a637-4114-8663-81dcf265436c
#> 24           FALSE active           129e5fb1-277d-4601-a161-cf918cd2078c
#> 25           FALSE active           6f4b94af-4500-4fb4-a7ac-48de29820e24
#>    packages  type                                   id           name
#> 1       103 group ada735db-98c9-42cb-8969-dc356ea4281e       business
#> 2         0 group 7d67a152-2ac6-4f5f-b1e5-f6a2791067cc          civic
#> 3        15 group cf4060c4-f279-43a9-ab5c-4fbe7889b7ba communications
#> 4       131 group bd09f325-4aea-4873-9204-66cdf638fc34      community
#> 5        19 group e95def3e-5061-44d0-ad1e-4cd355a3a897       cultural
#> 6         0 group 1923cbaf-000b-4e9a-bbe7-805fc206afd7        defence
#> 7        13 group 32f2e899-6198-410d-97e5-2c675d25ca78      education
#> 8         9 group 83562e4e-2850-4063-8f4e-26352b903f22     employment
#> 9        66 group 707bd86f-3a3f-4810-93da-04e2b6d59a11    environment
#> 10       56 group 7170b37f-994d-4056-b5fc-5ada01041f5a        finance
#> 11        4 group 757e2041-51f1-45ce-871d-9b292d617601     governance
#> 12       31 group 104574bd-92b3-4866-97c0-373797dbca43         health
#> 13        0 group 1d8af52d-65fe-48ac-b256-a3e0eb691202    immigration
#> 14        3 group 980b8179-746b-4ff8-b7e6-f8f8ee3cc865     indigenous
#> 15        0 group 42a3cfce-63ca-4386-a52d-416d8aa24094  international
#> 16        0 group 0d2300ca-dda4-47da-b533-cddd8d0776f4        justice
#> 17        0 group 68cb2a35-4bd0-4522-9265-5ddf37d6790b       maritime
#> 18        0 group c5cd3a09-753f-423d-97e6-300cec4dcdba        natural
#> 19        0 group 4695b1f2-5fbd-4bfd-9d09-4db32fb84e89        primary
#> 20       92 group 049a32a5-dac6-48c0-9add-e7847e85b7b3       sciences
#> 21        0 group 84e5ab19-4de6-4cbd-ba6b-457a4273c982       security
#> 22       50 group 79e3bdb0-071a-408d-b1d7-1dd20173b65b          sport
#> 23        6 group b0ded30e-bf78-43d1-9fee-1d90818c30c3        tourism
#> 24        0 group 25780283-7622-4cbd-b254-efbcaa9a647d          trade
#> 25       24 group 29fe1336-5109-464d-b6f1-743b8dd772c6      transport
```

## Show groups

Subset for readme brevity


```r
group_show('communications', as='table')$users
#>   openid about capacity      name                    created
#> 1     NA          admin custodian 2013-04-17T08:00:59.243065
#>                         email_hash sysadmin
#> 1 99e31a948195fdebcba0afc9313801e2     TRUE
#>   activity_streams_email_notifications  state number_of_edits
#> 1                                FALSE active            2925
#>   number_administered_packages          display_name              fullname
#> 1                         1118 data.gov.au Custodian data.gov.au Custodian
#>                                     id
#> 1 91af4eef-efb1-4e4e-87f2-171d81977ae0
```

## Show a package


```r
package_show('34d60b13-1fd5-430e-b0ec-c8bc7f4841cf', as='table')$resources
#> Error in ckan_POST(url, "package_show", body = body, ...): client error: (404) Not Found
```

## Search for packages


```r
out <- package_search(q = '*:*', rows = 2, as="table")$results
out[, !names(out) %in% 'resources']
#>                                license_title   maintainer
#> 1 Creative Commons Attribution 3.0 Australia datagovaubot
#> 2 Creative Commons Attribution 3.0 Australia  goldcoastcc
#>   relationships_as_object     jurisdiction temporal_coverage_to private
#> 1                    NULL          Federal                        FALSE
#> 2                    NULL Local Government                        FALSE
#>       maintainer_email         revision_timestamp geospatial_topic
#> 1 tim.laris@ret.gov.au 2014-08-31T23:08:43.751622             NULL
#> 2                 <NA> 2014-09-05T02:47:41.774647             NULL
#>                                     id           metadata_created
#> 1 559708e5-480e-4f94-8429-c49571e82761 2013-04-17T23:01:23.823563
#> 2 6b992102-1163-46dc-bbe0-bb997d2ffdb4 2014-09-04T23:42:51.066701
#>                                                     spatial_coverage
#> 1                                             Australia, New Zealand
#> 2 http://www.ga.gov.au/place-names/PlaceDetails.jsp?submit1=QLD42078
#>            metadata_modified             author         author_email
#> 1 2015-01-02T20:01:49.873819          Tim Laris tim.laris@ret.gov.au
#> 2 2015-01-02T08:21:09.525501 City of Gold Coast                 <NA>
#>    state version license_id                 contact_point    type
#> 1 active              cc-by  energyrating@industry.gov.au dataset
#> 2 active    <NA>      cc-by opendata@goldcoast.qld.gov.au dataset
#>   num_resources
#> 1             7
#> 2             2
#>                                                                                                                                                                                                                                                                                                                                                                                                           tags
#> 1 NA, NA, NA, NA, appliance, efficiency, energy, greenhouse, appliance, efficiency, energy, greenhouse, 2013-08-19T05:46:44.216374, 2013-08-19T05:44:44.364527, 2013-04-17T23:01:23.823563, 2013-08-19T05:45:50.076973, active, active, active, active, 32d8ef45-bfa2-4b0f-b3e5-3b34bec34bc4, b5b9efa2-5938-4361-a32d-e425776070ac, 37c6e5a5-2036-44bd-a4d0-6820265cf814, 748b1d38-cdd1-45ed-af5f-f85f2f674ebc
#> 2                                                                                                                                                                                                                                                                                                         NA, gold coast, gold coast, 2014-09-04T23:42:51.066701, active, 9e60a75e-538a-4e5f-995b-d8455e833ffc
#>   temporal_coverage_from language tracking_summary.total
#> 1                Current  English                   2792
#> 2             2014-09-05  English                    176
#>   tracking_summary.recent
#> 1                      60
#> 2                      12
#>                                                                                                                                                                                                                                                                                                                                                                                                                                                                     groups
#> 1 Business Support and Regulation, Formulating policy to regulate and support the private sector, including small business and non-profit organisations. Developing strategies to assist business growth and management. Implementing advocacy programs, providing funding and administering regulatory bodies.\r\n\r\nIncludes components listed at http://agift.naa.gov.au/000411.htm, , Business Support and Regulation, ada735db-98c9-42cb-8969-dc356ea4281e, business
#> 2                                                                                                                                                                                                                                                                                                                                                                                                                                                                     NULL
#>                        creator_user_id field_of_research
#> 1 91af4eef-efb1-4e4e-87f2-171d81977ae0              NULL
#> 2 68b91a41-7b08-47f1-8434-780eb9f4332d              NULL
#>   relationships_as_subject num_tags
#> 1                     NULL        4
#> 2                     NULL        1
#>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            organization.description
#> 1                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          The department helps industry to become more efficient, competitive and innovative. \r\n
#> 2 City of Gold Coast (the City) is the second largest local government in Australia (based on the city's resident population). Defined by its spectacular beaches, hinterland ranges, forests, waterways and vibrant communities, the Gold Coast is a global city which is proudly looking towards the future.  \r\n\r\nThe City is developing an Open Data framework and is committed to proactively publishing datasets for reuse and championing the use of open government data.\r\nObjectives of the City’s Open Data project include development of innovative solutions for Gold Coast residents, increased City transparency and accountability, improved data quality, reduction in Customer Contact enquiries and response times, building local ICT capabilities and providing local innovation and commercialisation opportunities.\r\n
#>         organization.created      organization.title
#> 1 2013-04-18T15:36:47.465027 Department of Industry 
#> 2 2013-05-31T00:13:58.069733      City of Gold Coast
#>        organization.name organization.revision_timestamp
#> 1 department-of-industry      2013-11-13T01:20:46.166597
#> 2     city-of-gold-coast      2013-11-04T03:23:28.369786
#>   organization.is_organization organization.state
#> 1                         TRUE             active
#> 2                         TRUE             active
#>                                                                          organization.image_url
#> 1 http://frds.dairyaustralia.com.au/wp-content/uploads/2013/10/dept-ind_stacked-tif-300x201.jpg
#> 2                          https://www.goldcoast.qld.gov.au/_images/structural/gccc-logo-v2.png
#>               organization.revision_id organization.type
#> 1 fd9c2253-0d46-40d2-b140-e69886b5b093      organization
#> 2 18b5045f-56ee-4326-b36b-d21855ac53d0      organization
#>                        organization.id organization.approval_status
#> 1 90153a8c-6a29-4068-a97d-7cf06dbef700                     approved
#> 2 c9301f4c-e741-44de-b4d4-33ac61e0eeba                     approved
#>                                     name isopen
#> 1 energy-rating-for-household-appliances   TRUE
#> 2       city-of-gold-coast-road-closures   TRUE
#>                               url
#> 1 http://www.energyrating.gov.au/
#> 2                            <NA>
#>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     notes
#> 1 ![Energy Rating](http://www.energyrating.gov.au/wp-content/uploads/2011/02/ERL_3.5_star1.gif "Optional title")\r\n\r\nThese datasets contain information about the energy efficiency of the following products that carry the Energy Rating Label.\r\n\r\n-\tAir Conditioners\r\n\r\n-\tClothes dryers\r\n\r\n-\tDishwashers\r\n\r\n-\tClothes Washers\r\n\r\n-\tFridges and Freezers\r\n\r\n-\tTelevisions\r\n\r\n-\tComputer monitors\r\n\r\n\r\nThe data is collected from suppliers when they register appliances that are going to be sold in Australia and New Zealand.\r\n\r\nFields depend on the exact dataset but generally include:\r\n\r\n-\tBrand Name (and URL)\r\n\r\n-\tOutput range (kilowatts used)\r\n\r\n-\tModel Number/name\r\n\r\n-\tCountry of Origin and where sold\r\n\r\n-\tAvailability \r\n\r\n-\tStar Rating\r\n\r\n-\tVarious other fields depending on the product type
#> 2                                                                                                                                                                                                                                                           This data set contains details of City of Gold Coast (City) planned road closures, due to local works and events. It is updated daily and, while the information presented here is believed to be accurate at the time of publication, no assurance can be provided past this point. Unplanned road closures due to emergency works are not included. Please note that the technical support services that facilitate this data publication service are provided under a service level agreeement with a 10 day service response time. In the event that there is a technical failure of this service it may take up to 10 days to reinstate.
#>                              owner_org
#> 1 90153a8c-6a29-4068-a97d-7cf06dbef700
#> 2 c9301f4c-e741-44de-b4d4-33ac61e0eeba
#>                                      license_url data_state
#> 1 http://creativecommons.org/licenses/by/3.0/au/     active
#> 2 http://creativecommons.org/licenses/by/3.0/au/     active
#>                                                             title
#> 1 Energy Rating Data for household appliances – Labelled Products
#> 2                                City of Gold Coast Road Closures
#>                            revision_id update_freq
#> 1 51d8ccc1-c40c-4b45-9f6a-fd7bf49db5df       daily
#> 2 27b28d36-46a3-4c48-b624-bb3cc2b61535       daily
#>                                                                     spatial
#> 1                                                                      <NA>
#> 2 {"type": "Point","coordinates": [153.33439640000000,-27.998399729999999]}
```

## Search for resources


```r
resource_search(q = 'name:data', limit = 2, as='table')
#> $count
#> [1] 4179
#> 
#> $results
#>                      resource_group_id cache_last_updated
#> 1 001fec9d-21f6-4a11-ae93-8fd16124301e                 NA
#> 2 001fec9d-21f6-4a11-ae93-8fd16124301e                 NA
#>   webstore_last_updated                                   id size  state
#> 1                    NA 0e433c7f-3c98-40d6-aa4c-6ba5ad047a18   NA active
#> 2                    NA c4c31577-660a-422b-8089-5b90d20b2d73   NA active
#>   last_modified hash description format mimetype_inner url_type
#> 1            NA                    HTML             NA       NA
#> 2            NA                    HTML             NA       NA
#>         resource_locator_protocol mimetype cache_url
#> 1         WWW:LINK-1.0-http--link       NA        NA
#> 2 WWW:LINK-1.0-http--metadata-URL       NA        NA
#>                                                                                                                   name
#> 1 Automatically checked Water Temperature at surface data from 20 Nov 2008 until 27 Oct 2014 (Quality Controlled Data)
#> 2                                                                           Point of truth URL of this metadata record
#>                      created
#> 1 2014-11-21T08:27:58.389084
#> 2 2014-11-21T08:27:58.389105
#>                                                                                                 url
#> 1                              http://data.aims.gov.au/aimsrtds/datatool.xhtml?qc=level1&channels=2
#> 2 http://data.aims.gov.au/metadataviewer/faces/view.xhtml?uuid=a0b44257-1652-4f4e-ae46-7a3fe20ef839
#>   webstore_url resource_locator_function position
#> 1           NA                                  0
#> 2           NA                                  1
#>                            revision_id resource_type
#> 1 ce9ca2ca-e682-4a79-94c2-5aeca64b1659            NA
#> 2 ce9ca2ca-e682-4a79-94c2-5aeca64b1659            NA
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
