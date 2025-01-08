Pod::Spec.new do |s|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

  s.name = "Turf"
  s.version = "3.0.0"
  s.summary = "Simple spatial analysis."
  s.description = "A spatial analysis library written in Swift for native iOS, macOS, tvOS, watchOS, visionOS, and Linux applications, ported from Turf.js."

  s.homepage = "https://github.com/mapbox/turf-swift"

  # ―――  Spec License  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

  s.license = { :type => "ISC", :file => "LICENSE.md" }

  # ――― Author Metadata  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

  s.author = { "Mapbox" => "mobile@mapbox.com" }
  s.social_media_url = "https://twitter.com/mapbox"

  # ――― Platform Specifics ――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

  s.ios.deployment_target = "11.0"
  s.osx.deployment_target = "10.13"
  s.tvos.deployment_target = "11.0"
  s.watchos.deployment_target = "4.0"
  # CocoaPods doesn't support releasing of visionOS pods yet, need to wait for v1.15.0 release of CocoaPods
  # with this fix https://github.com/CocoaPods/CocoaPods/pull/12159.
  # s.visionos.deployment_target = "1.0"

  # ――― Source Location ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  
  s.source = {
    :http => "https://github.com/mapbox/turf-swift/releases/download/v#{s.version}/Turf.xcframework.zip"
  }

  # ――― Project Settings ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

  s.requires_arc = true
  s.module_name = "Turf"
  s.frameworks = 'CoreLocation'
  s.swift_version = "5.7"
  s.vendored_frameworks = 'Turf.xcframework'

end