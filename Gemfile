source "https://rubygems.org"

gem "fastlane"
# activesupport was pinned because of Cocoapods being incompatible with active support 7.0.10,
# more details here - https://github.com/CocoaPods/CocoaPods/issues/12081
# allegedly, this issue is resolved in https://github.com/CocoaPods/CocoaPods/pull/12082,
# pinning can be removed after the above fix is released
gem 'activesupport', '7.0.8'

plugins_path = File.join(File.dirname(__FILE__), '.fastlane', 'Pluginfile')
eval_gemfile(plugins_path) if File.exist?(plugins_path)
