#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint mapbox_maps_flutter.podspec` to validate before publishing.
#

Pod::Spec.new do |nav|
  nav.name             = 'MapboxNavigationCore'
  nav.version          = '3.5.0'
  nav.summary          = 'Mapbox Navigation SDK.'
  nav.author           = { 'Mapbox' => 'mobile@mapbox.com' }
  nav.source           = { :git => "https://github.com/mapbox/mapbox-navigation-ios.git", :tag => "v3.5.0" }
  
  nav.homepage         = 'https://github.com/mapbox/mapbox-navigation-ios'
  nav.license          = 'MIT'
  nav.author           = { 'Mapbox' => 'mobile@mapbox.com' }  

  #nav.dependency 'MapboxMaps', '11.8.0'
  #nav.dependency 'Turf', '~> 3.0.0'
  #nav.dependency 'MapboxDirections', '~> 2.14'
  nav.source_files = 'Sources/MapboxNavigationCore/**/*.swift'

  s.platform = :ios, '12.0'

  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.8'
end