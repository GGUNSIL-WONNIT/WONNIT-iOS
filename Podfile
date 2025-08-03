platform :ios, '18.0'

target 'WONNIT' do
  use_frameworks!
  use_modular_headers!

  pod 'Kingfisher', '~> 8.0'

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['CODE_SIGNING_ALLOWED'] = 'NO'
    end
  end
end
