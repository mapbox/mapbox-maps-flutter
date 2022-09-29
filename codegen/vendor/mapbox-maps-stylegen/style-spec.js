const referenceSpec = require('./v8');

referenceSpec.layer.type.values["location-indicator"] = {
    "doc": "Location Indicator layer."
};
referenceSpec["layout_location-indicator"] = {
    "top-image": {
        "type": "resolvedImage",
        "property-type": "data-constant",
        "expression": {
            "interpolated": false,
            "parameters": [
                "zoom"
            ]
        },
        "doc": "Name of image in sprite to use as the top of the location indicator."
    },
    "bearing-image": {
        "type": "resolvedImage",
        "property-type": "data-constant",
        "expression": {
            "interpolated": false,
            "parameters": [
                "zoom"
            ]
        },
        "doc": "Name of image in sprite to use as the middle of the location indicator."
    },
    "shadow-image": {
        "type": "resolvedImage",
        "property-type": "data-constant",
        "expression": {
            "interpolated": false,
            "parameters": [
                "zoom"
            ]
        },
        "doc": "Name of image in sprite to use as the background of the location indicator."
    }
};

referenceSpec["paint_location-indicator"] = {
    "perspective-compensation": {
        "type": "number",
        "default": "0.85",
        "property-type": "data-constant",
        "expression": {
            "interpolated": true,
            "parameters": [
                "zoom"
            ]
        },
        "doc": "The amount of the perspective compensation, between 0 and 1. A value of 1 produces a location indicator of constant width across the screen. A value of 0 makes it scale naturally according to the viewing projection."
    },
    "image-pitch-displacement": {
        "type": "number",
        "property-type": "data-constant",
        "default": "0",
        "units": "pixels",
        "expression": {
            "interpolated": true,
            "parameters": [
                "zoom"
            ]
        },
        "doc": "The displacement off the center of the top image and the shadow image when the pitch of the map is greater than 0. This helps producing a three-dimensional appearence."
    },
    "bearing": {
        "type": "number",
        "default": "0",
        "default": 0,
        "period": 360,
        "units": "degrees",
        "property-type": "data-constant",
        "expression": {
            "interpolated": false,
            "parameters": [ ]
        },
        "transition": true,
        "doc": "The bearing of the location indicator."
    },
    "location": {
        "type": "array",
        "default": [
            0.0,
            0.0,
            0.0
        ],
        "length": 3,
        "value": "number",
        "property-type": "data-constant",
        "expression": {
            "interpolated": true,
            "parameters": []
        },
        "transition": true,
        "doc": "An array of [latitude, longitude, altitude] position of the location indicator."
    },
    "accuracy-radius": {
        "type": "number",
        "units": "meters",
        "default": 0,
        "property-type": "data-constant",
        "expression": {
            "interpolated": true,
            "parameters": [
                "zoom"
            ]
        },
        "transition": true,
        "doc": "The accuracy, in meters, of the position source used to retrieve the position of the location indicator."
    },
    "top-image-size": {
        "type": "number",
        "units": "factor of the original icon size",
        "property-type": "data-constant",
        "default": 1,
        "expression": {
            "interpolated": true,
            "parameters": [
                "zoom"
            ]
        },
        "transition": true,
        "doc": "The size of the top image, as a scale factor applied to the size of the specified image."
    },
    "bearing-image-size": {
        "type": "number",
        "units": "factor of the original icon size",
        "property-type": "data-constant",
        "default": 1,
        "expression": {
            "interpolated": true,
            "parameters": [
                "zoom"
            ]
        },
        "transition": true,
        "doc": "The size of the bearing image, as a scale factor applied to the size of the specified image."
    },
    "shadow-image-size": {
        "type": "number",
        "units": "factor of the original icon size",
        "property-type": "data-constant",
        "default": 1,
        "expression": {
            "interpolated": true,
            "parameters": [
                "zoom"
            ]
        },
        "transition": true,
        "doc": "The size of the shadow image, as a scale factor applied to the size of the specified image."
    },
    "accuracy-radius-color": {
        "type": "color",
        "property-type": "data-constant",
        "default": "#ffffff",
        "expression": {
            "interpolated": true,
            "parameters": [
                "zoom"
            ]
        },
        "transition": true,
        "doc": "The color for drawing the accuracy radius, as a circle. To adjust transparency, set the alpha component of the color accordingly."

    },
    "accuracy-radius-border-color": {
        "type": "color",
        "property-type": "data-constant",
        "default": "#ffffff",
        "expression": {
            "interpolated": true,
            "parameters": [
                "zoom"
            ]
        },
        "transition": true,
        "doc": "The color for drawing the accuracy radius border. To adjust transparency, set the alpha component of the color accordingly."
    },
    "emphasis-circle-radius": {
        "type": "number",
        "units": "pixels",
        "default": 0,
        "property-type": "data-constant",
        "expression": {
            "interpolated": true,
            "parameters": [
                "zoom"
            ]
        },
        "transition": true,
        "doc": "The radius, in pixel, of the circle emphasizing the indicator, drawn between the accuracy radius and the indicator shadow."
    },
    "emphasis-circle-color": {
        "type": "color",
        "property-type": "data-constant",
        "default": "#ffffff",
        "expression": {
            "interpolated": true,
            "parameters": [
                "zoom"
            ]
        },
        "transition": true,
        "doc": "The color of the circle emphasizing the indicator. To adjust transparency, set the alpha component of the color accordingly."

    }
};

referenceSpec["paint_line"]["line-trim-offset"] = {
    "type": "array",
    "value": "number",
    "length": 2,
    "default": [0.0, 0.0],
    "minimum": [0, 0],
    "maximum": [1, 1],
    "transition": false,
    "property-type": "constant",
    "requires": [
        "line-gradient",
        {
            "source": "geojson",
            "has": {
                "lineMetrics": true
            }
        }
    ],
    "doc": "The line trim-off percentage range based on the whole line gradinet range [0.0, 1.0]. The line part between [trim-start, trim-end] will be marked as transparent to make a route vanishing effect. If either 'trim-start' or 'trim-end' offset is out of valid range, the default range will be set."
};

referenceSpec.layer.type.values["model"] = {
    internal: true,
    experimental: true,
    doc: "A layer to render 3D Models."
};

referenceSpec["layer_capabilities_model"] = [
    'Source::Required',
    'PassOffScreen::NotRequired',
    'PassSkybox::NotRequired',
    'Layout::NotRequired',
    'FadingTiles::NotRequired',
    'CrossTileIndex::NotRequired',
    'TileKind::NotRequired'
];

referenceSpec["layout_model"] = {
    "visibility": {
        "type": "enum",
        "values": {
            "visible": {
                "doc": "The layer is shown."
            },
            "none": {
                "doc": "The layer is not shown."
            }
        },
        "default": "visible",
        "doc": "Whether this layer is displayed.",
        "sdk-support": {
            "basic functionality": {
                "js": "0.41.0",
                "android": "6.0.0",
                "ios": "4.0.0",
                "macos": "0.7.0"
            }
        },
        "property-type": "constant"
    },
    "model-id": {
        "type": "string",
        "doc": "Model to render.",
        "property-type": "data-driven",
        "expression": {
            "interpolated": false,
            "parameters": [
                "zoom",
                "feature"
            ]
        },
        "transition": false,
        "requires": [
            {
                "source": [
                    "geojson",
                    "vector"
                ]
            }
        ]
    },

};

referenceSpec["paint_model"] = {
    "model-opacity": {
        "type": "number",
        "default": 1,
        "minimum": 0,
        "maximum": 1,
        "doc": "The opacity of the model layer.",
        "transition": true,
        "expression": {
            "interpolated": true,
            "parameters": [
                "zoom"
            ]
        },
        "property-type": "data-constant"
    },
    "model-rotation": {
        "type": "array",
        "value": "number",
        "length": 3,
        "default": [0, 0, 0],
        "period": 360,
        "units": "degrees",
        "property-type": "data-driven",
        "expression": {
            "interpolated": true,
            "parameters": [
                "zoom",
                "feature",
                "feature-state"
            ]
        },
        "transition": true,
        "doc": "The rotation of the model in euler angles [lon, lat, z]."
    },
    "model-scale": {
        "type": "array",
        "value": "number",
        "length": 3,
        "default": [
            1,
            1,
            1
        ],
        "doc": "The scale of the model.",
        "property-type": "data-driven",
        "expression": {
            "interpolated": true,
            "parameters": [
                "zoom",
                "feature",
                "feature-state"
            ]
        },
        "transition": true
    },
    "model-translation": {
        "type": "array",
        "value": "number",
        "length": 3,
        "default": [
            0,
            0,
            0
        ],
        "property-type": "data-driven",
        "expression": {
            "interpolated": true,
            "parameters": [
                "zoom",
                "feature",
                "feature-state"
            ]
        },
        "transition": true,
        "doc": "The translation of the model in meters in form of [longitudal, latitudal, altitude] offsets."
    },
    "model-color": {
        "type": "color",
        "default": "#ffffff",
        "doc": "The tint color of the model layer. model-color-mix-intensity (defaults to 0) defines tint(mix) intensity - this means that, this color is not used unless model-color-mix-intensity gets value greater than 0.",
        "property-type": "data-driven",
        "expression": {
            "interpolated": true,
            "parameters": [
                "zoom",
                "feature",
                "feature-state"
            ]
        },
        "transition": true
    },
    "model-color-mix-intensity": {
        "type": "number",
        "property-type": "data-driven",
        "default": 0.0,
        "minimum": 0,
        "maximum": 1,
        "doc": "Intensity of model-color (on a scale from 0 to 1) in color mix with original 3D model's colors. Higher number will present a higher model-color contribution in mix.",
        "expression": {
            "interpolated": true,
            "parameters": [
                "zoom",
                "feature",
                "feature-state"
            ]
        },
        "transition": true
    },
    "model-type": {
        "type": "enum",
        "values": {
            "common-3d": {
                "doc": "Integrated to 3D scene, using depth testing, along with terrain, fill-extrusions and custom layer."
            },
            "location-indicator": {
                "doc": "Displayed over other 3D content, occluded by terrain."
            }
        },
        "default": "common-3d",
        "doc": "Defines rendering behavior of model in respect to other 3D scene objects."
    }
};

referenceSpec["layout_line"]["line-cap"]["expression"]["parameters"] = ["zoom"];
referenceSpec["layout_line"]["line-cap"]["property-type"] = "data-constant";
referenceSpec["paint_line"]["line-dasharray"]["expression"]["parameters"] = ["zoom"];
referenceSpec["paint_line"]["line-dasharray"]["property-type"] = "cross-faded";

var spec = module.exports = referenceSpec