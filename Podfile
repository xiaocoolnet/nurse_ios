use_frameworks!

pod 'Alamofire', '~> 3.0'
pod 'MBProgressHUD'
pod 'IQKeyboardManagerSwift'
pod 'ImageSlideshow', '~> 0.2.2'
pod 'SDWebImage', '~> 3.7.3'
pod 'MOBFoundation'
pod 'AFNetworking' ,'~> 3.0.1'
pod 'PagingMenuController','~> 0.9.1'
pod 'ShareSDK3'
pod 'ShareSDK3/ShareSDKUI'
pod 'ShareSDK3/ShareSDKPlatforms/SinaWeibo'
pod 'ShareSDK3/ShareSDKPlatforms/WeChat'
post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['ENABLE_BITCODE'] = 'NO'
    end
  end
end

