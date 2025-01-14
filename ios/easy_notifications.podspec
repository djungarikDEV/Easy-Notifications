#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint easy_notifications.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'easy_notifications'
  s.version          = '1.1.7'
  s.summary          = 'A simple Flutter plugin for handling local notifications'
  s.description      = <<-DESC
A simple Flutter plugin for handling local notifications with ease.
                       DESC
  s.homepage         = 'https://github.com/djungarikDEV/Easy-Notifications'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'DjungarikDev' => 'arnispprt171@gmail.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '11.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
