checkem <- function(url) {
  url = paste0(url, "/api/3/action/status_show")
  x = crul::HttpClient$new(url, opts = list(followlocation=TRUE))
  crul::ok(x, verb = "get")
}

out <- lapply(servers(), function(w) {
  data.frame(url=w, ok=checkem(w))
})
df <- dplyr::bind_rows(out)
df
