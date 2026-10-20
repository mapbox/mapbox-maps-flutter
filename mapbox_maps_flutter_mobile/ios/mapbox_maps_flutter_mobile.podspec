#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint mapbox_maps_flutter_mobile.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'mapbox_maps_flutter_mobile'
  s.version          = '3.35.0-SNAPSHOT-10-20--01-38.git-2505fca'

  s.summary          = 'Mapbox Maps SDK Flutter Plugin.'
  s.description      = 'An officially developed solution from Mapbox that enables use of our latest Maps SDK product.'
  s.homepage         = 'https://pub.dev/packages/mapbox_maps_flutter_mobile'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Mapbox' => 'mobile@mapbox.com' }
  s.source           = { :path => '.' }

  s.source_files = 'mapbox_maps_flutter_mobile/Sources/mapbox_maps_flutter_mobile/Classes/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '14.0'

  s.dependency 'MapboxMaps', '11.35.0-SNAPSHOT-10-20--01-38.git-2505fca'
  s.dependency 'Turf', '4.1.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
