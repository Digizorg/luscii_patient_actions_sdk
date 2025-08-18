#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = 'luscii_patient_actions_sdk_ios'
  s.version          = '0.4.0'
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
  s.platform         = :ios, '13.0'
  s.swift_version    = '5.0'

  # Specify the version of Actions you want to include
  actions_version = '1.4.1'

  # Download and unzip the Actions.xcframework and RxSwift frameworks during the prepare phase
  s.prepare_command = <<-CMD
    # Download Actions.xcframework
    curl -L -o Actions.xcframework.zip https://github.com/Luscii/actions-sdk-ios/releases/download/#{actions_version}/Actions.xcframework.zip
    unzip -o Actions.xcframework.zip
    rm Actions.xcframework.zip
  CMD

  # Include the frameworks as vendored frameworks
  s.vendored_frameworks = 'Actions.xcframework'

  # Specify that this pod builds a static framework to prevent multiple embeddings
  s.static_framework = true

  # Exclude i386 architecture for simulator builds
  s.pod_target_xcconfig = {
    'DEFINES_MODULE' => 'YES',
    'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386',
    'FRAMEWORK_SEARCH_PATHS' => '$(inherited) $(PODS_ROOT)/luscii_patient_actions_sdk_ios',
    'LD_RUNPATH_SEARCH_PATHS' => '$(inherited) @executable_path/Frameworks @loader_path/Frameworks'
  }

  s.user_target_xcconfig = {
    'FRAMEWORK_SEARCH_PATHS' => '$(inherited) $(PODS_ROOT)/luscii_patient_actions_sdk_ios',
    'LD_RUNPATH_SEARCH_PATHS' => '$(inherited) @executable_path/Frameworks @loader_path/Frameworks'
  }
end
