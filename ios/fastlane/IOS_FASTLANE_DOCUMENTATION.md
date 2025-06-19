fastlane documentation
----

# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```sh
xcode-select --install
```

For _fastlane_ installation instructions, see [Installing _fastlane_](https://docs.fastlane.tools/#installing-fastlane)

# Available Actions

## iOS

### ios setup

```sh
[bundle exec] fastlane ios setup
```

Setup iOS environment and dependencies

### ios test

```sh
[bundle exec] fastlane ios test
```

Run iOS tests

### ios build

```sh
[bundle exec] fastlane ios build
```

Build iOS app

### ios build_release

```sh
[bundle exec] fastlane ios build_release
```

Build and sign iOS app for distribution

### ios deploy_testflight

```sh
[bundle exec] fastlane ios deploy_testflight
```

Deploy to TestFlight

### ios deploy_appstore

```sh
[bundle exec] fastlane ios deploy_appstore
```

Deploy to App Store

### ios deploy_firebase

```sh
[bundle exec] fastlane ios deploy_firebase
```

Deploy to Firebase App Distribution

### ios setup_certificates

```sh
[bundle exec] fastlane ios setup_certificates
```

Setup certificates and provisioning profiles

### ios update_certificates

```sh
[bundle exec] fastlane ios update_certificates
```

Update certificates and provisioning profiles

### ios validate

```sh
[bundle exec] fastlane ios validate
```

Validate build configuration

### ios clean

```sh
[bundle exec] fastlane ios clean
```

Clean build artifacts

### ios add_device

```sh
[bundle exec] fastlane ios add_device
```

Register new device

----

This README.md is auto-generated and will be re-generated every time [_fastlane_](https://fastlane.tools) is run.

More information about _fastlane_ can be found on [fastlane.tools](https://fastlane.tools).

The documentation of _fastlane_ can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
