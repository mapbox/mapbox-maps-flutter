// This file is generated.

/// The style-spec property names of each light type, with the
/// `-transition` names of the properties that support a transition.
const Map<String, Set<String>> lightPropertyNames = {
  'flat': {
    'anchor',
    'position',
    'position-transition',
    'color',
    'color-transition',
    'intensity',
    'intensity-transition',
  },
  'ambient': {'color', 'color-transition', 'intensity', 'intensity-transition'},
  'directional': {
    'direction',
    'direction-transition',
    'color',
    'color-transition',
    'intensity',
    'intensity-transition',
    'cast-shadows',
    'shadow-quality',
    'shadow-intensity',
    'shadow-intensity-transition',
    'shadow-draw-before-layer',
  },
};

/// The values that reset each property of the flat light.
///
/// A value property gets its style-spec default. A transition gets an empty
/// transition, which uses the style transition. Colors use the CSS
/// `rgba(r, g, b, a)` form, the form that GL JS accepts.
const Map<String, Object> flatLightResetValues = {
  'anchor': 'viewport',
  'position': [1.15, 210, 30],
  'position-transition': <String, Object>{},
  'color': 'rgba(255, 255, 255, 1)',
  'color-transition': <String, Object>{},
  'intensity': 0.5,
  'intensity-transition': <String, Object>{},
};
