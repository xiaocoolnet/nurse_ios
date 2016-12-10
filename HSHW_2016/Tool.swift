//
//  Tool.swift
//  HSHW_2016
//
//  Created by apple on 16/5/14.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

let WIDTH = UIScreen.mainScreen().bounds.size.width
let HEIGHT = UIScreen.mainScreen().bounds.size.height
let COLOR = UIColor(red: 145/255.0, green: 26/255.0, blue: 107/255.0, alpha: 1.0)
let GREY = UIColor(red: 158/255.0, green: 158/255.0, blue: 158/255.0, alpha: 1.0)
let RGREY = UIColor(red: 242/255.0, green: 242/255.0, blue: 242/255.0, alpha: 1.0)
let slideImageListMaxNum = 5
let DomainName = "http://app.chinanurse.cn/"
//let DomainName = "http://nurse.xiaocool.net/"
//let PARK_URL_Header = "http://app.chinanurse.cn/index.php?g=apps&m=index&a="
let PARK_URL_Header = "\(DomainName)index.php?g=apps&m=index&a="
let NewsInfo_Header = "\(DomainName)index.php?g=portal&m=article&a=index&id="
let IMAGE_URL_HEADER = "\(DomainName)"
let SHOW_IMAGE_HEADER = "\(DomainName)uploads/microblog/"
let LOGINFO_KEY = "login_info"
let USER_NAME = "login_name"
let USER_PWD = "login_password"
let HULIBU_ORIGINALNEWSUPDATETIME = "hulibu_originalNewsUpdateTime\(QCLoginUserInfo.currentInfo.userid)"
var hulibu_updateNum = 0
var recruit_user_updateNum = 0
let RECRUIT_USER_ORIGINALCREATETIME = "RECRUIT_USER_ORIGINALNEWSCREATETIME\(QCLoginUserInfo.currentInfo.userid)"
var unreadNum = 0


var recruit_company_updateNum = 0
var recruit_company_alreadyRead = false
let RECRUIT_COMPANY_ORIGINALCREATETIME = "RECRUIT_USER_ORIGINALNEWSCREATETIME\(QCLoginUserInfo.currentInfo.userid)"

var LOGIN_STATE = false
let kAppKey = "3139633252"
// TODO:
let kRedirectURI = "http://app.chinanurse.cn"
//let kRedirectURI = "http://nurse.xiaocool.net"

let APP_SHARE_URL = "https://www.pgyer.com/kUyM"
let APP_SHARE_NAME = "中国护士网"

let APP_INVITEFRIEND_TITLE_ZONE = "邀请护士好友加入中国护士网，赚积分赢大奖，OPPO、VIVO更多大奖等你拿>>"
let APP_INVITEFRIEND_TITLE_FREND = "中国护士网-邀请您加入"

let APP_INVITEFRIEND_DESCRIPTION_ZONE = "成为中国护士网会员，会享受100余项积分功能和政策。我们会有积分兑换商城，定期会有积分活动，让您真正享受到您的每一份支持都将获得我们的真情回报。"
let APP_INVITEFRIEND_DESCRIPTION_FREND = "邀请护士好友加入中国护士网，赚积分赢大奖，OPPO、VIVO更多大奖等你拿>>"
let APP_INVITEFRIEND_URL = "\(DomainName)index.php?g=Score&m=Score&a=scorepengyou&userid="
//var myInviteFriendUrl = APP_INVITEFRIEND_URL+QCLoginUserInfo.currentInfo.userid
var myInviteFriendUrl = NSUserDefaults.standardUserDefaults().stringForKey("myInviteFriendUrl") ?? APP_INVITEFRIEND_URL+QCLoginUserInfo.currentInfo.userid

var loadPictureOnlyWiFi = false
var canLookTel = false

//let ZAN_URL_Header = "http://wxt.xiaocool.net/index.php?g=apps&m=index&a="

func calculateHeight(string:String,size:CGFloat,width:  CGFloat) -> CGFloat {
    let options : NSStringDrawingOptions = NSStringDrawingOptions.UsesLineFragmentOrigin
    //let screenBounds:CGRect = UIScreen.mainScreen().bounds
    let boundingRect = String(string).boundingRectWithSize(CGSizeMake(width, 0), options: options, attributes: [NSFontAttributeName:UIFont.systemFontOfSize(size)], context: nil)
//    print(boundingRect.height)
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

func requiredLogin(nav:UINavigationController, previousViewController:UIViewController, hiddenNavigationBar:Bool) -> Bool{
    
    print(LOGIN_STATE)
    
    if LOGIN_STATE == true {
        return true
    }
    
    let controller = ViewController()
    controller.hasBackBarButtonItem = hiddenNavigationBar
//    controller.navigationController?.navigationBar.hidden = hasBackItem
    controller.title = "登录"
    controller.previousViewcontroller = previousViewController
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
    NurseUtil.net.request(RequestType.requestTypeGet, URLString: url, Parameter: param) { (json, error) in

//    Alamofire.request(.GET, url, parameters: param).response { request, response, json, error in
//        print(request)
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
    NurseUtil.net.request(RequestType.requestTypeGet, URLString: url, Parameter: param) { (json, error) in

//    Alamofire.request(.GET, url, parameters: param).response { request, response, json, error in
//        print(request)
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

func getInvitedUrl() {
    
    myInviteFriendUrl = APP_INVITEFRIEND_URL+QCLoginUserInfo.currentInfo.userid

    
//    let url = "http://apis.baidu.com/3023/shorturl/shorten"
//    
//    Alamofire.request(.GET, url, parameters: ["url_long":APP_INVITEFRIEND_URL+QCLoginUserInfo.currentInfo.userid], encoding: .URLEncodedInURL, headers: ["apikey":"615ac7276ff0b752fc5f0b8cfa845544"]).response { (request, response, json, error) in
//        print(response,json,error)
//        if error != nil {
//            myInviteFriendUrl = APP_INVITEFRIEND_URL+QCLoginUserInfo.currentInfo.userid
//        }else{
//            
//            let js = try?NSJSONSerialization.JSONObjectWithData(json!, options: .MutableLeaves)
//            print(JSON(js!)["urls"][0]["url_short"].string!)
//            if JSON(js!)["urls"][0]["result"].boolValue {
//                NSUserDefaults.standardUserDefaults().setValue(JSON(js!)["urls"][0]["url_short"].string!, forKey: "myInviteFriendUrl")
//                myInviteFriendUrl = JSON(js!)["urls"][0]["url_short"].string!
//            }else{
//                myInviteFriendUrl = APP_INVITEFRIEND_URL+QCLoginUserInfo.currentInfo.userid
//            }
//        }
//    }
}

func getShareNewsUrl(originalUrlStr:String) {
    
    myInviteFriendUrl = APP_INVITEFRIEND_URL+QCLoginUserInfo.currentInfo.userid

//    let url = "http://apis.baidu.com/3023/shorturl/shorten"
//    
//    Alamofire.request(.GET, url, parameters: ["url_long":APP_INVITEFRIEND_URL+QCLoginUserInfo.currentInfo.userid], encoding: .URLEncodedInURL, headers: ["apikey":"615ac7276ff0b752fc5f0b8cfa845544"]).response { (request, response, json, error) in
//        print(response,json,error)
//        if error != nil {
//            myInviteFriendUrl = APP_INVITEFRIEND_URL+QCLoginUserInfo.currentInfo.userid
//        }else{
//            
//            let js = try?NSJSONSerialization.JSONObjectWithData(json!, options: .MutableLeaves)
//            print(JSON(js!)["urls"][0]["url_short"].string!)
//            if JSON(js!)["urls"][0]["result"].boolValue {
//                NSUserDefaults.standardUserDefaults().setValue(JSON(js!)["urls"][0]["url_short"].string!, forKey: "myInviteFriendUrl")
//                myInviteFriendUrl = JSON(js!)["urls"][0]["url_short"].string!
//            }else{
//                myInviteFriendUrl = APP_INVITEFRIEND_URL+QCLoginUserInfo.currentInfo.userid
//            }
//        }
//    }
}

enum ValidatedType {
    case Email
    case PhoneNumber
}
func ValidateText(validatedType type: ValidatedType, validateString: String) -> Bool {
    do {
        let pattern: String
        if type == ValidatedType.Email {
            pattern = "^([a-z0-9_\\.-]+)@([\\da-z\\.-]+)\\.([a-z\\.]{2,6})$"
        }
        else {
            pattern = "(^(13[0-9]|15[0-9]|18[0-9]|17[0-9]|147)\\d{8}$)|(^(0\\d{2})-(\\d{8})$)|(^(0\\d{3})-(\\d{7,8})$)|(^(0\\d{2})-(\\d{8})-(\\d+)$)|(^(0\\d{3})-(\\d{7,8})-(\\d+)$)"
        }
//        (^(13[0-9]|15[0-9]|18[0-9]|17[0-9]|147)\d{8}$)|(^(0\d{2})-(\d{8})$)|(^(0\d{3})-(\d{7,8})$)|(^(0\d{2})-(\d{8})-(\d+)$)|(^(0\d{3})-(\d{7,8})-(\d+)$)
//        (^(0\d{2})-(\d{8})$)|(^(0\d{3})-(\d{7})$)|(^(0\d{2})-(\d{8})-(\d+)$)|(^(0\d{3})-(\d{7})-(\d+)$)
        
        let regex: NSRegularExpression = try NSRegularExpression(pattern: pattern, options: NSRegularExpressionOptions.CaseInsensitive)
        let matches = regex.matchesInString(validateString, options: NSMatchingOptions.ReportProgress, range: NSMakeRange(0, validateString.characters.count))
        return matches.count > 0
    }
    catch {
        return false
    }
}
func EmailIsValidated(vStr: String) -> Bool {
    return ValidateText(validatedType: ValidatedType.Email, validateString: vStr)
}
func PhoneNumberIsValidated(vStr: String) -> Bool {
    return ValidateText(validatedType: ValidatedType.PhoneNumber, validateString: vStr)
}



