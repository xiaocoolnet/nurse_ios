//
//  AppDelegate.swift
//  HSHW_2016
//
//  Created by apple on 16/5/13.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        ShareSDK.registerApp("13be4c6c247e0", activePlatforms:
            
            [SSDKPlatformType.TypeQQ.rawValue,SSDKPlatformType.TypeWechat.rawValue], onImport: { (platform : SSDKPlatformType) -> Void in
                
                switch platform{
                case SSDKPlatformType.TypeWechat:
                    ShareSDKConnector.connectWeChat(WXApi.classForCoder())
                    
                default:
                    break
                }
                
        }) { (platform : SSDKPlatformType,appInfo : NSMutableDictionary!) -> Void in
            switch platform {
//            case  SSDKPlatformType.TypeQQ:
//                appInfo.SSDKSetupQQByAppId("1105281857", appKey: "bysMNvzaiLTMsXjQ", authType: "qq分享")
//                break
            case SSDKPlatformType.TypeWechat:
                //设置微信应用信息
                appInfo.SSDKSetupWeChatByAppId("15ad6d49bc7b3", appSecret: "b54397eff1c1c45d73392d5fb7dfff12")
                break
            default:
                break
            }
        }
        NSThread.sleepForTimeInterval(2.0)
        UITabBar.appearance().tintColor = COLOR
        UITabBar.appearance().backgroundColor = UIColor.whiteColor()
        UINavigationBar.appearance().barTintColor = UIColor.whiteColor()
        UINavigationBar.appearance().tintColor = COLOR
        UINavigationBar.appearance().translucent = false
        if let barFont = UIFont(name: "ChalkboardSE-Bold", size: 18){
            UINavigationBar.appearance().titleTextAttributes = [
                NSForegroundColorAttributeName:COLOR,
                NSFontAttributeName : barFont
            ]
        }
        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffsetMake(0, -60), forBarMetrics: UIBarMetrics.Default)
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

