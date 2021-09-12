# Uncomment the next line to define a global platform for your project
platform :ios, '11.0'

def shared_pods
  pod 'Cosmos', '~> 23.0'
  pod 'RxSwift', '~> 6.0.0'
  pod 'RxCocoa', '~> 6.0.0'
  pod 'Kingfisher', '~> 5.0'
  pod 'Reusable'
  pod 'RxDataSources', '~> 5.0'
  pod 'RxFlow'
  pod 'RealmSwift'
  pod 'Alamofire', '~> 5.4'
  pod 'Moya', '~> 14.0'
  pod 'SwiftyBeaver'
  pod 'Swinject'
  pod 'SwinjectStoryboard'
  pod 'SwiftLint'
  pod 'SwiftGen', '~> 6.0'
  pod 'Zip', '~> 2.1'
  pod 'ReactorKit'
end

target 'AppStoreSample' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for AppStoreSample
  shared_pods
  
  target 'AppStoreSampleTests' do
    # Pods for testing
  end
end

target 'Data' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Data
  shared_pods

  # target 'DataTests' do
    # Pods for testing
  # end

end

target 'Domain' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Domain
  shared_pods
end
