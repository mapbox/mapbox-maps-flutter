#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint mapbox_maps_flutter.podspec` to validate before publishing.
#
Pod::Spec.new do |nav|
  nav.name             = 'MapboxNavigation'
  nav.version          = '3.6.0'
  nav.summary          = 'Mapbox Navigation SDK.'
  nav.author           = { 'Mapbox' => 'mobile@mapbox.com' }
  nav.source           = { :git => "https://github.com/mapbox/mapbox-navigation-ios.git", :tag => "3.6.0" }

  nav.dependency 'MapboxMaps', '11.9.0'
  nav.dependency 'Turf', '~> 3.0.0'
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
  s.platform = :ios, '12.0'

  #s.dependency 'MapboxMaps', '11.6.0'
  #s.dependency 'Turf', '~> 2.8.0'
    
  #s.dependency 'MapboxNavigation'  
  s.subspec 'MapboxNavigation' do |nav_module|
  end

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.8'
end
