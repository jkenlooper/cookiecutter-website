# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

<!--
Not every commit is added to this list, but many items listed are taken from the
git commit messages (`git shortlog 0.1.0..origin/develop`).

Types of changes

- **Added** for new features.
- **Changed** for changes in existing functionality.
- **Deprecated** for soon-to-be removed features.
- **Removed** for now removed features.
- **Fixed** for any bug fixes.
- **Security** in case of vulnerabilities.
-->

<!--
## [Unreleased] - ...
-->

## [Unreleased] - ...

## Added
- Canonical URLs can be set per page by chill data and defaults to request URL
    path.

### Fixed
- favicon URL when served by https

### Changed
- Combined scripts for creating NGINX web config
- Cleaned up script to create ssl certificates for local development

## [0.3.0] - 2020-04-12

### Added
- backup.sh script

### Changed
- Use generic favicon and include documentation on favicon best practices.
- Replaced use of `chill-data.sql` file and now uses `chill initdb` subcommand.
    Requires latest chill version (0.7.0). The `site-data.sql` will now be
    used to store data that is needed for a site that chill dump yaml files do
    not store.

## [0.2.0] - 2020-04-03

### Added
- Guide on regenerating the project files.

### Fixed
- Design token names for selected category set correctly.

## [0.1.0] - 2020-03-27

Start of version tracking.

### Added

- Initial changelog.
- Include generated changelog for project.
- Add [CONTRIBUTING.md](CONTRIBUTING.md) document.

### Changed

- Improved the project's README with a feature list.
- Show cookiecutter-website version and include in generated content.
- Include date of when cookiecutter-website generated the content.
