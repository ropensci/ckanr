# TODO: CKAN 2.11 Coverage Roadmap

This checklist translates the CKAN 2.11 API review into discrete implementation work for `ckanr`. Each section groups closely related endpoints so they can share helpers, docs, and tests. Use `devtools::test(filter = "<area>")` as you deliver each bucket. Follow `.github/copilot-instructions.md`.

## 1. Collaborators & Membership (High)
- [x] Implement `package_collaborator_list()` and `package_collaborator_list_for_user()` wrappers with pagination, plus docs/tests that skip when `ckan.auth.allow_dataset_collaborators` is disabled.
- [x] Add `package_collaborator_create()`/`package_collaborator_delete()` using shared ID coercion and ensure authorization failures surface cleanly.
- [x] Cover `member_list()`, `member_create()`, `member_delete()`, and expose `member_roles_list()` to report valid capacities.
- [x] Add group/org membership helpers (`group_member_create/delete`, `organization_member_create/delete`) and the invitation endpoint `user_invite()`.
- [x] Provide `group_list_authz()` and `organization_list_for_user()` to help clients decide which containers a user can edit.

## 2. Dataset Management Extras (High)
- [x] Wrap the relationship API (`package_relationships_list`, `package_relationship_create`, `package_relationship_update`, `package_relationship_delete`) with helpers that accept either IDs or `ckan_package` objects.
- [x] Implement `package_revise()` (flattened-key payloads) with detailed parameter validation guidance.
- [x] Add `package_resource_reorder()` and `package_owner_org_update()` utilities; include tests that ensure resource ordering sticks.
- [x] Expose destructive maintenance endpoints such as `dataset_purge()` (skip tests unless running in disposable CKAN).

## 3. Resource View Management (Medium)
- [x] Create a `ckan_resource_view` S3 class plus wrappers for `resource_view_list`, `resource_view_show`, `resource_view_create`, `resource_view_update`, `resource_view_reorder`, `resource_view_delete`, and `resource_view_clear`.
- [x] Add helpers for `resource_create_default_resource_views()` and `package_create_default_resource_views()` with sensible defaults when the dataset payload is missing.
- [x] Extend tests to create a simple view (when the default text view plugin is available) and skip gracefully otherwise.

## 4. Followers & Social Features (Medium)
- [x] Implement follower counts/lists for datasets, groups, and users (CKAN does not expose organization follower endpoints, so those remain out of scope).
- [x] Add follow/unfollow helpers plus the "am I following" probes for datasets, groups, and users (organization follow APIs are unavailable upstream).
- [x] Surface `followee_count`, `followee_list`, `user_followee_count`, `user_followee_list`, `dataset_followee_*`, and `group_followee_*` so clients can build dashboards (organization variants depend on missing CKAN endpoints).
- [x] Tests should create a temporary follow relationship via the authorized test user, then clean up.

## 5. Vocabulary & Tag Extensions (Medium)
- [x] Add wrappers for `vocabulary_list`, `vocabulary_show`, `vocabulary_create`, `vocabulary_update`, and `vocabulary_delete` (sysadmin only).
- [x] Implement `tag_autocomplete()` alongside existing tag helpers.
- [x] Update docs to clarify when sysadmin credentials are required and reuse existing templates for parameters.

## 6. Activity & Dashboard APIs (Low-Medium)
- [x] Extend activity coverage: `group_activity_list`, `organization_activity_list`, `recently_changed_packages_activity_list`.
- [x] Wrap dashboard utilities (`dashboard_activity_list`, `dashboard_new_activities_count`, `dashboard_mark_activities_old`).
- [x] Support advanced introspection (`activity_show`, `activity_data_show`, `activity_diff`, `activity_create`, `send_email_notifications`).
- [x] Tests must check `status_show()` to confirm the `activity` plugin is enabled; skip otherwise.

## 7. Admin & Ops Utilities (Low)
- [x] Implement task-status maintenance (`task_status_show`, `task_status_update`, `task_status_update_many`, `task_status_delete`).
- [x] Add term-translation helpers (`term_translation_show`, `term_translation_update`, `term_translation_update_many`).
- [x] Provide runtime config editing (`config_option_list`, `config_option_show`, `config_option_update`).
- [x] Surface background job monitors (`job_list`, `job_show`, `job_clear`, `job_cancel`).
- [x] Cover API token lifecycle (`api_token_list`, `api_token_create`, `api_token_revoke`).
- [x] Expose `status_show()` and `help_show()` as general-purpose diagnostics.
- [x] Because these actions require sysadmin keys, mark tests with explicit skips when `get_test_key()` lacks that role.

## 8. Cross-Cutting Actions
- [x] For each new function, add roxygen docs (templates in `man-roxygen/`), and examples wrapped in `\dontrun{}`.
- [x] Ensure new HTTP calls reuse `ckan_GET/POST/PATCH/DELETE` and dual Authorization headers.
- [x] Expand the Copilot instructions (`.github/copilot-instructions.md`) once the first batch lands so future contributors follow the same patterns.
- [x] Track progress by checking off each bullet when implemented.

## 9. Maintainability & Refactors
- [x] Consolidate membership CRUD patterns (`member_create/delete`, `group_member_*`, `organization_member_*`) behind a single helper that handles ID coercion, POST bodies, and `as` parsing, so adding new endpoints only requires wiring endpoint names.
- [x] Introduce a collaborator request helper that encapsulates the repeated `as.ckan_package()` + `resolve_user_identifier()` + `ckan_{GET,POST}` logic in `R/package_collaborators.R`, reducing copy/paste when future collaborator features arrive.
- [x] Create a shared response parser (e.g., `parse_ckan_response(out, as, coerce = NULL)`) to replace the duplicated `switch(as, ...)` blocks across modules like `resource_views`, `membership`, and dataset extras.
- [x] Extract the `resolve_*` identifier helpers into a single internal file, export them as needed, and update dependent modules (`package_dataset_extras`, `group_list.R`, etc.) to reuse instead of reimplementing ID coercion.
- [x] Convert repeated roxygen example boilerplate (setup + teardown) into reusable templates under `man-roxygen/` to keep documentation consistent and easy to update.

## 10. Maintainability Follow-ups (Ongoing)
- [ ] Reuse `parse_ckan_response()` inside `R/admin_ops.R` so all new helpers share the centralized response handling instead of duplicating `switch(as, ...)` blocks.
- [ ] Add capability guards around the admin/ops helpers (e.g., detect job queue or task-status availability via `status_show()`) and expose matching skip helpers in `tests/testthat/helper-ckanr.R` to avoid confusing 404s on older CKANs.
- [ ] Introduce a `with_sysadmin_ckan()` (or similar) helper in `tests/testthat/helper-ckanr.R` to encapsulate the repetitive `skip_on_cran()`, `check_ckan()`, and `skip_if_not_sysadmin()` scaffolding in `test-admin_ops.R`.
- [ ] Create a roxygen template (e.g., `man-roxygen/example-admin.R`) for the repeated `\dontrun{ ckanr_setup(...) }` admin examples so future docs only need `@template example_admin` and stay consistent.

## 11. Replace lazyeval with rlang
- [x] Inventory all remaining lazyeval touch points (DESCRIPTION Suggests, `.devcontainer` packages, `codemeta.json`, `tests/testthat/test-dplyr.R`, etc.) to confirm scope and plan the migration.
- [x] Add `rlang` (Imports + Suggests if needed) and drop `lazyeval` from every dependency manifest (`DESCRIPTION`, `.devcontainer/devcontainer.json`, docs) so the package pulls in the modern tidy-eval helper.
- [x] Refactor any lazyeval::interp usage (currently in `test-dplyr.R`, plus any others found during inventory) to the equivalent `rlang::expr()`/`rlang::inject()` patterns, keeping tests readable and backwards compatible with supported R versions.
- [x] Update documentation and metadata: mention the migration in `NEWS.md`, ensure `README`/pkgdown snippets no longer reference lazyeval, and explain the new tidy-eval dependency where appropriate.
- [x] Run `devtools::document()`, the targeted test file(s), and `devtools::check()` to ensure the refactor passes CI scaffolding before merging.

## 12. Test Coverage Follow-ups (2025-11-19)
- [x] Add datastore-focused tests ( `ds_search_sql()`, `ds_search()`, `ds_create()`, `ds_create_dataset()` ) once the CKAN datastore plugin is enabled so the critical read/write helpers gain coverage (currently 0%).
- [x] Exercise resource mutation helpers (`resource_update()`, `resource_patch()`, `resource_delete()`, `resource_search()`) with fixtures created by `prepare_test_ckan()` to cover the entire resource lifecycle.
- [x] Cover organization/group mutations and destructive ops (`group_update()`, `group_patch()`, `organization_delete()`, `organization_purge()`) including permission failure expectations.
- [x] Add user lifecycle tests around `user_create()`, `user_delete()`, `user_list()`, `user_activity_list()`, and follower counter endpoints so `followers.R` and related helpers lose their 0% coverage status.
- [ ] Expand tag/vocabulary coverage ( `tag_create()`, `tag_list()`, `tag_search()`, `tag_show()`, `vocabulary.R` ) while ensuring skips when sysadmin rights are absent.
- [ ] Add dashboard/activity plugin coverage for `dashboard_activity_list()`, `dashboard_count()`, and `package_activity_list()` guarded by the existing `activity_plugin_enabled()` helper.
- [ ] Smoke-test the DBI/dplyr bridge (`dbi.R`, `dplyr.R`) by running a simple `collect()` pipeline via `src_ckan()` backed by the seeded datastore table.
- [ ] Add regression tests for `ckan_fetch()` covering at least CSV and JSON downloads (and skip gracefully when optional readers like `sf`/`arrow` are missing).

Test failures on CKAN 2.9:
```
══ Failed tests ════════════════════════════════════════════════════════════════
── Failure ('test-ds_search_sql.R:57:3'): ds_search_sql gives back expected class types ──
Expected `"records" %in% names(a$result)` to be TRUE.
Differences:
`actual`:   FALSE
`expected`: TRUE

── Failure ('test-ds_search_sql.R:58:3'): ds_search_sql gives back expected class types ──
Expected `length(a$result$records)` > 0.
Actual comparison: 0.0 <= 0.0
Difference: 0.0 <= 0
```
