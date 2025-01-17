<!-- markdownlint-disable MD022 MD024 -->
# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---
## [Unreleased]
### Added
### Changed
### Deprecated
### Removed
### Fixed
### Security

---
## [0.3.4]
### Added
### Changed

* Update docs to point to new Helm chart repo

### Deprecated
### Removed
### Fixed

---
## [0.3.3]
### Added
### Changed

* Update Timesketch configs download logic to pull git repo instead and copy out
configs from data folder

### Deprecated
### Removed
### Fixed

---
## [0.3.0]
### Added
### Changed
### Deprecated
### Removed
### Fixed

* Adds logic to prevent password regen for Timesketch on Helm upgrades
* Adds missing plaso_formatters.yaml config for Timesketch
* Keep PVC on helm uninstall as an additional safeguard for data retention

---
## [0.2.0]
### Added

* dfTimewolf integration instructions through post install NOTES.txt

### Changed
### Deprecated
### Removed
### Fixed
