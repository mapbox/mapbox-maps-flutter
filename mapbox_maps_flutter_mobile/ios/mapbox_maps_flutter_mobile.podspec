#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint mapbox_maps_flutter_mobile.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'mapbox_maps_flutter_mobile'
  s.version          = '3.0.0-beta.1'

  s.summary          = 'Mapbox Maps SDK Flutter Plugin.'
  s.description      = 'An officially developed solution from Mapbox that enables use of our latest Maps SDK product.'
  s.homepage         = 'https://pub.dev/packages/mapbox_maps_flutter_mobile'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Mapbox' => 'mobile@mapbox.com' }
  s.source           = { :path => '.' }

  s.source_files = 'mapbox_maps_flutter_mobile/Sources/mapbox_maps_flutter_mobile/Classes/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '14.0'

  s.dependency 'MapboxMaps', '11.25.0-SNAPSHOT-05-12--02-05.git-6dae5a9'
  s.dependency 'Turf', '4.0.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.9'
end
