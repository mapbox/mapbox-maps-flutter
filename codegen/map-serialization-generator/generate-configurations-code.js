#!/usr/bin/env node
'use strict';

const fs = require('fs');
const ejs = require('ejs');
const spec = require('./../vendor/mapbox-maps-stylegen/map-serialization-generator/spec-parser');
const _ = require('lodash');
require('./../vendor/mapbox-maps-stylegen/style-code');
require('./../vendor/mapbox-maps-stylegen/type-utils');

// Template processing //

// Pigeon Configs
const pigeonTemplateDart = ejs.compile(fs.readFileSync('map-serialization-generator/pigeon_templates.dart.ejs', 'utf8'), { strict: true })
// Mappings from Pigeon to plugin interfaces
const pigeonMappingsTemplateKt = ejs.compile(fs.readFileSync('map-serialization-generator/pigeon-flt-settings-mappings.kt.ejs', 'utf8'), { strict: true })

// Filter out the properties not supported by Android
for (const config of spec.configurations) {
  config.supported_properties = config.properties.filter(property => property[`sdk-support`][`basic functionality`].android !== undefined)
  config.properties = config.supported_properties

  // Add property platformName since it was introduced at https://github.com/mapbox/mapbox-maps-internal/blob/main/serialization-spec/v1.json#L366.
  for (const property of config.properties) {
    if (property[`sdk-support`][`platform-name`] !== undefined && property[`sdk-support`][`platform-name`].android !== undefined) {
      property.platformName = property[`sdk-support`][`platform-name`].android;
    } else {
      property.platformName = property.name
    }
  }
}

writeIfModified(`../pigeons/settings.dart`, pigeonTemplateDart(spec));

for (const config of spec.configurations) {
  // Generate files for target repository
  if (config.name !== 'resources' && config.name !== 'map' ) {
    writeIfModified(`../android/src/main/kotlin/com/mapbox/maps/mapbox_maps/mapping/${camelizeWithUndercoreRemoved(config.name)}Mappings.kt`, pigeonMappingsTemplateKt(config));
  }
}