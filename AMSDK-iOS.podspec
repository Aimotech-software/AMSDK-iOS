#
# Be sure to run `pod lib lint AMSDK-iOS.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'AMSDK-iOS'
  s.version          = '0.1.6'
  s.summary          = 'A short description of AMSDK-iOS.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  AiMO tech SDK
                       DESC

  s.homepage         = 'https://github.com/Aimotech-software'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'pengbi' => 'bi_p@qu-in.com' }
  s.source           = { :git => 'https://github.com/Aimotech-software/AMSDK-iOS.git', :tag => s.version.to_s }
  s.platform     = :ios, '10.0'
  s.ios.deployment_target = '10.0'
  s.pod_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }
  s.user_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }


  s.source_files = 'AMSDK-iOS/Classes/**/*'
  s.vendored_frameworks = 'AMSDK-iOS/frameworks/*.xcframework'
  s.static_framework = true
  s.dependency 'OpenCV', '3.4.6'
end
