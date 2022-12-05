#import "MapboxMapsPlugin.h"
#if __has_include(<mapbox_maps_flutter/mapbox_maps_flutter-Swift.h>)
#import <mapbox_maps_flutter/mapbox_maps_flutter-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "mapbox_maps_flutter-Swift.h"
#endif

@implementation MapboxMapsPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftMapboxMapsPlugin registerWithRegistrar:registrar];
}
@end
