# Adversarial Review — ckanr

**Verdict: `course-correct`**

**Status (2026-09-20): all 5 actionable improvements implemented in working tree, uncommitted. Verified: R parse OK, `parse_version_number` edge cases return `NA` without warning, `ping(logical)` → `FALSE` / `ping(json)` → error on `http://127.0.0.1:9`, `.onLoad` resets empty URL to default, `test-utils.R` passes 16 assertions (`NOT_CRAN=true`). `roxygen2::roxygenise()` regenerated `man/ping.Rd`, `man/ckan_info.Rd`, `man/ckanr_setup.Rd`. Awaiting human review + commit permission — no commits made.**

Direction — disposable devcontainer CKAN + `SKIP`-gated integration tests + modern tidy-eval — is sound. Do not expand coverage until confirmed crash/brittleness defects below are fixed. Not `rethink`: no architectural flaw found.

## Confirmed defects (with evidence)

1. **Crash on unknown/offline version — `revision_list`, `package_revision_list`:**
   - `R/revision_list.R:15-20`: `ver <- try(ckan_version(url)$version_num); if(inherits...) ver <- NA` then `if(ver >= 29.0)`. When `ver` is `NA`, `if(NA)` errors `missing value where TRUE/FALSE needed` instead of skipping/falling through.
   - `R/package_revision_list.R:32-37`: identical pattern.
   - `R/package_search.R:64-76` handles `is.na(ver)` correctly — proving the other two are oversights. This directly breaks the `check_ckan`/`SKIP` philosophy for offline CI.

2. **`ping()` type contract broken:**
   - `R/ping.R:11-24`: `switch(as, json=res, logical=...)` with no default validation, and `error=function(e) FALSE` unconditionally. `ping(as="json")` on failure returns logical `FALSE`, not JSON; `ping(as="typo")` silently returns `NULL`.

3. **Fragile version parser:**
   - `R/ckan_info.R:30-39`: `version_components[1:2]` assumes `>=2` numeric components. Single-component `"2"` → `paste0("2",NA)` → `"2NA"` → `NA` + warning; `NULL`/missing `ckan_version` from `status_show` → `regmatches(NULL,...)` misbehaves. Encoding `2.11.2 → 211.2` and comparisons like `ver < 23.5` in `R/package_search.R:78-81` work but are opaque and untested offline (`tests/testthat/test-utils.R` only covers `handle_many`).

4. **Dead code + extra network hop:**
   - `R/activity.R:84`: `ver <- floor(ckan_version(url)$version_num)` in `recently_changed_packages_activity_list()` is never used. It adds a second `status_show` call that can fail even when the main action would succeed. `R/changes.R:17-20` has the same logic commented out — inconsistency.

5. **Availability caches poison on transient failure:**
   - `R/zzz.R:309-333` `ckan_action_available()`: `cache_key=paste(url,action)` ignores `key`, and `assign(cache_key, ok)` caches `FALSE` even when `res` is a network error. Offline during `helper-ckanr.R` load permanently disables actions for the session.
   - Same pattern in `R/activity.R:235-276` `activity_email_notifications_enabled()` caching `NA`/`FALSE` from `tryCatch`.

Supporting stale-docs/config evidence:

- `R/ckanr_settings.R:66` and `R/ckan_info.R:21` still document default `https://data.ontario.ca`, while `R/on_load.R:3` and `R/ckanr_settings.R:130` default to `https://demo.ckan.org/`.
- `R/on_load.R:4`: `if(!(names(ckanr) %in% names(envs)))` preserves an explicitly empty `CKANR_DEFAULT_URL=""`; then `get_default_url()` returns `""` (`R/ckanr_settings.R:158-160`), producing cryptic `file.path("", "api/3/action",...)` failures in `R/zzz.R:37`.
- `.devcontainer/docker-compose-dev.yml:40 vs :55`: `CKAN__AUTH__...`/`CKAN__ACTIVITY_STREAMS_EMAIL_NOTIFICATIONS` (single `_`) vs `CKAN__ACTIVITY_STREAMS__EMAIL_NOTIFICATIONS` (double `__`, hardcoded `true`). Only the latter matches CKAN env convention; former is ignored.

## Top 5 actionable improvements (ordered by value)

1. **Guard `NA` version before comparison + regression tests.** `if(isTRUE(ver >= 29))` or `if(!is.na(ver) && ver>=29)` in both revision files; add offline unit tests with mocked `ckan_version` returning `NA`/`try-error`. Unblocks offline `SKIP`.
2. **Harden + document `parse_version_number()`.** Early return `NA_real_` for `NULL`/`NA`/`<2` components, no warning; replace magic `23.5/26.1/29.0` with named helpers or comments mapping to `2.3.5/2.6.1/2.9`; unit-test `2`, `2.11.2`, `2.10.4`, `3.0.0`, `NA`.
3. **Fix `ping()` contract.** `as <- match.arg(as,c("logical","json"))`; on error return `FALSE` for `logical` but signal/return JSON-shaped error for `json` (or document). Replace `tests/testthat/test-ping.R:6` dependency on `http://www.google.com` with mocked `ckan_GET` failure.
4. **Make availability checks non-poisoning.** Don't cache errors/transients; key cache on `url|action|key-hash` or remove cache; add TTL. Same for `activity_email_notifications_enabled`.
5. **Fix default-URL + devcontainer nits.** `onLoad` should reset when `get_default_url()==""`; update stale roxygen defaults; dedupe/fix `CKAN__...` env var in `docker-compose-dev.yml`; reduce `healthcheck.interval:60s` for faster feedback. Remove dead `ver` line in `activity.R:84`.

## Hypotheses / risks in proposed work (not confirmed)

- `Fix #138` intent unverified — if it touched `package_search` version gating, re-check interaction with (2).
- `fetch_GET`/`read_session` in `R/zzz.R:81-142` + `R/ckan_fetch.R:185-239`: `switch(fmt,...)` with unknown/`NA` `fmt` returns `NULL` silently; `tolower(NA)` path untested. Likely needs explicit `stop("unsupported format")` but needs live-resource verification.
- `tests/testthat/helper-ckanr.R:485-491` side-effecting `ping()+prepare_test_ckan()` at source time is slow/fragile; moving to `setup` fixture is advisable but changes test harness behavior — needs maintainer buy-in.
- `resolve-helpers.R` fallbacks (returning whole input `x` when only `name` present) may send malformed IDs; needs review against membership/collaborator callers.

## Material evidence gaps

- Could not verify `git log bdfdc31,208b71c/d1c2361` or diff for `Fix #138`, roxygen refresh, devcontainer fix — read-only tools, no shell/`git show`.
- No tests run, no coverage numbers in session; all defect confirmations are static (`read`/`grep`), not executed.
- No live CKAN (`localhost:5000` or `demo.ckan.org`) probed; network-dependent claims (ping, `datastore_enabled`, `status_show` shape) unverified.
- Prior review failures left no output to reconcile against.

## Single best next action

Fix + test the `ver >= 29.0` `NA` crash in `R/revision_list.R:20` and `R/package_revision_list.R:37` — smallest change that restores the advertised offline-`SKIP` behavior and unblocks reliable coverage work.

## Fix log (implemented, uncommitted)

- [x] 1. `R/revision_list.R`, `R/package_revision_list.R`: `if (ver >= 29.0)` → `if (isTRUE(ver >= 29.0))` so `NA`/offline falls through to the API call instead of `missing value where TRUE/FALSE needed`.
- [x] 2. `R/ckan_info.R` `parse_version_number()`: early `NA_real_` for `NULL`/`NA`/non-character/length != 1/`<2` components, no warning; documented `2.3.5→23.5`, `2.6.1→26.1`, `2.9→29` encoding. `R/package_search.R`: annotated `23.5`/`26.1` thresholds. `tests/testthat/test-utils.R`: 10 new assertions (`2.9`, `2.3.5`, `2.6.1`, `2.11.2`, `2.10.4`, `3.0.0`, `2`, `NA`, `NULL`, no-warning).
- [x] 3. `R/ping.R`: `match.arg(as, c("logical","json"))` + documented contract (`logical` → `FALSE` on failure, `json` → error). `tests/testthat/test-ping.R`: dropped `http://www.google.com` for `http://127.0.0.1:9`, added `as` validation + `json`-failure tests. Regenerated `man/ping.Rd`.
- [x] 4. `R/zzz.R` `ckan_action_available()`: cache key now `url|action|nokey|keyed` (never stores the key), transient/error `FALSE` returned uncached. `R/activity.R` `activity_email_notifications_enabled()`: same keyed cache key, `NA`/unknown returned uncached.
- [x] 5. `R/on_load.R`: resets unset **or empty** `CKANR_DEFAULT_URL` to `https://demo.ckan.org/`. `R/ckanr_settings.R`, `R/ckan_info.R` + regenerated `.Rd`: default `https://demo.ckan.org/`. `R/activity.R`: removed dead `ver <- floor(...)`. `.devcontainer/docker-compose-dev.yml`: removed invalid single-underscore `CKAN__ACTIVITY_STREAMS_EMAIL_NOTIFICATIONS`, kept overridable `CKAN__ACTIVITY_STREAMS__EMAIL_NOTIFICATIONS=${...:-true}`; ckan + solr healthcheck `60s` → `30s`.

Note: `.github/CONTRIBUTING.md` shows as modified in `git status` but was not touched by these fixes (pre-existing working-tree change); left alone, excluded from proposed commits.
