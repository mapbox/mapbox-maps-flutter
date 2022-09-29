# mapbox-maps-stylegen

This repository contains the Mapbox maps style code generator that support generation [style specification](https://github.com/mapbox/mapbox-gl-js/tree/master/src/style-spec) components for C++, Kotlin, and Swift programming languages by using [EJS](https://ejs.co/) template files. The code generator takes the style spec reference definition file as input and outputs an object oriented API for sources, layers, layer properties, light and expressions.

**Update**: The code generator and ejs templates for Kotlin/Swift have been moved from this repo to `mapbox-maps-android-internal`/`mapbox-maps-ios-internal`. This repo only keeps the shared style spec/serialisation spec parsers that are reused by downstream projects.

## Setup environment

```
npm install
```

## Run generator

### Android:

Navigate to `mapbox-maps-android-internal` repo and run the following from the project root:

```
// generate strongly typed Style APIs and their tests:
make generate-style-code

// generate strongly typed plugin configuration APIs from serialisation spec and their tests:
make generate-config-code

// generate strongly typed Annotation APIs and their tests:
make generate-annotation-code
```

### iOS

Navigate to `mapbox-maps-ios-internal` repo and run the following from the project root:

```
// generate strongly typed Style APIs and their tests:
make generate-style-code

// generate strongly typed Annotation APIs and their tests:
make generate-annotation-code
```

## FAQ

#### Style-specification has entries that are only supported by gl-js, how do we handle this?

Within style-parser.js, we allow deleting entries from the specification before its provided as input to the generator:
> `delete spec["expression_name"]["values"]["interpolate-hcl"]`
