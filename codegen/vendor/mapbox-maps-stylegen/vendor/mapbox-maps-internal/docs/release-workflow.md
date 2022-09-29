# Maps SDK team workflow
The `mapbox-gl-native` used to be a monorepo but is now split into separate platform specific repositories (see below). In the context of developing the Carbon Maps SDKs, this document summarizes how platform teams will work together with the GL Native and Core SDK teams.

New repos:

- Hydrogen SDK platform repos: `mapbox-gl-native-android` and `mapbox-gl-native-ios`.

- Carbon SDK platform repos: `mapbox-maps-android` and `mapbox-maps-ios`.

## How releases work

Starting with release `a` (city releases), the GL Native team will start doing tag releases by providing releases on https://github.com/mapbox/mapbox-gl-native/releases. These tags are used downstream by the platform teams/core-sdk. We will consume `mapbox-gl-native`  via submodules pointing at the right tag.
 
## How branches work

The responsibility of cutting and maintaining `mapbox-gl-native` release branches is moved from the platform teams to the GL Native team. Every platform release should be correctly synced to the latest state for the given release type. 

## Release cadence for `mapbox-gl-native-ios|android`

The platforms teams are moving towards a cadence of 6 weeks but will keep the amount of releases the same as with a cadence of 4 weeks. Concretely, this means that we will remain having at least two pre-releases (alpha.1 and beta.1) and one final release in a time period of 6 weeks. This cadence will be effective with release `t`. This allows adding extra time for QA.

**Summary schedule (**[**source**](https://docs.google.com/spreadsheets/d/1_Tg1Rg1JlFVKOjgf4HtucHVXT2hlJQgWMT-irP5okf8/edit?usp=sharing)**)**

![Feature work happens weeks 1-3. Starting week 4 there’s a feature freeze and we cut release branches (indicated by the horizontal vertical line)](https://paper-attachments.dropbox.com/s_879E7BDBAB8E77A966091A09083CC15C6F2B4583601AC4898D6D1B613F6702FC_1575408608447_image.png)

**Platform** **(Android & iOS)**

- Week 1: *No releases.*
    - QA for `master`
    - Retro on previous release cycle.
- Week 2: **R****elease alpha.1**
- Week 3: *No releases.*
    - Branch cut should be cut a week ahead of `beta.1`
    - QA for alpha.1
- Week 4: **R****elease beta.1**
    - Feature freeze + release branch is cut for iOS and Android.
    - All new features require an example
- Week 5: *No releases.*
    - QA for beta.1
- Week 6: **Final release**

**Core SDK**

- Week 1: Retro on previous release cycle
- Week 3: **Release**
    - From GL Native's *release*
- Week 4-6: **Patch release****s**
    - From GL Native’s *patch release*

**GL-****Native**

- Week 1: Retro on previous release cycle
- Week 3: **Release** 
    - Release branch is cut
- Week 4-6: **Patch** **releases**
    - If issues are found in beta.1 of platform release

Notes:

- Optional pre-releases can happen during weeks 1, 3, and 5, for iOS or Android, not necessarily for both platforms. This reduces overlap of releases for old and new SDKs, and patch releases.

## Changelogs

- [Maps SDK Changelog Guidelines](https://github.com/mapbox/mapbox-maps-internal/blob/master/docs/guidelines-changelog.md).
- [More information about iOS changelog styling](https://github.com/mapbox/mapbox-gl-native/wiki/Release-notes-style-guide)
- The GL-Native team will be responsible for creating and maintaining their own changelog file and appending these notes to the github release tag. The native changelog will flag and label the changes that affect Android/iOS/both/none

## Changes to release manager role for platform teams

Release managers are responsible for, in addition to performing the actual release, running point on integrating required changes from the upstream repository. They monitor the pull requests created by the GL-Native team and are point of contact when breaking changes are made.