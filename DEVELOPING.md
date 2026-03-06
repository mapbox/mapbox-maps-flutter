# Developing

This guide covers everything you need to set up a development environment and contribute to the Mapbox Maps SDK for Flutter.

* [Prerequisites](#prerequisites)
* [Setting Up a Development Environment](#setting-up-a-development-environment)
* [Running the Example App](#running-the-example-app)

## Prerequisites

- **Flutter SDK** 3.27.0 or higher (Dart SDK 3.6.0+)
- **Xcode** (for iOS development) — iOS deployment target is 14.0+
- **Android Studio** or the Android SDK (API level 21+, compile SDK 35)
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

2. Create a `pubspec_overrides.yaml` in the package root to reset [workspace resolution](https://dart.dev/tools/pub/workspaces):

    ```yaml
    # pubspec_overrides.yaml
    resolution:
    ```

3. Fetch Flutter dependencies:

    ```sh
    flutter pub get
    ```

4. Verify your environment is ready:

    ```sh
    flutter analyze
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
