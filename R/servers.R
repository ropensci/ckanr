#' CKAN server URLS and other info
#'
#' @export
#' @details Comes from the links at https://ckan.org/about/instances/
#'
#' There were a number of other URLs for CKAN instances in the CKAN URL
#' above, but some sites are now gone completely, or if they do exist,
#' I can't figure out how to get access to the CKAN API on their instance.
#' @examples \dontrun{
#' servers()
#' ckan_info(servers()[5])
#'
#' # what version is each CKAN server running
#' out <- lapply(servers()[1:6], function(w) {
#'   cat(w, sep='\n') 
#'   ckan_info(w)
#' })
#' vapply(out, "[[", "", "ckan_version")
#' }
servers <- function() server_urls

server_urls <- c(
  "http://catalog.data.gov",
  "http://africaopendata.org",
  "http://ckan.gsi.go.jp",
  "http://dados.gov.br",
  "http://dados.recife.pe.gov.br",
  "http://dados.rs.gov.br",
  "http://dartportal.leeds.ac.uk",
  "http://data.bris.ac.uk/data",
  "http://data.buenosaires.gob.ar",
  "http://data.glasgow.gov.uk",
  "http://data.go.id",
  "http://data.gov.au",
  "http://data.gov.hr",
  "http://data.gov.ie",
  "http://data.gov.ro",
  "http://data.gov.sk",
  "http://data.openva.com",
  "http://data.qld.gov.au",
  "http://data.salzburgerland.com",
  "http://data.surrey.ca",
  "http://data.tainan.gov.tw",
  "http://data.gv.at/katalog",
  "http://data.nsw.gov.au/data",
  "http://data.zagreb.hr",
  "http://datahub.io",
  "http://datamx.io",
  "http://datapoa.com.br",
  "http://dati.trentino.it",
  "http://datos.codeandomexico.org",
  "http://suche.transparenz.hamburg.de",
  "http://dati.lazio.it/catalog",
  "http://dati.toscana.it",
  "http://datosabiertos.malaga.eu",
  "http://drdsi.jrc.ec.europa.eu",
  "http://etsin.avointiede.fi",
  "http://datos.santander.es/catalogo",
  "http://search.geothermaldata.org",
  "http://govdata.de/ckan",
  "http://iatiregistry.org",
  "http://offenedaten.de",
  "http://opendata.aachen.de",
  "http://opendata.awt.be",
  "http://opendata.caceres.es",
  "http://opendata.comune.bari.it",
  "http://opendata.hu",
  "http://opendata.lisra.jp",
  "https://opendata.riik.ee",
  "http://opendatagortynia.gr",
  "http://opingogn.is",
  "http://oppnadata.se",
  "http://rotterdamopendata.nl",
  "http://taijiang.tw",
  "http://www.civicdata.io",
  "http://www.daten.rlp.de",
  "http://www.datos.misiones.gov.ar",
  "http://www.nosdonnees.fr",
  "http://www.odaa.dk",
  "http://www.opendata-hro.de",
  "http://www.opendatahub.it",
  "https://catalogodatos.gub.uy",
  "https://data.barrowbc.gov.uk",
  "https://data.humdata.org",
  "https://data.qld.gov.au",
  "https://datahub.cmap.illinois.gov",
  "https://edx.netl.doe.gov",
  "https://offenedaten.de",
  "https://data.noaa.gov/dataset",
  "https://data.overheid.nl/data",
  "https://www.data.gv.at/katalog",
  "https://data.ontario.ca/",
  "https://ckan0.cf.opendata.inter.prod-toronto.ca/",
  "https://data.cnra.ca.gov/",
  "https://data.ca.gov/",
  "https://data.chhs.ca.gov/",
  "http://data.whiterockcity.ca/"
)
