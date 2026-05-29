# Developing

This guide covers everything you need to set up a development environment and contribute to the Mapbox Maps SDK for Flutter.

* [Prerequisites](#prerequisites)
* [Setting Up a Development Environment](#setting-up-a-development-environment)
* [Running the Example App](#running-the-example-app)

## Prerequisites

- **Flutter SDK** 3.38.1 or higher (Dart SDK 3.10.0+)
- **Xcode** (for iOS development) — iOS deployment target is 14.0+
- **Android Studio** or the Android SDK (API level 21+, compile SDK 35)
- A modern browser with WebGL 2 support (for web development)
- A Mapbox account with a valid [access token](https://account.mapbox.com/access-tokens/)

### Mapbox Access Tokens

You need two types of tokens:

1. **Secret token** (`sk.*`) — required to download Mapbox binary dependencies.
2. **Public token** (`pk.*`) — used at runtime to authenticate with Mapbox APIs.

#### iOS — configure `~/.netrc`

Add the following to `~/.netrc` (create it if it doesn't exist):

```
machine api.mapbox.com
  login mapbox
  password <your-secret-token>
```

#### Android — configure `SDK_REGISTRY_TOKEN`

Set the `SDK_REGISTRY_TOKEN` environment variable, or add it to your `gradle.properties`:

```properties
SDK_REGISTRY_TOKEN=<your-secret-token>
```

## Setting Up a Development Environment

1. Clone the repository:

    ```sh
    git clone git@github.com:mapbox/mapbox-maps-flutter.git
    cd mapbox-maps-flutter
    ```

2. Resolve dependencies for the federated packages — for example, by
   running `flutter pub get` in each package, or by setting up a
   [pub workspace](https://dart.dev/tools/pub/workspaces) at the repo
   root.

   The example app under `mapbox_maps_flutter/example/` already has a
   `pubspec_overrides.yaml` that points its dependencies at the in-tree
   packages, so no extra wiring is required to run it.

3. Verify your environment is ready by analyzing any package:

    ```sh
    cd mapbox_maps_flutter && flutter analyze
    ```

## Running the Example App

The example app demonstrates the SDK's features and serves as the host for integration tests.

```sh
cd example

# Provide your public access token
flutter run --dart-define=ACCESS_TOKEN=pk.your_token_here
```

You can also persist the token in `.vscode/launch.json`:

```json
{
  "configurations": [
    {
      "args": ["--dart-define", "ACCESS_TOKEN=pk.your_token_here"]
    }
  ]
}
```
