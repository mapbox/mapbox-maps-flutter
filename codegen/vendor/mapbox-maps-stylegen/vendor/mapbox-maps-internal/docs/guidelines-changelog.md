# Maps SDK Changelog Guidelines
The Maps SDK team maintains one `CHANGELOG.md` file per platform and tags releases with the changes included. The following guidelines provide a minimum level of cross-platform consistency between iOS and Android for changelogs and release tags. Any team is welcome to follow additional processes on top of these guidelines. For example, the iOS team may adhere to this [style guide](https://github.com/mapbox/mapbox-gl-native/wiki/Release-notes-style-guide).

## For PR authors
- Apply the `skip changelog` label to your PR if it does not need a changelog entry. For example:
    - a change that doesn’t impact Android/iOS developers or end-users
    - a fix for a regression that has not been released in a final release yet
    - a minor improvement not worth calling out, e.g., code simplification.
- Provide a suggested changelog entry in the PR in `<changelog>Text goes here.</changelog>`.
- Begin each changelog entry with a capitalized past tense verb and end it with a period.

**PR reviewers:** make sure all of the above are present in the PR during your review.

## For release managers
### Changelog entries
- Are followed by a link to the PR in parentheses. `(#####)`
    - For cherry-picked changes, link to the original PR.
    - If an issue provides better context to the developer than the PR, link to the issue followed by the PR. `(#####, fixed by #####)`.
    - Credit external contributors by tagging them. `(#####) (h/t @github-username)`
- Fall under the following categories when applicable and should be ordered as such:
    - `Features`
    - `Performance improvements`
    - `Bug fixes`
    - `Other changes`
- Are included in both changelogs (or neither) if a GL-Native change applies to both platforms.

### Release tags
- Pre-release tags link to changes since the previous release.
- Final release tags link to changes since the previous *final* release.
- All changes in the minor release including pre-releases are in the final release tag.

### `CHANGELOG.md` file
- All changes in the minor release, including pre-releases, are in the final release changelog.
- Entries are ordered by date, with the most recent release on top.

## FAQ
### What is the `skip changelog` label?

The `skip changelog` label is for PR authors to indicate that their change does not need to be in the changelog.

### What changes need to be in the changelog?

Changes that impact the developer or end user should be in the changelog. The goal of the changelog is to communicate to developers the benefits of upgrading to a release.

This includes:
- Breaking changes
- API additions and changes
- New features
- Bug fixes
- Performance improvements
- Dependency upgrades

**If in doubt, include it in the changelog.**

### Who is responsible for preparing the changelog?

Hydrogen: The release manager on-call for publishing a release prepares the changelog based on the changes in the release. PR authors are expected to add suggested changelog entries to the description of the PR when opening a PR.

### Who is responsible for adapting entries from the GL-Native changelog to the Maps SDK changelog?

The release manager who upgrades to a new version of GL-Native is responsible for checking the GL-Native changelog and incorporating any changes that impact developers to the Maps SDK changelog.

### Who is responsible for writing changelog entries for external contributions?

The Mapbox engineer who reviews the PR is responsible for ensuring there is a suggested changelog entry in the PR description before approving it. They should communicate with the external contributor as needed on the changelog entry.

### Does the repository a PR comes from matter when linking to it?

No. Link to the PR number in the changelog without referencing the repository.

### Who approves each changelog?

For now, @chloekraw will review and approve each changelog as we pilot this process. Please tag your team or release buddy for review as well.

# Examples
## Release tags
### Final releases

All changelog entries from pre-releases are included in the release tag and `CHANGELOG.md`. 

The following example assumes we are releasing Maps SDK for Android v8.6.0.

```
    [Changes](https://github.com/mapbox/mapbox-gl-native-android/compare/android-v8.6.0...android-v8.5.2) since [Mapbox Maps SDK for Android v8.5.2](https://github.com/mapbox/mapbox-gl-native-android/releases/tag/android-v8.5.2): // Link to changes since the previous final release (including patches)

    ### Features
     - Added `in` expression for testing whether an item exists in an array or a substring exists in a string. ([#171](https://github.com/mapbox/mapbox-gl-native-android/pull/171))
     - Added option to set the minimum and maximum pitch of a map. ([#199](https://github.com/mapbox/mapbox-gl-native-android/pull/199))

    ### Bug fixes
     - Fixed GeoJSON source flickering during style transitions. ([#15907](https://github.com/mapbox/mapbox-gl-native/pull/15907))
     - Fixed a memory leak during zooming when `MapboxMapOptions.debugActive` is enabled. ([#15179](https://github.com/mapbox/mapbox-gl-native/issues/15179), fixed by [#15395](https://github.com/mapbox/mapbox-gl-native/pull/15395))
     - Fixed a bug where `SymbolLayer.symbolSortKey` would not be applied when overlap was disabled. ([#16023](https://github.com/mapbox/mapbox-gl-native/pull/16023))
```

### Pre-releases

Only changes in this pre-release should be included in the release tag and `CHANGELOG.md`. 

The following example assumes we are releasing Maps SDK for Android v8.6.0-beta.1.

```
    [Changes](https://github.com/mapbox/mapbox-gl-native/compare/android-v8.6.0-alpha.2...android-v8.6.0-beta.1) since [Mapbox Maps SDK for Android v8.6.0-alpha.2](https://github.com/mapbox/mapbox-gl-native/releases/tag/android-v8.6.0-alpha.2): // Link to changes since the previous pre-release (or release, if releasing an alpha.1)

    ### Features
     - Added `in` expression for testing whether an item exists in an array or a substring exists in a string. ([#171](https://github.com/mapbox/mapbox-gl-native-android/pull/171))

    ### Bug fixes
     - Fixed a bug where `SymbolLayer.symbolSortKey` would not be applied when overlap was disabled. ([#16023](https://github.com/mapbox/mapbox-gl-native/pull/16023))
```

## `CHANGELOG.md` file
### Final releases

Headings include the release number, a hyphen, and the full date. `#.#.# - Month DD, YYYY` 

The following example assumes we are releasing a patch release, Maps SDK for Android v8.5.3, after v8.6.0 has already been published. The content of v8.6.0 matches the final release tag example above.

```
    # Changelog for the Mapbox Maps SDK for Android

    Mapbox welcomes participation and contributions from everyone. Please read CONTRIBUTING.md to get started.

    ## 8.5.3 - January 9, 2020 // Order entries by date, not release number
    // Do not start the entry with "Changes since..."
     ...

    ## 8.6.0 - December 20, 2019
    ### Features
     - Added `in` expression for testing whether an item exists in an array or a substring exists in a string. ([#171](https://github.com/mapbox/mapbox-gl-native-android/pull/171))
     - Added option to set the minimum and maximum pitch of a map. ([#199](https://github.com/mapbox/mapbox-gl-native-android/pull/199))

    ### Bug fixes
     - Fixed GeoJSON source flickering during style transitions. ([#15907](https://github.com/mapbox/mapbox-gl-native/pull/15907))
     - Fixed a memory leak during zooming when `MapboxMapOptions.debugActive` is enabled. ([#15179](https://github.com/mapbox/mapbox-gl-native/issues/15179), fixed by [#15395](https://github.com/mapbox/mapbox-gl-native/pull/15395))
     - Fixed a bug where `SymbolLayer.symbolSortKey` would not be applied when overlap was disabled. ([#16023](https://github.com/mapbox/mapbox-gl-native/pull/16023))

    ## 8.5.2 - December 10, 2019
     ...
```

### Pre-releases

Headings refer to final release numbers, even during pre-releases. `#.#.#` 

The following example assumes we are releasing a beta pre-release, Maps SDK for Android v8.6.0-beta.1. The content matches the pre-release tag example above.

```
    # Changelog for the Mapbox Maps SDK for Android

    Mapbox welcomes participation and contributions from everyone. Please read CONTRIBUTING.md to get started.

    ## 8.6.0 // Do not specify the pre-release
    // Do not start the entry with "Changes since..."
    ### Features
     - Added `in` expression for testing whether an item exists in an array or a substring exists in a string. ([#171](https://github.com/mapbox/mapbox-gl-native-android/pull/171))

    ### Bug fixes
     - Fixed a bug where `SymbolLayer.symbolSortKey` would not be applied when overlap was disabled. ([#16023](https://github.com/mapbox/mapbox-gl-native/pull/16023))
```
