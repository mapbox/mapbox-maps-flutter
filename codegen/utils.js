#!/usr/bin/env node
'use strict';

const fs = require('fs');
const ejs = require('ejs');
const _ = require('lodash');
const path = require('path');
require('./vendor/mapbox-maps-stylegen/style-code');

global.withSource = function withSource(type) {
    return type !== 'background' && type !== 'custom' && type !== 'location-indicator' && type !== 'sky'
}
global.shouldSkipAnnotationProperty = function shouldSkipAnnotationProperty(annotationType, property) {
  return property.name == "line-gradient"
  // Pigeon doesn't support list of enum in iOS https://github.com/flutter/flutter/issues/93525
  || property.name == "text-variable-anchor" || property.name == "text-writing-mode";
}

global.serializationSpecPropertyDartType = function serializationSpecPropertyDartType(property) {
  switch (property.type) {
    case 'boolean':
      return 'bool';
    case 'number':
    case 'dimension':
      if (property.name === 'refresh-interval' || property.name === 'stale-state-timeout') {
        return 'int';
      }
      return 'double';
    case 'formatted':
    case 'string':
    case 'resolvedImage':
      return 'String';
    case 'image':
      return 'String';
    case 'enum':
      if (property.name === 'position') {
        return 'int'
      }
      return `${property.name ? camelize(property.name) : "String"}`;
    case 'color':
      return 'int';
    case 'array':
      if (`${serializationSpecPropertyDartType({ type: property.value })}` === "String") {
        return 'List<String?>';
      }
      if (property.name === "focal-point") {
        return 'ScreenCoordinate'
      }
      return `List<${serializationSpecPropertyDartType({ type: property.value })}?>`;
    default:
      throw new Error(`unknown type for ${property.name}`);
  }
}

global.propertyDartReturnType = function propertyDartReturnType(property) {
    switch (property.type) {
      case 'enum':
        return 'int';
      default:
        return `${propertyDartType(property)}`;
    }
}

global.propertyDartElementType = function propertyDartElementType(property) {
  let elementProperty;
  if (property === "string" || property === "number") {
      elementProperty = {type: property};
  } else if (property.value === "string" || property.value === "number") {
    elementProperty = {type: property.value};
  } else if (property.value === "enum") {
    elementProperty = {type: property.value, name: property.name};
  } else {
    elementProperty = property.value;
  }
  return propertyDartType(elementProperty);
}

global.propertyDartStylePropertyValue = function propertyDartStylePropertyValue(property) {
  switch (property.type) {
    case 'boolean':
      return 'value.value.toLowerCase() == \'1\'';
    case 'number':
      return 'double.parse(value.value)';
    case 'formatted':
    case 'string':
    case 'resolvedImage':
      return 'value.value';
    case 'promoteId':
      return 'PromoteId';
    case 'enum':
      return `${camelize(property.name)}.values.firstWhere((e) => e.toString().split('.').last.toLowerCase().contains(value.value))`
    case 'color':
      return 'int';
    case '*':
      return 'value.value';
    case 'array':
      if (property.value.type == 'array') {
         return `(json.decode(value.value) as List).cast<List<${propertyDartElementType(property.value.value)}>>()`;
      } else {
        return `(json.decode(value.value) as List).cast<${propertyDartElementType(property.value)}>()`;
      }
    default:
      throw new Error(`unknown type for ${property} . Property type = ${property.type}`);
  }
}

global.propertyDartType = function propertyDartType(property) {
  switch (property.type) {
    case 'boolean':
      return 'bool';
    case 'number':
      return 'double';
    case 'formatted':
    case 'string':
    case 'resolvedImage':
      return 'String';
    case 'promoteId':
      return 'PromoteId';
    case 'enum':
      if (property.name === "text-variable-anchor") {
        return "TextAnchor";
      } else {
        return `${property.name ? camelize(property.name) : "String"}`;
      }
    case 'color':
      return 'int';
    case '*':
      if (property.name === "data") {
        return 'String';
      }
      return 'Map<String, dynamic>';
    case 'array':
      return `List<${propertyDartElementType(property)}?>`;
    default:
      throw new Error(`unknown type for ${property} . Property type = ${property.type}`);
  }
}

global.propertyDartTestValue = function propertyDartTestValue(property) {
  switch (property.type) {
    case 'boolean':
      return 'true';
    case 'number':
      return '1.0';
    case 'formatted':
    case 'string':
    case 'resolvedImage':
      return `"abc"`;
    case 'enum':
      return `${camelize(property.name)}.${snakeCaseUpper(Object.keys(property.values)[0])}`;
    case 'color':
      return `Colors.red.value`;
    case 'array':
      if (property.value.type === "array") {
        if (property.name === "coordinates") {
          return `[${propertyDartTestValue(property.value)}, ${propertyDartTestValue(property.value)}, ${propertyDartTestValue(property.value)}, ${propertyDartTestValue(property.value)}]`;
        }
        return `[${propertyDartTestValue(property.value)}]`;
      }
      if (property.value === "enum") {
        return `["${Object.keys(property.values)[0]}", "${Object.keys(property.values)[1]}"]`;
      }
      if (property.name === "position") {
            if (property.length === 3) {
                 return '[1.0, 2.0, 3.0]';
            } else {
                return 'Position( 1.0, 2.0, )';
            }
      }
      if (`${propertyKotlinType({ type: property.value })}` === "String") {
        return `["a", "b", "c"]`;
      }
      if (`${propertyKotlinType({ type: property.value })}` === "Double") {
        const length = property['length']
        if (length) {
          var array = Array.from(Array(length).keys())
          return `[${array.map(x => x.toFixed(1)).join(', ')}]`
        }
        return `[1.0, 2.0]`;
      }
      return `${propertyKotlinType({ type: property.value })}Array`;
    case '*':
      if (property.name === "data") {
        return `json.encode(Point(coordinates: Position(-77.032667, 38.913175)))`
      } else if (property.name === "clusterProperties") {
        return `{"sum": ["+", ["get", "scalerank"]]}`
      } else if (property.name === 'filter') {
        return `gt {
          get {
            literal("mag")
          }
          literal(5.0)
        }`
      } else {
        throw new Error(`unknown type for ${property.name}`);
      }
    default:
      throw new Error(`unknown type for ${property.name}`);
  }
}