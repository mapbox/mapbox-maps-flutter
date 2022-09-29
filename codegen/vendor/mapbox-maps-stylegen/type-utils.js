// Global functions //

const _ = require('lodash');
const colorParser = require('csscolorparser');
const style = require('./style-parser');

function parseCSSColor(str) {
  const color = colorParser.parseCSSColor(str);
  return [
    color[0] / 255 * color[3], color[1] / 255 * color[3], color[2] / 255 * color[3], color[3]
  ];
}

// Basic types //
global.propertyType = function propertyType(property) {
  switch (property.type) {
    case 'boolean':
      return 'Boolean';
    case 'number':
      return 'Float';
    case 'formatted':
      return 'Formatted';
    case 'string':
    case 'resolvedImage':
      return 'String';
    case 'enum':
      return 'String';
    case 'color':
      return 'String';
    case 'array':
      return `${propertyType({ type: property.value })}[]`;
    default:
      throw new Error(`unknown type for ${property.name}`);
  }
}

global.propertyJavaType = function propertyType(property) {
  switch (property.type) {
    case 'boolean':
      return 'boolean';
    case 'number':
      return 'float';
    case 'formatted':
      return 'Formatted';
    case 'string':
    case 'resolvedImage':
      return 'String';
    case 'enum':
      return 'String';
    case 'color':
      return 'String';
    case 'array':
      return `${propertyJavaType({ type: property.value })}[]`;
    default:
      throw new Error(`unknown type for ${property.name}`);
  }
}

global.propertyAnnotationKotlinType = function propertyAnnotationKotlinType(property) {
  switch (property.type) {
    case 'formatted':
      return 'String';
    default:
      return propertyKotlinType(property);
  }
}

global.propertyKotlinType = function propertyKotlinType(property) {
  switch (property.type) {
    case 'boolean':
      return 'Boolean';
    case 'number':
      if (property.name) {
        if (property.name.toLowerCase().includes('zoom') ||
            property.name === 'clusterRadius' ||
            property.name === 'buffer' ||
            property.name === 'tileSize' ||
            property.name === 'max-overscale-factor-for-parent-tiles') {
          return 'Long'
        }
      }
      return 'Double';
    case 'formatted':
      return 'Formatted';
    case 'string':
    case 'resolvedImage':
      return 'String';
    case 'promoteId':
      return 'PromoteId';
    case 'enum':
      return `${property.name ? camelize(property.name) : "String"}`;
    case 'color':
      if (property['property-type'] === 'color-ramp') {
        return 'Expression'
      }
      return 'String';
    case 'array':
      if (property.value.type === "array") {
        return `List<${propertyKotlinType(property.value)}>`
      }
      if (property.name === "position") {
        return 'LightPosition'
      }
      return `List<${propertyKotlinType({ type: property.value })}>`;
    case '*':
      if (property.name === "data") {
        return 'String'
      } else if (property.name === "clusterProperties") {
        return 'HashMap<String, Any>'
      } else if (property.name === 'filter') {
        return 'Expression'
      } else {
        throw new Error(`unknown type for ${property.name}`);
      }
    default:
      throw new Error(`unknown type ${property.type} for ${property.name}`);
  }
}
global.propertyKotlinTypeInArray = function propertyKotlinTypeInArray(property) {
  switch (property.type) {
    case 'array':
      if (property.value.type === "array") {
        return propertyKotlinType(property.value);
      }

      return propertyKotlinType({ type: property.value });
    default:
      throw new Error(`unknown type ${property.type} for ${property.name}`);
  }
}

global.propertyKotlinAnnotationDefaultValue = function propertyXmlAttributeDefaultValue(property) {
    if(property.name.endsWith("-pattern")) {
        return '"pedestrian-polygon"';
    }
    if(property.name.endsWith("-font")) {
        return 'listOf("Open Sans Regular", "Arial Unicode MS Regular")';
    }
    if(property.name.endsWith("text-variable-anchor")){
        return 'listOf(TEXT_ANCHOR_RIGHT, TEXT_ANCHOR_TOP)'
    }

    if (property.default != undefined) {
        switch (property.type) {
          case 'formatted':
          case 'string':
            return `"${snakeCaseUpper(property.default)}"`;
          case 'color':
            return '"rgba(0, 0, 0, 1)"';
          case 'number':
            if(`${property.default}`.indexOf('.') != -1) {
              return `${property.default}`;
            }
            return `${property.default}.0`;
          case 'enum':
            return `${camelize(property.name)}.${snakeCaseUpper(property.default)}`;
          case 'array':
            if (property.value === 'number') {
              return `listOf(${String(property.default).split(',').map(num => num + '.0').join(', ')})`
            }
            if (property.value === 'string') {
              return `listOf(${String(property.default).split(',').map(str => `\"${str}\"`).join(', ')})`
            }
        }
        return property.default
      } else {
        switch (property.type) {
          case 'resolvedImage':
            return `""`;
          case 'color':
            return '"rgba(0, 0, 0, 1)"';
          case 'number':
            return `1.0`;
        }
      }
      return ""
}

global.serializationSpecPropertyKotlinType = function serializationSpecPropertyKotlinType(property) {
  switch (property.type) {
    case 'boolean':
      return 'Boolean';
    case 'number':
    case 'dimension':
      if (property.name === 'refresh-interval' || property.name === 'stale-state-timeout') {
        return 'Long';
      }
      return 'Float';
    case 'formatted':
      return 'Formatted';
    case 'string':
    case 'resolvedImage':
      return 'String';
    case 'image':
      return 'Drawable';
    case 'enum':
      if (property.name === 'position') {
        return 'Int'
      }
      return `${property.name ? camelize(property.name) : "String"}`;
    case 'color':
      return 'Int';
    case 'array':
      if (`${serializationSpecPropertyKotlinType({ type: property.value })}` === "String") {
        return 'List<String>';
      }
      if (property.name === "focal-point") {
        return 'ScreenCoordinate'
      }
      return `List<${serializationSpecPropertyKotlinType({ type: property.value })}>`;
    default:
      throw new Error(`unknown type for ${property.name}`);
  }
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
      return 'Formatted';
    case 'string':
    case 'resolvedImage':
      return 'String';
    case 'image':
      return 'Uint8List';
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

global.propertyXmlType = function propertyXmlType(property) {
  switch (property.type) {
      case 'boolean':
        return 'boolean';
      case 'number':
        if (property.name === 'refresh-interval' || property.name === 'stale-state-timeout') {
          return 'integer';
        }
        return 'float';
      case 'dimension':
        return 'dimension';
      case 'string':
        return 'string';
      case 'enum':
        return 'enum';
      case 'image':
        return 'reference';
      case 'color':
        return 'color';
      case 'array':
        return "reference";
      default:
        throw new Error(`unknown type "${property.type}" for ${property.name}`);
    }
}

global.getPropertyXmlAttributeFunctionName = function getPropertyXmlAttributeFunctionName(property) {
  switch (property.type) {
      case 'boolean':
        return 'getBoolean';
      case 'number':
        if (property.name === 'refresh-interval' || property.name === 'stale-state-timeout') {
          return 'getInt'
        }
        return 'getFloat';
      case 'dimension':
        return 'getDimension';
      case 'string':
        return 'getString';
      case 'image':
        return 'getDrawable';
      case 'color':
        return 'getColor';
      case 'array':
        return "reference";
      default:
        throw new Error(`unknown type "${property.type}" for ${property.name}`);
    }
}

global.propertyXmlAttributeDefaultValue = function propertyXmlAttributeDefaultValue(property) {
    if (property.default != undefined) {
        switch (property.type) {
          case 'string':
          case 'color':
            if (property.default.startsWith('#')) {
              return `Color.parseColor("${property.default}")`;
            }
            return `Color.${snakeCaseUpper(property.default)}`;
          case 'number':
          case 'dimension':
            if (property.name === 'refresh-interval' || property.name === 'stale-state-timeout') {
              return `${property.default}`;
            }
            return `${property.default}f`;
          case 'enum':
            if (property.name === 'position') {
              switch(property.default) {
                case 'top-left':
                  return `Gravity.TOP or Gravity.START`;
                case 'top-center"':
                  return `Gravity.TOP or Gravity.CENTER_HORIZONTAL`;
                case 'top-right':
                  return `Gravity.TOP or Gravity.END`;
                case 'center-right':
                  return `Gravity.CENTER_VERTICAL or Gravity.END`;
                case 'bottom-right"':
                  return `Gravity.BOTTOM or Gravity.END`;
                case 'bottom-center':
                  return `Gravity.BOTTOM or Gravity.CENTER_HORIZONTAL`;
                case 'bottom-left':
                  return `Gravity.BOTTOM or Gravity.START`;
                case 'center-left':
                  return `Gravity.CENTER_VERTICAL or Gravity.START`;
                default:
                  return `Gravity.TOP or Gravity.START`;
              }
            } else {
              return `${camelize(property.name)}.${snakeCaseUpper(property.default)}`
            }
          case 'array':
            if (property.value === 'number') {
              return `listOf(${String(property.default).split(',').map(num => num + 'f').join(', ')})`
            }
            if (property.value === 'string') {
              return `listOf(${String(property.default).split(',').map(str => `\"${str}\"`).join(', ')})`
            }
            return `listOf(${property.default})`;
        }
        return property.default
      }
      return ""
}

global.propertyXmlAttributeTestValue = function propertyXmlAttributeTestValue(property) {
    switch (property.type) {
      case 'string':
        return `testString`
      case 'color':
        return `#000000`;
      case 'boolean':
        return 'false'
      case 'number':
        if (property.name === 'refresh-interval' || property.name === 'stale-state-timeout') {
          return `1000000`;
        }
        return `0.9`;
      case 'dimension':
        return `10dp`;
      case 'image':
        return '@drawable/mapbox_logo_icon'
      case 'enum':
        if (property.name === 'position') {
          return `bottom|end`;
        } else {
          return `${property.default}`.replace(/-/g, "_");
        }
      case 'array':
        if (property.name === 'focal-point') {
          return 'ScreenCoordinate(10.0, 20.0)'
        }
      default:
        return ""
    }
}

global.propertyXmlAttributeExpectedValue = function propertyXmlAttributeExpectedValue(property) {
    switch (property.type) {
      case 'string':
        return `"testString"`;
      case 'color':
        return `Color.BLACK`;
      case 'number':
        if (property.name === 'refresh-interval' || property.name === 'stale-state-timeout') {
          return `1000000L`;
        }
        return `0.9f`;
      case 'dimension':
        return `10.0f * pixelRatio`;
      case 'boolean':
        return 'false'
      case 'image':
        return 'context.resources.getDrawable(R.drawable.mapbox_logo_icon, null)'
      case 'enum':
        if (property.name === 'position') {
          return `Gravity.BOTTOM or Gravity.END`;
        } else {
          return `${camelize(property.name)}.${snakeCaseUpper(property.default)}`
        }
      case 'array':
        if (property.name === 'focal-point') {
          return 'ScreenCoordinate(10.0, 20.0)'
        }
      default:
        return ''
    }
}

global.propertyXmlAttributeDefaultExpectedValue = function propertyXmlAttributeDefaultExpectedValue(property) {
    if (property.required === false) {
      return "null"
    } else if (property.type === 'image') {
      return 'null'
    } else if (property.name === 'focal-point') {
      return 'null'
    } else if (property.name === 'pixel-ratio') {
      return 'pixelRatio'
    } else if (property.name === 'is-metric-units') {
      return 'LocaleUnitResolver.isMetricSystem'
    } else if (property.type === 'dimension') {
      return `${propertyXmlAttributeDefaultValue(property)} * pixelRatio`
    }
    return propertyXmlAttributeDefaultValue(property)
}

global.kotlinPrimitiveType = function kotlinType(type) {
  switch (type) {
    case 'boolean':
      return 'Boolean';
    case 'number':
      return 'Double';
    case 'string':
    case 'resolvedImage':
    case 'enum':
    case 'color':
      return 'String';
    default:
      throw new Error(`unknown type for ${type}`);
  }
}

// For generating kotlin tests.
global.propertyKotlinTestValue = function propertyKotlinTestValue(property) {
  switch (property.type) {
    case 'boolean':
      return 'true';
    case 'number':
      if (property.name) {
        if (property.name.toLowerCase().includes('zoom') ||
            property.name === 'clusterRadius' ||
            property.name === 'buffer' ||
            property.name === 'tileSize' ||
            property.name === 'max-overscale-factor-for-parent-tiles') {
          return '1L'
        }
      }
      return '1.0';
    case 'formatted':
      return `formatted {
      formattedSection("cyan") {
        fontScale = 0.9
        fontStack = listOf(
          "Open Sans Regular",
          "Arial Unicode MS Regular"
        )
        textColorAsInt = Color.CYAN
      }
      formattedSection("black") {
        fontScale = 2.0
        fontStack = listOf(
          "Open Sans Regular",
          "Arial Unicode MS Regular"
        )
        textColor = "rgba(0, 0, 0, 1)"
      }
    }`;
    case 'string':
    case 'resolvedImage':
      return `"abc"`;
    case 'enum':
      return `${camelize(property.name)}.${snakeCaseUpper(Object.keys(property.values)[0])}`;
    case 'color':
      if (property['property-type'] === 'color-ramp') {
        return `interpolate {
      linear()
      heatmapDensity()
      stop {
        literal(0.0)
        rgba {
          literal(0.0)
          literal(0.0)
          literal(0.0)
          literal(0.0)
        }
      }
      stop {
        literal(1.0)
        rgba {
          literal(0.0)
          literal(255.0)
          literal(0.0)
          literal(1.0)
        }
      }
    }`
      }
      return `"rgba(0, 0, 0, 1)"`;
    case 'array':
      if (property.value.type === "array") {
        if (property.name === "coordinates") {
          return `listOf(${propertyKotlinTestValue(property.value)}, ${propertyKotlinTestValue(property.value)}, ${propertyKotlinTestValue(property.value)}, ${propertyKotlinTestValue(property.value)})`
        }
        return `listOf(${propertyKotlinTestValue(property.value)})`
      }
      if (property.value === "enum") {
        return `listOf("${Object.keys(property.values)[0]}", "${Object.keys(property.values)[1]}")`
      }
      if (property.name === "position") {
        return 'LightPosition(0.0, 1.0, 2.0)'
      }
      if (`${propertyKotlinType({ type: property.value })}` === "String") {
        return `listOf("a", "b", "c")`;
      }
      if (`${propertyKotlinType({ type: property.value })}` === "Double") {
        const length = property['length']
        if (length) {
          var array = Array.from(Array(length).keys())
          return `listOf(${array.map(x => x.toFixed(1)).join(', ')})`
        }
        return `listOf(1.0, 2.0)`;
      }
      return `${propertyKotlinType({ type: property.value })}Array`;
    case '*':
      if (property.name === "data") {
        return `TEST_GEOJSON`
      } else if (property.name === "clusterProperties") {
        return `(hashMapOf("key1" to "x", "key2" to "y") as HashMap<String, Any>)`
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

global.propertyKotlinTestExpectedValue = function propertyKotlinTestExpectedValue(property) {
  switch (property.type) {
    case 'boolean':
      return 'true';
    case 'number':
      if (property.name) {
        if (property.name.toLowerCase().includes('zoom') ||
            property.name === 'clusterRadius' ||
            property.name === 'buffer' ||
            property.name === 'tileSize' ||
            property.name === 'max-overscale-factor-for-parent-tiles') {
          return '1'
        }
      }
      return '1.0';
    case 'formatted':
      return '[[cyan, {text-color=rgba(0, 255, 255, 1), font-scale=0.9, text-font=[Open Sans Regular, Arial Unicode MS Regular]}], [black, {text-color=rgba(0, 0, 0, 1), font-scale=2.0, text-font=[Open Sans Regular, Arial Unicode MS Regular]}]]';
    case 'string':
    case 'resolvedImage':
      return `abc`;
    case 'enum':
      return `${camelize(property.name)}.${snakeCaseUpper(Object.keys(property.values)[0])}`;
    case 'color':
      if (property['property-type'] === 'color-ramp') {
        return '[interpolate, [linear], [heatmap-density], 0.0, [rgba, 0.0, 0.0, 0.0, 0.0], 1.0, [rgba, 0.0, 255.0, 0.0, 1.0]]'
      }
      return `rgba(0, 0, 0, 1)`;
    case 'array':
      if (property.value.type === "array") {
        if (property.name === "coordinates") {
          return `[${propertyKotlinTestExpectedValue(property.value)}, ${propertyKotlinTestExpectedValue(property.value)}, ${propertyKotlinTestExpectedValue(property.value)}, ${propertyKotlinTestExpectedValue(property.value)}]`
        }
        return `[${propertyKotlinTestExpectedValue(property.value)}]`
      }
      if (property.value === "enum") {
        return `[${Object.keys(property.values)[0]}, ${Object.keys(property.values)[1]}]`
      }
      if (property.name === "position") {
        return '[0.0, 1.0, 2.0]'
      }
      if (`${propertyKotlinType({ type: property.value })}` === "String") {
        return `[a, b, c]`;
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
        return '{\\"type\\":\\"FeatureCollection\\",\\"features\\":[]}'
      } else if (property.name === "clusterProperties") {
        return "{key1=x, key2=y}"
      } else if (property.name === 'filter') {
        return `[>, [get, mag], 5.0]`
      } else {
        throw new Error(`unknown type for ${property.name}`);
      }
    default:
      throw new Error(`unknown type for ${property.name}`);
  }
}

global.propertyKotlinTestExpressionValue = function propertyKotlinTestExpressionValue(property) {
  if (supportsPropertyFunction(property)) {
    switch(property.type) {
      case 'number':
        return `number {
      get {
        literal("${property.type}")
      }
    }`;
      case 'color':
        return `toColor {
      get {
        literal("${property.type}")
      }
    }`;
      case 'enum':
        return `toString {
      get {
        literal("${property.type}")
      }
    }`;
      case 'formatted':
        return `format {
      get {
        literal("${property.type}")
      }
    }`;
      case 'resolvedImage':
        return `image {
      string {
        get {
          literal("${property.type}")
        }
      }
    }`;
      case 'array':
        if (property.length) {
          return `array {
      literal("${property.value}")
      literal(${property.length})
      get {
        literal("${property.type}")
      }
    }`;
        } else {
          return `array {
      literal("${property.value}")
      get {
        literal("${property.type}")
      }
    }`;
        }
      default:
        return `get {
      literal("${property.type}")
    }`;
    }
  }
  switch (property.type) {
    case 'boolean':
      return 'literal(true)';
    case 'number':
      if (property.name) {
        if (property.name.toLowerCase().includes('zoom') ||
            property.name === 'clusterRadius' ||
            property.name === 'buffer' ||
            property.name === 'tileSize' ||
            property.name === 'max-overscale-factor-for-parent-tiles') {
          return 'literal(1L)'
        }
      }
      return 'literal(1.0)';
    case 'formatted':
    case 'string':
    case 'resolvedImage':
      return `literal("abc")`;
    case 'enum':
      return `literal("${Object.keys(property.values)[0]}")`;
    case 'color':
      return `rgba {
      literal(0.0)
      literal(0.0)
      literal(0.0)
      literal(1.0)
    }`;
    case 'array':
      if (property.value.type === "array") {
        if (property.name === "coordinates") {
          return `literal(listOf(${propertyKotlinTestValue(property.value)}, ${propertyKotlinTestValue(property.value)}, ${propertyKotlinTestValue(property.value)}, ${propertyKotlinTestValue(property.value)}))`
        }
        return `literal(listOf(${propertyKotlinTestValue(property.value)}))`
      }
      if (property.value === "enum") {
        return `literal(listOf("${Object.keys(property.values)[0]}", "${Object.keys(property.values)[1]}"))`
      }
      if (`${propertyKotlinType({ type: property.value })}` === "String") {
        return `literal(listOf("a", "b", "c"))`;
      }
      if (`${propertyKotlinType({ type: property.value })}` === "Double") {
        const length = property['length']
        if (length) {
          var array = Array.from(Array(length).keys())
          return `literal(listOf(${array.map(x => x.toFixed(1)).join(', ')}))`
        }
        return `literal(listOf(1.0, 2.0))`;
      }
    case '*':
      if (property.name === 'data') {
        return `literal(TEST_URI)`
      }
      if (property.name === 'clusterProperties') {
        return `literal(hashMapOf("key1" to "x", "key2" to "y") as HashMap<String, Any>)`
      }
      if (property.name === 'filter') {
        return `gt {
          get {
            literal("mag")
          }
          literal(5.0)
        }`
      }
    default:
      throw new Error(`unknown type for ${property.name}`);
  }
}

global.propertySwiftType = function propertySwiftType(property) {
  switch (property.type) {
    case 'boolean':
      return 'Bool';
    case 'number':
      return 'Double';
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
      return 'StyleColor';
    case '*':
      if (property.name === "data") {
        return 'GeoJSONSourceData';
      }
      return '[String: Expression]';
    case 'array':
      return `[${propertySwiftElementType(property)}]`;
    default:
      throw new Error(`unknown type for ${property.name} . Property type = ${property.type}`);
  }
}

global.propertySwiftElementType = function propertySwiftElementType(property) {
  let elementProperty;
  if (property.value === "string" || property.value === "number") {
    elementProperty = {type: property.value};
  } else if (property.value === "enum") {
    elementProperty = {type: property.value, name: property.name};
  } else {
    elementProperty = property.value;
  }
  return propertySwiftType(elementProperty);
}

global.propertySwiftTurfJSONValueCase = function propertySwiftTurfJSONValueCase(property) {
  switch (property.type) {
    case 'boolean':
      return 'boolean';
    case 'number':
      return 'number';
    case 'formatted':
    case 'string':
    case 'resolvedImage':
    case 'enum':
    case 'color':
      return 'string';
    case '*':
      return 'object';
    case 'array':
      return 'array';
    default:
      throw new Error(`unknown Turf.JSONValue case for ${property.name} . Property type = ${property.type}`);
  }
}

global.propertySwiftValueType = function propertySwiftValueType(property) {
  switch (property.type) {
    case 'boolean':
    case 'number':
    case 'formatted':
    case 'string':
    case 'enum':
    case 'color':
    case 'array':
      return `Value<${propertySwiftType(property)}>`;
    case 'resolvedImage':
      return 'Value<ResolvedImage>';
    case '*':
      return 'GeoJSON';
    default:
      throw new Error(`unknown type for ${property.name} . Property type = ${property.type}`);
  }
}

global.isEnumProperty = function isEnumProperty(property) {
  return property.type === 'enum' && property.name
}

global.isArrayProperty = function isArrayProperty(property) {
  return property.type === 'array' && property.name
}

global.isKotlinStringArrayProperty = function isKotlinStringArrayProperty(property) {
  return property.type === 'array' && property.name && `${propertyKotlinType({ type: property.value })}` === "String"
}

global.propertyJNIType = function propertyJNIType(property) {
  switch (property.type) {
    case 'boolean':
      return 'jboolean';
    case 'number':
      return 'jfloat';
    case 'String':
      return 'String';
    case 'enum':
      return 'String';
    case 'color':
      return 'String';
    case 'array':
      return `jarray<${propertyJNIType({ type: property.value })}[]>`;
    default:
      return 'jobject*';
  }
}

global.propertyNativeType = function (property) {
  if (/-translate-anchor$/.test(property.name)) {
    return 'TranslateAnchorType';
  }
  if (/-(rotation|pitch|illumination)-alignment$/.test(property.name)) {
    return 'AlignmentType';
  }
  if (/^(text|icon)-anchor$/.test(property.name)) {
    return 'SymbolAnchorType';
  }
  switch (property.type) {
    case 'boolean':
      return 'bool';
    case 'number':
      return 'float';
    case 'formatted':
    case 'string':
    case 'resolvedImage': // TODO: replace once we implement image expressions
      return 'std::string';
    case 'enum':
      if (property['light-property']) {
        return `Light${camelize(property.name)}Type`;
      }
      return `${camelize(property.name)}Type`;
    case 'color':
      return `Color`;
    case 'array':
      if (property.length) {
        return `std::array<${propertyType({ type: property.value })}, ${property.length}>`;
      } else {
        return `std::vector<${propertyType({ type: property.value })}>`;
      }
    default: throw new Error(`unknown type for ${property.name}.`)
  }
}

global.propertyTypeAnnotation = function propertyTypeAnnotation(property) {
  switch (property.type) {
    case 'enum':
      return `@Property.${snakeCaseUpper(property.name)}`;
    default:
      return "";
  }
};

global.propertyDefaultKotlinExpression = function propertyDefaultValue(property) {
  if (property[`default-expression`] === true) {
    return `Expression.fromRaw(\"\"\"${property.default}\"\"\".trimIndent())`;
  }
  return undefined;
}

global.propertyDefaultKotlinValue = function propertyDefaultValue(property) {
  if (property.default !== undefined) {
    if (property[`default-expression`] === true) {
      return undefined;
    }
    switch (property.type) {
      case 'string':
      case 'color':
        if (property['property-type'] === 'color-ramp') {
          // TODO construct expression with ValueConverter later
          return undefined
        }
        return `\"${property.default}\"`;
      case 'formatted':
        // TODO support formatted type
        return undefined
      case 'number':
        if (propertyKotlinType(property) === 'Long') {
          return `${property.default}L`;
        } else {
          return String(property.default).includes('.') ? property.default : `${property.default}.0`;
        }
      case 'enum':
        return `${camelize(property.name)}.${snakeCaseUpper(property.default)}`
      case 'array':
        if (property.name === "position") {
          return `LightPosition(${String(property.default).split(',').map(num => num.includes('.') ? num : num + '.0').join(', ')})`
        }
        if (property.value === 'number') {
          return `listOf(${String(property.default).split(',').map(num => num.includes('.') ? num : num + '.0').join(', ')})`
        }
        if (property.value === 'string') {
          return `listOf(${String(property.default).split(',').map(str => `\"${str}\"`).join(', ')})`
        }
        return `listOf(${property.default})`;
    }
    return property.default
  }
  return undefined
}

global.defaultExpressionJava = function (property) {
  switch (property.type) {
    case 'boolean':
      return 'boolean';
    case 'number':
      return 'number';
    case 'formatted':
      return 'format';
    case 'resolvedImage':
      return "image";
    case 'string':
    case 'image':
      return "string";
    case 'enum':
      return "string";
    case 'color':
      return 'toColor';
    case 'array':
      return "array";
    default: return "string";
  }
}

global.defaultValueJava = function (property) {
  if (property.name.endsWith("-pattern")) {
    return '"pedestrian-polygon"';
  }
  if (property.name.endsWith("-font")) {
    return 'new String[]{"Open Sans Regular", "Arial Unicode MS Regular"}';
  }
  switch (property.type) {
    case 'boolean':
      return 'true';
    case 'number':
      return '0.3f';
    case 'formatted':
      return 'new Formatted(new FormattedSection("default"))'
    case 'string':
    case 'resolvedImage':
      return '"' + property['default'] + '"';
    case 'enum':
      return snakeCaseUpper(property.name) + "_" + snakeCaseUpper(Object.keys(property.values)[0]);
    case 'color':
      return '"rgba(255,128,0,0.7)"';
    case 'array':
      switch (property.value) {
        case 'string':
        case 'enum':
          if (property['default'] !== undefined) {
            return '[' + property['default'] + ']';
          } else {
            return 'new String[0]';
          }
        case 'number':
          var result = 'new Float[] {';
          for (var i = 0; i < property.length; i++) {
            result += "0f";
            if (i + 1 != property.length) {
              result += ", ";
            }
          }
          return result + "}";
      }
    default: throw new Error(`unknown type for ${property.name}`)
  }
}


/**
 * Produces documentation for property value constants
 */
global.propertyValueDoc = function (property, value) {

  // Match references to other property names & values.
  // Requires the format 'When `foo` is set to `bar`,'.
  let doc = property.values[value].doc.replace(/When `(.+?)` is set to `(.+?)`(?: or `([^`]+?)`)?,/g, function (m, peerPropertyName, propertyValue, secondPropertyValue, offset, str) {
    let otherProperty = snakeCaseUpper(peerPropertyName);
    let otherValue = snakeCaseUpper(peerPropertyName) + '_' + snakeCaseUpper(propertyValue);
    const firstPropertyValue = 'When {@link ' + `${otherProperty}` + '} is set to {@link Property#' + `${otherValue}` + '}';
    if (secondPropertyValue) {
      return firstPropertyValue + ` or {@link Property#${snakeCaseUpper(peerPropertyName) + '_' + snakeCaseUpper(secondPropertyValue)}},`;
    } else {
      return firstPropertyValue + ',';
    }
  });

  // Match references to our own property values.
  // Requires the format 'is equivalent to `bar`'.
  doc = doc.replace(/is equivalent to `(.+?)`/g, function (m, propertyValue, offset, str) {
    propertyValue = snakeCaseUpper(property.name) + '_' + snakeCaseUpper(propertyValue);
    return 'is equivalent to {@link Property#' + propertyValue + '}';
  });

  // Match other items in back ticks
  doc = doc.replace(/`(.+?)`/g, function (m, symbol, offset, str) {
    if ('values' in property && Object.keys(property.values).indexOf(symbol) !== -1) {
      // Property values
      propertyValue = snakeCaseUpper(property.name) + '_' + snakeCaseUpper(symbol);
      console.log("Transforming", symbol, propertyValue);
      return '{@link Property#' + `${propertyValue}` + '}';
    } else if (str.substr(offset - 4, 3) !== 'CSS' && symbol[0].toUpperCase() != symbol[0]) {
      // Property 'enums'
      if (symbol === 'symbol-sort-key') {
        return 'symbol sort key';
      }

      symbol = snakeCaseUpper(symbol);
      return '{@link ' + symbol + '}';
    } else {
      // Left overs
      return symbol
    }
  });
  return doc;
};

global.isLightProperty = function (property) {
  return property['light-property'] === true;
};

// Native methods //
global.isOverridable = function (property) {
  return ['text-color'].includes(property.name);
};

global.expressionType = function (property) {
  switch (property.type) {
    case 'boolean':
      return 'BooleanType';
    case 'number':
    case 'enum':
      return 'NumberType';
    case 'image':
      return 'ImageType';
    case 'string':
      return 'StringType';
    case 'color':
      return `ColorType`;
    case 'formatted':
      return `FormattedType`;
    case 'array':
      return `Array<${expressionType({ type: property.value })}>`;
    default: throw new Error(`unknown type for ${property.name}`)
  }
};

global.propertyValueType = function (property) {
  switch (property['property-type']) {
    default:
      return `PropertyValue<${evaluatedType(property)}>`;
  }
};

global.evaluatedType = function (property) {
  if (/-translate-anchor$/.test(property.name)) {
    return 'TranslateAnchorType';
  }
  if (/-(rotation|pitch|illumination)-alignment$/.test(property.name)) {
    return 'AlignmentType';
  }
  if (/^(text|icon)-anchor$/.test(property.name)) {
    return 'SymbolAnchorType';
  }
  if (/position/.test(property.name)) {
    return 'Position';
  }
  switch (property.type) {
    case 'boolean':
      return 'bool';
    case 'number':
      return 'float';
    case 'resolvedImage':
      return 'expression::Image';
    case 'formatted':
      return 'expression::Formatted';
    case 'string':
      return 'std::string';
    case 'enum':
      return (isLightProperty(property) ? 'Light' : '') + `${camelize(property.name)}Type`;
    case 'color':
      return `Color`;
    case 'array':
      if (property.length) {
        return `std::array<${evaluatedType({ type: property.value })}, ${property.length}>`;
      } else {
        return `std::vector<${evaluatedType({ type: property.value, name: property.name })}>`;
      }
    default: throw new Error(`unknown type for ${property.name}`)
  }
};


function attributeUniformType(property, type) {
  const attributeNameExceptions = {
    'text-opacity': ['opacity'],
    'icon-opacity': ['opacity'],
    'text-color': ['fill_color'],
    'icon-color': ['fill_color'],
    'text-halo-color': ['halo_color'],
    'icon-halo-color': ['halo_color'],
    'text-halo-blur': ['halo_blur'],
    'icon-halo-blur': ['halo_blur'],
    'text-halo-width': ['halo_width'],
    'icon-halo-width': ['halo_width'],
    'line-gap-width': ['gapwidth'],
    'line-pattern': ['pattern_to', 'pattern_from'],
    'line-floor-width': ['floorwidth'],
    'fill-pattern': ['pattern_to', 'pattern_from'],
    'fill-extrusion-pattern': ['pattern_to', 'pattern_from']
  }
  const names = attributeNameExceptions[property.name] ||
    [property.name.replace(type + '-', '').replace(/-/g, '_')];

  return names.map(name => {
    return `attributes::${name}, uniforms::${name}`
  }).join(', ');
}

global.layoutPropertyType = function (property) {
  switch (property['property-type']) {
    case 'data-driven':
    case 'cross-faded-data-driven':
      return `DataDrivenLayoutProperty<${evaluatedType(property)}>`;
    default:
      return `LayoutProperty<${evaluatedType(property)}>`;
  }
};

global.paintPropertyType = function (property, type) {
  switch (property['property-type']) {
    case 'data-driven':
      if (isOverridable(property))
        return `DataDrivenPaintProperty<${evaluatedType(property)}, ${attributeUniformType(property, type)}, true>`;
      return `DataDrivenPaintProperty<${evaluatedType(property)}, ${attributeUniformType(property, type)}>`;
    case 'cross-faded-data-driven':
      return `CrossFadedDataDrivenPaintProperty<${evaluatedType(property)}, ${attributeUniformType(property, type)}>`;
    case 'cross-faded':
      return `CrossFadedPaintProperty<${evaluatedType(property)}>`;
    default:
      return `PaintProperty<${evaluatedType(property)}>`;
  }
};

global.propertyValueType = function (property) {
  switch (property['property-type']) {
    case 'color-ramp':
      return `ColorRampPropertyValue`;
    default:
      return `PropertyValue<${evaluatedType(property)}>`;
  }
};

global.defaultValue = function (property) {
  // https://github.com/mapbox/mapbox-gl-native/issues/5258
  if (property.name === 'line-round-limit') {
    return 1;
  }

  if (property.name === 'fill-outline-color') {
    return '{}';
  }

  if (property['property-type'] === 'color-ramp') {
    return '{}';
  }

  switch (property.type) {
    case 'number':
      if (property.default === undefined) {
        return 0;
      } else {
        return property.default;
      }
    case 'formatted':
    case 'string':
    case 'resolvedImage':
      return property.default ? `{${JSON.stringify(property.default)}}` : '{}';
    case 'enum':
      if (property.default === undefined) {
        return `${evaluatedType(property)}::Undefined`;
      } else {
        return `${evaluatedType(property)}::${camelize(property.default)}`;
      }
    case 'color':
      const color = parseCSSColor(property.default).join(', ');
      switch (color) {
        case '0, 0, 0, 0':
          return '{}';
        case '0, 0, 0, 1':
          return 'Color::black()';
        case '1, 1, 1, 1':
          return 'Color::white()';
        default:
          return `{ ${color} }`;
      }
    case 'array':
      const defaults = (property.default || []).map((e) => defaultValue({ type: property.value, default: e }));
      if (property.length) {
        return `{{${defaults.join(', ')}}}`;
      } else {
        return `{${defaults.join(', ')}}`;
      }
    default:
      return property.default;
  }
};

// End of Native methods

global.supportsZoomFunction = function (property) {
  return property.expression && property.expression.parameters.indexOf('zoom') > -1;
};

global.supportsPropertyFunction = function (property) {
  return property['property-type'] === 'data-driven' || property['property-type'] === 'cross-faded-data-driven';
};

// For expression generation
global.compatibleExpressionName = function (expression) {
  switch(expression.name) {
    case '-':
      return 'subtract';
    case '!':
      return 'not';
    case '!=':
      return 'neq';
    case '*':
      return 'product';
    case '/':
      return 'division';
    case '%':
      return 'mod';
    case '^':
      return 'pow';
    case '+':
      return 'sum';
    case '<':
      return 'lt';
    case '<=':
      return 'lte';
    case '==':
      return 'eq';
    case '>':
      return 'gt';
    case '>=':
      return 'gte';
    // for Java conflicting keywords:
    case 'case':
      return "switchCase";
    // for Kotlin conflicting keywords:
    case 'in':
    case 'object':
    case 'typeof':
    case 'var':
    case 'let':
      return expression.name + 'Expression'

    default:
      return expression.name
  }
}

global.expressionGroup = function(expression) {
  return expression.group
}

global.isExpressionConstant = function(expression) {
  return expression.doc.includes('mathematical constant')
}

global.isExpressionLiteral = function(expression) {
  return expression.doc.includes('Asserts that the input value is an')
}

global.isExpressionConvert = function(expression) {
  return expression.name.includes('Converts the input value to a')
}

global.isExpressionNonArgument = function(expression) {
  return isExpressionConstant(expression) ||
            expression.name === "zoom" ||
            expression.name === "accumulated" ||
            expression.name === "geometry-type" ||
            expression.name === "heatmap-density" ||
            expression.name === "id" ||
            expression.name === "line-progress" ||
            expression.name === "properties" ||
            expression.name === "sky-radial-progress"
}

global.isLayoutProperty = function(property) {
  for (const item of style.layoutProperties) {
    if (item[`name`] === property[`name`]) {
      return true
    }
  }
  return false
}
global.isPaintProperty = function(property) {
  for (const item of style.paintProperties) {
    if (item[`name`] === property[`name`]) {
      return true
    }
  }
  return false
}

global.geometryType = function (str) {
 if (str === "pointAnnotation" || str === "circleAnnotation") {
   return "Point"
 } else if (str === "polylineAnnotation") {
   return "LineString"
 } else if (str === "polygonAnnotation") {
   return "Polygon"
 } else {
   return "?"
 }
}

global.compatibleSwiftExpressionName = function (expression) {
  switch(expression.name) {
    case '-':
      return 'subtract';
    case '!':
      return 'not';
    case '!=':
      return 'neq';
    case '*':
      return 'product';
    case '/':
      return 'division';
    case '%':
      return 'mod';
    case '^':
      return 'pow';
    case '+':
      return 'sum';
    case '<':
      return 'lt';
    case '<=':
      return 'lte';
    case '==':
      return 'eq';
    case '>':
      return 'gt';
    case '>=':
      return 'gte';
    // for Java conflicting keywords:
    case 'case':
      return "switchCase";
    // for Kotlin conflicting keywords:
    case 'in':
    case 'object':
    case 'typeof':
    case 'var':
    case 'let':
      return expression.name + 'Expression'

    default:
      return camelizeWithLeadingLowercase(expression.name)
  }
}

global.shouldSkipAnnotationProperty = function shouldSkipAnnotationProperty(annotationType, property) {
  return property.name == "line-gradient";
}

global.propertySwiftTypeToJSONValueConvertor = function propertySwiftTypeToJSONValueConvertor(property) {
  switch (property.type) {
    case 'boolean':
    case 'string':
    case 'resolvedImage':
    case 'number':
    case 'formatted':
      return `newValue`;
    case 'array':
      if (property.value === "enum") {
        return `newValue?.map(\\.rawValue)`;
      } else if (property.value === "string") {
        return `newValue.map { ["literal", $0] }`;
      } else {
        return `newValue`;
      }
    case 'enum':
      return `newValue?.rawValue`;
    case 'color':
      return `newValue?.rgbaString`;
    default:
      throw new Error(`unknown type for ${property.name} . Property type = ${property.type}`);
  }
}

global.propertyJSONValueToSwiftTypeConvertor = function propertyJSONValueToSwiftTypeConvertor(property) {
  switch (property.type) {
    case 'boolean':
    case 'string':
    case 'resolvedImage':
    case 'number':
    case 'formatted':
      return `layerProperties["${property.name}"] as? ${propertySwiftType(property)}`;
    case 'array':
      if (property.value === "enum") {
        return `layerProperties["${property.name}"].flatMap { $0 as? [String] }.flatMap { $0.compactMap(${propertySwiftType({type: property.value, name: property.name})}.init(rawValue:)) }`;
      } else if (property.value === "string") {
        return `(layerProperties["${property.name}"] as? [Any])?[1] as? [String]`;
      } else {
        return `layerProperties["${property.name}"] as? ${propertySwiftType(property)}`;
      }
    case 'enum':
      return `layerProperties["${property.name}"].flatMap { $0 as? String }.flatMap(${propertySwiftType(property)}.init(rawValue:))`;
    case 'color':
      return `layerProperties["${property.name}"].flatMap { $0 as? String }.flatMap(StyleColor.init(rgbaString:))`;
    default:
      throw new Error(`unknown type for ${property.name} . Property type = ${property.type}`);
  }
}
