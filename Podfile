platform :ios, '8.0'
use_frameworks!

target 'HSHW_2016' do
    #    pod 'ReachabilitySwift'
    #    pod 'Alamofire','~> 3.0'
    #    pod 'IQKeyboardManagerSwift'
    pod 'SwiftyJSON','~> 3.1.1'
    pod 'MBProgressHUD','~> 1.0.0'
    pod 'ImageSlideshow', '~> 1.0.0'
    pod 'SDWebImage', '~> 3.8'
    pod 'AFNetworking','~> 3.1.0'
    pod 'PagingMenuController','~> 1.4.0'
    pod 'HandyJSON', '~> 1.4.0'
    pod 'MOBFoundation'
    pod 'BmobSDK'
    pod "WeiboSDK", :git => "https://github.com/sinaweibosdk/weibo_ios_sdk.git"
    pod 'BaiduMapKit'
    
    post_install do |installer|
      installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
#          config.build_settings['ENABLE_BITCODE'] = 'NO'
          config.build_settings['SWIFT_VERSION'] = '3.0'
        end
      end
    end
end

