//
//  AppDelegate.swift
//  HSHW_2016
//
//  Created by apple on 16/5/13.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit
import MBProgressHUD

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, WXApiDelegate, WeiboSDKDelegate {

    var window: UIWindow?
    var wbtoken: String?
    var wbCurrentUserID: String?
    var wbRefreshToken: String?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        WXApi.registerApp("wxdd50558e711439e8")
        
        WeiboSDK.enableDebugMode(true)
        WeiboSDK.registerApp(kAppKey)
        
        let _ = TencentOAuth(appId: "1105552541", andDelegate: nil)
        
        
        
//        ShareSDK.registerApp("13be4c6c247e0", activePlatforms:
//            
//            [SSDKPlatformType.TypeQQ.rawValue,SSDKPlatformType.TypeWechat.rawValue], onImport: { (platform : SSDKPlatformType) -> Void in
//                
//                switch platform{
//                case SSDKPlatformType.TypeWechat:
//                    ShareSDKConnector.connectWeChat(WXApi.classForCoder())
//                    
//                default:
//                    break
//                }
//                
//        }) { (platform : SSDKPlatformType,appInfo : NSMutableDictionary!) -> Void in
//            switch platform {
////            case  SSDKPlatformType.TypeQQ:
////                appInfo.SSDKSetupQQByAppId("1105281857", appKey: "bysMNvzaiLTMsXjQ", authType: "qq分享")
////                break
//            case SSDKPlatformType.TypeWechat:
//                //设置微信应用信息
//                appInfo.SSDKSetupWeChatByAppId("wxe61df5d7fee96861", appSecret: "0dbfa83f68bfca4d3b60412e581301e2")
//                break
//            default:
//                break
//            }
//        }
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
    
    func application(application: UIApplication, handleOpenURL url: NSURL) -> Bool {
        let str = url.absoluteString
        if str.hasPrefix("wx") {
            return WXApi.handleOpenURL(url, delegate: self)
        }else if str.hasPrefix("wb"){
            return WeiboSDK.handleOpenURL(url, delegate: self)
        }else{
            QQApiInterface.handleOpenURL(url, delegate: qqDelegate())
            return TencentOAuth.HandleOpenURL(url)
        }
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        
        let str = url.absoluteString
        if str.hasPrefix("wx") {
            return WXApi.handleOpenURL(url, delegate: self)
        }else if str.hasPrefix("wb"){
            return WeiboSDK.handleOpenURL(url, delegate: self)
        }else{
            QQApiInterface.handleOpenURL(url, delegate: qqDelegate())

            return TencentOAuth.HandleOpenURL(url)
        }
    }

    // MARK:- 微博回调
    func didReceiveWeiboRequest(request: WBBaseRequest!) {
        
    }
    
    func didReceiveWeiboResponse(response: WBBaseResponse!) {

//        print(response.isKindOfClass(WBSendMessageToWeiboResponse))
//        print(response.isKindOfClass(WBAuthorizeResponse))
//        print(response.isKindOfClass(WBPaymentResponse))
//        print(response.isKindOfClass(WBSDKAppRecommendResponse))
//        print(response.isKindOfClass(WBShareMessageToContactResponse))
//        print(response.isKindOfClass(WBShareMessageToContactResponse))

        if response.isKindOfClass(WBAuthorizeResponse) {
            
//            WBShareMessageToContactResponse* shareMessageToContactResponse = (WBShareMessageToContactResponse*)response;
//            NSString* accessToken = [shareMessageToContactResponse.authResponse accessToken];
//            let shareMessageToContactResponse:WBShareMessageToContactResponse = response as! WBShareMessageToContactResponse
//            let accessToken = shareMessageToContactResponse.authResponse.accessToken
//            print(shareMessageToContactResponse.authResponse.debugDescription)
//            if (accessToken != nil) {
//                wbtoken = accessToken
//            }
            let authorizeResponse:WBAuthorizeResponse = response as! WBAuthorizeResponse
            self.wbtoken = authorizeResponse.accessToken
            self.wbCurrentUserID = authorizeResponse.userID
            self.wbRefreshToken = authorizeResponse.refreshToken
            
            print(authorizeResponse.debugDescription)
//            self.wbtoken = [(WBAuthorizeResponse *)response accessToken];
//            self.wbCurrentUserID = [(WBAuthorizeResponse *)response userID];
//            self.wbRefreshToken = [(WBAuthorizeResponse *)response refreshToken];
            print("123  \(response.statusCode.rawValue)")
            if response.statusCode.rawValue == 0 {
                NewsPageHelper().addScore_fenxiang({ (success, response) in
                    if success || String(response!) == "Exceed the upper limit value" {
                        
                        let hud = MBProgressHUD.showHUDAddedTo(UIApplication.sharedApplication().keyWindow, animated: true)
                        hud.mode = MBProgressHUDMode.Text;
                        hud.labelText = "分享成功 积分增加"
                        print(hud.labelText)
                        hud.margin = 10.0
                        hud.removeFromSuperViewOnHide = true
                        hud.hide(true, afterDelay: 1)
                    }else{
                        let hud = MBProgressHUD.showHUDAddedTo(UIApplication.sharedApplication().keyWindow, animated: true)
                        hud.mode = MBProgressHUDMode.Text;
                        hud.labelText = "分享成功 积分不变"
                        print(hud.labelText)
                        hud.margin = 10.0
                        hud.removeFromSuperViewOnHide = true
                        hud.hide(true, afterDelay: 1)
                    }
                })
            }else{
                let hud = MBProgressHUD.showHUDAddedTo(UIApplication.sharedApplication().keyWindow, animated: true)
                hud.mode = MBProgressHUDMode.Text;
                hud.labelText = "分享失败"
                print(hud.labelText)
                hud.margin = 10.0
                hud.removeFromSuperViewOnHide = true
                hud.hide(true, afterDelay: 1)
            }
            
        }else if response.isKindOfClass(WBSendMessageToWeiboResponse) {

//            let authorizeResponse:WBSendMessageToWeiboResponse = response as! WBSendMessageToWeiboResponse
//            self.wbtoken = authorizeResponse.authResponse.accessToken
            
//            print(authorizeResponse.debugDescription)
            //            self.wbtoken = [(WBAuthorizeResponse *)response accessToken];
            //            self.wbCurrentUserID = [(WBAuthorizeResponse *)response userID];
            //            self.wbRefreshToken = [(WBAuthorizeResponse *)response refreshToken];
            if response.statusCode.rawValue == 0 {
                NewsPageHelper().addScore_fenxiang({ (success, response) in
                    if success || String(response!) == "Exceed the upper limit value" {
                        
                        let hud = MBProgressHUD.showHUDAddedTo(UIApplication.sharedApplication().keyWindow, animated: true)
                        hud.mode = MBProgressHUDMode.Text;
                        hud.labelText = "分享成功 积分增加"
                        print(hud.labelText)
                        hud.margin = 10.0
                        hud.removeFromSuperViewOnHide = true
                        hud.hide(true, afterDelay: 1)
                    }else{
                        let hud = MBProgressHUD.showHUDAddedTo(UIApplication.sharedApplication().keyWindow, animated: true)
                        hud.mode = MBProgressHUDMode.Text;
                        hud.labelText = "分享成功 积分不变"
                        print(hud.labelText)
                        hud.margin = 10.0
                        hud.removeFromSuperViewOnHide = true
                        hud.hide(true, afterDelay: 1)
                    }
                })
            }else{
                let hud = MBProgressHUD.showHUDAddedTo(UIApplication.sharedApplication().keyWindow, animated: true)
                hud.mode = MBProgressHUDMode.Text;
                hud.labelText = "分享失败"
                print(hud.labelText)
                print(hud.labelText)
                hud.margin = 10.0
                hud.removeFromSuperViewOnHide = true
                hud.hide(true, afterDelay: 1)
            }
        }
    }
    // MARK:-
    
    
    func onResp(resp: BaseResp!) {
        
        print(resp.errCode)
        if resp.errCode == 0 {
            NewsPageHelper().addScore_fenxiang({ (success, response) in
                if success || String(response!) == "Exceed the upper limit value" {
                    
                    let hud = MBProgressHUD.showHUDAddedTo(UIApplication.sharedApplication().keyWindow, animated: true)
                    hud.mode = MBProgressHUDMode.Text;
                    hud.labelText = "分享成功 积分增加"
                    print(hud.labelText)
                    hud.margin = 10.0
                    hud.removeFromSuperViewOnHide = true
                    hud.hide(true, afterDelay: 1)
                }else{
                    let hud = MBProgressHUD.showHUDAddedTo(UIApplication.sharedApplication().keyWindow, animated: true)
                    hud.mode = MBProgressHUDMode.Text;
                    hud.labelText = "分享成功 积分不变"
                    print(hud.labelText)
                    hud.margin = 10.0
                    hud.removeFromSuperViewOnHide = true
                    hud.hide(true, afterDelay: 1)
                }
            })
        }else{
            let hud = MBProgressHUD.showHUDAddedTo(UIApplication.sharedApplication().keyWindow, animated: true)
            hud.mode = MBProgressHUDMode.Text;
            hud.labelText = "分享失败"
            print(hud.labelText)
            hud.margin = 10.0
            hud.removeFromSuperViewOnHide = true
            hud.hide(true, afterDelay: 1)
        }
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

