# Changelog

## 2019-10-17

* Added
  * Add shell script for a retry command

## 2019-10-14

* Fixed
  * Downloaded tools got to be executable
* Changed
  * Replace wait-for-it with a static binary

## 2019-10-08

* Changed
  * Switch to single branch development
  * Use drone starlark instead of yaml
  * Prepare multi architecture support

## 2019-07-29

* Changed
  * Unified ownership of all files

## 2018-10-08

* Changed
  * Download additional tools within drone
* Removed
  * Dropped shell script for tool download

## 2018-09-25

* Changed
  * Upgrade dockerize from v0.4.0 to v0.6.1
  * Provide an `edge` tage besides the `latest` tag
  * Trigger `owncloud-docker/client` downstream
  * Limit downstream to `master` branch
