#' CKAN server URLS and other info
#'
#' @export
#' @details CKAN instances from https://github.com/ckan/ckan-instances/
#'
#' @examples \dontrun{
#' servers()
#' ckan_info(servers()[5])
#'
#' # what version is each CKAN server running
#' out <- lapply(servers()[1:6], function(w) {ckan_version(w)$version_num})
#' }
servers <- function() server_urls

server_urls <- c(
  "http://datos.ciudaddemendoza.gob.ar",
  "http://datos.ciudaddemendoza.gov.ar",
  "http://datos.jus.gov.ar",
  "http://www.datos.misiones.gov.ar",
  "https://catalogue.data.wa.gov.au",
  "http://data.gov.au",
  "http://data.nsw.gov.au/data",
  "http://data.qld.gov.au",
  "https://data.qld.gov.au",
  "http://data.sa.gov.au/data",
  "http://ckan.jbrj.gov.br",
  "http://dados.recife.pe.gov.br",
  "http://dados.ufrn.br",
  "https://catalogue.data.gov.bc.ca",
  "https://ckan0.cf.opendata.inter.prod-toronto.ca",
  "https://data.montreal.ca",
  "https://data.ontario.ca",
  "http://donnees.ville.montreal.qc.ca",
  "https://www.donneesquebec.ca",
  "https://data.stadt-zuerich.ch",
  "http://datos.gob.cl",
  "https://data.uni-hannover.de",
  "http://govdata.de/ckan",
  "http://suche.transparenz.hamburg.de",
  "https://transparenz.karlsruhe.de",
  "http://www.opendata-hro.de",
  "http://portal.opendata.dk",
  "http://datos.santander.es/catalogo",
  "http://datosabiertos.rivasciudad.es",
  "http://opendata.aragon.es",
  "http://opendata.caceres.es",
  "http://opendata.ugr.es",
  "http://dataportal.aquacross.eu",
  "http://datosabiertos.malaga.eu",
  "http://journaldata.zbw.eu",
  "http://www.hri.fi/data",
  "http://catalog.data.gov",
  "https://data.ca.gov",
  "https://data.chhs.ca.gov",
  "https://data.cnra.ca.gov",
  "https://edx.netl.doe.gov",
  "http://gisdata.mn.gov",
  "http://data.zagreb.hr",
  "http://data.gov.ie",
  "http://datamx.io",
  "http://dati.retecivica.bz.it/it",
  "http://dati.toscana.it",
  "https://opendata.gov.je",
  "http://www.data.go.jp/data",
  "http://datos.gob.mx",
  "http://ckan.dataplatform.nl",
  "http://data.overheid.nl/data",
  "https://data.overheid.nl/data",
  "http://africaopendata.org",
  "https://data.amerigeoss.org",
  "https://data.humdata.org",
  "http://datos.codeandomexico.org",
  "http://ecaidata.org",
  "http://iatiregistry.org",
  "http://data.gov.ro",
  "http://hubofdata.ru",
  "http://data.nantou.gov.tw",
  "http://data.bris.ac.uk/data",
  "http://data.london.gov.uk"
)
