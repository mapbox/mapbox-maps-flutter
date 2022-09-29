#!/usr/bin/env node
'use strict';

const fs = require('fs');
const ejs = require('ejs');
const _ = require('lodash');
const path = require('path');
const style = require('./../vendor/mapbox-maps-stylegen/style-parser');
require('./../vendor/mapbox-maps-stylegen/type-utils');
require('./../vendor/mapbox-maps-stylegen/style-code');
require('./../utils');

// Template processing //

// Pigeon Configs
const style_layer = ejs.compile(fs.readFileSync('style-generator/style_layer.dart.ejs', 'utf8'), { strict: true })
const style_layer_test = ejs.compile(fs.readFileSync('style-generator/style_layer_test.dart.ejs', 'utf8'), { strict: true })
const style_source = ejs.compile(fs.readFileSync('style-generator/style_source.dart.ejs', 'utf8'), { strict: true })
const style_source_test = ejs.compile(fs.readFileSync('style-generator/style_source_test.dart.ejs', 'utf8'), { strict: true })
const style_light = ejs.compile(fs.readFileSync('style-generator/style_light.dart.ejs', 'utf8'), { strict: true })

for (const layer of style.layers) {
  if (layer.type != 'model') {
    writeIfModified(`../lib/src/style/layer/${layer.type}_layer.dart`, style_layer(layer));
    writeIfModified(`../example/integration_test/style/layer/${layer.type}_layer_test.dart`, style_layer_test(layer));
  }
}

for (const source of style.sources) {
  writeIfModified(`../lib/src/style/source/${removeUnderScore(source.name)}_source.dart`, style_source(source));
  writeIfModified(`../example/integration_test/style/source/${removeUnderScore(source.name)}_source_test.dart`, style_source_test(source));
}
writeIfModified(`../lib/src/style/light.dart`, style_light({properties: style.lightProperties}));