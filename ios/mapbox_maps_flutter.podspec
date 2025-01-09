#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint mapbox_maps_flutter.podspec` to validate before publishing.
#
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

Pod::Spec.new do |nav|
  nav.name             = 'MapboxNavigationCore'
  nav.version          = '3.5.0'
  nav.summary          = 'Mapbox Navigation SDK.'
  nav.author           = { 'Mapbox' => 'mobile@mapbox.com' }
  nav.source           = { :git => "https://github.com/mapbox/mapbox-navigation-ios.git", :tag => "v3.5.0" }
  
  nav.homepage         = 'https://github.com/mapbox/mapbox-navigation-ios'
  nav.license          = 'MIT'
  nav.author           = { 'Mapbox' => 'mobile@mapbox.com' }  

  nav.source_files = 'Sources/MapboxNavigationCore/**/*.{h,m,swift}'
  nav.resource_bundle = { 'MapboxCoreNavigationResources' => ['Sources/MapboxCoreNavigation/Resources/*/*', 'Sources/MapboxCoreNavigation/Resources/*'] }

  nav.requires_arc = true
  nav.module_name = "MapboxCoreNavigation"

  nav.platform = :ios, '13.0'

  nav.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  nav.swift_version = '5.8'

  nav.dependency 'Turf', '3.0.0'
  #nav.dependency 'MapboxDirections', '3.5.0'

  nav.subspec 'MapboxDirections' do |directions|
  end
end

Pod::Spec.new do |s|
  s.name             = 'mapbox_maps_flutter'
  s.version          = '2.4.0'

  s.summary          = 'Mapbox Maps SDK Flutter Plugin.'
  s.description      = 'An officially developed solution from Mapbox that enables use of our latest Maps SDK product.'
  s.homepage         = 'https://pub.dev/packages/mapbox_maps_flutter'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Mapbox' => 'mobile@mapbox.com' }
  s.source           = { :path => '.' }

  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '13.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.8'

  s.dependency 'MapboxMaps', '11.8.0'
  s.dependency 'Turf', '3.0.0'

  s.subspec 'MapboxDirections' do |directions|
  end

  s.subspec 'MapboxNavigationCore' do |nav|
  end
end
