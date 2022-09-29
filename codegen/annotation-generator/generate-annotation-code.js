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

const symbol = "pointAnnotation"
const circle = "circleAnnotation"
const fill = "polygonAnnotation"
const line = "polylineAnnotation"

const pigeonTemplateDartMessager = ejs.compile(fs.readFileSync('annotation-generator/annotation_messager.dart.ejs', 'utf8'), {strict: true});
const annotation_manager = ejs.compile(fs.readFileSync('annotation-generator/annotation_manager.dart.ejs', 'utf8'), {strict: true});
const annotation_controller_kt = ejs.compile(fs.readFileSync('annotation-generator/annotation_controller.kt.ejs', 'utf8'), {strict: true});
const annotation_controller_swift = ejs.compile(fs.readFileSync('annotation-generator/annotation_controller.swift.ejs', 'utf8'), {strict: true});
const annotation_test_dart = ejs.compile(fs.readFileSync('annotation-generator/annotation_test.dart.ejs', 'utf8'), {strict: true});
const annotation_manager_test_dart = ejs.compile(fs.readFileSync('annotation-generator/annotation_manager_test.dart.ejs', 'utf8'), {strict: true});

for (const layer of style.layers) {
  layer.orignalType = layer.type
  if(layer.type === "symbol") {

    layer.type = symbol
    for (const property of layer.properties) {
      if (property.name == "text-font"){
            property['property-type'] = 'constant'
            break;
      }
    }
  } else if(layer.type === "circle") {
    layer.type = "circleAnnotation"
  }else if(layer.type === "fill") {
    layer.type = "polygonAnnotation"
  }else if(layer.type === "line") {
    layer.type = "polylineAnnotation"
  }
}
for (const layer of style.layers) {
  if(layer.orignalType === "symbol" || layer.orignalType === "circle" || layer.orignalType === "fill" || layer.orignalType === "line"){
      writeIfModified(`../pigeons/${camelizeWithUndercoreRemoved(layer.type)}Messager.dart`, pigeonTemplateDartMessager(layer));
      writeIfModified(`../lib/src/annotation/${camelizeWithUndercoreRemoved(layer.type)}Manager.dart`, annotation_manager(layer));
      writeIfModified(`../example/integration_test/annotations/${camelizeWithLeadingLowercase(layer.type)}_test.dart`, annotation_test_dart(layer));
      writeIfModified(`../example/integration_test/annotations/${camelizeWithLeadingLowercase(layer.type)}_manager_test.dart`, annotation_manager_test_dart(layer));
      writeIfModified(`../android/src/main/kotlin/com/mapbox/maps/mapbox_maps/annotation/${camelizeWithUndercoreRemoved(layer.type)}Controller.kt`, annotation_controller_kt(layer));
      writeIfModified(`../ios/Classes/${camelizeWithUndercoreRemoved(layer.type)}Controller.swift`, annotation_controller_swift(layer));
  }
}