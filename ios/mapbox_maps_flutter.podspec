#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint mapbox_maps_flutter.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'mapbox_maps_flutter'
  s.version          = '2.6.0'

  s.summary          = 'Mapbox Maps SDK Flutter Plugin.'
  s.description      = 'An officially developed solution from Mapbox that enables use of our latest Maps SDK product.'
  s.homepage         = 'https://pub.dev/packages/mapbox_maps_flutter'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Mapbox' => 'mobile@mapbox.com' }
  s.source           = { :path => '.' }

  s.source_files = 'mapbox_maps_flutter/Sources/mapbox_maps_flutter/Classes/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '14.0'

  s.dependency 'MapboxMaps', '~> 11.10.0'
  s.dependency 'Turf', '4.0.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.8'
end
