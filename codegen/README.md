# Codegen

This directory contains the Mapbox maps code generators for Flutter pigeon templates. We support generating code for our higher level Style, annotations and map serialization APIs.
Code generation occurs by reading a specification file (eg. [Style specification](https://github.com/mapbox/mapbox-gl-js/blob/main/src/style-spec/reference/v8.json)) and using a [EJS](https://ejs.co/) template files to output code directly into the project.

## Running the generators

We expose easy to use make targets to run the code generators from the root folder of this repository

```
// Generate map serialisation config templates
make generate-config-templates
```

## FAQ

#### Style-specification has entries that are only supported by gl-js, how do we handle this?

Within style-parser.js, we allow deleting entries from the specification before its provided as input to the generator:
> `delete spec["expression_name"]["values"]["interpolate-hcl"]`
