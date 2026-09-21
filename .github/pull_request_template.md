<!--- Add a general summary of your changes in the Title above.
Name your branch after the issue it addresses: <ISSUE_ID>-<SHORT_BRANCH_NAME> -->

## Description
<!--- Describe your changes in detail -->

## Related Issue
<!--- If this closes an issue, include for example "fix #4".
If it relates to an issue, mention for example "#4" -->

## Example
<!--- If you add a new feature or change behavior of existing
methods/functions, include an example in brief form if you can -->

## Devcontainer checklist
<!--- The devcontainer provides the full toolchain plus a test CKAN
instance at http://localhost:5000. Run these before you submit.
Delete lines that do not apply. -->
- [ ] Installed with the "Install" VS Code task or `just install`
- [ ] Docs regenerated with `just doc` (updates `man/` and `README.md`)
- [ ] Tests pass with the "Test" task or `just test`
- [ ] Test CKAN version checked with `just ckan_version`
- [ ] `R CMD check` shows 0 errors, 0 warnings, 0 notes

## R package checklist
- [ ] New behavior has tests. Tests skip cleanly when the test CKAN lacks the feature.
- [ ] `NEWS.md` has an entry for user-facing changes.
- [ ] New docs use plain language. See the `simple-english` skill.
- [ ] No secrets, keys, or tokens are committed.
