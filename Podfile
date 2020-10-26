
platform :ios, '11.0'

target 'American Whitewater' do

  use_frameworks!

  # Handles issues with Keyboard covering UI elements automatically
  # Note: This is a Fork of the main repo - this allows UISearchBars
  # to be included in the functionality - this will need to be updated
  # or reverted back - but Search on RunsListViewController will not
  # work correctly if you do not use this Fork
  pod 'IQKeyboardManagerSwift', :git => 'https://github.com/duffek/IQKeyboardManager.git'  
  
  # Push Notification System
  pod 'OneSignal', '~> 2.11.2'
  
  # Best HTTP Request Handling
  pod 'Alamofire', '~> 5.1.0'
  pod 'AlamofireImage', '~> 4.1'
  pod 'AlamofireNetworkActivityIndicator', '~> 3.1.0'
  pod 'SwiftyJSON', '~> 5.0.0'
  
  # OAuth and Secure Storge for Auth Keys
  pod 'OAuthSwift', '~> 2.1.0'
  pod 'KeychainSwift', '~> 19.0'
  
  # Better looking alerts
  pod 'NYAlertViewController', '~> 1.3.0'
  
  # Firebase added for analytics and Crashlytics
  pod 'Fabric', '~> 1.10.2'
  pod 'Crashlytics', '~> 3.14.0'
  pod 'Firebase/Analytics', '~> 6.22.0'
  
  # Pod Charts
  pod 'Charts', '~> 3.6.0'
  
  # Advanced debugging - only loads in debug
  pod 'netfox'
end

# Push Notification system implementation
target 'OneSignalNotificationServiceExtension' do
  use_frameworks!

  pod 'OneSignal', '~> 2.11.2'
  
end
