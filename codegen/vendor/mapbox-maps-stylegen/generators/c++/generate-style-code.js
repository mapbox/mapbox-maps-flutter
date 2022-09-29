#!/usr/bin/env node
'use strict';

const fs = require('fs');
const ejs = require('ejs');
const style = require('../../style-parser');
require('../../style-code');
require('../../type-utils');

const layerHpp = ejs.compile(fs.readFileSync('templates/c++/layer.hpp.ejs', 'utf8'), { strict: true });
const layerCpp = ejs.compile(fs.readFileSync('templates/c++/layer.cpp.ejs', 'utf8'), { strict: true });
const propertiesHpp = ejs.compile(fs.readFileSync('templates/c++/layer_properties.hpp.ejs', 'utf8'), { strict: true });
const propertiesCpp = ejs.compile(fs.readFileSync('templates/c++/layer_properties.cpp.ejs', 'utf8'), { strict: true });

for (const layer of style.layers_internal) {
  const layerFileName = layer.type.replace('-', '_');

  writeIfModified(`../src/mbgl/style/layers/${layerFileName}_layer_properties.hpp`, propertiesHpp(layer));
  writeIfModified(`../src/mbgl/style/layers/${layerFileName}_layer_properties.cpp`, propertiesCpp(layer));

  // Remove our fake property for the external interace.
  if (layer.type === 'line') {
    layer.paintProperties = layer.paintProperties.filter(property => property.name !== 'line-floor-width');
  }

  writeIfModified(`../include/mbgl/style/layers/${layerFileName}_layer.hpp`, layerHpp(layer));
  writeIfModified(`../src/mbgl/style/layers/${layerFileName}_layer.cpp`, layerCpp(layer));
}

const lightHpp = ejs.compile(fs.readFileSync('templates/c++/light.hpp.ejs', 'utf8'), { strict: true });
const lightCpp = ejs.compile(fs.readFileSync('templates/c++/light.cpp.ejs', 'utf8'), { strict: true });
writeIfModified(`../include/mbgl/style/light.hpp`, lightHpp({ properties: style.lightProperties }));
writeIfModified(`../src/mbgl/style/light.cpp`, lightCpp({ properties: style.lightProperties }));