# Test Coverage Summary

## New Tests Added

This document summarizes the test files that were created to improve test coverage for the ckanr package.

### Package (Dataset) Functions

#### test-package_create.R
- Tests for creating packages with minimal and full parameters
- Tests for private packages
- Tests for JSON output format
- Error handling tests for validation errors and authorization failures
- **Coverage**: `package_create()` function from `R/package_create.R`

#### test-package_delete.R
- Tests for deleting packages by ID and by ckan_package object
- Error handling tests for missing IDs, invalid IDs, and bad keys
- **Coverage**: `package_delete()` function from `R/package_delete.R`

#### test-package_update.R
- Tests for updating package metadata (single and multiple fields)
- Tests for JSON output format
- Error handling tests for invalid input types, IDs, and authentication
- **Coverage**: `package_update()` function from `R/package_update.R`

#### test-package_patch.R
- Tests for patching package metadata (partial updates)
- Tests for working with ckan_package objects
- Tests for adding extras to packages
- Error handling and JSON output tests
- **Coverage**: `package_patch()` function from `R/package_patch.R`

### Resource Functions

#### test-resource_create.R
- Tests for creating resources with file uploads
- Tests for creating resources with URL only
- Tests for resource extras (additional metadata)
- Tests for accepting ckan_package objects
- Error handling tests for missing/invalid parameters
- Tests for JSON output format
- **Coverage**: `resource_create()` function from `R/resource_create.R`

#### test-resource_delete.R
- Tests for deleting resources by ID and by ckan_resource object
- Error handling tests for missing IDs, invalid IDs, and bad keys
- Verification that deleted resources cannot be retrieved
- **Coverage**: `resource_delete()` function from `R/resource_delete.R`

### Organization Functions

#### test-organization_create.R
- Tests for creating organizations with minimal and full parameters
- Tests for setting organization metadata (title, description, image_url)
- Error handling tests for validation errors and authorization failures
- Tests for JSON output format
- **Coverage**: `organization_create()` function from `R/organization_create.R`

#### test-organization_delete.R
- Tests for deleting organizations by ID and by ckan_organization object
- Error handling tests for missing IDs, invalid IDs, and bad keys
- Verification that deleted organizations cannot be retrieved
- **Coverage**: `organization_delete()` function from `R/organization_delete.R`

### Group Functions

#### test-group_create.R
- Tests for creating groups with minimal and full parameters
- Tests for setting group metadata (title, description, image_url)
- Error handling tests for validation errors and authorization failures
- Tests for JSON output format
- **Coverage**: `group_create()` function from `R/group_create.R`

#### test-group_delete.R
- Tests for deleting groups by ID and by ckan_group object
- Error handling tests for missing IDs, invalid IDs, and bad keys
- Verification that deleted groups cannot be retrieved
- **Coverage**: `group_delete()` function from `R/group_delete.R`

### User Functions

#### test-user_show.R
- Tests for showing user information
- Tests for include_datasets parameter
- Tests for include_num_followers parameter
- Tests for JSON output format
- Error handling tests for non-existent users
- **Coverage**: `user_show()` function from `R/user_show.R`

#### test-user_activity_list.R
- Tests for listing user activities
- Tests for limit parameter (pagination)
- Tests for accepting ckan_user objects
- Tests for different output formats (JSON, table)
- Error handling tests for non-existent users
- **Coverage**: `user_activity_list()` function from `R/user_activity_list.R`

### DataStore Functions

#### test-ds_create.R
- Tests for creating datastore tables for resources
- Tests for creating datastore with sample records
- Tests for creating datastore with field specifications
- Error handling tests for missing/invalid resource IDs
- **Note**: This function has known issues and may not work in all CKAN versions
- **Coverage**: `ds_create()` function from `R/ds_create.R`

### Dashboard Functions

#### test-dashboard_activity_list.R
- Tests for retrieving dashboard activities for authenticated users
- Tests for limit parameter (pagination)
- Tests for JSON output format
- Error handling tests for invalid API keys
- **Note**: Requires valid API key for testing
- **Coverage**: `dashboard_activity_list()` function from `R/dashboard_activity_list.R`

## Test Patterns

All tests follow consistent patterns established in the existing test suite:

1. **Test Setup**: Use `get_test_url()`, `get_test_key()`, and test fixture IDs
2. **CRAN Skip**: All tests skip on CRAN with `skip_on_cran()`
3. **OS Skip**: Tests that modify data skip on Windows and Mac to avoid CI conflicts
4. **CKAN Check**: Use `check_ckan()` to skip tests when CKAN is offline
5. **Cleanup**: Delete created resources after testing to avoid accumulation
6. **Error Testing**: Test both successful operations and failure modes
7. **Output Formats**: Test JSON, list, and table output formats where applicable
8. **S3 Class Testing**: Test functions accepting both IDs and S3 objects (ckan_package, ckan_resource, etc.)

## Functions Still Without Tests

The following functions were identified as not having dedicated test coverage. They may be lower priority or have issues that prevent testing:

### Medium Priority:
- `group_update()` - Update group metadata
- `group_patch()` - Patch group metadata
- `organization_purge()` - Permanently delete organization
- `resource_patch()` - Patch resource metadata
- `tag_create()` - Create tags (requires sysadmin privileges, has warning)
- `user_create()` - Create users (may require special permissions)
- `user_delete()` - Delete users (may require special permissions)
- `user_followee_count()` - Count users followed by a user
- `user_follower_count()` - Count user's followers
- `user_follower_list()` - List user's followers
- `dashboard_count()` - Get dashboard counts

### Lower Priority (deprecated or specialized):
- `related_create()` - Create related items
- `related_delete()` - Delete related items
- `related_list()` - List related items
- `related_show()` - Show related item
- `related_update()` - Update related items

### Internal/Infrastructure:
- S3 coercion functions (`as.ckan_*`) - mostly tested indirectly
- DBI/dplyr integration - partially tested via `test-dplyr.R`
- Helper functions in `R/zzz.R` - tested indirectly

## Running the Tests

To run the new tests:

```r
# Run all tests
devtools::test()

# Run specific test files
devtools::test(filter = "package_create")
devtools::test(filter = "resource")
devtools::test(filter = "organization")

# Run with coverage report
covr::package_coverage()
```

## Notes

1. All tests require a running CKAN instance (configured via `ckanr_setup()`)
2. Tests that create/modify data require a valid API key with appropriate permissions
3. Some tests may fail or be skipped on certain CKAN versions due to API differences
4. The test suite uses `prepare_test_ckan()` to auto-create test fixtures on first run
5. Tests are designed to clean up after themselves to avoid accumulating test data
