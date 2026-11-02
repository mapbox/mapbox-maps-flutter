// This file is generated.

/// The source properties that Android and iOS, or GL JS, can set after the
/// source is added, by source type.
const Map<String, Set<String>> liveSourceProperties = {
  'vector': {
    'url',
    'tiles',
    'minzoom',
    'maxzoom',
    'volatile',
    'prefetch-zoom-delta',
    'tile-cache-budget',
    'minimum-tile-update-interval',
    'max-overscale-factor-for-parent-tiles',
    'tile-requests-delay',
    'tile-network-requests-delay',
  },
  'raster': {
    'url',
    'tiles',
    'minzoom',
    'maxzoom',
    'volatile',
    'prefetch-zoom-delta',
    'tile-cache-budget',
    'minimum-tile-update-interval',
    'max-overscale-factor-for-parent-tiles',
    'tile-requests-delay',
    'tile-network-requests-delay',
  },
  'raster-dem': {
    'url',
    'tiles',
    'minzoom',
    'maxzoom',
    'volatile',
    'prefetch-zoom-delta',
    'tile-cache-budget',
    'minimum-tile-update-interval',
    'max-overscale-factor-for-parent-tiles',
    'tile-requests-delay',
    'tile-network-requests-delay',
  },
  'raster-array': {
    'url',
    'tiles',
    'minzoom',
    'maxzoom',
    'volatile',
    'tile-cache-budget',
  },
  'image': {'url', 'coordinates', 'prefetch-zoom-delta'},
  'model': {'url', 'maxzoom', 'minzoom', 'tiles', 'models'},
  'geojson': {'data', 'prefetch-zoom-delta', 'tile-cache-budget'},
};

/// The live source properties that GL JS cannot set, by source type, with
/// the reason.
const Map<String, Map<String, String>> webUnsupportedLiveSourceProperties = {
  'vector': {
    'volatile': 'GL JS does not cache tiles locally.',
    'prefetch-zoom-delta': 'GL JS has no equivalent tile loading setting.',
    'tile-cache-budget': 'GL JS has no equivalent tile loading setting.',
    'minimum-tile-update-interval':
        'GL JS has no equivalent tile loading setting.',
    'max-overscale-factor-for-parent-tiles':
        'GL JS has no equivalent tile loading setting.',
    'tile-requests-delay': 'GL JS has no equivalent tile loading setting.',
    'tile-network-requests-delay':
        'GL JS has no equivalent tile loading setting.',
  },
  'raster': {
    'volatile': 'GL JS does not cache tiles locally.',
    'prefetch-zoom-delta': 'GL JS has no equivalent tile loading setting.',
    'tile-cache-budget': 'GL JS has no equivalent tile loading setting.',
    'minimum-tile-update-interval':
        'GL JS has no equivalent tile loading setting.',
    'max-overscale-factor-for-parent-tiles':
        'GL JS has no equivalent tile loading setting.',
    'tile-requests-delay': 'GL JS has no equivalent tile loading setting.',
    'tile-network-requests-delay':
        'GL JS has no equivalent tile loading setting.',
  },
  'raster-dem': {
    'volatile': 'GL JS does not cache tiles locally.',
    'prefetch-zoom-delta': 'GL JS has no equivalent tile loading setting.',
    'tile-cache-budget': 'GL JS has no equivalent tile loading setting.',
    'minimum-tile-update-interval':
        'GL JS has no equivalent tile loading setting.',
    'max-overscale-factor-for-parent-tiles':
        'GL JS has no equivalent tile loading setting.',
    'tile-requests-delay': 'GL JS has no equivalent tile loading setting.',
    'tile-network-requests-delay':
        'GL JS has no equivalent tile loading setting.',
  },
  'raster-array': {
    'volatile': 'GL JS does not cache tiles locally.',
    'tile-cache-budget': 'GL JS has no equivalent tile loading setting.',
  },
  'image': {
    'prefetch-zoom-delta': 'GL JS has no equivalent tile loading setting.',
  },
  'model': {
    'url': 'GL JS cannot change the tiles of a model source after it is added.',
    'maxzoom':
        'GL JS cannot change the zoom range of a model source after it is added.',
    'minzoom':
        'GL JS cannot change the zoom range of a model source after it is added.',
    'tiles':
        'GL JS cannot change the tiles of a model source after it is added.',
  },
  'geojson': {
    'prefetch-zoom-delta': 'GL JS has no equivalent tile loading setting.',
    'tile-cache-budget': 'GL JS has no equivalent tile loading setting.',
  },
};
// End of generated file.
