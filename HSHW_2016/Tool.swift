//
//  Tool.swift
//  HSHW_2016
//
//  Created by apple on 16/5/14.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

let WIDTH = UIScreen.mainScreen().bounds.size.width
let HEIGHT = UIScreen.mainScreen().bounds.size.height
let COLOR = UIColor(red: 145/255.0, green: 26/255.0, blue: 107/255.0, alpha: 1.0)
let GREY = UIColor(red: 158/255.0, green: 158/255.0, blue: 158/255.0, alpha: 1.0)
let RGREY = UIColor(red: 242/255.0, green: 242/255.0, blue: 242/255.0, alpha: 1.0)
let PARK_URL_Header = "http://nurse.xiaocool.net/index.php?g=apps&m=index&a="
let NewsInfo_Header = "http://nurse.xiaocool.net/index.php?g=portal&m=article&a=index&id="
let IMAGE_URL_HEADER = "http://nurse.xiaocool.net"
let SHOW_IMAGE_HEADER = "http://nurse.xiaocool.net/uploads/microblog/"
let LOGINFO_KEY = "login_info"
let USER_NAME = "login_name"
let USER_PWD = "login_password"
var LOGIN_STATE = false

let APP_SHARE_URL = "https://www.pgyer.com/kUyM"
let APP_SHARE_NAME = "中国护士网"

//let ZAN_URL_Header = "http://wxt.xiaocool.net/index.php?g=apps&m=index&a="

func calculateHeight(string:String,size:CGFloat,width:  CGFloat) -> CGFloat {
    let options : NSStringDrawingOptions = NSStringDrawingOptions.UsesLineFragmentOrigin
    //let screenBounds:CGRect = UIScreen.mainScreen().bounds
    let boundingRect = String(string).boundingRectWithSize(CGSizeMake(width, 0), options: options, attributes: [NSFontAttributeName:UIFont.systemFontOfSize(size)], context: nil)
    print(boundingRect.height)
    return boundingRect.height
}

func calculateWidth(string:String,size:CGFloat,height:  CGFloat) -> CGFloat {
    let options : NSStringDrawingOptions = NSStringDrawingOptions.UsesLineFragmentOrigin
    //let screenBounds:CGRect = UIScreen.mainScreen().bounds
    let boundingRect = String(string).boundingRectWithSize(CGSizeMake(0, height), options: options, attributes: [NSFontAttributeName:UIFont.systemFontOfSize(size)], context: nil)

    return boundingRect.width
}


typealias TimerHandle = (timeInterVal:Int)->Void

//计时器类
class TimeManager{
    var taskDic = Dictionary<String,TimeTask>()
    
    //两行代码创建一个单例
    static let shareManager = TimeManager()
    private init() {
    }
    func begainTimerWithKey(key:String,timeInterval:Float,process:TimerHandle,finish:TimerHandle){
        if taskDic.count > 20 {
            print("任务太多")
            return
        }
        if timeInterval>120 {
            print("不支持120秒以上后台操作")
            return
        }
        if taskDic[key] != nil{
            print("存在这个任务")
            return
        }
        let task = TimeTask().configureWithTime(key,time:timeInterval, processHandle: process, finishHandle:finish)
        taskDic[key] = task
    }
}
class TimeTask :NSObject{
    var key:String?
    var FHandle:TimerHandle?
    var PHandle:TimerHandle?
    var leftTime:Float = 0
    var totolTime:Float = 0
    var backgroundID:UIBackgroundTaskIdentifier?
    var timer:NSTimer?
    
    func configureWithTime(myKey:String,time:Float,processHandle:TimerHandle,finishHandle:TimerHandle) -> TimeTask {
        backgroundID = UIApplication.sharedApplication().beginBackgroundTaskWithExpirationHandler(nil)
        key = myKey
        totolTime = time
        leftTime = totolTime
        FHandle = finishHandle
        PHandle = processHandle
        timer = NSTimer(timeInterval: 1.0, target: self, selector:#selector(sendHandle), userInfo: nil, repeats: true)
        
        //将timer源写入runloop中被监听，commonMode-滑动不停止
        NSRunLoop.currentRunLoop().addTimer(self.timer!, forMode: NSRunLoopCommonModes)
        return self
    }
    
    func sendHandle(){
        leftTime -= 1
        if leftTime > 0 {
            if PHandle != nil {
                PHandle!(timeInterVal:Int(leftTime))
            }
        }else{
            timer?.invalidate()
            TimeManager.shareManager.taskDic.removeValueForKey(key!)
            if FHandle != nil {
                FHandle!(timeInterVal: 0)
            }
        }
    }
    

}

func requiredLogin(nav:UINavigationController,hasBackItem:Bool) -> Bool{
    
    print(LOGIN_STATE)
    
    if LOGIN_STATE == true {
        return true
    }
    
    let controller = ViewController()
    controller.navigationController?.navigationBar.hidden = hasBackItem
    controller.title = "登录"
    nav.pushViewController(controller, animated: true)
    
    return false
}

// MARK:检测是否收藏 type: 1 新闻  2 考试  4 论坛帖子  5招聘  6用户
func checkHadFavorite(refid:String, type:String, handle:ResponseBlock){
    let url = PARK_URL_Header+"CheckHadFavorite"
    let param = [
        "userid":QCLoginUserInfo.currentInfo.userid,
        "type":type,
        "refid":refid
    ];
    Alamofire.request(.GET, url, parameters: param).response { request, response, json, error in
        print(request)
        if(error != nil){
            handle(success: false, response: error?.description)
        }else{
            let result = JSONDecoder(json!)["status"].string ?? ""
            if(result == "success"){
                handle(success: true, response: nil)
            }else{
                handle(success: false, response: nil)
            }
        }
    }
}
// MARK:检测是否点赞 type: 1 新闻  2 论坛
func checkHadLike(id:String, type:String, handle:ResponseBlock){
    let url = PARK_URL_Header+"CheckHadLike"
    let param = [
        "userid":QCLoginUserInfo.currentInfo.userid,
        "type":type,
        "id":id
    ];
    Alamofire.request(.GET, url, parameters: param).response { request, response, json, error in
        print(request)
        if(error != nil){
            handle(success: false, response: error?.description)
        }else{
            let result = JSONDecoder(json!)["status"].string ?? ""
            if(result == "success"){
                handle(success: true, response: nil)
            }else{
                handle(success: false, response: nil)
            }
        }
    }
}

//  提示框
func alert(message:String,delegate:AnyObject){
    let alert = UIAlertView(title: "提示信息", message: message, delegate: delegate, cancelButtonTitle: "确定")
    alert.show()
}
