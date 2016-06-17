//
//  LoginModel.swift
//  HSHW_2016
//
//  Created by JQ on 16/6/15.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit
import AFNetworking
//  block
typealias ResponseBlock = (success:Bool,response:AnyObject?)->Void

class LoginModel: NSObject {
    var requestManager:AFHTTPSessionManager?
    override init() {
        super.init()
        requestManager = AFHTTPSessionManager()
        requestManager?.responseSerializer = AFHTTPResponseSerializer()
    }
    // MARK: - 登录
    func login(phoneNumber:String,passwordNumber:String,handle:ResponseBlock){

        //  GET请求
        let paramDic = ["a":"applogin","phone":phoneNumber,"password":passwordNumber]
        
        requestManager?.GET(PARK_URL_Header, parameters: paramDic, success: { (NSURLSessionDataTask, AnyObject) in
            let result = LoginUserInfoModel(JSONDecoder(AnyObject))
    
            //  进行数据解析
            if result.status == "success"{
                //  进行赋值
            
                QCLoginUserInfo.currentInfo.phoneNumber = (result.data?.user_phone)!
                QCLoginUserInfo.currentInfo.userid = (result.data?.user_id)!
                QCLoginUserInfo.currentInfo.devicestate = (result.data?.user_devicestate)!
                QCLoginUserInfo.currentInfo.usertype = (result.data?.user_usertype)!
                
                
                
              
            }
            let responseStr = result.status == "success" ? nil : result.errorData
            handle(success: result.status == "success",response: responseStr)
           
            
            }, failure: { (NSURLSessionDataTask, NSError) in
                //  请求失败
                //  闭包传送错误信息
                handle(success: false,response: "网络错误")
        })
        
    }
    
    //  MARK - 发送验证码
    func sendMobileCodeWithPhoneNumber(phoneNumber:String){
        let paramDic = ["a":"SendMobileCode","phone":phoneNumber]
        print(phoneNumber)
        requestManager?.GET(PARK_URL_Header, parameters: paramDic, success: { (task, obj) in
            // 请求成功
            }, failure: { (task, error) in
                //  请求失败
        })
    }
    
    
    
    //  MARK - 注册 (需要传入需要注册的几个信息)
    //  phone,password,code,usertype,devicestate
    func register(phone:String,password:String,
                  code:String,usertype:String,devicestate:String, handle:ResponseBlock){
        let paramDic = ["a":"AppRegister","phone":phone,"password":password,
                        "code":code,"usertype":usertype,"devicestate":devicestate]
        //  进行GET请求
        requestManager?.GET(PARK_URL_Header, parameters: paramDic, success: { (task, response) in
            let result = Http(JSONDecoder(response))
            let responseStr = result.status == "success" ? nil : result.errorData
            //  闭包传值
            handle(success: result.status == "success",response: responseStr)
            }, failure: { (task, error) in
                //  请求错误的传值
                handle(success: false,response: "网络错误")
        })
    }
    //验证手机是否已经注册
    func comfirmPhoneHasRegister(phoneNum:String,handle:ResponseBlock){
        let paraDic = ["a":"checkphone","phone":phoneNum]
        requestManager?.GET(PARK_URL_Header, parameters: paraDic, success: { (task, response) in
            let result = Http(JSONDecoder(response))
            let responseStr = result.status == "success" ? nil : result.errorData
            handle(success: result.status == "success",response: responseStr)
        
            }, failure: { (task, error) in
                handle(success: false,response: "网络错误")
        })
    }
    //  忘记密码
    func forgetPassword(phone:String,code:String,password:String,handle:ResponseBlock){
        let paramDic = ["a":"forgetpwd","phone":phone,"code":code,"password":password]
        requestManager?.GET(PARK_URL_Header, parameters: paramDic, success: { (task, response) in
            let result = Http(JSONDecoder(response))
            let responseStr = result.status == "success" ? "成功" : result.errorData
            if responseStr != nil {
                handle(success: result.status == "success",response: responseStr)
            }
            }, failure: { (task, error) in
                handle(success: false,response: "网络错误")
        })
    }

}

