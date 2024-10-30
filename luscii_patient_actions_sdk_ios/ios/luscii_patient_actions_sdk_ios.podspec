#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = 'luscii_patient_actions_sdk_ios'
  s.version          = '0.0.1'
  s.summary          = 'An iOS implementation of the luscii_patient_actions_sdk plugin.'
  s.description      = <<-DESC
  An iOS implementation of the luscii_patient_actions_sdk plugin.
                       DESC
  s.homepage         = 'https://github.com/Digizorg/luscii_patient_actions_sdk'
  s.license          = { :type => 'BSD', :file => '../LICENSE' }
  s.author           = { 'Digizorg' => 'info@digizorg.app' }
  s.source           = { :path => '.' }  
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '13.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'

  # Specify the version of Actions you want to include
  actions_version = '1.2.0'

  # The version of Actions depends on dependencies, lets include them here
  s.dependency 'RxSwift', '~> 6.6.0'
  s.dependency 'RxCocoa', '~> 6.6.0'
  s.dependency 'RxRelay', '~> 6.6.0'

  # Download and unzip the Actions.xcframework during the prepare phase
  s.prepare_command = <<-CMD
    curl -L -o Actions.xcframework.zip https://github.com/Luscii/actions-sdk-ios/releases/download/#{actions_version}/Actions.xcframework.zip
    unzip -o Actions.xcframework.zip
    rm Actions.xcframework.zip
  CMD

  # Include the Actions.xcframework as a vendored framework
  s.vendored_frameworks = 'Actions.xcframework'

  # Specify that this pod builds a static framework to prevent multiple embeddings
  s.static_framework = true

  # Exclude i386 architecture for simulator builds
  s.pod_target_xcconfig = {
    'DEFINES_MODULE' => 'YES',
    'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386'
  }
end
