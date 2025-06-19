fastlane documentation
----

# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```sh
xcode-select --install
```

For _fastlane_ installation instructions, see [Installing _fastlane_](https://docs.fastlane.tools/#installing-fastlane)

# Available Actions

## Android

### android setup

```sh
[bundle exec] fastlane android setup
```

Setup Android environment and dependencies

### android test

```sh
[bundle exec] fastlane android test
```

Run Android tests

### android build_apk

```sh
[bundle exec] fastlane android build_apk
```

Build Android APK

### android build_bundle

```sh
[bundle exec] fastlane android build_bundle
```

Build Android App Bundle

### android deploy_internal

```sh
[bundle exec] fastlane android deploy_internal
```

Deploy to internal testing

### android deploy_alpha

```sh
[bundle exec] fastlane android deploy_alpha
```

Deploy to alpha testing

### android deploy_beta

```sh
[bundle exec] fastlane android deploy_beta
```

Deploy to beta testing

### android deploy_production

```sh
[bundle exec] fastlane android deploy_production
```

Deploy to production

### android deploy_firebase

```sh
[bundle exec] fastlane android deploy_firebase
```

Deploy to Firebase App Distribution

### android build_debug_artifacts

```sh
[bundle exec] fastlane android build_debug_artifacts
```

Build debug artifacts with dynamic versioning

### android build_release_artifacts

```sh
[bundle exec] fastlane android build_release_artifacts
```

Build release artifacts with dynamic versioning

### android build_staging_debug_artifacts

```sh
[bundle exec] fastlane android build_staging_debug_artifacts
```

Build staging debug artifacts with dynamic versioning

### android build_staging_release_artifacts

```sh
[bundle exec] fastlane android build_staging_release_artifacts
```

Build staging release artifacts with dynamic versioning

### android build_production_debug_artifacts

```sh
[bundle exec] fastlane android build_production_debug_artifacts
```

Build production debug artifacts with dynamic versioning

### android build_production_release_artifacts

```sh
[bundle exec] fastlane android build_production_release_artifacts
```

Build production release artifacts with dynamic versioning

### android validate

```sh
[bundle exec] fastlane android validate
```

Validate build configuration

### android clean

```sh
[bundle exec] fastlane android clean
```

Clean build artifacts

----

This README.md is auto-generated and will be re-generated every time [_fastlane_](https://fastlane.tools) is run.

More information about _fastlane_ can be found on [fastlane.tools](https://fastlane.tools).

The documentation of _fastlane_ can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
