platform :ios, '18.0'

inhibit_all_warnings!
use_frameworks! :linkage => :static

target 'WONNIT' do
  use_modular_headers!

  pod 'lottie-ios'

  pod 'Kingfisher', '~> 8.0'

  pod 'Alamofire'

  pod 'Moya', '~> 15.0'

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['CODE_SIGNING_ALLOWED'] = 'NO'
      config.build_settings['SWIFT_COMPILATION_MODE'] = 'wholemodule'
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '18.0'
    end
  end
end
