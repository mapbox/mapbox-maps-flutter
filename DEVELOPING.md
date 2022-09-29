### Configuring private Mapbox access token
A mapbox secret token is required to download the corresponding Android/iOS native libraries from Mapbox hosting infrastructure. Please follow the instructions from below to configure your secret token:

For Android:
https://docs.mapbox.com/android/maps/guides/install/#configure-credentials

For iOS:
https://docs.mapbox.com/ios/maps/guides/install/#configure-credentials

### Configuring public Mapbox access token

A public access token must be provided to a MapboxMap widget for retrieving styles and resources.
While you can hardcode it directly into source files,
it's good practise to retrieve access tokens from some external source
(e.g. a config file or an environment variable).

You can pass access token via the command line arguments when either building : 

```
flutter build <platform> --dart-define ACCESS_TOKEN=YOUR_TOKEN_HERE
```

or running the application : 

```
flutter run --dart-define ACCESS_TOKEN=YOUR_TOKEN_HERE
```

You can also persist token in launch.json : 
```
"configurations": [
    {
        ...
        "args": [
            "--dart-define", "ACCESS_TOKEN=..."
        ],
    }
]
```

Then it's retrieved in Dart:
```
MapboxMap(
  ...
  accessToken: const String.fromEnvironment("ACCESS_TOKEN"),
  ...
)
```

### Develop with pigeon
We apply pigeon to generate bridge codes between dart and Android/iOS, the develop process is:

1. Update the template file `pigeons/mapbox_map.dart`.
   
2. Run command `make run-pigeon` to generate the bridge codes.
   
3. Implement the APIs in Android and iOS the forward the api call to sdk side.