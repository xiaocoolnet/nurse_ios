platform :ios, '8.0'
use_frameworks!

target 'HSHW_2016' do
    pod 'SwiftyJSON'
#    pod 'ReachabilitySwift'
#    pod 'Alamofire','~> 3.0'
    pod 'MBProgressHUD'
#    pod 'IQKeyboardManagerSwift'
    pod 'ImageSlideshow', '~> 0.2.2'
    pod 'SDWebImage', '~> 3.7.3'
    pod 'MOBFoundation'
    pod 'AFNetworking','~> 3.0.1'
    pod 'PagingMenuController','~> 0.9.1'
    pod 'BmobSDK'
    pod "WeiboSDK", :git => "https://github.com/sinaweibosdk/weibo_ios_sdk.git"
    pod 'HandyJSON', '~> 0.4.0'
    
    post_install do |installer|
      installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
          config.build_settings['ENABLE_BITCODE'] = 'NO'
        end
      end
    end
end

