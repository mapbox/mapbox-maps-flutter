#!/usr/bin/env node
'use strict';

const spec = require('./serialization-spec');
const _ = require('lodash');

require('../style-code');
const collator = new Intl.Collator("en-US");

// Specification parsing //
// Skip location plugin, since the it is currently under refactoring and many APIs will be changed.
//delete spec["configuration_location"];


// configurations parsing
const configurations = Object.keys(spec).filter(key => key.includes(`configuration_`)).reduce((memo, name) => {
  var config = spec[name];
  const properties = Object.keys(config).reduce((memo, name) => {
    var property = config[name];
    property.name = name
    memo.push(property);
    return memo;
  }, []);
  config.name = name.split(/_(.+)/)[1];
  config.doc = spec[`$root`].option.type.values[config.name].doc
  config[`sdk-support`] = spec[`$root`].option.type.values[config.name][`sdk-support`]
  config.properties = properties;
  memo.push(config);
  return memo;
}, []);

let allConfigsEnumProperties = configurations.filter(config => config.name !== 'resources' && config.name !== 'map').map(config => config.properties).
  reduce((x,y) => x.concat(y), []).filter(property => property.type ==='enum' && property.name !== 'type' && property.name !== 'position');

const configEnumProperties = Array.from(new Set(allConfigsEnumProperties.map(a => a.name)))
  .map(name => {
    var property = allConfigsEnumProperties.find(a => a.name === name)
    if (name === 'location-puck') {
      property.name = name
    }
    return property
  })

module.exports = Object.freeze({
  configurations: configurations,
  configEnumProperties: configEnumProperties
});