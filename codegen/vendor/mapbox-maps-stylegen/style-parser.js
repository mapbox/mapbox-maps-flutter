#!/usr/bin/env node
'use strict';

const spec = require('./style-spec');
const _ = require('lodash');

// Video source is not supported by gl-native yet.
delete spec["source_video"]

// Filter property not supported yet.
// https://github.com/mapbox/mapbox-gl-native-internal/issues/733
delete spec["source_geojson"]["filter"]

// clusterMinPoints property not supported yet.
// https://github.com/mapbox/mapbox-gl-native-internal/issues/732
delete spec["source_geojson"]["clusterMinPoints"]

// Following expression is not supported on gl-native.
delete spec["expression_name"]["values"]["interpolate-hcl"]
delete spec["expression_name"]["values"]["interpolate-lab"]

// Add read-only flag to selected source properties.
// https://github.com/mapbox/mapbox-gl-js-internal/issues/248
spec["source_geojson"]["clusterMaxZoom"]["read-only"] = true
spec["source_geojson"]["clusterRadius"]["read-only"] = true
spec["source_geojson"]["clusterProperties"]["read-only"] = true
spec["source_geojson"]["lineMetrics"]["read-only"] = true
spec["source_geojson"]["maxzoom"]["read-only"] = true
spec["source_geojson"]["tolerance"]["read-only"] = true
spec["source_geojson"]["generateId"]["read-only"] = true
spec["source_geojson"]["promoteId"]["read-only"] = true
spec["source_geojson"]["attribution"]["read-only"] = true
spec["source_geojson"]["buffer"]["read-only"] = true
spec["source_geojson"]["cluster"]["read-only"] = true
spec["source_raster_dem"]["encoding"]["read-only"] = true
spec["source_raster_dem"]["bounds"]["read-only"] = true
spec["source_raster_dem"]["attribution"]["read-only"] = true
spec["source_raster_dem"]["tileSize"]["read-only"] = true
spec["source_raster"]["bounds"]["read-only"] = true
spec["source_raster"]["attribution"]["read-only"] = true
spec["source_raster"]["scheme"]["read-only"] = true
spec["source_raster"]["tileSize"]["read-only"] = true
spec["source_vector"]["bounds"]["read-only"] = true
spec["source_vector"]["attribution"]["read-only"] = true
spec["source_vector"]["scheme"]["read-only"] = true
spec["source_vector"]["promoteId"]["read-only"] = true

// Add prefetch-zoom-delta to all sources.
const prefetchZoomDelta = {
  "type": "number",
  "default": 4,
  "volatile": true,
  "doc": "When loading a map, if PrefetchZoomDelta is set to any number greater than 0, the map will first request a tile at zoom level lower than zoom - delta, but so that the zoom level is multiple of delta, in an attempt to display a full map at lower resolution as quick as possible. It will get clamped at the tile source minimum zoom. The default delta is 4."
}
spec["source_geojson"]["prefetch-zoom-delta"] = prefetchZoomDelta
spec["source_raster_dem"]["prefetch-zoom-delta"] = prefetchZoomDelta
spec["source_raster"]["prefetch-zoom-delta"] = prefetchZoomDelta
spec["source_vector"]["prefetch-zoom-delta"] = prefetchZoomDelta
spec["source_image"]["prefetch-zoom-delta"] = prefetchZoomDelta

// Add minimum-tile-update-interval property for source properties with volatile support.
const minimumTileUpdateInterval = {
  "type": "number",
  "default": 0,
  "volatile": true,
  "doc": "Minimum tile update interval in seconds, which is used to throttle the tile update network requests. If the given source supports loading tiles from a server, sets the minimum tile update interval. Update network requests that are more frequent than the minimum tile update interval are suppressed."
}
spec["source_vector"]["minimum-tile-update-interval"] = minimumTileUpdateInterval
spec["source_raster"]["minimum-tile-update-interval"] = minimumTileUpdateInterval
spec["source_raster_dem"]["minimum-tile-update-interval"] = minimumTileUpdateInterval

// Add max-overscale-factor-for-parent-tiles property for source properties with volatile support.
const maxOverscaleFactorForParentTiles = {
  "type": "number",
  "volatile": true,
  "doc": "When a set of tiles for a current zoom level is being rendered and some of the ideal tiles that cover the screen are not yet loaded, parent tile could be used instead. This might introduce unwanted rendering side-effects, especially for raster tiles that are overscaled multiple times. This property sets the maximum limit for how much a parent tile can be overscaled."
}
spec["source_vector"]["max-overscale-factor-for-parent-tiles"] = maxOverscaleFactorForParentTiles
spec["source_raster"]["max-overscale-factor-for-parent-tiles"] = maxOverscaleFactorForParentTiles
spec["source_raster_dem"]["max-overscale-factor-for-parent-tiles"] = maxOverscaleFactorForParentTiles

// Add tile-requests-delay property for source properties with volatile support.
const tileRequestsDelay = {
  "type": "number",
  "default": 0,
  "volatile": true,
  "doc": "For the tiled sources, this property sets the tile requests delay. The given delay comes in action only during an ongoing animation or gestures. It helps to avoid loading, parsing and rendering of the transient tiles and thus to improve the rendering performance, especially on low-end devices."
}
spec["source_vector"]["tile-requests-delay"] = tileRequestsDelay
spec["source_raster"]["tile-requests-delay"] = tileRequestsDelay
spec["source_raster_dem"]["tile-requests-delay"] = tileRequestsDelay

// Add tile-network-requests-delay property for source properties with volatile support.
const tileNetworkRequestsDelay = {
  "type": "number",
  "default": 0,
  "volatile": true,
  "doc": "For the tiled sources, this property sets the tile network requests delay. The given delay comes in action only during an ongoing animation or gestures. It helps to avoid loading the transient tiles from the network and thus to avoid redundant network requests. Note that tile-network-requests-delay value is superseded with tile-requests-delay property value, if both are provided."
}
spec["source_vector"]["tile-network-requests-delay"] = tileNetworkRequestsDelay
spec["source_raster"]["tile-network-requests-delay"] = tileNetworkRequestsDelay
spec["source_raster_dem"]["tile-network-requests-delay"] = tileNetworkRequestsDelay

// rename GeojsonSource to GeoJsonSource
Object.defineProperty(spec, "source_geo_json", Object.getOwnPropertyDescriptor(spec, "source_geojson"));
delete spec["source_geojson"];

require('./style-code');
const collator = new Intl.Collator("en-US");

// Specification parsing //

// Light parsing
const lightProperties = Object.keys(spec[`light`]).reduce((memo, name) => {
  var property = spec[`light`][name];
  property.name = name;
  property['light-property'] = true;
  memo.push(property);
  return memo;
}, []);

lightProperties.doc = spec[`$root`][`light`][`doc`]
// JSON doesn't have a defined order. We're going to sort them alphabetically
// to get a deterministic order.
lightProperties.sort((a, b) => collator.compare(a.name, b.name));

// Terrain parsing
const terrainProperties = Object.keys(spec[`terrain`]).reduce((memo, name) => {
  var property = spec[`terrain`][name];
  property.name = name;
  property['terrain-property'] = true;
  if (property.name !== "source") {
    memo.push(property);
  }
  return memo;
}, []);

terrainProperties.doc = spec[`$root`][`terrain`][`doc`]
// JSON doesn't have a defined order. We're going to sort them alphabetically
// to get a deterministic order.
terrainProperties.sort((a, b) => collator.compare(a.name, b.name));

// Fog parsing that we actually call atmosphere on Android / iOS
const atmosphereProperties = Object.keys(spec[`fog`]).reduce((memo, name) => {
  var property = spec[`fog`][name];
  property.name = name;
  property['atmosphere-property'] = true;
  // check if we have default expression and treat is a string then
  if (property[`default`].includes('interpolate')) {
    property[`default`] = JSON.stringify(property[`default`])
    property['default-expression'] = true;
  }
  memo.push(property);
  return memo;
}, []);

atmosphereProperties.doc = spec[`$root`][`fog`][`doc`]
// JSON doesn't have a defined order. We're going to sort them alphabetically
// to get a deterministic order.
atmosphereProperties.sort((a, b) => collator.compare(a.name, b.name));


// Projection parsing
const projectionProperties = Object.keys(spec[`projection`]).reduce((memo, name) => {
  // Ignore all properties but the ones required for the globe view
  if (name === 'name') {
    var property = spec[`projection`][name];
    property.name = name;
    property['projection-property'] = true;
    var result = property
    var map = property[`values`];
    // only globe and mercator are supported for now
    result[`values`] = ["mercator", "globe"].reduce((obj, key) => {
        if (map.hasOwnProperty(key)) obj[key] = map[key];
        return obj;
    }, {});
    memo.push(result);
    return memo;
  }
  return memo;
}, []);

// projectionProperties.doc = spec[`$root`][`projection`][`doc`]
projectionProperties.sort((a, b) => collator.compare(a.name, b.name));

// Collect layer types from spec
const layers = constructLayers(spec)

// Add this mock property that our SDF line shader needs so that it gets added to the list of
// "data driven" properties.
spec.paint_line['line-floor-width'] = {
  "type": "number",
  "default": 1,
  "property-type": "data-driven"
};
const layers_internal = constructLayers(spec)

function constructLayers(specification) {
  return Object.keys(specification.layer.type.values).map((type) => {
    const layoutProperties = Object.keys(specification[`layout_${type}`]).reduce((memo, name) => {
      if (name !== 'visibility') {
        specification[`layout_${type}`][name].name = name;
        memo.push(specification[`layout_${type}`][name]);
      }
      return memo;
    }, []);

    // JSON doesn't have a defined order. We're going to sort them alphabetically
    // to get a deterministic order.
    layoutProperties.sort((a, b) => collator.compare(a.name, b.name));

    const paintProperties = Object.keys(specification[`paint_${type}`]).reduce((memo, name) => {
      specification[`paint_${type}`][name].name = name;
      memo.push(specification[`paint_${type}`][name]);
      return memo;
    }, []);

    // JSON doesn't have a defined order. We're going to sort them alphabetically
    // to get a deterministic order.
    paintProperties.sort((a, b) => collator.compare(a.name, b.name));

    return {
      type: type,
      doc: specification.layer.type.values[type].doc,
      layoutProperties: layoutProperties,
      paintProperties: paintProperties,
      properties: layoutProperties.concat(paintProperties),
      layoutPropertiesByName: specification[`layout_${type}`],
      paintPropertiesByName: specification[`paint_${type}`],
      experimental: specification.layer.type.values[type].experimental === undefined ? false : specification.layer.type.values[type].experimental,
      internal: specification.layer.type.values[type].internal === undefined ? false : specification.layer.type.values[type].internal
    };
  });
}

// Specification parsing for Expressions
const expressions = Object.keys(spec[`expression_name`][`values`]).reduce((memo, name) => {
  var expression = spec[`expression_name`][`values`][name];
  expression.name = name;
  // expression['expression-name'] = true;
  memo.push(expression);
  return memo;
}, []);

// JSON doesn't have a defined order. We're going to sort them alphabetically
// to get a deterministic order.
expressions.sort((a, b) => collator.compare(a.name, b.name));

// const expressions = spec[`expression_name`][`values`]

// Process all layer properties
const uniqueArrayEnum = (prop, enums) => {
  if (prop.value !== 'enum') return false;
  const enumsEqual = (val1, val2) => val1.length === val1.length && val1.every((val, i) => val === val2[i]);
  return enums.filter(e => enumsEqual(Object.keys(prop.values).sort(), Object.keys(e.values).sort())).length == 0;
};

const layoutProperties = _(layers).map('layoutProperties').flatten().value();
const paintProperties = _(layers).map('paintProperties').flatten().value();
const allProperties = _(layoutProperties).union(paintProperties).union(lightProperties).union(terrainProperties).union(atmosphereProperties).union(projectionProperties).value();

let allEnumProperties = _(allProperties).filter({ 'type': 'enum' }).value();
const uniqueArrayEnumProperties = _(allProperties).filter({ 'type': 'array' }).filter(prop => uniqueArrayEnum(prop, allEnumProperties)).value();
const enumProperties = _(allEnumProperties).union(uniqueArrayEnumProperties).value();

// Parsing sources.
const sources = Object.keys(spec).filter(key => key.includes(`source_`)).reduce((memo, name) => {
  var source = spec[name];
  const properties = Object.keys(source).reduce((memo, name) => {
    var property = source[name];
    property.name = name
    memo.push(property);
    return memo;
  }, []);
  source.name = name.split(/_(.+)/)[1];
  source.properties = properties;
  memo.push(source);
  return memo;
}, []);

let allSourceEnumProperties = sources.map(source => source.properties).
  reduce((x,y) => x.concat(y), []).filter(property => property.type ==='enum' && property.name !== 'type');
const sourceEnumProperties = Array.from(new Set(allSourceEnumProperties.map(a => a.name)))
  .map(name => {
    return allSourceEnumProperties.find(a => a.name === name)
  })

// Util funtions to generate documentation.
/**
 * Produces documentation for property factory methods
 */
global.propertyFactoryMethodDoc = function (property) {
  var replaceIfPixels = function (doc) {
    return doc.replace('pixels', 'density-independent pixels')
  }
  let doc = replaceIfPixels(property.doc);
  // Match other items in back ticks
  doc = doc.replace(/`(.+?)`/g, function (m, symbol, offset, str) {
    if (str.substr(offset - 4, 3) !== 'CSS' && symbol[0].toUpperCase() != symbol[0] && _(enumProperties).filter({ 'name': symbol }).value().length > 0) {
      // Property 'enums'
      symbol = snakeCaseUpper(symbol);
      return '{@link Property.' + symbol + '}';
    } else if (_(allProperties).filter({ 'name': symbol }).value().length > 0) {
      // Other properties
      return '{@link PropertyFactory#' + camelizeWithLeadingLowercase(symbol) + '}';
    } else {
      // Left overs
      return '`' + symbol + '`';
    }
  });
  return doc;
};

/**
 * Produce website-friendly documentation for property
 */
global.markdownFriendlyDoc = function (property) {
  var replaceDegree = function (doc) {
    return doc.replace(/°/g, ' degree');
  }
  return replaceDegree(property.doc)
}

module.exports = Object.freeze({
  layers: layers,
  layers_internal: layers_internal,
  layoutProperties: layoutProperties,
  paintProperties: paintProperties,
  enumProperties: enumProperties,
  lightProperties: lightProperties,
  terrainProperties: terrainProperties,
  atmosphereProperties: atmosphereProperties,
  projectionProperties: projectionProperties,
  expressions: expressions,
  sources: sources,
  sourceEnumProperties: sourceEnumProperties
});