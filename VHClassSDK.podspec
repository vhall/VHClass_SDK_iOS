Pod::Spec.new do |s|
  s.name            = "VHClassSDK"
  s.version         = "3.4.0"
  s.author          = { "vhall" => "xiaoxiang.wang@vhall.com" }
  s.license         = { :type => "MIT", :file => "LICENSE" }
  s.homepage        = 'https://www.vhall.com'
  s.source          = { :git => "https://github.com/vhall/VHClass_SDK_iOS.git", :tag => s.version.to_s}
  s.summary         = "VHClassSDK for IOS"
  s.platform        = :ios, '9.0'
  s.requires_arc    = true
  #s.source_files    = ''
  #s.libraries = 'xml2.2'
  s.frameworks      = "AVFoundation", "VideoToolbox","OpenAL","CoreMedia","CoreTelephony" ,"OpenGLES" ,"MediaPlayer" ,"AssetsLibrary","QuartzCore" ,"JavaScriptCore","Security"
  s.module_name     = 'VHClassSDK'
  s.resources       = ['README.md']
  #s.resource_bundles= {}
  s.vendored_frameworks = 'VHClassSDK/framework/*.framework'
  s.pod_target_xcconfig = {
    'FRAMEWORK_SEARCH_PATHS' => '$(inherited) $(PODS_ROOT)/**',
    'HEADER_SEARCH_PATHS' => '$(inherited) $(PODS_ROOT)/**',
    'VALID_ARCHS' => 'armv7 arm64',
    'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64'
  }

end
