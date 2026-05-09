Pod::Spec.new do |s|
  s.name             = 'unik_torch'
  s.version          = '0.1.0'
  s.summary          = 'Unik torch plugin'
  s.description      = 'Flashlight MethodChannel bridge for Lab 7.'
  s.homepage         = 'https://github.com'
  s.license          = { :type => 'Proprietary' }
  s.author           = { 'Unik' => 'unik@example.local' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '13.0'
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES' }
  s.swift_version = '5.0'
end
