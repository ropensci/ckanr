# CONTRIBUTING #

### Bugs?

* Submit an issue on the [Issues page](https://github.com/ropensci/ckanr/issues)

### Code contributions

* Fork this repo to your Github account
* Clone your version on your account down to your machine from your account, e.g,. `git clone https://github.com/<yourgithubusername>/ckanr.git`
* Make sure to track progress upstream (i.e., on our version of `ckanr` at `ropensci/ckanr`) by doing `git remote add upstream https://github.com/ropensci/ckanr.git`. Before making changes make sure to pull changes in from upstream by doing either `git fetch upstream` then merge later or `git pull upstream` to fetch and merge in one step
* Make your changes (bonus points for making changes on a new feature branch)
* Test your changes locally. You can spin up a local CKAN site running at <http://localhost:5000/> for testing with

    ```bash
    docker compose up
    ```

    There is a sysadmin user created by default with `username=ckan_admin` and `password=test1234`. You can retrieve the user details including the API KEY (for the R environment variable `TEST_API_KEY`) with

    ```bash
    docker exec ckanr-ckan-1 paster --plugin=ckan user ckan_admin
    ```
* Push up to your account
* Submit a pull request to home base (likely master branch, but check to make sure) at `ropensci/ckanr`

### Also, check out our [discussion forum](https://discuss.ropensci.org)

### Email

Don't send email. Open an issue instead.
