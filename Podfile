deployment_target = '13.0'
platform :ios, deployment_target

target 'American Whitewater' do

  use_frameworks!

  # Handles issues with Keyboard covering UI elements automatically
  # Note: This is a Fork of the main repo - this allows UISearchBars
  # to be included in the functionality - this will need to be updated
  # or reverted back - but Search on RunsListViewController will not
  # work correctly if you do not use this Fork
  pod 'IQKeyboardManagerSwift', :git => 'https://github.com/duffek/IQKeyboardManager.git', :inhibit_warnings => true
  
  # Push Notification System
  pod 'OneSignalXCFramework'
  
  # Best HTTP Request Handling
  # - Used for reach API / rivers listing
  pod 'Alamofire', '~> 5.4.0'
  pod 'AlamofireImage', '~> 4.1'
  pod 'AlamofireNetworkActivityIndicator', '~> 3.1.0'
  pod 'SwiftyJSON', '~> 5.0.0'
  
  # GraphQL client
  pod 'Apollo', '~> 0.45'
  
  # OAuth and Secure Storge for Auth Keys
  pod 'OAuthSwift', '~> 2', :inhibit_warnings => true
  pod 'KeychainSwift', '~> 19.0'
  
  # Better looking alerts
  pod 'NYAlertViewController', '~> 1.3.0', :inhibit_warnings => true
  
  # Firebase added for analytics and Crashlytics
  pod 'Firebase/Analytics'
  pod 'Firebase/Crashlytics'
  
  # Pod Charts
  pod 'Charts', '~> 3.6.0', :inhibit_warnings => true
  
  # Advanced debugging - only loads in debug
  pod 'netfox'
end

# Push Notification system implementation
target 'OneSignalNotificationServiceExtension' do
  use_frameworks!

  pod 'OneSignalXCFramework'
end

post_install do |installer|
  installer.pods_project.targets.each do |t|
    t.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = deployment_target
    end
  end
end
