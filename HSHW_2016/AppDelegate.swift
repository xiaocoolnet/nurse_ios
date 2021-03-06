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
    
    var mapManger:BMKMapManager?

    // 启动百度移动统计
    func startBaiduMobileStat() {
        /*若应用是基于iOS 9系统开发，需要在程序的info.plist文件中添加一项参数配置，确保日志正常发送，配置如下：
         NSAppTransportSecurity(NSDictionary):
         NSAllowsArbitraryLoads(Boolen):YES
         详情参考本Demo的BaiduMobStatSample-Info.plist文件中的配置
         */
        let statTracker = BaiduMobStat.default()

        // 此处(startWithAppId之前)可以设置初始化的可选参数，具体有哪些参数，可详见BaiduMobStat.h文件，例如：
        statTracker?.shortAppVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
//        statTracker.enableDebugOn = true
        
        // TODO:
//        statTracker.channelId = "pgyer"

        statTracker?.start(withAppId: "7f69594569") // 设置您在mtj网站上添加的app的appkey,此处AppId即为应用的appKey
        
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        self.startBaiduMobileStat()
        
        if ((launchOptions) != nil) {
            
            let remoteNotificationDic = launchOptions?[UIApplicationLaunchOptionsKey.init("UIApplicationLaunchOptionsRemoteNotificationKey")]
//            let remoteNotificationDic = launchOptions!["UIApplicationLaunchOptionsRemoteNotificationKey"]
            
            UserDefaults.standard.setValue(remoteNotificationDic, forKey: "recivePushNotification")
            

        }
        application.applicationIconBadgeNumber = application.applicationIconBadgeNumber >= 1 ? (application.applicationIconBadgeNumber - 1):0
        
        // 向苹果注册推送，获取deviceToken并上报
        self.registerAPNS(application)
        // 初始化SDK
        self.initCloudPush()
        // 监听推送通道打开动作
        self.listenerOnChannelOpened()
        // 监听推送消息到来
        self.registerMessageReceive()
        // 点击通知将App从关闭状态启动时，将通知打开回执上报
        CloudPushSDK.handleLaunching(launchOptions)
        
        Bmob.register(withAppKey: "41294c11c5f9bec7b6a7192142439427")
        
        WXApi.registerApp("wxdd50558e711439e8")
        
        WeiboSDK.enableDebugMode(true)
        WeiboSDK.registerApp(kAppKey)
        
        let _ = TencentOAuth(appId: "1105552541", andDelegate: nil)
        
        
        mapManger = BMKMapManager()
        // 如果要关注网络及授权验证事件，请设定     generalDelegate参数
        let ret:Bool = mapManger!.start("qkbhS4bi9XYrMyDMlds9AI1ujn21AhdC", generalDelegate: nil)
        if (!ret) {
            print("manager start failed!")
        }
        
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
        
//        Thread.sleep(forTimeInterval: 1.0)
        UITabBar.appearance().tintColor = COLOR
        UITabBar.appearance().backgroundColor = UIColor.white
        UINavigationBar.appearance().barTintColor = UIColor.white
        UINavigationBar.appearance().tintColor = COLOR
        UINavigationBar.appearance().isTranslucent = false
        if let barFont = UIFont(name: "ChalkboardSE-Bold", size: 18){
            UINavigationBar.appearance().titleTextAttributes = [
                NSForegroundColorAttributeName:COLOR,
                NSFontAttributeName : barFont
            ]
        }
        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffsetMake(0, -60), for: UIBarMetrics.default)
        
//        self.window?.rootViewController = LaunchViewController()
        
        return true
    }
    
    func application(_ application: UIApplication, handleOpen url: URL) -> Bool {
        let str = url.absoluteString
        if str.hasPrefix("wx") {
            return WXApi.handleOpen(url, delegate: self)
        }else if str.hasPrefix("wb"){
            return WeiboSDK.handleOpen(url, delegate: self)
        }else{
            QQApiInterface.handleOpen(url, delegate: qqDelegate())
            return TencentOAuth.handleOpen(url)
        }
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        
        let str = url.absoluteString
        if str.hasPrefix("wx") {
            return WXApi.handleOpen(url, delegate: self)
        }else if str.hasPrefix("wb"){
            return WeiboSDK.handleOpen(url, delegate: self)
        }else{
            QQApiInterface.handleOpen(url, delegate: qqDelegate())

            return TencentOAuth.handleOpen(url)
        }
    }

    // MARK:- 微博回调
    func didReceiveWeiboRequest(_ request: WBBaseRequest!) {
        
    }
    
    func didReceiveWeiboResponse(_ response: WBBaseResponse!) {

//        print(response.isKindOfClass(WBSendMessageToWeiboResponse))
//        print(response.isKindOfClass(WBAuthorizeResponse))
//        print(response.isKindOfClass(WBPaymentResponse))
//        print(response.isKindOfClass(WBSDKAppRecommendResponse))
//        print(response.isKindOfClass(WBShareMessageToContactResponse))
//        print(response.isKindOfClass(WBShareMessageToContactResponse))

        if response.isKind(of: WBAuthorizeResponse.self) {
            
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
            
//            print(authorizeResponse.debugDescription)
//            self.wbtoken = [(WBAuthorizeResponse *)response accessToken];
//            self.wbCurrentUserID = [(WBAuthorizeResponse *)response userID];
//            self.wbRefreshToken = [(WBAuthorizeResponse *)response refreshToken];
//            print("123  \(response.statusCode.rawValue)")
            if response.statusCode.rawValue == 0 {
                NewsPageHelper().addScore_fenxiang({ (success, response) in
                    if success {
                        
                        
                        if success {
                            let result = response as! addScore_ReadingInformationDataModel
                            NursePublicAction.showScoreTips(self.window!, nameString: result.event, score: result.score)
                        }
                        //                    let hud = MBProgressHUD.showHUDAddedTo(UIApplication.sharedApplication().keyWindow, animated: true)
                        //                    hud.mode = MBProgressHUDMode.Text;
                        //                    hud.label.text = "分享成功 积分增加"
                        //                    
                        //                    hud.margin = 10.0
                        //                    hud.removeFromSuperViewOnHide = true
                        //                    hud.hide(animated: true, afterDelay: 1)
                    }else{
                        let hud = MBProgressHUD.showAdded(to: UIApplication.shared.keyWindow!, animated: true)
                        hud.mode = MBProgressHUDMode.text;
                        hud.label.text = "分享成功"
                        
                        hud.margin = 10.0
                        hud.removeFromSuperViewOnHide = true
                        hud.hide(animated: true, afterDelay: 1)
                    }
                })
            }else{
                let hud = MBProgressHUD.showAdded(to: UIApplication.shared.keyWindow!, animated: true)
                hud.mode = MBProgressHUDMode.text;
                hud.label.text = "分享失败"
                
                hud.margin = 10.0
                hud.removeFromSuperViewOnHide = true
                hud.hide(animated: true, afterDelay: 1)
            }
            
        }else if response.isKind(of: WBSendMessageToWeiboResponse.self) {

//            let authorizeResponse:WBSendMessageToWeiboResponse = response as! WBSendMessageToWeiboResponse
//            self.wbtoken = authorizeResponse.authResponse.accessToken
            
//            print(authorizeResponse.debugDescription)
            //            self.wbtoken = [(WBAuthorizeResponse *)response accessToken];
            //            self.wbCurrentUserID = [(WBAuthorizeResponse *)response userID];
            //            self.wbRefreshToken = [(WBAuthorizeResponse *)response refreshToken];
            if response.statusCode.rawValue == 0 {
                NewsPageHelper().addScore_fenxiang({ (success, response) in
                    if success {
                        
                        
                        if success {
                            let result = response as! addScore_ReadingInformationDataModel
                            NursePublicAction.showScoreTips(self.window!, nameString: result.event, score: result.score)
                        }
                        //                    let hud = MBProgressHUD.showHUDAddedTo(UIApplication.sharedApplication().keyWindow, animated: true)
                        //                    hud.mode = MBProgressHUDMode.Text;
                        //                    hud.label.text = "分享成功 积分增加"
                        //                    
                        //                    hud.margin = 10.0
                        //                    hud.removeFromSuperViewOnHide = true
                        //                    hud.hide(animated: true, afterDelay: 1)
                    }else{
                        let hud = MBProgressHUD.showAdded(to: UIApplication.shared.keyWindow!, animated: true)
                        hud.mode = MBProgressHUDMode.text;
                        hud.label.text = "分享成功"
                        
                        hud.margin = 10.0
                        hud.removeFromSuperViewOnHide = true
                        hud.hide(animated: true, afterDelay: 1)
                    }
                })
            }else{
                let hud = MBProgressHUD.showAdded(to: UIApplication.shared.keyWindow!, animated: true)
                hud.mode = MBProgressHUDMode.text;
                hud.label.text = "分享失败"
                
                hud.margin = 10.0
                hud.removeFromSuperViewOnHide = true
                hud.hide(animated: true, afterDelay: 1)
            }
        }
    }
    // MARK:-
    
    
    func onResp(_ resp: BaseResp!) {
        
        print(resp.errCode)
        if resp.errCode == 0 {
            NewsPageHelper().addScore_fenxiang({ (success, response) in
                if success {
                    
                    
                    if success {
                        let result = response as! addScore_ReadingInformationDataModel
                        NursePublicAction.showScoreTips(self.window!, nameString: result.event, score: result.score)
                    }
//                    let hud = MBProgressHUD.showHUDAddedTo(UIApplication.sharedApplication().keyWindow, animated: true)
//                    hud.mode = MBProgressHUDMode.Text;
//                    hud.label.text = "分享成功 积分增加"
//                    
//                    hud.margin = 10.0
//                    hud.removeFromSuperViewOnHide = true
//                    hud.hide(animated: true, afterDelay: 1)
                }else{
                    let hud = MBProgressHUD.showAdded(to: UIApplication.shared.keyWindow!, animated: true)
                    hud.mode = MBProgressHUDMode.text;
                    hud.label.text = "分享成功"
                    
                    hud.margin = 10.0
                    hud.removeFromSuperViewOnHide = true
                    hud.hide(animated: true, afterDelay: 1)
                }
            })
        }else{
            let hud = MBProgressHUD.showAdded(to: UIApplication.shared.keyWindow!, animated: true)
            hud.mode = MBProgressHUDMode.text;
            hud.label.text = "分享失败"
            
            hud.margin = 10.0
            hud.removeFromSuperViewOnHide = true
            hud.hide(animated: true, afterDelay: 1)
        }
    }
    
    // MARK:- 阿里云推送
    func initCloudPush() {
        CloudPushSDK.asyncInit("23442294", appSecret: "0f9e9e29d7e6c6d6792183658370b55b") { (res) in
            if (res?.success)! {
                print("Push SDK init success, deviceId: %@.", CloudPushSDK.getDeviceId())
            }else{
                print("Push SDK init failed, error: %@", res?.error ?? "error")
            }
        }
    }
    /**
     *    注册苹果推送，获取deviceToken用于推送
     *
     *    @param     application
     */
    func registerAPNS(_ application:UIApplication) {
        
        // iOS 8 Notifications
        application.registerUserNotificationSettings(UIUserNotificationSettings(types: [UIUserNotificationType.sound,UIUserNotificationType.alert,UIUserNotificationType.badge], categories: nil))
        application.registerForRemoteNotifications()
        
    }
    /*
     *  苹果推送注册成功回调，将苹果返回的deviceToken上传到CloudPush服务器
     */
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        CloudPushSDK.registerDevice(deviceToken) { (res) in
            if (res?.success)! {
                print("Register deviceToken success.")
            }else{
                print("Register deviceToken failed, error: %@", res?.error ?? "error")
            }
        }
    }
    /*
     *  苹果推送注册失败回调
     */
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("didFailToRegisterForRemoteNotificationsWithError %@", error)
    }
    /**
     *	注册推送通道打开监听
     */
    func listenerOnChannelOpened() {
        NotificationCenter.default.addObserver(self, selector: #selector(onChannelOpened), name: NSNotification.Name(rawValue: "CCPDidChannelConnectedSuccess"), object: nil)
    }
    
    
    /**
     *    注册推送消息到来监听
     */
    func registerMessageReceive() {
        NotificationCenter.default.addObserver(self, selector: #selector(onMessageReceived(_:)), name: NSNotification.Name(rawValue: "CCPDidReceiveMessageNotification"), object: nil)
    }
    /**
     *	推送通道打开回调
     *
     *	@param 	notification
     */
    func onChannelOpened(_ notification:Notification) {
        print("温馨提示:消息通道建立成功")
    }
    /**
     *    处理到来推送消息
     *
     *    @param     notification
     */
    func onMessageReceived(_ notification:Notification) {
        let message = notification.object as! CCPSysMessage
        let title = NSString(data: message.title, encoding: String.Encoding.utf8.rawValue)
        let body = NSString(data: message.body, encoding: String.Encoding.utf8.rawValue)
        
        print("Receive message title: \(title), content: \(body).")
    }
    /*
     *  App处于启动状态时，通知打开回调
     */
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        print("App处于启动状态时，通知打开回调")
        
        // 取得APNS通知内容
        let aps = userInfo["aps"] as? NSDictionary
        // 内容
        let content = aps!["alert"] as? NSString
        // badge数量
        let badge = aps!["badge"] as? NSInteger
        // 播放声音
        let sound = aps!.value(forKey: "sound") as? NSString
        // 取得Extras字段内容
        let Extras = userInfo["Extras"] as? NSString //服务端中Extras字段，key是自己定义的
        print("content = [\(content)], badge = [\(badge)], sound = [\(sound)], Extras = [\(Extras)]")
        // iOS badge 清0
        application.applicationIconBadgeNumber = application.applicationIconBadgeNumber - (badge ?? 0)!
        
        if application.applicationState == .inactive {
            
            if (userInfo["news"] != nil) {
                
                //                [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil
                //                let data = try?NSJSONSerialization.dataWithJSONObject(userInfo, options: NSJSONWritingOptions.PrettyPrinted)
                var data2 = Data()
                if (userInfo["news"]! is NSString) {
                    data2 = (userInfo["news"] as! NSString).data(using: String.Encoding.utf8.rawValue)!
                }else if (userInfo["news"]! is NSDictionary) {
                    data2 = try!JSONSerialization.data(withJSONObject: userInfo["news"] as! NSDictionary, options: JSONSerialization.WritingOptions.prettyPrinted)
                }
                //                let data = (userInfo["news"] as! NSString).dataUsingEncoding(NSUTF8StringEncoding)
                
                let newsInfo =  NewsInfo(JSONDecoder(data2 as AnyObject))
                let next = NewsContantViewController()
                next.newsInfo = newsInfo
                
                let tabBarController = self.window?.rootViewController as! UITabBarController
                let nav = tabBarController.selectedViewController as! UINavigationController
                
                nav.pushViewController(next, animated: true)
            }
            // 通知打开回执上报
            CloudPushSDK.handleReceiveRemoteNotification(userInfo)
        }else{
            
            
            let alert = UIAlertController(title: "新通知", message: String(content!), preferredStyle: .alert)
            self.window?.rootViewController?.present(alert, animated: true, completion: nil)
            
            let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            alert.addAction(cancelAction)
            
            let viewAction = UIAlertAction(title: "查看", style: .default) { (viewAction) in
                
                if (userInfo["news"] != nil) {
                    
                    //                [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil
                    //                let data = try?NSJSONSerialization.dataWithJSONObject(userInfo, options: NSJSONWritingOptions.PrettyPrinted)
                    var data2 = Data()
                    if (userInfo["news"]! is NSString) {
                        data2 = (userInfo["news"] as! NSString).data(using: String.Encoding.utf8.rawValue)!
                    }else if (userInfo["news"]! is NSDictionary) {
                        data2 = try!JSONSerialization.data(withJSONObject: userInfo["news"] as! NSDictionary, options: JSONSerialization.WritingOptions.prettyPrinted)
                    }
                    //                let data = (userInfo["news"] as! NSString).dataUsingEncoding(NSUTF8StringEncoding)
                    
                    let newsInfo =  NewsInfo(JSONDecoder(data2 as AnyObject))
                    let next = NewsContantViewController()
                    next.newsInfo = newsInfo
                    
                    let tabBarController = self.window?.rootViewController as! UITabBarController
                    let nav = tabBarController.selectedViewController as! UINavigationController
                    
                    nav.pushViewController(next, animated: true)
                }
                // 通知打开回执上报
                CloudPushSDK.handleReceiveRemoteNotification(userInfo)
            }
            alert.addAction(viewAction)
        }
    }
    // MARK:-
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

