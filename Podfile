# Uncomment the next line to define a global platform for your project
platform :ios, '13.2'

target 'Library' do
  use_frameworks!

  # Pods for Library

  target 'LibraryTests' do
    inherit! :search_paths
    # Pods for testing
  end

end

target 'RxSwiftIncrementalSearch' do
  use_frameworks!

  # Pods for RxSwiftIncrementalSearch
  pod 'RxSwift'
  pod 'RxCocoa'
  pod 'RxSwiftExt'

  target 'RxSwiftIncrementalSearchTests' do
    inherit! :search_paths
    # Pods for testing
    pod 'RxBlocking'
    pod 'RxTest'
  end

  target 'RxSwiftIncrementalSearchUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end

target 'WikipediaAPI' do
  use_frameworks!

  # Pods for WikipediaAPI
  pod 'RxSwift'

  target 'WikipediaAPITests' do
    inherit! :search_paths
    # Pods for testing
    pod 'RxBlocking'
  end

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      if config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] <= '9.0'
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '9.0'
      end
    end
  end
end
