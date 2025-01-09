#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint mapbox_maps_flutter.podspec` to validate before publishing.
#

Pod::Spec.new do |md|
  md.name             = 'MapboxDirections'
  md.version          = '3.5.0'
  md.summary          = 'Mapbox Directions.'
  md.author           = { 'Mapbox' => 'mobile@mapbox.com' }
  md.source           = { :git => "https://github.com/mapbox/mapbox-navigation-ios.git", :tag => "v3.5.0" }
  
  md.homepage         = 'https://github.com/mapbox/mapbox-navigation-ios'
  md.license          = 'MIT'
  md.author           = { 'Mapbox' => 'mobile@mapbox.com' }  

  md.source_files = 'Sources/MapboxDirections/**/*.{h,m,swift}'  

  md.requires_arc = true
  md.module_name = "MapboxDirections"

  md.platform = :ios, '13.0'

  md.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  md.swift_version = '5.8'

  md.dependency 'Turf', '3.0.0'
end