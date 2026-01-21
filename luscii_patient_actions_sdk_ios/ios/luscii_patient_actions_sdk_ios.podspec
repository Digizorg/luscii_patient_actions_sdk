#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = 'luscii_patient_actions_sdk_ios'
  s.version          = '0.8.0'
  s.summary          = 'An iOS implementation of the luscii_patient_actions_sdk plugin.'
  s.description      = <<-DESC
  An iOS implementation of the luscii_patient_actions_sdk plugin.
                       DESC
  s.homepage         = 'https://github.com/Digizorg/luscii_patient_actions_sdk'
  s.license          = { :type => 'BSD', :file => '../LICENSE' }
  s.author           = { 'Digizorg' => 'info@digizorg.app' }
  s.source           = { :path => '.' }
  s.source_files     = 'Classes/**/*'
  s.dependency       'Flutter'
  s.platform         = :ios, '15.5'
  s.swift_version    = '5.0'

  # Specify the version of Actions you want to include
  actions_version = '2.0.0'

  # Download and unzip the frameworks during the prepare phase
  s.prepare_command = <<-CMD
    # Download Actions.xcframework
    curl -L -o Actions.xcframework.zip https://github.com/Luscii/actions-sdk-ios/releases/download/#{actions_version}/Actions.xcframework.zip
    unzip -o Actions.xcframework.zip
    rm Actions.xcframework.zip

    # Download Centraal.xcframework
    curl -L -o Centraal.xcframework.zip https://github.com/Luscii/actions-sdk-ios/releases/download/#{actions_version}/Centraal.xcframework.zip
    unzip -o Centraal.xcframework.zip
    rm Centraal.xcframework.zip

    # Download HTTPii.xcframework
    curl -L -o HTTPii.xcframework.zip https://github.com/Luscii/actions-sdk-ios/releases/download/#{actions_version}/HTTPii.xcframework.zip
    unzip -o HTTPii.xcframework.zip
    rm HTTPii.xcframework.zip

    # Download Measurements.xcframework
    curl -L -o Measurements.xcframework.zip https://github.com/Luscii/actions-sdk-ios/releases/download/#{actions_version}/Measurements.xcframework.zip
    unzip -o Measurements.xcframework.zip
    rm Measurements.xcframework.zip
  CMD

  # Include the frameworks as vendored frameworks
  s.vendored_frameworks = 'Actions.xcframework', 'Centraal.xcframework', 'HTTPii.xcframework', 'Measurements.xcframework'

  # Exclude i386 architecture for simulator builds
  s.pod_target_xcconfig = {
    'DEFINES_MODULE' => 'YES',
    'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386',
    'LIBRARY_SEARCH_PATHS' => '$(TOOLCHAIN_DIR)/usr/lib/swift/$(PLATFORM_NAME) $(TOOLCHAIN_DIR)/usr/lib/swift-5.0/$(PLATFORM_NAME)'
  }

  s.user_target_xcconfig = {
    'LIBRARY_SEARCH_PATHS' => '$(TOOLCHAIN_DIR)/usr/lib/swift/$(PLATFORM_NAME) $(TOOLCHAIN_DIR)/usr/lib/swift-5.0/$(PLATFORM_NAME)'
  }
end
